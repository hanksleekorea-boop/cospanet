CREATE TABLE IF NOT EXISTS gd_support_cases (
  id TEXT PRIMARY KEY,
  requester_id TEXT NOT NULL REFERENCES gd_users(id),
  type TEXT NOT NULL CHECK (type IN ('general','rights','privacy','deletion')),
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  state TEXT NOT NULL DEFAULT 'received' CHECK (state IN ('received','reviewing','waiting_user','resolved','closed')),
  operator_response TEXT,
  assigned_to TEXT REFERENCES gd_users(id),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  resolved_at TEXT
);

CREATE TABLE IF NOT EXISTS gd_support_events (
  id TEXT PRIMARY KEY,
  support_id TEXT NOT NULL REFERENCES gd_support_cases(id),
  actor_id TEXT REFERENCES gd_users(id),
  action TEXT NOT NULL CHECK (action IN ('received','start_review','request_info','user_reply','resolve','close')),
  message TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_gd_support_requester_updated
ON gd_support_cases(requester_id, updated_at DESC, id DESC);

CREATE INDEX IF NOT EXISTS idx_gd_support_state_created
ON gd_support_cases(state, created_at, id);

CREATE INDEX IF NOT EXISTS idx_gd_support_events_case_created
ON gd_support_events(support_id, created_at, id);
