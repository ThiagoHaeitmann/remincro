#!/usr/bin/env bash
set -e

APP_DIR="/workspace"
WEB_USER="cnb" # Usuário padrão do Paketo Buildpacks

# --- PASSO 1: Criar os diretórios que o Vtiger espera que existam ---
mkdir -p \
  "$APP_DIR/cache/images" \
  "$APP_DIR/cache/import" \
  "$APP_DIR/cron/modules" \
  "$APP_DIR/logs" \
  "$APP_DIR/storage" \
  "$APP_DIR/user_privileges" \
  "$APP_DIR/test/vtlib/HTML" \
  "$APP_DIR/test/wordtemplatedownload" \
  "$APP_DIR/test/product" \
  "$APP_DIR/test/user" \
  "$APP_DIR/test/contact" \
  "$APP_DIR/tmp" \
  "$APP_DIR/config.inc.php" \
  "$APP_DIR/tabdata.php" \
  "$APP_DIR/parent_tabdata.php" \
  "$APP_DIR/test/vtlib" \
  "$APP_DIR/test/templates_c" \
  "$APP_DIR/modules" \
  "$APP_DIR/test/logo"

# --- PASSO 2: Ajustar a PROPRIEDADE das pastas para o usuário do servidor web ---
# Esta é a parte mais importante. Torna o usuário 'cnb' o dono das pastas.
chown -R $WEB_USER:$WEB_USER \
  "$APP_DIR/cache" \
  "$APP_DIR/cron/modules" \
  "$APP_DIR/logs" \
  "$APP_DIR/storage" \
  "$APP_DIR/user_privileges" \
  "$APP_DIR/tmp" \
  "$APP_DIR/config.inc.php" \
  "$APP_DIR/tabdata.php" \
  "$APP_DIR/parent_tabdata.php" \
  "$APP_DIR/test/vtlib" \
  "$APP_DIR/test/templates_c" \
  "$APP_DIR/modules" \
  "$APP_DIR/test"

# --- PASSO 3: Ajustar as PERMISSÕES de escrita ---
# Damos permissão de escrita para o dono (o usuário 'cnb')
chmod -R 775 \
  "$APP_DIR/cache" \
  "$APP_DIR/cron/modules" \
  "$APP_DIR/logs" \
  "$APP_DIR/storage" \
  "$APP_DIR/user_privileges" \
  "$APP_DIR/tmp" \
  "$APP_DIR/config.inc.php" \
  "$APP_DIR/tabdata.php" \
  "$APP_DIR/parent_tabdata.php" \
  "$APP_DIR/test/vtlib" \
  "$APP_DIR/test/templates_c" \
  "$APP_DIR/modules" \
  "$APP_DIR/test"

# --- PASSO 4: Garantir que os arquivos de configuração existam e sejam graváveis ---
for f in "$APP_DIR/config.inc.php" "$APP_DIR/tabdata.php" "$APP_DIR/parent_tabdata.php"; do
  [ -f "$f" ] || touch "$f"
  chown $WEB_USER:$WEB_USER "$f"
  chmod 664 "$f"
done

# --- PASSO 5: Iniciar o servidor web (Comando padrão do Paketo) ---
# Este comando só é executado após os passos acima serem concluídos com sucesso.
exec procmgr-binary /layers/paketo-buildpacks_php-start/php-start/procs.yml
