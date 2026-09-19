CREATE TABLE IF NOT EXISTS gd_rate_limits (
  actor_id TEXT NOT NULL,
  route_group TEXT NOT NULL,
  window_start TEXT NOT NULL,
  count INTEGER NOT NULL DEFAULT 0 CHECK (count >= 0),
  updated_at TEXT NOT NULL,
  PRIMARY KEY (actor_id, route_group, window_start)
);

CREATE TABLE IF NOT EXISTS gd_deleted_subjects (
  subject_hash TEXT PRIMARY KEY,
  deleted_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_gd_rate_limits_updated
ON gd_rate_limits(updated_at);
