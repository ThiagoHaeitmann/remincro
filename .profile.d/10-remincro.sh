#!/usr/bin/env bash
set -e
APP="/workspace"

mkdir -p \
  "$APP/cache/images" \
  "$APP/cache/import" \
  "$APP/cron/modules" \
  "$APP/test/vtlib/HTML" \
  "$APP/test/wordtemplatedownload" \
  "$APP/test/product" \
  "$APP/test/user" \
  "$APP/test/contact" \
  "$APP/test/logo"

chmod -R 0777 \
  "$APP/cache" \
  "$APP/cron/modules" \
  "$APP/test/vtlib" \
  "$APP/test/wordtemplatedownload" \
  "$APP/test/product" \
  "$APP/test/user" \
  "$APP/test/contact" \
  "$APP/test/logo" \
  "$APP/storage" \
  "$APP/logs" \
  "$APP/user_privileges"

for f in "$APP/config.inc.php" "$APP/tabdata.php" "$APP/parent_tabdata.php"; do
  [ -f "$f" ] || touch "$f"
  chmod 0666 "$f"
done

