#!/usr/bin/env bash
set -e

APP_DIR="/workspace"
WEB_USER="cnb" # Usuário padrão do Paketo Buildpacks

# Lista de todos os diretórios que o VtigerCRM precisa para escrever dados.
# Não inclua diretórios de código-fonte como /modules aqui.
WRITABLE_DIRS=(
    "$APP_DIR/cache"
    "$APP_DIR/cron/modules"
    "$APP_DIR/logs"
    "$APP_DIR/storage"
    "$APP_DIR/user_privileges"
    "$APP_DIR/test/vtlib/HTML"
    "$APP_DIR/test/templates_c"
    "$APP_DIR/test/wordtemplatedownload"
    "$APP_DIR/test/product"
    "$APP_DIR/test/user"
    "$APP_DIR/test/contact"
    "$APP_DIR/test/logo"
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

# PASSO 3: Ajustar a PROPRIEDADE de todos os diretórios e arquivos necessários.
# O chown torna o usuário 'cnb' o dono de tudo que a aplicação precisa escrever.
echo "Ajustando propriedade para o usuário '$WEB_USER'..."
chown -R "$WEB_USER:$WEB_USER" \
    "${WRITABLE_DIRS[@]}" \
    "${CONFIG_FILES[@]}"

# PASSO 4: Ajustar as PERMISSÕES de forma granular e segura.
echo "Ajustando permissões de escrita..."
for DIR in "${WRITABLE_DIRS[@]}"; do
    chmod 775 "$DIR" # Permissão para diretórios
done
for FILE in "${CONFIG_FILES[@]}"; do
    chmod 664 "$FILE" # Permissão para arquivos
done

echo "--- Ambiente preparado com sucesso. Iniciando servidor web. ---"

# PASSO 5: Iniciar o servidor web (Comando padrão do Paketo).
# O 'exec' substitui o processo do script pelo do servidor, o que é uma boa prática.
exec procmgr-binary /layers/paketo-buildpacks_php-start/php-start/procs.yml