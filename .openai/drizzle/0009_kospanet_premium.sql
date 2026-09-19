CREATE TABLE IF NOT EXISTS kp_premium_items (
  id TEXT PRIMARY KEY,
  deal_id TEXT NOT NULL REFERENCES gd_deals(id),
  content_revision INTEGER NOT NULL CHECK(content_revision > 0),
  premium_type TEXT NOT NULL CHECK(premium_type IN ('comparison','route','stack','forecast')),
  point_cost INTEGER NOT NULL CHECK(point_cost IN (10,20,30,50)),
  free_preview TEXT NOT NULL,
  premium_payload TEXT NOT NULL,
  review_state TEXT NOT NULL CHECK(review_state IN ('approved','rejected','retired')),
  premium_until TEXT NOT NULL,
  created_by TEXT NOT NULL REFERENCES gd_users(id),
  reviewed_by TEXT NOT NULL REFERENCES gd_users(id),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE(deal_id, content_revision)
);
CREATE INDEX IF NOT EXISTS kp_premium_items_deal_idx ON kp_premium_items(deal_id, review_state, premium_until);

CREATE TABLE IF NOT EXISTS kp_unlocks (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  premium_item_id TEXT NOT NULL REFERENCES kp_premium_items(id),
  content_revision INTEGER NOT NULL,
  point_cost INTEGER NOT NULL CHECK(point_cost > 0),
  ledger_id TEXT NOT NULL REFERENCES kp_point_ledger(id),
  state TEXT NOT NULL CHECK(state IN ('unlocked','refunded')),
  unlocked_at TEXT NOT NULL,
  refunded_at TEXT,
  refund_ledger_id TEXT REFERENCES kp_point_ledger(id),
  UNIQUE(user_id, premium_item_id, content_revision)
);
CREATE INDEX IF NOT EXISTS kp_unlocks_user_idx ON kp_unlocks(user_id, unlocked_at DESC);

CREATE TABLE IF NOT EXISTS kp_unlock_lots (
  unlock_id TEXT NOT NULL REFERENCES kp_unlocks(id),
  point_lot_id TEXT NOT NULL REFERENCES kp_point_lots(id),
  points INTEGER NOT NULL CHECK(points > 0),
  source_type TEXT NOT NULL CHECK(source_type IN ('activity','operator_compensation')),
  original_expires_at TEXT NOT NULL,
  PRIMARY KEY(unlock_id, point_lot_id)
);

CREATE TABLE IF NOT EXISTS kp_refund_requests (
  id TEXT PRIMARY KEY,
  unlock_id TEXT NOT NULL REFERENCES kp_unlocks(id),
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  reason_code TEXT NOT NULL CHECK(reason_code IN ('incorrect','content_unavailable','unlock_failed','removed_immediately','other')),
  detail TEXT NOT NULL DEFAULT '',
  state TEXT NOT NULL CHECK(state IN ('received','auto_refunded','approved','rejected')),
  operator_reason TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  resolved_at TEXT,
  UNIQUE(unlock_id)
);
CREATE INDEX IF NOT EXISTS kp_refund_requests_state_idx ON kp_refund_requests(state, created_at);
