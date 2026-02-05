-- ==============================================
-- Chatbot Memory Schema (PostgreSQL)
-- ==============================================
-- Este schema DEBERÍA ser creado automáticamente por n8n,
-- pero lo incluimos para documentación
-- OJO, recomiendo su configuración directamente en su servicio de DB

-- Tabla de sesiones de chat
CREATE TABLE IF NOT EXISTS n8n_chat_histories (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(255) NOT NULL,
    message JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Índice para búsquedas rápidas por sesión
CREATE INDEX idx_chat_session ON n8n_chat_histories(session_id);
CREATE INDEX idx_chat_created_at ON n8n_chat_histories(created_at);

-- Set timezone
ALTER DATABASE chatbot_memory SET timezone TO 'America/Guayaquil';

-- Función para limpiar conversaciones antiguas (opcional)
CREATE OR REPLACE FUNCTION cleanup_old_chats()
RETURNS void AS $$
BEGIN
  DELETE FROM n8n_chat_histories
  WHERE created_at < NOW() - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql;
