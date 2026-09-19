CREATE TABLE IF NOT EXISTS kp_budget_accounts (
  user_id TEXT PRIMARY KEY REFERENCES gd_users(id),
  revision INTEGER NOT NULL DEFAULT 0,
  sync_consent INTEGER NOT NULL DEFAULT 0 CHECK(sync_consent IN (0,1)),
  updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS kp_budget_entries (
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  id TEXT NOT NULL,
  occurred_on TEXT NOT NULL,
  kind TEXT NOT NULL CHECK(kind IN ('expense','income','transfer','refund')),
  category_id TEXT NOT NULL,
  amount INTEGER NOT NULL CHECK(amount>0),
  payload_json TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  PRIMARY KEY(user_id,id)
);
CREATE INDEX IF NOT EXISTS kp_budget_entries_month_idx ON kp_budget_entries(user_id,occurred_on,kind);
CREATE TABLE IF NOT EXISTS kp_budget_deletion_markers (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  deleted_revision INTEGER NOT NULL,
  created_at TEXT NOT NULL
);
