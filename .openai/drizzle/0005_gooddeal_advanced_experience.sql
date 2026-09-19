CREATE TABLE IF NOT EXISTS gd_user_preferences (
  user_id TEXT PRIMARY KEY REFERENCES gd_users(id) ON DELETE CASCADE,
  region_code TEXT,
  interests_json TEXT NOT NULL DEFAULT '[]',
  personalization_enabled INTEGER NOT NULL DEFAULT 1 CHECK (personalization_enabled IN (0,1)),
  notification_mode TEXT NOT NULL DEFAULT 'daily' CHECK (notification_mode IN ('instant','daily','weekly','off')),
  notification_types_json TEXT NOT NULL DEFAULT '["price","expiry","submission","comment"]',
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_collections (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_collection_items (
  collection_id TEXT NOT NULL REFERENCES gd_collections(id) ON DELETE CASCADE,
  deal_id TEXT NOT NULL REFERENCES gd_deals(id) ON DELETE CASCADE,
  added_at TEXT NOT NULL,
  PRIMARY KEY (collection_id, deal_id)
);

CREATE INDEX IF NOT EXISTS idx_gd_collections_user_updated
ON gd_collections(user_id, updated_at DESC);

CREATE INDEX IF NOT EXISTS idx_gd_collection_items_deal
ON gd_collection_items(deal_id, added_at DESC);
