ALTER TABLE gd_collections ADD COLUMN visibility TEXT NOT NULL DEFAULT 'private' CHECK (visibility IN ('private','public'));
ALTER TABLE gd_collections ADD COLUMN share_token TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS idx_gd_collections_share_token ON gd_collections(share_token) WHERE share_token IS NOT NULL;

ALTER TABLE gd_inbox_events ADD COLUMN dedupe_key TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS idx_gd_inbox_user_dedupe ON gd_inbox_events(user_id,dedupe_key) WHERE dedupe_key IS NOT NULL;

CREATE TABLE IF NOT EXISTS gd_editorial_collections (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  selection_reason TEXT NOT NULL,
  state TEXT NOT NULL DEFAULT 'draft' CHECK (state IN ('draft','published','archived')),
  created_by TEXT NOT NULL REFERENCES gd_users(id),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_editorial_collection_items (
  collection_id TEXT NOT NULL REFERENCES gd_editorial_collections(id) ON DELETE CASCADE,
  deal_id TEXT NOT NULL REFERENCES gd_deals(id) ON DELETE CASCADE,
  position INTEGER NOT NULL DEFAULT 0 CHECK (position >= 0),
  added_at TEXT NOT NULL,
  PRIMARY KEY (collection_id,deal_id)
);

CREATE TABLE IF NOT EXISTS gd_daily_metrics (
  day TEXT NOT NULL,
  metric TEXT NOT NULL,
  dimension TEXT NOT NULL DEFAULT '',
  count INTEGER NOT NULL DEFAULT 0 CHECK (count >= 0),
  updated_at TEXT NOT NULL,
  PRIMARY KEY (day,metric,dimension)
);

CREATE INDEX IF NOT EXISTS idx_gd_editorial_state_updated ON gd_editorial_collections(state,updated_at DESC);
CREATE INDEX IF NOT EXISTS idx_gd_editorial_items_position ON gd_editorial_collection_items(collection_id,position,added_at);
