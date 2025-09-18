#!/usr/bin/env bash
set -e

APP_DIR="/workspace"
WEB_USER="cnb"

echo "--- Iniciando script de preparação (executando como: $(whoami)) ---"

# Lista de diretórios que o VtigerCRM precisa para escrever dados.
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
    "$APP_DIR/modules"
    "$APP_DIR/tmp"
)

# Lista de arquivos de configuração que precisam existir.
CONFIG_FILES=(
    "$APP_DIR/config.inc.php"
    "$APP_DIR/tabdata.php"
    "$APP_DIR/parent_tabdata.php"
)

# PASSO 1: Criar todos os diretórios e arquivos necessários.
echo "Garantindo a existência de diretórios e arquivos..."
for DIR in "${WRITABLE_DIRS[@]}"; do mkdir -p "$DIR"; done
for FILE in "${CONFIG_FILES[@]}"; do touch "$FILE"; done

# PASSO 2: Ajustar a PROPRIEDADE para o usuário 'cnb'.
# Este comando só funciona se o script estiver rodando como root.
echo "Ajustando propriedade das pastas e arquivos para o usuário '$WEB_USER'..."
chown -R "$WEB_USER:$WEB_USER" \
    "${WRITABLE_DIRS[@]}" \
    "${CONFIG_FILES[@]}"

# PASSO 3: Ajustar as PERMISSÕES.
echo "Ajustando permissões de escrita..."
for DIR in "${WRITABLE_DIRS[@]}"; do chmod 777 "$DIR"; done
for FILE in "${CONFIG_FILES[@]}"; do chmod 777 "$FILE"; done

echo "--- Ambiente preparado. Rebaixando privilégios e iniciando o servidor web como '$WEB_USER'... ---"

# PASSO 4: Iniciar o servidor web como o usuário 'cnb' (sem root).
# 'gosu' é uma ferramenta segura para trocar de usuário.
exec gosu $WEB_USER procmgr-binary /layers/paketo-buildpacks_php-start/php-start/procs.yml
