-- Page fingerprints are supplied by an authorised operator or a future
-- rights-aware collector.  They are versioned evidence, never a scraper cache
-- and never an automatic publishing signal.
CREATE TABLE IF NOT EXISTS gd_content_source_snapshots (
  id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL,
  page_url TEXT NOT NULL,
  content_hash TEXT NOT NULL,
  checked_at TEXT NOT NULL,
  expires_at TEXT NOT NULL,
  captured_by TEXT NOT NULL REFERENCES gd_users(id),
  capture_note TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_gd_content_source_snapshot_current
ON gd_content_source_snapshots(source_id,page_url,checked_at DESC,id DESC);
