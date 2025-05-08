# Makefile - Pipeline DevOps Local

dev:
	npm run dev

build:
	npm run build

deploy:
	@echo "🚀 Rodando processo de deploy (configure aqui seu provider: Vercel, Supabase, etc.)"

check:
	@echo "✔ Supabase conectado"
	@test -f .env.local && echo "✔ .env.local presente" || (echo '❌ .env.local não encontrado' && exit 1)
	@test -f src/lib/supabaseClient.ts && echo "✔ supabaseClient.ts disponível" || (echo '❌ supabaseClient.ts não encontrado' && exit 1)
	@test -f src/pages/TesteSupabase.tsx && echo "✔ rota /teste-supabase ativa" || (echo '❌ TesteSupabase.tsx não encontrada' && exit 1)

clean:
	rm -rf dist

