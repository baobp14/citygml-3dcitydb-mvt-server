require('dotenv').config();
const express = require('express');
const cors = require('cors');
const pool = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

const NATIVE_SRID = Number(process.env.NATIVE_SRID);
const BUILDING_OBJECTCLASS_ID = Number(process.env.BUILDING_OBJECTCLASS_ID);
const HEIGHT_PROPERTY_NAME = process.env.HEIGHT_PROPERTY_NAME || 'measuredHeight';
const PORT = process.env.PORT || 3000;

const MIN_ZOOM_FOR_BUILDINGS = 13;
const MAX_BUILDINGS_PER_TILE = 20000;
const TILE_CACHE_TTL_MS = 10 * 60 * 1000;
const TILE_CACHE_MAX_ENTRIES = 5000;
const tileCache = new Map();

function getCached(key) {
  const entry = tileCache.get(key);
  if (!entry) return null;
  if (Date.now() - entry.time > TILE_CACHE_TTL_MS) { tileCache.delete(key); return null; }
  return entry.buffer;
}
function setCached(key, buffer) {
  if (tileCache.size >= TILE_CACHE_MAX_ENTRIES) tileCache.delete(tileCache.keys().next().value);
  tileCache.set(key, { buffer, time: Date.now() });
}
function clearTileCache() { tileCache.clear(); }

// GET tiles
app.get('/api/tiles/:z/:x/:y.mvt', async (req, res) => {
  const z = parseInt(req.params.z, 10), x = parseInt(req.params.x, 10), y = parseInt(req.params.y, 10);
  if (Number.isNaN(z) || Number.isNaN(x) || Number.isNaN(y)) return res.status(400).send('Tham so tile khong hop le');
  if (z < MIN_ZOOM_FOR_BUILDINGS) return res.status(204).end();

  const cacheKey = `${z}/${x}/${y}`;
  const cached = getCached(cacheKey);
  if (cached) { res.set('Content-Type', 'application/x-protobuf'); res.set('X-Cache', 'HIT'); return res.send(cached); }

  const sql = `
    WITH tile_bounds AS (
      SELECT
        ST_TileEnvelope($1::int, $2::int, $3::int) AS web_geom,
        ST_FlipCoordinates(ST_Transform(ST_TileEnvelope($1::int, $2::int, $3::int), $4::int)) AS native_geom
    ),
    candidate_buildings AS (
      SELECT DISTINCT ON (f.id)
        f.id AS feature_id, f.objectid AS gml_id, g.geometry AS geom
      FROM feature f
      JOIN geometry_data g ON g.feature_id = f.id
      CROSS JOIN tile_bounds tb
      WHERE f.objectclass_id = $5
        AND g.geometry && tb.native_geom
        AND g.geometry IS NOT NULL
      ORDER BY f.id, g.feature_id
      LIMIT $7
    ),
    with_height AS (
      SELECT cb.feature_id, cb.gml_id,
        ST_MakeValid(ST_ConvexHull(ST_Force2D(cb.geom))) AS footprint,
        COALESCE(
          (SELECT p.val_double FROM property p WHERE p.feature_id = cb.feature_id AND p.name = $6 LIMIT 1),
          ST_ZMax(cb.geom) - ST_ZMin(cb.geom), 10
        ) AS height
      FROM candidate_buildings cb
    ),
    mvt_source AS (
      SELECT
        ST_AsMVTGeom(
          ST_Transform(ST_SetSRID(ST_FlipCoordinates(wh.footprint), $4::int), 3857),
          tb.web_geom, 4096, 64, true
        ) AS geom,
        wh.feature_id, wh.gml_id, ROUND(wh.height::numeric, 1) AS height
      FROM with_height wh CROSS JOIN tile_bounds tb
      WHERE wh.footprint IS NOT NULL AND NOT ST_IsEmpty(wh.footprint)
    )
    SELECT ST_AsMVT(mvt_source, 'buildings', 4096, 'geom') AS mvt FROM mvt_source;
  `;

  try {
    const result = await pool.query(sql, [z, x, y, NATIVE_SRID, BUILDING_OBJECTCLASS_ID, HEIGHT_PROPERTY_NAME, MAX_BUILDINGS_PER_TILE]);
    const mvt = result.rows[0]?.mvt;
    if (!mvt || mvt.length === 0) return res.status(204).end();
    setCached(cacheKey, mvt);
    res.set('Content-Type', 'application/x-protobuf');
    res.set('X-Cache', 'MISS');
    res.send(mvt);
  } catch (err) {
    console.error(`Loi tao tile ${z}/${x}/${y}:`, err.message);
    res.status(500).send('Loi khi tao vector tile');
  }
});

// GET building detail
app.get('/api/buildings/:id', async (req, res) => {
  const featureId = parseInt(req.params.id, 10);
  if (Number.isNaN(featureId)) return res.status(400).json({ error: 'id khong hop le' });
  try {
    const geomResult = await pool.query(
      `SELECT f.id, f.objectid AS gml_id,
         ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_FlipCoordinates(g.geometry), $2::int), 4326)) AS geojson
       FROM feature f JOIN geometry_data g ON g.feature_id = f.id
       WHERE f.id = $1 LIMIT 1`,
      [featureId, NATIVE_SRID]
    );
    if (geomResult.rows.length === 0) return res.status(404).json({ error: 'Khong tim thay building' });

    const propsResult = await pool.query(
      `SELECT name, val_string, val_int, val_double FROM property WHERE feature_id = $1`,
      [featureId]
    );
    const properties = {};
    for (const row of propsResult.rows) {
      properties[row.name] = row.val_string ?? row.val_int ?? row.val_double ?? null;
    }
    res.json({ id: geomResult.rows[0].id, gml_id: geomResult.rows[0].gml_id, geometry: JSON.parse(geomResult.rows[0].geojson), properties });
  } catch (err) {
    console.error(`Loi lay chi tiet building ${featureId}:`, err.message);
    res.status(500).json({ error: 'Loi server' });
  }
});

