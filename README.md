Project Description
📌 Overview
This project implements a high-performance Dynamic Vector Tiles (MVT) Server specialized in streaming and rendering large-scale 3D Building Models (LoD2 - Level of Detail 2) on a Web GIS platform. The system ingests nationwide 3D spatial data based on the open CityGML standard (sourced from the Estonian Land Board / Maa-amet) and dynamically processes it for real-time browser visualization without overloading client-side memory.

🎯 Requirements & Core Challenges Addressed
Massive Data Streaming: Dynamically slicing and serving a dataset of over 856,000 spatial features into binary Vector Tiles (z/x/y), eliminating the performance bottleneck of loading massive static GeoJSON files.

Coordinate Reference System (CRS) & Axis Flip Fix: Resolving spatial displacement and axis-order discrepancies (X/Y flip) typical of European GML structures when transforming data from local coordinate systems to Web Mercator (EPSG:3857).

Database Concurrency Optimization: Mitigating heavy table scans and server timeouts during high-frequency parallel requests from frontend camera movements by ncurring strict spatial indexing rules and expanding connection limits.

🏗️ Data Model & Database Architecture
Source Data: CityGML (LoD2) dataset including detailed building structures with roof shapes (roof geometry) captured via airborne laser scanning (LiDAR) and photogrammetry.

Database Schema: Implemented using 3DCityDB v5 (3D City Database v5) on top of PostgreSQL/PostGIS.

Spatial Indexing: Built custom GIST (Generalized Search Tree) spatial indexes on the geometry_data table's geometry columns to ensure PostGIS utilizes index-driven bounding box operators (&&) for instant geographical queries.

🛠️ Tech Stack Included
Database: PostgreSQL 17 + PostGIS Extension + 3DCityDB v5 Schema

Backend: Node.js, Express, pg (Native Postgres Driver)

Frontend: MapLibre GL JS (using fill-extrusion layers for 3D roof height presentation)
