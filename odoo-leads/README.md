\# PostgreSQL → Odoo CRM Lead Sync



Workflow automatizado de n8n que sincroniza leads desde base de datos PostgreSQL a Odoo CRM cada 15 minutos con manejo de errores y auto-retry.



\## Descripción



Este workflow lee leads pendientes de sincronización desde una tabla PostgreSQL y los crea como oportunidades en Odoo CRM. Incluye:



\- Sincronización automática cada 15 minutos

\- Procesamiento en batches (50 leads max por ejecución)

\- Clasificación automática de leads (hot/warm/cold → priority)

\- Manejo de errores con auto-retry

\- Logging completo de errores

\- Timezone: America/Guayaquil



\## Arquitectura



Schedule Trigger (15 min)

↓

PostgreSQL SELECT (WHERE synced\_to\_odoo = false, LIMIT 50)

↓

Loop Over Items

↓

Code: Prepare Data (mapeo + limpieza)

↓

Odoo: Create Opportunity

↓

IF: ¿Creado exitosamente?

├─ TRUE → PostgreSQL UPDATE (synced\_to\_odoo = true)

└─ FALSE → Code: Log Error → Retry en 15 min



\## Requisitos



\- \*\*n8n\*\* v2.4.6+

\- \*\*PostgreSQL\*\* 12+ (recomendado: DigitalOcean Managed Database)

\- \*\*Odoo\*\* v14+ con API habilitada



\## Instalación



\### 1. Crear tabla en PostgreSQL



`bash

psql -h your-host -U doadmin -d defaultdb < schema.sql



2\. Configurar credenciales en Odoo



&nbsp;   Ir a Odoo → Perfil → Account Security → API Keys



&nbsp;   Crear nueva API Key



&nbsp;   Copiar la clave generada



3\. Importar workflow en n8n



&nbsp;   En n8n: Workflows → Import from File



&nbsp;   Seleccionar workflow.json



&nbsp;   Configurar credenciales:



PostgreSQL Connection:



&nbsp;   Host: Tu host de DigitalOcean



&nbsp;   Port: 25060



&nbsp;   Database: defaultdb



&nbsp;   User: doadmin



&nbsp;   Password: Tu contraseña



&nbsp;   SSL: Activado



Odoo API Connection:



&nbsp;   Site URL: https://tu-empresa.odoo.com



&nbsp;   Username: tu-email@company.com



&nbsp;   API Key: La clave copiada



&nbsp;   Database: nombre\_bd\_odoo



4\. Activar workflow



Toggle Active en n8n



\## Configuración



Ajustar intervalo de sincronización



En el nodo Schedule Trigger:



&nbsp;   Cambiar minutesInterval de 15 a tu valor preferido



Ajustar batch limit



En el nodo Select rows from a table:



&nbsp;   Cambiar limit de 50 a tu valor preferido. NO se recomienda valores muy altos.



Personalizar limpieza de teléfonos



En el nodo Code in JavaScript, líneas 24-35:



&nbsp;   Modificar el prefijo +593 según tu país



Mapeo de Campos

PostgreSQL	Odoo CRM

nombre + empresa	name

nombre	contact\_name

email	email\_from

telefono	phone

empresa	partner\_name

mensaje + metadata	description

lead\_quality	priority (hot=3, warm=2, cold=1)



\## Notas



&nbsp;   Los leads fallidos se reintentarán automáticamente en la próxima ejecución (15 min)



&nbsp;   El workflow procesa máximo 50 leads por ejecución para evitar timeouts



&nbsp;   Los errores se logean en la consola de n8n con detalles completos



&nbsp;   El campo synced\_to\_odoo controla qué leads se procesan



Workflows Relacionados



&nbsp;   Lead Capture - Captura de leads desde formulario web. YA DISPONIBLE EN ESTE REPO.



\## Autor



Robinson Barrazueta

Data Engineer \& Business Process Automation Specialist



Processia Ops - Automatización de procesos empresariales

Ecuador

