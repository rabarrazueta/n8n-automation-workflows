\# Alerta de Actualizaciones de n8n (GitHub Releases → Email)



Workflow n8n que monitorea la última versión estable publicada de n8n en GitHub y envía un correo cuando detecta una versión nueva disponible para actualización.



\## Problema de Negocio



Cuando operas n8n en producción (self-hosted), mantenerte actualizado es clave para:

\- Evitar quedarte atrás en fixes de seguridad y bugs.

\- Planificar upgrades sin sorpresas ni caídas.

\- Estandarizar versiones entre entornos (dev/staging/prod).



El problema típico: las actualizaciones se revisan “a mano”, de forma irregular, y el equipo se entera tarde.



\## Solución Implementada



Workflow automatizado con ejecución programada que:

1\. Obtiene la versión instalada de n8n ejecutando `n8n --version`.

2\. Consulta el último release estable en GitHub (endpoint `/repos/n8n-io/n8n/releases/latest`).

3\. Compara el `tag\_name` del release con la versión instalada.

4\. Si detecta una nueva versión, envía un correo de aviso (Gmail node) al destinatario configurado.



\## Arquitectura del Flujo



\### Componentes Técnicos



| Nodo | Función | Tecnología | Notas |

|------|---------|------------|-------|

| Schedule Trigger | Dispara el flujo en un intervalo programado | n8n Cron/Schedule | Ajustable (cada X horas/días) |

| Execute Command | Lee versión local con `n8n --version` | n8n Execute Command | Requiere permisos en el host |

| HTTP Request | Consulta el último release de n8n | GitHub API | Usa `User-Agent` configurado |

| IF | Compara `tag\_name` vs versión instalada | n8n If | Define si se notifica |

| Gmail | Envía alerta por correo | Gmail OAuth2 | Destino por variable de entorno |



\### Flujo de Datos



Schedule → Execute Command (n8n --version)

→ HTTP Request (GitHub releases/latest)

→ IF (¿Hay versión nueva?)

→ Gmail (Notificar)





\## Ejemplo de Notificación



Asunto: `Nueva versión n8n!`



Cuerpo:

`La versión de n8n estable se ha actualizado a <tag\_name>. Tenlo en cuenta para tus siguientes proyectos.`



\## Impacto Medible



| Métrica | Antes (Manual) | Después (Automatizado) | Mejora |

|---------|----------------|------------------------|--------|

| Tiempo de verificación | Variable (olvidos) | 0 min | 100% |

| Detección de nuevas versiones | Reactiva | Proactiva | Consistente |

| Riesgo de quedarse en versiones antiguas | Alto | Bajo | Mejora operativa |



\## 🔧 Requisitos Técnicos



\### Credenciales Necesarias



1\. \*\*Gmail OAuth2\*\*

\- Configurar en n8n: Settings → Credentials → Gmail OAuth2

\- Conceder permisos para enviar correos



\### Variables de Entorno



Este workflow usa variables de entorno (no hardcodeadas en el JSON):

\- `NOTIFY\_EMAIL`: email destino para avisos

\- `APP\_USER\_AGENT`: User-Agent para la llamada a GitHub API



\*\*Nota:\*\* se configuran en tu instancia n8n (Docker/system settings). No subas `.env` real al repositorio.



\## Instalación Paso a Paso



\### 1. Importar el Workflow



1\. En n8n: Menú (☰) → Import from File

2\. Selecciona `workflow.json`

3\. Importa el flujo



\### 2. Configurar Credenciales



1\. Settings → Credentials → Add Credential

2\. Selecciona Gmail OAuth2

3\. Autoriza tu cuenta (o cuenta técnica) para envío



\### 3. Configurar Variables de Entorno



Configura en tu entorno n8n:

\- `NOTIFY\_EMAIL`

\- `APP\_USER\_AGENT`



\### 4. Probar y Activar



1\. Ejecuta manualmente (Execute Workflow) para validar:

\- que `Execute Command` devuelve versión

\- que la llamada a GitHub responde

\- que el IF toma la rama correcta

\- que el correo se envía

2\. Activa el workflow



\## Personalizaciones Comunes



\- Cambiar frecuencia: ajusta el Schedule Trigger.

\- Notificar a varios correos: usa una lista (separada por comas) o duplica el nodo Gmail.

\- Cambiar el mensaje: modifica subject/body del nodo Gmail.

\- Añadir canal alterno: Telegram/Slack/Discord además de email.



\## Seguridad



\- El JSON del workflow está sanitizado (sin IDs sensibles ni datos privados).

\- La dirección destino se parametriza por `NOTIFY\_EMAIL`.

\- Evita publicar tokens/IDs reales en `.env.example`.



\## Contacto



Processia Ops — Automatización y digitalización de procesos de negocio (n8n, Odoo, ETL).  

LinkedIn: linkedin.com/in/rabarrazueta  

GitHub: github.com/rabarrazueta



