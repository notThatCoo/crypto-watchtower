USE WAREHOUSE CRYPTO_WATCH_WH;
USE DATABASE CRYPTO_WATCH_DB;
USE SCHEMA INGEST;

-- 1) CURATED: one row per coin per snapshot time
CREATE TABLE IF NOT EXISTS MARKET_FACTS (
  snapshot_time TIMESTAMP_NTZ NOT NULL,
  coin_id STRING NOT NULL,
  symbol STRING,
  name STRING,

  price_usd FLOAT,
  market_cap_usd FLOAT,
  volume_24h_usd FLOAT,
  price_change_24h_pct FLOAT,

  source STRING NOT NULL DEFAULT 'coingecko',

  PRIMARY KEY (snapshot_time, coin_id)
);

-- 2) FEATURES: rolling baselines / anomaly features you compute daily or hourly
CREATE TABLE IF NOT EXISTS FEATURES_ROLLING (
  feature_time TIMESTAMP_NTZ NOT NULL,
  coin_id STRING NOT NULL,

  -- examples of “normal” vs “now”
  vol_24h_usd_mean_3h FLOAT,
  vol_24h_usd_std_3h FLOAT,
  price_return_5m FLOAT,
  price_return_1h FLOAT,
  z_price_return_1h FLOAT,
  z_vol_24h_usd FLOAT,

  PRIMARY KEY (feature_time, coin_id)
);

-- 3) ALERTS: what humans actually read
CREATE TABLE IF NOT EXISTS ALERTS (
  alert_time TIMESTAMP_NTZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  coin_id STRING,
  severity STRING NOT NULL,       -- 'LOW'|'MED'|'HIGH'|'CRITICAL'
  rule_id STRING NOT NULL,        -- e.g., 'VOLUME_CLIFF', 'SPIKE', 'STALE_FEED'
  reason STRING NOT NULL,         -- human-readable
  evidence VARIANT,               -- store deltas, baselines, sample values
  status STRING NOT NULL DEFAULT 'OPEN'  -- OPEN/ACK/CLOSED
);
