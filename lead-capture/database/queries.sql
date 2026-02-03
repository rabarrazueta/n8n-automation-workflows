-- Leads hot del día
SELECT nombre, email, empresa, lead_score, created_at
FROM processia_leads
WHERE lead_quality = 'hot' 
  AND created_at::date = CURRENT_DATE
ORDER BY lead_score DESC;

-- Distribución por calidad
SELECT 
    lead_quality,
    COUNT(*) as total,
    ROUND(AVG(lead_score), 2) as score_promedio
FROM processia_leads
GROUP BY lead_quality
ORDER BY 
    CASE lead_quality
        WHEN 'hot' THEN 1
        WHEN 'warm' THEN 2
        WHEN 'cold' THEN 3
    END;

-- Leads pendientes de sincronizar a Odoo
-- Con otro flujo se puede modificar de forma sencilla
SELECT COUNT(*) as pendientes
FROM processia_leads
WHERE synced_to_odoo = FALSE;

-- Top 5 empresas
SELECT 
    empresa,
    COUNT(*) as total_contactos
FROM processia_leads
WHERE empresa IS NOT NULL
GROUP BY empresa
ORDER BY total_contactos DESC
LIMIT 5;

-- Últimos 10 leads
SELECT 
    nombre,
    email,
    empresa,
    lead_quality,
    lead_score,
    created_at
FROM processia_leads
ORDER BY created_at DESC
LIMIT 10;