// DELETE building
app.delete('/api/buildings/:id', async (req, res) => {
  const featureId = parseInt(req.params.id, 10);
  if (Number.isNaN(featureId)) return res.status(400).json({ error: 'id khong hop le' });
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query('DELETE FROM property WHERE feature_id = $1', [featureId]);
    await client.query('DELETE FROM geometry_data WHERE feature_id = $1', [featureId]);
    await client.query('DELETE FROM feature WHERE id = $1', [featureId]);
    await client.query('COMMIT');
    clearTileCache();
    res.json({ success: true });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error(`Loi xoa building ${featureId}:`, err.message);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

// PUT update properties
app.put('/api/buildings/:id/properties', async (req, res) => {
  const featureId = parseInt(req.params.id, 10);
  if (Number.isNaN(featureId)) return res.status(400).json({ error: 'id khong hop le' });
  const { properties } = req.body;
  if (!properties || typeof properties !== 'object') return res.status(400).json({ error: 'Thieu properties' });

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    await client.query('DELETE FROM property WHERE feature_id = $1', [featureId]);
    for (const [name, value] of Object.entries(properties)) {
      if (value === null || value === '') continue;
      const isNum = !isNaN(value) && value !== '';
      if (isNum) {
        await client.query(
          'INSERT INTO property (feature_id, name, val_double, datatype_id) VALUES ($1, $2, $3, 1)',
          [featureId, name, parseFloat(value)]
        );
      } else {
        await client.query(
          'INSERT INTO property (feature_id, name, val_string) VALUES ($1, $2, $3)',
          [featureId, name, String(value)]
        );
      }
    }
    await client.query('COMMIT');
    clearTileCache();
    res.json({ success: true });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error(`Loi cap nhat properties ${featureId}:`, err.message);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

// PUT update geometry
app.put('/api/buildings/:id/geometry', async (req, res) => {
  const featureId = parseInt(req.params.id, 10);
  if (Number.isNaN(featureId)) return res.status(400).json({ error: 'id khong hop le' });
  const { geojson } = req.body;
  if (!geojson) return res.status(400).json({ error: 'Thieu geojson' });

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    // Convert GeoJSON (4326) -> flip -> 3301 stored as "4326"
    await client.query(
      `UPDATE geometry_data
       SET geometry = ST_FlipCoordinates(ST_Transform(ST_SetSRID(ST_GeomFromGeoJSON($2), 4326), $3::int))
       WHERE feature_id = $1`,
      [featureId, JSON.stringify(geojson), NATIVE_SRID]
    );
    await client.query('COMMIT');
    clearTileCache();
    res.json({ success: true });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error(`Loi cap nhat geometry ${featureId}:`, err.message);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

// POST create new building
app.post('/api/buildings', async (req, res) => {
  const { geojson, properties, gml_id } = req.body;
  if (!geojson) return res.status(400).json({ error: 'Thieu geojson' });

  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const featureRes = await client.query(
      `INSERT INTO feature (objectclass_id, objectid, creation_date)
       VALUES ($1, $2, NOW()) RETURNING id`,
      [BUILDING_OBJECTCLASS_ID, gml_id || `building-${Date.now()}`]
    );
    const featureId = featureRes.rows[0].id;

    await client.query(
      `INSERT INTO geometry_data (feature_id, geometry)
      VALUES (
        $1,
        ST_FlipCoordinates(ST_Force3D(ST_Transform(ST_SetSRID(ST_GeomFromGeoJSON($2), 4326), $3::int)))
      )`,
      [featureId, JSON.stringify(geojson), NATIVE_SRID]
    );

    if (properties && typeof properties === 'object') {
      for (const [name, value] of Object.entries(properties)) {
        if (value === null || value === '') continue;
        const isNum = !isNaN(value) && value !== '';
        if (isNum) {
          await client.query(
            'INSERT INTO property (feature_id, name, val_double, datatype_id) VALUES ($1, $2, $3, 1)',
            [featureId, name, parseFloat(value)]
          );
        } else {
          await client.query(
            'INSERT INTO property (feature_id, name, val_string, datatype_id) VALUES ($1, $2, $3, 1)',
            [featureId, name, String(value)]
          );
        }
      }
    }

    await client.query('COMMIT');
    clearTileCache();
    res.json({ success: true, id: featureId });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Loi tao building:', err.message);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

app.get('/api/health', (req, res) => res.json({ status: 'ok', cacheSize: tileCache.size }));
app.use(express.static('../frontend'));
app.post('/api/cache/clear', (req, res) => {
  clearTileCache();
  res.json({ success: true, message: 'Cache cleared' });
});
app.listen(PORT, () => {
  console.log(`Server dang chay tai http://localhost:${PORT}`);
  console.log(`Building objectclass_id = ${BUILDING_OBJECTCLASS_ID}, SRID = ${NATIVE_SRID}`);
});