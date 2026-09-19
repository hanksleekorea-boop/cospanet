-- Level-four merchant/store integrations. Provider credentials stay in server-managed secret storage.
CREATE TABLE IF NOT EXISTS gd_merchants (
  id TEXT PRIMARY KEY,
  owner_user_id TEXT NOT NULL UNIQUE REFERENCES gd_users(id),
  business_name TEXT NOT NULL,
  public_contact_url TEXT NOT NULL,
  policy_version TEXT NOT NULL CHECK (policy_version = 'store-content-v1'),
  state TEXT NOT NULL DEFAULT 'active' CHECK (state IN ('active','suspended','withdrawn')),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS gd_merchant_stores (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL REFERENCES gd_merchants(id),
  name TEXT NOT NULL,
  region_code TEXT NOT NULL,
  public_address TEXT NOT NULL,
  proof_ref TEXT NOT NULL,
  verification_state TEXT NOT NULL DEFAULT 'pending' CHECK (verification_state IN ('pending','verified','rejected','suspended')),
  verification_reason TEXT,
  verified_by TEXT REFERENCES gd_users(id),
  verified_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_gd_merchant_stores_merchant ON gd_merchant_stores(merchant_id,updated_at DESC);
CREATE TABLE IF NOT EXISTS gd_store_integrations (
  id TEXT PRIMARY KEY,
  store_id TEXT NOT NULL REFERENCES gd_merchant_stores(id),
  provider TEXT NOT NULL CHECK (provider IN ('smaregi','square','shopify','line')),
  external_account_hash TEXT,
  scopes_json TEXT NOT NULL,
  policy_version TEXT NOT NULL CHECK (policy_version = 'store-content-v1'),
  state TEXT NOT NULL DEFAULT 'pending' CHECK (state IN ('pending','active','paused','revoked','expired','rejected')),
  state_reason TEXT,
  token_expires_at TEXT,
  credential_stored INTEGER NOT NULL DEFAULT 0 CHECK (credential_stored = 0),
  automatic_publish INTEGER NOT NULL DEFAULT 0 CHECK (automatic_publish = 0),
  approved_by TEXT REFERENCES gd_users(id),
  approved_at TEXT,
  revoked_at TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  UNIQUE(store_id,provider)
);
CREATE INDEX IF NOT EXISTS idx_gd_store_integrations_state ON gd_store_integrations(state,provider,updated_at DESC);
CREATE TABLE IF NOT EXISTS gd_store_webhook_events (
  id TEXT PRIMARY KEY,
  integration_id TEXT NOT NULL REFERENCES gd_store_integrations(id),
  provider TEXT NOT NULL,
  provider_event_id TEXT NOT NULL,
  action TEXT NOT NULL,
  external_store_hash TEXT,
  item_ids_json TEXT NOT NULL,
  payload_hash TEXT NOT NULL,
  signature_verified INTEGER NOT NULL CHECK (signature_verified = 1),
  raw_retained INTEGER NOT NULL DEFAULT 0 CHECK (raw_retained = 0),
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','processed','ignored','failed')),
  received_at TEXT NOT NULL,
  processed_at TEXT,
  UNIQUE(provider,provider_event_id)
);
CREATE INDEX IF NOT EXISTS idx_gd_store_webhook_pending ON gd_store_webhook_events(integration_id,status,received_at);
CREATE TABLE IF NOT EXISTS gd_store_sync_runs (
  id TEXT PRIMARY KEY,
  integration_id TEXT NOT NULL REFERENCES gd_store_integrations(id),
  status TEXT NOT NULL CHECK (status IN ('completed','unchanged','partial','failed')),
  received_count INTEGER NOT NULL DEFAULT 0 CHECK (received_count >= 0),
  accepted_count INTEGER NOT NULL DEFAULT 0 CHECK (accepted_count >= 0),
  error_code TEXT,
  dry_run INTEGER NOT NULL DEFAULT 1 CHECK (dry_run IN (0,1)),
  automatic_publish INTEGER NOT NULL DEFAULT 0 CHECK (automatic_publish = 0),
  actor_id TEXT NOT NULL REFERENCES gd_users(id),
  started_at TEXT NOT NULL,
  completed_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_gd_store_sync_runs_integration ON gd_store_sync_runs(integration_id,completed_at DESC);
CREATE TABLE IF NOT EXISTS gd_store_content_candidates (
  id TEXT PRIMARY KEY,
  integration_id TEXT NOT NULL REFERENCES gd_store_integrations(id),
  store_id TEXT NOT NULL REFERENCES gd_merchant_stores(id),
  external_item_id TEXT NOT NULL,
  payload_hash TEXT NOT NULL,
  payload_json TEXT NOT NULL,
  review_state TEXT NOT NULL DEFAULT 'draft' CHECK (review_state IN ('draft','merchant_confirmed','operator_approved','needs_changes','rejected','withdrawn')),
  review_reason TEXT,
  merchant_confirmed_at TEXT,
  reviewed_by TEXT REFERENCES gd_users(id),
  reviewed_at TEXT,
  linked_deal_id TEXT REFERENCES gd_deals(id),
  first_seen_at TEXT NOT NULL,
  last_seen_at TEXT NOT NULL,
  automatic_publish INTEGER NOT NULL DEFAULT 0 CHECK (automatic_publish = 0),
  UNIQUE(integration_id,external_item_id)
);
CREATE INDEX IF NOT EXISTS idx_gd_store_candidates_review ON gd_store_content_candidates(review_state,last_seen_at DESC);
