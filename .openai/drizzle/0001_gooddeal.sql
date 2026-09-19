CREATE TABLE IF NOT EXISTS gd_users (
  id TEXT PRIMARY KEY,
  auth_subject TEXT NOT NULL UNIQUE,
  alias TEXT NOT NULL UNIQUE,
  role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('member','moderator','admin')),
  state TEXT NOT NULL DEFAULT 'active' CHECK (state IN ('active','suspended','deleted')),
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_deals (
  id TEXT PRIMARY KEY,
  author_id TEXT NOT NULL REFERENCES gd_users(id),
  public_revision INTEGER,
  pending_revision INTEGER,
  edit_version INTEGER NOT NULL DEFAULT 1,
  publication_state TEXT NOT NULL CHECK (publication_state IN ('submitted','under_review','published','needs_changes','rejected','hidden','deleted')),
  availability TEXT NOT NULL DEFAULT 'reported_available' CHECK (availability IN ('reported_available','sold_out','check_needed')),
  search_title TEXT NOT NULL,
  search_channel TEXT NOT NULL,
  search_category TEXT NOT NULL,
  search_region TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS gd_deal_revisions (
  deal_id TEXT NOT NULL REFERENCES gd_deals(id),
  revision INTEGER NOT NULL,
  payload_json TEXT NOT NULL,
  material_revision INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  submitted_by TEXT NOT NULL REFERENCES gd_users(id),
  PRIMARY KEY (deal_id, revision)
);

CREATE TABLE IF NOT EXISTS gd_observations (
  deal_id TEXT NOT NULL REFERENCES gd_deals(id),
  public_revision INTEGER NOT NULL,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  value TEXT NOT NULL CHECK (value IN ('available','sold_out','condition_changed')),
  observed_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  PRIMARY KEY (deal_id, public_revision, user_id)
);

CREATE TABLE IF NOT EXISTS gd_votes (
  deal_id TEXT NOT NULL REFERENCES gd_deals(id),
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  value INTEGER NOT NULL CHECK (value IN (-1,1)),
  updated_at TEXT NOT NULL,
  PRIMARY KEY (deal_id, user_id)
);

CREATE TABLE IF NOT EXISTS gd_comments (
  id TEXT PRIMARY KEY,
  deal_id TEXT NOT NULL REFERENCES gd_deals(id),
  author_id TEXT NOT NULL REFERENCES gd_users(id),
  parent_id TEXT REFERENCES gd_comments(id),
  body TEXT NOT NULL,
  state TEXT NOT NULL DEFAULT 'visible' CHECK (state IN ('visible','hidden','deleted')),
  edit_version INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_cases (
  id TEXT PRIMARY KEY,
  deal_id TEXT REFERENCES gd_deals(id),
  comment_id TEXT REFERENCES gd_comments(id),
  reporter_id TEXT REFERENCES gd_users(id),
  type TEXT NOT NULL CHECK (type IN ('price_error','stock_error','rights','privacy','abuse','other')),
  state TEXT NOT NULL DEFAULT 'received' CHECK (state IN ('received','triaged','reviewing','waiting_user','actioned','rejected','appealed','closed')),
  reason TEXT NOT NULL,
  assigned_to TEXT REFERENCES gd_users(id),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_case_events (
  id TEXT PRIMARY KEY,
  case_id TEXT NOT NULL REFERENCES gd_cases(id),
  actor_id TEXT REFERENCES gd_users(id),
  action TEXT NOT NULL,
  reason TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_inbox_events (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  type TEXT NOT NULL,
  entity_id TEXT NOT NULL,
  message TEXT NOT NULL,
  read_at TEXT,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_mutation_receipts (
  actor_id TEXT NOT NULL,
  request_key TEXT NOT NULL,
  route TEXT NOT NULL,
  request_hash TEXT NOT NULL,
  status_code INTEGER NOT NULL,
  response_json TEXT NOT NULL,
  created_at TEXT NOT NULL,
  PRIMARY KEY (actor_id, request_key)
);

CREATE TABLE IF NOT EXISTS gd_deletion_requests (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  state TEXT NOT NULL DEFAULT 'completed' CHECK (state IN ('requested','processing','completed','failed')),
  requested_at TEXT NOT NULL,
  completed_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_gd_deals_publication_created ON gd_deals(publication_state, created_at DESC, id DESC);
CREATE INDEX IF NOT EXISTS idx_gd_deals_public_filters ON gd_deals(publication_state, search_channel, search_category, search_region, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_gd_observations_deal_revision ON gd_observations(deal_id, public_revision);
CREATE INDEX IF NOT EXISTS idx_gd_comments_deal_state_created ON gd_comments(deal_id, state, created_at, id);
CREATE INDEX IF NOT EXISTS idx_gd_cases_state_created ON gd_cases(state, created_at);
CREATE INDEX IF NOT EXISTS idx_gd_inbox_user_created ON gd_inbox_events(user_id, created_at DESC, id DESC);
CREATE INDEX IF NOT EXISTS idx_gd_deletion_user_created ON gd_deletion_requests(user_id, requested_at DESC);
