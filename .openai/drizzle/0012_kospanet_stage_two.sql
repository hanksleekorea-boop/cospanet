CREATE TABLE IF NOT EXISTS kp_income_profiles (
  user_id TEXT PRIMARY KEY REFERENCES gd_users(id),
  pay_cycle TEXT NOT NULL CHECK(pay_cycle IN ('monthly','twice_monthly','weekly','irregular')),
  next_income_minor INTEGER CHECK(next_income_minor IS NULL OR next_income_minor >= 0),
  next_income_at TEXT,
  safety_reserve_minor INTEGER NOT NULL DEFAULT 0 CHECK(safety_reserve_minor >= 0),
  payload_json TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS kp_households (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  owner_user_id TEXT NOT NULL REFERENCES gd_users(id),
  invite_hash TEXT UNIQUE,
  invite_expires_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS kp_household_members (
  household_id TEXT NOT NULL REFERENCES kp_households(id),
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  role TEXT NOT NULL CHECK(role IN ('owner','member')),
  state TEXT NOT NULL CHECK(state IN ('active','left')),
  joined_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  PRIMARY KEY(household_id,user_id)
);
CREATE INDEX IF NOT EXISTS idx_kp_household_members_user
ON kp_household_members(user_id,state);
CREATE TABLE IF NOT EXISTS kp_household_items (
  id TEXT PRIMARY KEY,
  household_id TEXT NOT NULL REFERENCES kp_households(id),
  owner_user_id TEXT NOT NULL REFERENCES gd_users(id),
  title TEXT NOT NULL,
  amount_minor INTEGER CHECK(amount_minor IS NULL OR amount_minor >= 0),
  category TEXT NOT NULL,
  note TEXT NOT NULL DEFAULT '',
  revision INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_kp_household_items_household
ON kp_household_items(household_id,updated_at DESC);

CREATE TABLE IF NOT EXISTS kp_stage_two_alerts (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  payload_json TEXT NOT NULL,
  enabled INTEGER NOT NULL DEFAULT 1 CHECK(enabled IN (0,1)),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_kp_stage_two_alerts_user
ON kp_stage_two_alerts(user_id,enabled,updated_at DESC);

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
