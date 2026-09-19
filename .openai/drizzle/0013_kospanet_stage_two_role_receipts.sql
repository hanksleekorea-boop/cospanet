-- Upgrade migration for Sites environments that applied the original 0012
-- before role applications and receipt drafts were added to that file.
CREATE TABLE IF NOT EXISTS kp_role_applications (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  kind TEXT NOT NULL CHECK(kind IN ('community_verifier','merchant_correction')),
  region_code TEXT NOT NULL,
  statement TEXT NOT NULL,
  relationship TEXT NOT NULL,
  evidence_url TEXT,
  state TEXT NOT NULL CHECK(state IN ('submitted','in_review','approved','rejected','withdrawn')),
  reviewer_user_id TEXT REFERENCES gd_users(id),
  decision_reason TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_kp_role_applications_queue
ON kp_role_applications(state,created_at);

CREATE TABLE IF NOT EXISTS kp_receipt_drafts (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  payload_json TEXT NOT NULL,
  confirmed INTEGER NOT NULL DEFAULT 0 CHECK(confirmed IN (0,1)),
  original_retained INTEGER NOT NULL DEFAULT 0 CHECK(original_retained=0),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_kp_receipt_drafts_user
ON kp_receipt_drafts(user_id,updated_at DESC);

PRAGMA optimize;
