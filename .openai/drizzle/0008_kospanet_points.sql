CREATE TABLE IF NOT EXISTS kp_point_accounts (
  user_id TEXT PRIMARY KEY REFERENCES gd_users(id),
  gift_address TEXT NOT NULL UNIQUE,
  available INTEGER NOT NULL DEFAULT 0 CHECK(available >= 0),
  pending INTEGER NOT NULL DEFAULT 0 CHECK(pending >= 0),
  held INTEGER NOT NULL DEFAULT 0 CHECK(held >= 0),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS kp_point_ledger (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  kind TEXT NOT NULL CHECK(kind IN ('activity_confirmed','operator_compensation','transfer_hold','transfer_release','transfer_out','transfer_in','premium_spend','premium_refund','reversal')),
  amount INTEGER NOT NULL,
  available_after INTEGER NOT NULL CHECK(available_after >= 0),
  held_after INTEGER NOT NULL CHECK(held_after >= 0),
  source_type TEXT NOT NULL,
  source_id TEXT,
  transfer_id TEXT,
  counterparty_user_id TEXT REFERENCES gd_users(id),
  reason_code TEXT NOT NULL,
  idempotency_key TEXT NOT NULL,
  effective_at TEXT NOT NULL,
  expires_at TEXT,
  created_at TEXT NOT NULL,
  UNIQUE(user_id, idempotency_key)
);
CREATE INDEX IF NOT EXISTS kp_point_ledger_user_idx ON kp_point_ledger(user_id, created_at DESC, id DESC);

CREATE TABLE IF NOT EXISTS kp_point_lots (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  source_ledger_id TEXT NOT NULL REFERENCES kp_point_ledger(id),
  origin_lot_id TEXT,
  source_type TEXT NOT NULL CHECK(source_type IN ('activity','operator_compensation')),
  original_points INTEGER NOT NULL CHECK(original_points > 0),
  remaining_points INTEGER NOT NULL CHECK(remaining_points >= 0),
  transferable INTEGER NOT NULL CHECK(transferable IN (0,1)),
  expires_at TEXT NOT NULL,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS kp_point_lots_spend_idx ON kp_point_lots(user_id, transferable, expires_at, created_at);

CREATE TABLE IF NOT EXISTS kp_point_transfer_offers (
  id TEXT PRIMARY KEY,
  sender_user_id TEXT NOT NULL REFERENCES gd_users(id),
  recipient_user_id TEXT NOT NULL REFERENCES gd_users(id),
  points INTEGER NOT NULL CHECK(points > 0 AND points <= 50),
  state TEXT NOT NULL CHECK(state IN ('pending','accepted','rejected','cancelled','expired')),
  message TEXT NOT NULL DEFAULT '',
  expires_at TEXT NOT NULL,
  accepted_at TEXT,
  cancelled_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  CHECK(sender_user_id <> recipient_user_id)
);
CREATE INDEX IF NOT EXISTS kp_point_transfer_sender_idx ON kp_point_transfer_offers(sender_user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS kp_point_transfer_recipient_idx ON kp_point_transfer_offers(recipient_user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS kp_point_transfer_lots (
  transfer_id TEXT NOT NULL REFERENCES kp_point_transfer_offers(id),
  point_lot_id TEXT NOT NULL REFERENCES kp_point_lots(id),
  points INTEGER NOT NULL CHECK(points > 0),
  original_expires_at TEXT NOT NULL,
  PRIMARY KEY(transfer_id, point_lot_id)
);
