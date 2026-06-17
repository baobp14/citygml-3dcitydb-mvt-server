require('dotenv').config();
const { Pool } = require('pg');


const pool = new Pool({
  host: process.env.PGHOST,
  port: Number(process.env.PGPORT || 5432),
  database: process.env.PGDATABASE,
  user: process.env.PGUSER,
  password: process.env.PGPASSWORD,
  max: 10,                     
  idleTimeoutMillis: 30000,
  statement_timeout: 15000,     
  options: '-c search_path=citydb,public'
});

pool.on('error', (err) => {
  console.error('Loi khong mong doi tu connection pool:', err);
});

module.exports = pool;
