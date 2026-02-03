# Sistema de Captura Inteligente de Leads con n8n



Workflow automatizado para capturar, clasificar y gestionar leads desde formularios web con scoring automático, notificaciones por email y almacenamiento en PostgreSQL. Además, permite transformar una landing page en una web dinámica sin necesidad de conocimiento avanzados de programación ni un host.



![n8n](https://img.shields.io/badge/n8n-2.4.6+-EA4B71?style=flat-square&logo=n8n)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-12+-336791?style=flat-square&logo=postgresql&logoColor=white)



---



## Descripción



Este workflow de n8n automatiza completamente el proceso de captura de leads desde formularios web, eliminando trabajo manual y garantizando respuesta inmediata a cada contacto.



### ¿Qué Hace?



1. **Recibe** formularios web vía webhook POST con validación de seguridad

2. **Clasifica** automáticamente cada lead según calidad (hot/warm/cold)

3. **Calcula** un lead score de 0-100 puntos basado en datos proporcionados

4. **Almacena** en PostgreSQL con metadata completa (navegador, idioma, timestamp)

5. **Notifica** vía email a tu equipo con análisis automático del lead

6. **Confirma** al cliente con email profesional de respuesta automática

7. **Responde** al navegador en <3 segundos para mejor UX



### Problema que Resuelve



**Antes:**

- Leads perdidos en emails sin leer

- Respuestas lentas a contactos importantes

- Sin priorización de oportunidades

- Datos dispersos sin seguimiento

- Página web estática sin uso real



**Después:**

- 100% de leads capturados y clasificados

- Notificaciones instantáneas al equipo

- Priorización automática por scoring

- Base de datos centralizada con metadata

- Confirmación inmediata al cliente

- Preparado para sincronización con CRM (Odoo)

- Página web básica convertida en una herramienta de ingresos reales.



---



## Lead Scoring Automático



Sistema de puntuación inteligente basado en calidad de datos:



| Criterio | Puntos | Lógica |

|----------|--------|--------|

| **Teléfono** | +30 | Longitud > 6 caracteres |

| **Empresa** | +40 | Campo no vacío |

| **Mensaje detallado** | +30 | Longitud > 100 caracteres |



### Clasificación por Calidad



- **HOT** (70-100 pts): Lead de alta prioridad

&nbsp; - Tiene todos los datos completos

&nbsp; - Requiere respuesta inmediata

&nbsp; - Mayor probabilidad de conversión



- **WARM** (40-69 pts): Lead de prioridad media

&nbsp; - Datos parcialmente completos

&nbsp; - Responder en 24 horas

&nbsp; - Potencial interesante



- **COLD** (<40 pts): Lead de baja prioridad

&nbsp; - Información mínima

&nbsp; - Seguimiento estándar

&nbsp; - Requiere calificación adicional



---



## Arquitectura del Sistema



┌─────────────────────┐

│ Usuario Completa │

│ Formulario Web │

│ (processia.online) │

└──────────┬──────────┘

│

│ POST /webhook/processia-contact-form

│ Header: X-Processia-Key: [token]

│ Body: JSON con datos del formulario

↓

┌──────────────────────────────────────────────┐

│ n8n Workflow Engine │

│ ┌────────────────────────────────────────┐ │

│ │ ① Webhook Receiver │ │

│ │ └─ Valida origen y método │ │

│ │ │ │

│ │ ② Security Validation (IF) │ │

│ │ └─ Comprueba X-Processia-Key │ │

│ │ │ │

│ │ ③ Lead Scoring (JavaScript) │ │

│ │ └─ Calcula score y calidad │ │

│ │ └─ Genera lead_id único │ │

│ │ │ │

│ │ ④ PostgreSQL Insert │ │

│ │ └─ Guarda lead con metadata │ │

│ │ │ │

│ │ ⑤ Email Notifications (Paralelo) │ │

│ │ ├─ Email interno (equipo) │ │

│ │ └─ Email confirmación (cliente) │ │

│ │ │ │

│ │ ⑥ Response (200 OK) │ │

│ │ └─ JSON con leadId y calidad │ │

│ └────────────────────────────────────────┘ │

└──────────────────────────────────────────────┘

│ │

↓ ↓

┌─────────────┐ ┌─────────────┐

│ PostgreSQL │ │ Zoho Mail │

│ Database │ │ SMTP │

└─────────────┘ └─────────────┘



text



**Tiempo de respuesta promedio:** 3-4 segundos



---



## Estructura de Datos



### Tabla: `processia_leads`



Ver carpeta /database



## Stack Tecnológico



| Componente | Tecnología | Versión | Uso |

|------------|------------|---------|-----|

| **Workflow Engine** | n8n | 2.4.6+ | Automatización principal |

| **Base de Datos** | PostgreSQL | 12+ | Almacenamiento persistente |

| **SMTP** | Zoho Mail | - | Envío de emails |

| **Hosting** | DigitalOcean | - | Servidor n8n + PostgreSQL |

| **Frontend** | HTML/CSS/JS | - | [Ver repo →](https://github.com/rabarrazueta/rabarrazueta.github.io) |



---



## Instalación



### Requisitos Previos



- n8n instalado (self-hosted o cloud)

- PostgreSQL 12 o superior

- Cuenta SMTP (Zoho Mail, Gmail, SendGrid, etc.)

- Dominio con SSL (recomendado para producción)



### Paso 1: Configurar Base de Datos



`bash

# Conectar a PostgreSQL

psql -U postgres -d tu_database



# Ejecutar schema

i database/schema.sql



# Verificar tabla creada

dt processia_leads



Resultado esperado:



&nbsp;   Tabla processia_leads creada



&nbsp;   4 índices configurados



&nbsp;   Trigger update_updated_at activo



Paso 2: Configurar Variables de Entorno



bash

# Copiar template

cp .env.example .env



# Editar con tus valores

nano .env



Variables críticas a configurar:



bash

WEBHOOK_SECRET_TOKEN=     # Generar con: openssl rand -hex 32

DB_HOST=                  # Host de tu PostgreSQL

DB_PASSWORD=              # Password de PostgreSQL

SMTP_USER=                # Tu email corporativo

SMTP_PASSWORD=            # Password SMTP o App Password

ALLOWED_ORIGIN=           # Tu dominio web



Paso 3: Importar Workflow a n8n



&nbsp;   Abrir n8n → Menú (☰) → Import from File



&nbsp;   Seleccionar workflow.json



&nbsp;   Configurar 3 credenciales:



A) PostgreSQL Database



&nbsp;   Credential Type: Postgres



&nbsp;   Host: Tu servidor PostgreSQL



&nbsp;   Database: Nombre de tu base de datos



&nbsp;   User: Usuario PostgreSQL



&nbsp;   Password: Password PostgreSQL



&nbsp;   Port: 5432 (default)



B) SMTP Account (Zoho Mail)



&nbsp;   Credential Type: SMTP



&nbsp;   Host: smtp.zoho.com



&nbsp;   Port: 465 (Ojo, puede que también se utilice el 587)



&nbsp;   Security: STARTTLS



&nbsp;   User: contacto@tudominio.com



&nbsp;   Password: Tu password SMTP



C) Header Auth



&nbsp;   Credential Type: Header Auth



&nbsp;   Name: x-processia-key



&nbsp;   Value: El token que generaste en .env



&nbsp;   Guardar credenciales



&nbsp;   Activar workflow (toggle arriba a la derecha)



Paso 4: Integrar con tu Formulario Web



Formulario HTML completo: Ver en repo https://github.com/rabarrazueta/rabarrazueta.github.io



Emails Enviados:



Email 1: Notificación Interna (Equipo)



Subject: IMPORTANTE: 🔔 Nuevo Lead [HOT/WARM/COLD] - [Empresa]



Contenido:



&nbsp;   Datos completos del lead



&nbsp;   Score y clasificación



&nbsp;   Metadata del navegador



&nbsp;   Link directo (futuro: al CRM)



Email 2: Confirmación al Cliente



Subject: ¡Recibimos tu mensaje! - Processia Ops



Contenido:



&nbsp;   Saludo personalizado con nombre



&nbsp;   Confirmación de recepción



&nbsp;   Tiempo de respuesta esperado (24h)



&nbsp;   Links a servicios



&nbsp;   Branding corporativo



Diseño: HTML responsive con colores de marca

Consultas Útiles



Ver ejemplos completos en: database/queries.sql



Importante



&nbsp;   Nunca expongas tu token en código frontend visible



&nbsp;   Usa variables de entorno en producción



&nbsp;   Regenera tokens si sospechas compromiso



&nbsp;   Monitorea logs para detectar intentos de abuso



Contribuciones



Este proyecto es parte del portafolio de Processia Ops.



Si encuentras bugs o tienes sugerencias:



&nbsp;   Abre un Issue describiendo el problema



&nbsp;   Fork el repositorio



&nbsp;   Crea un Pull Request con tus mejoras



## Sobre Processia Ops



Processia Ops es una consultora ecuatoriana especializada en automatización y optimización de procesos empresariales para PYMEs.

Servicios



&nbsp;   🔄 Automatización de workflows (n8n, Python)



&nbsp;   📊 Implementación y customización de Odoo ERP



&nbsp;   🔌 Data Engineering & Pipelines ETL



&nbsp;   🤖 Integraciones entre sistemas (APIs, webhooks)



&nbsp;   📈 Dashboards y Business Intelligence



Contacto



Robinson Barrazueta

Data Engineer & Business Process Automation Specialist



🌐 Web: processia.online

📧 Email: contacto@processia.online

💼 GitHub: @rabarrazueta

🔗 LinkedIn: linkedin.com/in/rabarrazueta

📍 Ubicación: Ecuador



¿Necesitas Automatizar Procesos?



Ofrecemos servicios de:



&nbsp;   ✅ Consultoría en automatización



&nbsp;   ✅ Implementación de workflows personalizados



&nbsp;   ✅ Capacitación en n8n y herramientas no-code



&nbsp;   ✅ Migración a sistemas modernos



Agenda una consultoría gratuita: contacto@processia.online

