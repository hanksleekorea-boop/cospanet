CREATE TABLE IF NOT EXISTS kp_contribution_rewards (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  contribution_type TEXT NOT NULL CHECK(contribution_type IN ('new_deal','correction','availability','evidence')),
  target_id TEXT NOT NULL,
  state TEXT NOT NULL CHECK(state IN ('pending','confirmed','cancelled')),
  points INTEGER NOT NULL CHECK(points > 0),
  reason_code TEXT NOT NULL,
  risk_state TEXT NOT NULL CHECK(risk_state IN ('clear','review')),
  confirmed_at TEXT,
  cancelled_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE(contribution_type, target_id)
);
CREATE INDEX IF NOT EXISTS kp_contribution_rewards_queue_idx ON kp_contribution_rewards(state, risk_state, created_at);
CREATE INDEX IF NOT EXISTS kp_contribution_rewards_user_idx ON kp_contribution_rewards(user_id, created_at DESC);

CREATE TABLE IF NOT EXISTS kp_point_risk_events (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  reward_id TEXT REFERENCES kp_contribution_rewards(id),
  transfer_id TEXT REFERENCES kp_point_transfer_offers(id),
  signal_code TEXT NOT NULL CHECK(signal_code IN ('daily_contribution_volume','operator_self_review','circular_gift','new_account_velocity','manual_flag')),
  state TEXT NOT NULL CHECK(state IN ('open','cleared','confirmed_abuse')),
  detail TEXT NOT NULL,
  reviewed_by TEXT REFERENCES gd_users(id),
  reviewed_at TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS kp_point_risk_events_queue_idx ON kp_point_risk_events(state, created_at);
