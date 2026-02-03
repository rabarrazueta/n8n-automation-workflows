-- ==============================================
-- Table: processia_leads
-- Purpose: Store leads captured from web forms
-- ==============================================

CREATE TABLE IF NOT EXISTS processia_leads (
  id SERIAL PRIMARY KEY,
  lead_id VARCHAR(255) UNIQUE NOT NULL,
  nombre VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  empresa VARCHAR(255),
  telefono VARCHAR(50),
  mensaje TEXT,
  lead_score INTEGER DEFAULT 0 CHECK (lead_score >= 0 AND lead_score <= 100),
  lead_quality VARCHAR(20) CHECK (lead_quality IN ('hot', 'warm', 'cold')),
  source VARCHAR(100),
  metadata JSONB,
  synced_to_odoo BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_processia_leads_synced ON processia_leads(synced_to_odoo);
CREATE INDEX IF NOT EXISTS idx_processia_leads_created_at ON processia_leads(created_at);
CREATE INDEX IF NOT EXISTS idx_processia_leads_email ON processia_leads(email);
CREATE INDEX IF NOT EXISTS idx_processia_leads_quality ON processia_leads(lead_quality);

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_processia_leads_updated_at
  BEFORE UPDATE ON processia_leads
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Set database timezone
ALTER DATABASE defaultdb SET timezone TO 'America/Guayaquil';
