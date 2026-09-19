-- Level-one content acquisition audit trail. Imports create review candidates;
-- this schema intentionally contains no automatic-publication flag or path.
CREATE TABLE IF NOT EXISTS gd_content_import_runs (
  id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL,
  page_url TEXT NOT NULL,
  mode TEXT NOT NULL CHECK (mode IN ('operator_upload','remote_fetch')),
  format TEXT NOT NULL CHECK (format IN ('csv','json','rss')),
  status TEXT NOT NULL CHECK (status IN ('completed','failed')),
  content_hash TEXT,
  rows_seen INTEGER NOT NULL DEFAULT 0 CHECK (rows_seen >= 0),
  selected_count INTEGER NOT NULL DEFAULT 0 CHECK (selected_count >= 0),
  created_count INTEGER NOT NULL DEFAULT 0 CHECK (created_count >= 0),
  updated_count INTEGER NOT NULL DEFAULT 0 CHECK (updated_count >= 0),
  skipped_count INTEGER NOT NULL DEFAULT 0 CHECK (skipped_count >= 0),
  error_count INTEGER NOT NULL DEFAULT 0 CHECK (error_count >= 0),
  errors_json TEXT NOT NULL DEFAULT '{}',
  automatic_publish INTEGER NOT NULL DEFAULT 0 CHECK (automatic_publish = 0),
  actor_id TEXT NOT NULL REFERENCES gd_users(id),
  started_at TEXT NOT NULL,
  completed_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_gd_content_import_runs_recent
ON gd_content_import_runs(completed_at DESC,id DESC);
CREATE INDEX IF NOT EXISTS idx_gd_content_import_runs_source
ON gd_content_import_runs(source_id,completed_at DESC,id DESC);

CREATE TABLE IF NOT EXISTS gd_content_import_items (
  source_id TEXT NOT NULL,
  source_item_key TEXT NOT NULL,
  deal_id TEXT NOT NULL REFERENCES gd_deals(id),
  item_hash TEXT NOT NULL,
  first_seen_at TEXT NOT NULL,
  last_seen_at TEXT NOT NULL,
  last_run_id TEXT NOT NULL REFERENCES gd_content_import_runs(id),
  PRIMARY KEY (source_id,source_item_key),
  UNIQUE (deal_id)
);
CREATE INDEX IF NOT EXISTS idx_gd_content_import_items_last_seen
ON gd_content_import_items(last_seen_at DESC,source_id,source_item_key);
