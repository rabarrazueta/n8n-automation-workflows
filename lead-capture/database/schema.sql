-- Tabla de leads capturados desde formularios web
CREATE TABLE IF NOT EXISTS processia_leads (
    id SERIAL PRIMARY KEY,
    lead_id VARCHAR(255) UNIQUE NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    empresa VARCHAR(255),
    telefono VARCHAR(50),
    mensaje TEXT NOT NULL,
    lead_score INTEGER DEFAULT 0,
    lead_quality VARCHAR(20) CHECK (lead_quality IN ('hot', 'warm', 'cold')),
    source VARCHAR(100),
    metadata JSONB,
    synced_to_odoo BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para performance
CREATE INDEX idx_leads_email ON processia_leads(email);
CREATE INDEX idx_leads_quality ON processia_leads(lead_quality);
CREATE INDEX idx_leads_synced ON processia_leads(synced_to_odoo);
CREATE INDEX idx_leads_created ON processia_leads(created_at DESC);

-- Trigger para updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_processia_leads_updated_at
    BEFORE UPDATE ON processia_leads
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
