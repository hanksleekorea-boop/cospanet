-- Durable, operator-only evidence for the content programme.  A row records
-- what a reviewer attested; it never turns a candidate into published content
-- by itself and it is intentionally scoped to one immutable deal revision.
CREATE TABLE IF NOT EXISTS gd_content_review_ledger (
  id TEXT PRIMARY KEY,
  deal_id TEXT NOT NULL REFERENCES gd_deals(id) ON DELETE CASCADE,
  revision INTEGER NOT NULL CHECK (revision > 0),
  review_type TEXT NOT NULL CHECK (review_type IN ('source_rights','source_snapshot','fact_check','native_language','correction')),
  decision TEXT NOT NULL CHECK (decision IN ('approved','needs_changes','rejected')),
  evidence_ref TEXT,
  summary TEXT NOT NULL,
  reviewed_by TEXT NOT NULL REFERENCES gd_users(id),
  reviewed_at TEXT NOT NULL,
  expires_at TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_gd_content_review_current
ON gd_content_review_ledger(deal_id,revision,review_type,decision,reviewed_at DESC);

-- A regional/category cell may be marked temporarily not applicable only by
-- an operator with a reason and an expiry.  These rows are audit annotations,
-- not inventory: they never increase the 900/3,000/10,000 content totals.
CREATE TABLE IF NOT EXISTS gd_content_not_applicable_approvals (
  id TEXT PRIMARY KEY,
  stage INTEGER NOT NULL CHECK (stage IN (1,2,3)),
  region_code TEXT NOT NULL,
  category_id TEXT NOT NULL,
  scope TEXT NOT NULL CHECK (scope IN ('temporary_gap','not_applicable')),
  reason TEXT NOT NULL,
  approved_by TEXT NOT NULL REFERENCES gd_users(id),
  approved_at TEXT NOT NULL,
  expires_at TEXT NOT NULL,
  revoked_at TEXT,
  revoked_by TEXT REFERENCES gd_users(id),
  revoke_reason TEXT,
  created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_gd_content_na_active
ON gd_content_not_applicable_approvals(stage,region_code,category_id,expires_at)
WHERE revoked_at IS NULL;
