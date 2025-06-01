import os
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI() # <-- Esta é a instância do seu aplicativo!

# Variáveis de ambiente serão lidas aqui
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY", "NOT_SET")
ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY", "NOT_SET")
SUPABASE_URL = os.getenv("SUPABASE_URL", "NOT_SET")
SUPABASE_SERVICE_ROLE_KEY_ENV = os.getenv("SUPABASE_SERVICE_ROLE_KEY", "NOT_SET")
WHATSAPP_API_KEY = os.getenv("WHATSAPP_API_KEY", "NOT_SET")
WHATSAPP_WEBHOOK_URL_ENV = os.getenv("WHATSAPP_WEBHOOK_URL", "NOT_SET")
GOOGLE_API_KEY_ENV = os.getenv("GOOGLE_API_KEY", "NOT_SET")
GOOGLE_CREDENTIALS_PATH = os.getenv("GOOGLE_APPLICATION_CREDENTIALS", "NOT_SET")

@app.get("/", response_class=HTMLResponse)
async def read_root():
    return f"""
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <title>FastAPI Real - Moenn AI</title>
        <style>
            body {{ font-family: Arial, sans-serif; text-align: center; padding: 50px; background-color: #e6f7ff; color: #333; }}
            h1 {{ color: #1a5276; }}
            .section {{ margin-top: 20px; border-top: 1px solid #aaddff; padding-top: 20px; }}
            .key-info {{ background-color: #e0ffe0; padding: 10px; border-radius: 5px; margin-bottom: 5px; text-align: left; word-wrap: break-word; }}
            .alert {{ background-color: #fffacd; padding: 10px; border-radius: 5px; margin-top: 10px; }}
        </style>
    </head>
    <body>
        <h1>FastAPI Real da Moenn AI em Execução!</h1>
        <p>Este é o backend principal para <code>api.moenn.online</code>.</p>
        <div class="section">
            <h2>Status das Variáveis de Ambiente</h2>
            <div class="key-info"><strong>OPENAI_API_KEY:</strong> {'Configurada' if OPENAI_API_KEY != 'NOT_SET' else 'NÃO CONFIGURADA!'}</div>
            <div class="key-info"><strong>ANTHROPIC_API_KEY:</strong> {'Configurada' if ANTHROPIC_API_KEY != 'NOT_SET' else 'NÃO CONFIGURADA!'}</div>
            <div class="key-info"><strong>SUPABASE_URL:</strong> {'Configurada' if SUPABASE_URL != 'NOT_SET' else 'NÃO CONFIGURADA!'}</div>
            <div class="key-info"><strong>SUPABASE_SERVICE_ROLE_KEY:</strong> {'Configurada' if SUPABASE_SERVICE_ROLE_KEY_ENV != 'NOT_SET' else 'NÃO CONFIGURADA!'}</div>
            <div class="key-info"><strong>WHATSAPP_API_KEY:</strong> {'Configurada' if WHATSAPP_API_KEY != 'NOT_SET' else 'NÃO CONFIGURADA!'}</div>
            <div class="key-info"><strong>WHATSAPP_WEBHOOK_URL:</strong> {WHATSAPP_WEBHOOK_URL_ENV}</div>
            <div class="key-info"><strong>GOOGLE_API_KEY:</strong> {'Configurada' if GOOGLE_API_KEY_ENV != 'NOT_SET' else 'NÃO CONFIGURADA!'}</div>
            <div class="key-info"><strong>GOOGLE_APPLICATION_CREDENTIALS:</strong> {GOOGLE_CREDENTIALS_PATH}</div>
        </div>
        <div class="alert">
            <p>Agora você pode integrar seus frontends e começar a desenvolver seus agentes de IA!</p>
        </div>
    </body>
    </html>
    """

@app.get("/health")
async def health_check():
    return {"status": "ok", "message": "API está saudável!"}
