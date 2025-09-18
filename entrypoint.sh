#!/usr/bin/env bash
set -e

# --- INÍCIO DO DIAGNÓSTICO ---
# Estas linhas nos dirão quem está executando o script e quais as permissões da pasta pai.
echo "--- DIAGNÓSTICO DE PERMISSÕES ---"
echo "Executando como usuário: $(whoami)"
echo "Conteúdo e permissões de /workspace: $(ls -la /workspace)"
if [ -d "/workspace/test" ]; then
    echo "Permissões de /workspace/test: $(ls -ld /workspace/test)"
else
    echo "O diretório /workspace/test não existe ainda."
fi
echo "--- FIM DO DIAGNÓSTICO ---"


APP_DIR="/workspace"

# Lista de diretórios que o VtigerCRM precisa para escrever dados.
WRITABLE_DIRS=(
    "$APP_DIR/cache"
    "$APP_DIR/cache/images"
    "$APP_DIR/cache/import"
    "$APP_DIR/cron/modules"
    "$APP_DIR/logs"
    "$APP_DIR/storage"
    "$APP_DIR/user_privileges"
    "$APP_DIR/test/vtlib"
    "$APP_DIR/test/vtlib/HTML"
    "$APP_DIR/test/templates_c"
    "$APP_DIR/test/wordtemplatedownload"
    "$APP_DIR/test/product"
    "$APP_DIR/test/user"
    "$APP_DIR/test/contact"
    "$APP_DIR/test/logo"
    "$APP_DIR/modules"
    "$APP_DIR/tmp"
)

# Lista de arquivos de configuração que precisam existir e ser graváveis pela aplicação.
CONFIG_FILES=(
    "$APP_DIR/config.inc.php"
    "$APP_DIR/tabdata.php"
    "$APP_DIR/parent_tabdata.php"
)

echo "--- Iniciando script de preparação do ambiente VtigerCRM ---"

# PASSO 1: Garantir que todos os diretórios de escrita existam.
echo "Criando diretórios de dados necessários..."
for DIR in "${WRITABLE_DIRS[@]}"; do
    mkdir -p "$DIR"
done

# PASSO 2: Garantir que os arquivos de configuração existam.
echo "Verificando arquivos de configuração..."
for FILE in "${CONFIG_FILES[@]}"; do
    touch "$FILE"
done

### ⚠️ AVISO DE SEGURANÇA ###
# O comando 'chmod -R 777' abaixo concede permissão total a todos os usuários.
# Isso é extremamente inseguro e deve ser usado APENAS para testes de diagnóstico.
# Se isso resolver, o problema é confirmado como sendo de permissão, e devemos
# voltar para uma solução segura com 'chown'.

echo "Ajustando permissões para 777 (modo de teste)..."
chmod -R 777 \
    "${WRITABLE_DIRS[@]}" \
    "${CONFIG_FILES[@]}"

echo "--- Ambiente preparado com sucesso. Iniciando servidor web. ---"

# PASSO 5: Iniciar o servidor web (Comando padrão do Paketo).
exec procmgr-binary /layers/paketo-buildpacks_php-start/php-start/procs.yml