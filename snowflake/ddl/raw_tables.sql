-- 0) Warehouse (if you already have one, skip)
CREATE WAREHOUSE IF NOT EXISTS CRYPTO_WATCH_WH
  WAREHOUSE_SIZE = 'XSMALL'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE;

-- 1) Database + schema
CREATE DATABASE IF NOT EXISTS CRYPTO_WATCH_DB;
CREATE SCHEMA IF NOT EXISTS CRYPTO_WATCH_DB.INGEST;

USE WAREHOUSE CRYPTO_WATCH_WH;
USE DATABASE CRYPTO_WATCH_DB;
USE SCHEMA INGEST;

-- 2) RAW: market snapshots (CoinGecko /coins/markets responses)
CREATE TABLE IF NOT EXISTS RAW_MARKET_SNAPSHOTS (
  ingested_at TIMESTAMP_NTZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  source STRING NOT NULL,                 -- e.g., 'coingecko'
  endpoint STRING NOT NULL,               -- e.g., '/coins/markets'
  request_params VARIANT,                 -- store query params used
  payload VARIANT NOT NULL                -- raw JSON response (row or array)
);

-- 3) RAW: trending (CoinGecko /search/trending responses)
CREATE TABLE IF NOT EXISTS RAW_TRENDING (
  ingested_at TIMESTAMP_NTZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  source STRING NOT NULL,
  endpoint STRING NOT NULL,               -- e.g., '/search/trending'
  payload VARIANT NOT NULL
);
