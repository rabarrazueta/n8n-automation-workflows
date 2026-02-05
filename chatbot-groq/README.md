# AI Chatbot con n8n + Groq + PostgreSQL



Chatbot conversacional embebible en sitios web, construido con n8n, Groq (Llama 3.3 70B) y PostgreSQL para memoria de conversaciones.



## Características



- Conversación natural con LLM (Groq - Llama 3.3 70B). OJO, TIENEN UN PLAN GRATUITO PARA WEBS CON POCO TRÁFICO, APROVÉCHALO!

- Memoria persistente de conversaciones (PostgreSQL). OJO, para este flujo se ha trabajado con el servicio serverless de Neon (DBaaS), con su alternativa gratuita que, en mi opinión, es muy interesante a tomar en cuenta para proyectos de baja escala. 

- System prompt personalizable con información del negocio

- Webhook público para integración web

- Streaming de respuestas en tiempo real

- Context window configurable

- Widget embebible en cualquier sitio web



## Arquitectura



Usuario (Web)

↓ (Webhook)

Chat Trigger

↓

Set Variables (userMessage, sessionId)

↓

AI Agent (System Prompt)

├─ LLM: Groq (Llama 3.3 70B, temp: 0.5)

└─ Memory: PostgreSQL (10 mensajes de contexto)

↓

Respuesta al usuario (Streaming)



## Requisitos



- **n8n** v2.4.6+

- **PostgreSQL** 12+ (recomendado: Neon.tech para serverless)

- **Groq API Key** (obtener en [console.groq.com](https://console.groq.com)), aunque se puede usar OpenRouter o incluso Gemini/OpenAI de tener tokens disponibles en su cuenta. 

- **Dominio propio** con SSL (para webhook público)



## Instalación



### 1. Configurar PostgreSQL



**Opción A: Neon.tech (Recomendado - Gratis)**



1. Crear cuenta en [neon.tech](https://neon.tech)

2. Crear nuevo proyecto "chatbot-memory"

3. Copiar connection string



**Opción B: PostgreSQL Local/VPS**



2. Configurar Groq API



&nbsp;   Ir a console.groq.com



&nbsp;   Crear API Key



&nbsp;   Copiar la key generada



3. Importar workflow en n8n



&nbsp;   En n8n: Workflows → Import from File



&nbsp;   Seleccionar workflow.json



&nbsp;   Configurar credenciales:



Groq API:



&nbsp;   API Key: Tu key de Groq



PostgreSQL Memory:



&nbsp;   Host: Tu host de Neon/PostgreSQL



&nbsp;   Port: 5432



&nbsp;   Database: chatbot_memory



&nbsp;   User: tu_usuario



&nbsp;   Password: tu_contraseña



&nbsp;   SSL: Activado (para Neon)



4. Personalizar System Prompt



&nbsp;   Abrir system-prompt.txt



&nbsp;   Reemplazar placeholders con tu información:



&nbsp;       {{COMPANY_NAME}} → Nombre de tu empresa



&nbsp;       {{CONTACT_EMAIL}} → Tu email



&nbsp;       {{COMPANY_WEBSITE}} → Tu sitio web



&nbsp;       {{LOCATION}} → Tu ubicación



&nbsp;       Precios y servicios específicos



&nbsp;   Copiar el prompt personalizado al nodo "Agente IA" en n8n



5. Activar webhook



&nbsp;   Activar el workflow en n8n



&nbsp;   Copiar la URL del webhook (aparece en "Mensaje de usuario")



&nbsp;   Configurar allowedOrigins con tu dominio



6. Embeber en tu sitio web



HTML básico: código disponible en https://www.npmjs.com/package/@n8n/chat



# Configuración



## Ajustar temperatura del LLM



En el nodo "Groq: Modelo Llama 3.70":



&nbsp;   temperature: 0.5 (balance entre creatividad y precisión)



&nbsp;   Valores más bajos (0.1-0.3): Más consistente



&nbsp;   Valores más altos (0.7-0.9): Más creativo



## Ajustar memoria de contexto



En el nodo "Conexión con DB Postgres Neon":



&nbsp;   contextWindowLength: 10 (mensajes previos a recordar)



&nbsp;   Aumentar si necesitas más contexto (más uso de tokens)



&nbsp;   Disminuir para ahorrar costos



## Cambiar modelo de LLM



Modelos disponibles en Groq:



&nbsp;   llama-3.3-70b-versatile (Recomendado - Balance)



&nbsp;   llama-3.1-8b-instant (Más rápido, menos preciso)



&nbsp;   mixtral-8x7b-32768 (Contexto largo)



# Costos Estimados



## Groq (Gratis hasta 6000 requests/día)



&nbsp;   Modelo: Llama 3.3 70B



&nbsp;   Costo después del free tier: ~$0.00059 por 1K tokens



&nbsp;   Promedio: $0.01 - $0.05 por conversación



## PostgreSQL (Neon.tech)



&nbsp;   Plan Gratis: 0.5 GB storage



&nbsp;   Uso típico: < 100 MB/mes (miles de conversaciones)



Total estimado: $0 - $5 USD/mes (tráfico bajo-medio)



# Gestión de Base de Datos



Revisar documento de schema.sql



# Troubleshooting



El nodo set (Definición de variables) es fundamental ya que sin esta definición la base de datos Postgres no tiene contexto de los valores a los que se referencia en el chatbot. TENERLO MUY EN CUENTA.



# Contacto



📧 contacto@processia.online



💼 linkedin.com/in/rabarrazueta



🌐 github.com/rabarrazueta



Desarrollado por: Robinson Barrazueta | Processia Ops



Última actualización: Enero 2026

