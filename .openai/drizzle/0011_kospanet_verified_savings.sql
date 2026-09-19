CREATE TABLE IF NOT EXISTS kp_shopping_lists (
  user_id TEXT PRIMARY KEY REFERENCES gd_users(id),
  revision INTEGER NOT NULL DEFAULT 0,
  payload_json TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS kp_saving_decisions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  shopping_item_id TEXT NOT NULL,
  deal_id TEXT REFERENCES gd_deals(id),
  decision TEXT NOT NULL CHECK(decision IN ('buy','substitute','wait','skip')),
  baseline_minor INTEGER CHECK(baseline_minor IS NULL OR baseline_minor >= 0),
  selected_total_minor INTEGER CHECK(selected_total_minor IS NULL OR selected_total_minor >= 0),
  predicted_saving_minor INTEGER,
  reason TEXT NOT NULL,
  state TEXT NOT NULL CHECK(state IN ('active','completed','cancelled')),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_kp_saving_decisions_user_state
ON kp_saving_decisions(user_id,state,created_at DESC);

CREATE TABLE IF NOT EXISTS kp_saving_outcomes (
  id TEXT PRIMARY KEY,
  decision_id TEXT NOT NULL UNIQUE REFERENCES kp_saving_decisions(id),
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  actual_spend_minor INTEGER CHECK(actual_spend_minor IS NULL OR actual_spend_minor >= 0),
  extra_cost_minor INTEGER NOT NULL DEFAULT 0 CHECK(extra_cost_minor >= 0),
  confirmed_saving_minor INTEGER,
  outcome_type TEXT NOT NULL CHECK(outcome_type IN ('confirmed','estimated','nonpurchase','extra_cost','overspend','unconfirmed')),
  confidence TEXT NOT NULL CHECK(confidence IN ('user_confirmed','insufficient')),
  note TEXT NOT NULL DEFAULT '',
  confirmed_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_kp_saving_outcomes_user_confirmed
ON kp_saving_outcomes(user_id,confirmed_at DESC);

CREATE TABLE IF NOT EXISTS kp_privacy_preferences (
  user_id TEXT PRIMARY KEY REFERENCES gd_users(id),
  sync_enabled INTEGER NOT NULL DEFAULT 0 CHECK(sync_enabled IN (0,1)),
  ai_transmission INTEGER NOT NULL DEFAULT 0 CHECK(ai_transmission IN (0,1)),
  location_precision TEXT NOT NULL DEFAULT 'prefecture' CHECK(location_precision IN ('none','prefecture','municipality')),
  analytics_enabled INTEGER NOT NULL DEFAULT 0 CHECK(analytics_enabled IN (0,1)),
  ads_enabled INTEGER NOT NULL DEFAULT 0 CHECK(ads_enabled IN (0,1)),
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_deal_verifications (
  deal_id TEXT NOT NULL REFERENCES gd_deals(id),
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  verdict TEXT NOT NULL CHECK(verdict IN ('available','sold_out','condition_changed','confirmed')),
  observed_at TEXT NOT NULL,
  reason TEXT NOT NULL DEFAULT '',
  evidence_ref TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  PRIMARY KEY(deal_id,user_id)
);
CREATE INDEX IF NOT EXISTS idx_gd_deal_verifications_recent
ON gd_deal_verifications(deal_id,observed_at DESC);

PRAGMA optimize;
