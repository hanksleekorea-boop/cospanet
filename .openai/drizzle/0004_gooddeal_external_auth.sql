CREATE TABLE IF NOT EXISTS gd_external_identities (
  provider TEXT NOT NULL CHECK (provider IN ('google','apple')),
  provider_subject TEXT NOT NULL,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  PRIMARY KEY (provider, provider_subject),
  UNIQUE (user_id, provider)
);

CREATE TABLE IF NOT EXISTS gd_auth_sessions (
  token_hash TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES gd_users(id),
  provider TEXT NOT NULL CHECK (provider IN ('google','apple')),
  created_at TEXT NOT NULL,
  expires_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS gd_oauth_states (
  state_hash TEXT PRIMARY KEY,
  provider TEXT NOT NULL CHECK (provider IN ('google','apple')),
  nonce TEXT NOT NULL,
  return_to TEXT NOT NULL,
  link_user_id TEXT REFERENCES gd_users(id),
  created_at TEXT NOT NULL,
  expires_at TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_gd_external_identities_user
ON gd_external_identities(user_id, provider);

CREATE INDEX IF NOT EXISTS idx_gd_auth_sessions_user_expiry
ON gd_auth_sessions(user_id, expires_at);

CREATE INDEX IF NOT EXISTS idx_gd_oauth_states_expiry
ON gd_oauth_states(expires_at);
