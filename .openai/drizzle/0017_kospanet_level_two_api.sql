-- Level-two official API ingestion. Credentials stay in server environment values.
-- Normalized records remain in the operator review inbox and never auto-publish.
CREATE TABLE IF NOT EXISTS gd_content_api_sources (
  provider_id TEXT PRIMARY KEY CHECK (provider_id IN ('rakuten','yahoo','hotpepper','estat')),
  state TEXT NOT NULL CHECK (state IN ('ready','paused','error','rate_limited','auth_required','deprecated')),
  last_success_at TEXT,
  last_error_at TEXT,
  last_error_code TEXT,
  next_run_at TEXT,
  last_cursor TEXT,
  response_version TEXT,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_content_api_runs (
  id TEXT PRIMARY KEY,
  provider_id TEXT NOT NULL CHECK (provider_id IN ('rakuten','yahoo','hotpepper','estat')),
  kind TEXT NOT NULL CHECK (kind IN ('product','venue','statistic')),
  status TEXT NOT NULL CHECK (status IN ('completed','partial','failed','rate_limited','auth_required','deprecated')),
  request_url_redacted TEXT NOT NULL,
  pages_fetched INTEGER NOT NULL DEFAULT 0 CHECK (pages_fetched BETWEEN 0 AND 3),
  received_count INTEGER NOT NULL DEFAULT 0 CHECK (received_count >= 0),
  accepted_count INTEGER NOT NULL DEFAULT 0 CHECK (accepted_count >= 0),
  rejected_count INTEGER NOT NULL DEFAULT 0 CHECK (rejected_count >= 0),
  created_count INTEGER NOT NULL DEFAULT 0 CHECK (created_count >= 0),
  updated_count INTEGER NOT NULL DEFAULT 0 CHECK (updated_count >= 0),
  skipped_count INTEGER NOT NULL DEFAULT 0 CHECK (skipped_count >= 0),
  next_cursor TEXT,
  error_code TEXT,
  retry_after TEXT,
  automatic_publish INTEGER NOT NULL DEFAULT 0 CHECK (automatic_publish = 0),
  dry_run INTEGER NOT NULL DEFAULT 1 CHECK (dry_run IN (0,1)),
  actor_id TEXT NOT NULL REFERENCES gd_users(id),
  started_at TEXT NOT NULL,
  completed_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_gd_content_api_runs_provider
ON gd_content_api_runs(provider_id,completed_at DESC,id DESC);

CREATE TABLE IF NOT EXISTS gd_content_api_items (
  provider_id TEXT NOT NULL,
  source_item_key TEXT NOT NULL,
  kind TEXT NOT NULL CHECK (kind IN ('product','venue','statistic')),
  identity_key TEXT NOT NULL,
  payload_hash TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  first_seen_at TEXT NOT NULL,
  last_seen_at TEXT NOT NULL,
  last_run_id TEXT NOT NULL REFERENCES gd_content_api_runs(id),
  review_state TEXT NOT NULL DEFAULT 'pending' CHECK (review_state IN ('pending','approved','needs_changes','rejected','withdrawn')),
  review_reason TEXT,
  reviewed_by TEXT REFERENCES gd_users(id),
  reviewed_at TEXT,
  PRIMARY KEY (provider_id,source_item_key)
);
CREATE INDEX IF NOT EXISTS idx_gd_content_api_items_review
ON gd_content_api_items(review_state,kind,last_seen_at DESC);
CREATE INDEX IF NOT EXISTS idx_gd_content_api_items_identity
ON gd_content_api_items(identity_key,provider_id);
