-- Level-three page-selection monitoring and Japanese image OCR review workflow.
-- Originals and credentials are never stored. Every candidate remains non-public.
CREATE TABLE IF NOT EXISTS gd_content_extraction_targets (
  id TEXT PRIMARY KEY,
  source_id TEXT NOT NULL,
  mode TEXT NOT NULL CHECK (mode IN ('page_selection','image_ocr')),
  page_url TEXT NOT NULL,
  selector TEXT,
  image_url TEXT,
  label TEXT NOT NULL,
  state TEXT NOT NULL DEFAULT 'active' CHECK (state IN ('active','paused','withdrawn')),
  withdrawal_reason TEXT,
  created_by TEXT NOT NULL REFERENCES gd_users(id),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS idx_gd_content_extraction_target_unique
ON gd_content_extraction_targets(source_id,mode,page_url,COALESCE(selector,''),COALESCE(image_url,''));

CREATE TABLE IF NOT EXISTS gd_content_extraction_runs (
  id TEXT PRIMARY KEY,
  target_id TEXT NOT NULL REFERENCES gd_content_extraction_targets(id),
  mode TEXT NOT NULL CHECK (mode IN ('page_selection','image_ocr')),
  status TEXT NOT NULL CHECK (status IN ('completed','partial','unchanged','failed','withdrawn')),
  change_type TEXT CHECK (change_type IN ('first_seen','unchanged','price_changed','validity_changed','content_changed','deleted','moved')),
  accepted_count INTEGER NOT NULL DEFAULT 0 CHECK (accepted_count >= 0),
  error_code TEXT,
  original_retained INTEGER NOT NULL DEFAULT 0 CHECK (original_retained = 0),
  automatic_publish INTEGER NOT NULL DEFAULT 0 CHECK (automatic_publish = 0),
  dry_run INTEGER NOT NULL DEFAULT 1 CHECK (dry_run IN (0,1)),
  actor_id TEXT NOT NULL REFERENCES gd_users(id),
  started_at TEXT NOT NULL,
  completed_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_gd_content_extraction_runs_target
ON gd_content_extraction_runs(target_id,completed_at DESC,id DESC);

CREATE TABLE IF NOT EXISTS gd_content_extraction_candidates (
  id TEXT PRIMARY KEY,
  target_id TEXT NOT NULL REFERENCES gd_content_extraction_targets(id),
  source_item_key TEXT NOT NULL,
  kind TEXT NOT NULL CHECK (kind IN ('page_fact','image_ocr')),
  origin TEXT NOT NULL CHECK (origin IN ('automatic','user_image')),
  payload_hash TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  evidence_location_json TEXT NOT NULL,
  confidence REAL,
  review_state TEXT NOT NULL DEFAULT 'pending' CHECK (review_state IN ('pending','user_confirmed','operator_approved','needs_changes','rejected','withdrawn')),
  review_reason TEXT,
  submitted_by_user_id TEXT REFERENCES gd_users(id),
  user_confirmed_at TEXT,
  reviewed_by TEXT REFERENCES gd_users(id),
  reviewed_at TEXT,
  linked_deal_id TEXT REFERENCES gd_deals(id),
  first_seen_at TEXT NOT NULL,
  last_seen_at TEXT NOT NULL,
  last_run_id TEXT NOT NULL REFERENCES gd_content_extraction_runs(id),
  automatic_publish INTEGER NOT NULL DEFAULT 0 CHECK (automatic_publish = 0),
  UNIQUE(target_id,source_item_key)
);
CREATE INDEX IF NOT EXISTS idx_gd_content_extraction_candidates_review
ON gd_content_extraction_candidates(review_state,last_seen_at DESC,id DESC);

CREATE TABLE IF NOT EXISTS gd_content_extraction_assets (
  candidate_id TEXT PRIMARY KEY REFERENCES gd_content_extraction_candidates(id) ON DELETE CASCADE,
  safe_derivative_id TEXT NOT NULL,
  output_mime TEXT NOT NULL CHECK (output_mime = 'image/webp'),
  metadata_stripped INTEGER NOT NULL CHECK (metadata_stripped = 1),
  gps_stripped INTEGER NOT NULL CHECK (gps_stripped = 1),
  original_retained INTEGER NOT NULL DEFAULT 0 CHECK (original_retained = 0),
  redacted_region_count INTEGER NOT NULL DEFAULT 0 CHECK (redacted_region_count >= 0),
  created_at TEXT NOT NULL
);
