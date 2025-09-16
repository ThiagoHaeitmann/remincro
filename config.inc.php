<?php
$root_directory = __DIR__ . DIRECTORY_SEPARATOR;
$dbconfig = [];
$dbconfig['db_type']     = 'mysqli';
$dbconfig['db_status']   = 'true';
$dbconfig['db_server']   = getenv('VT_DB_HOST') ?: 'pi-remincrodb-ulwseq';
$dbconfig['db_port']     = ':' . (getenv('VT_DB_PORT') ?: '3306');
$dbconfig['db_username'] = getenv('VT_DB_USER') ?: 'remincro';
$dbconfig['db_password'] = getenv('VT_DB_PASS') ?: '@Senhaboa10';
$dbconfig['db_name']     = getenv('VT_DB_NAME') ?: 'remincro';
$dbconfig['db_hostname'] = $dbconfig['db_server'] . $dbconfig['db_port'];
$site_URL = rtrim(getenv('VT_SITE_URL') ?: 'https://crm2vliftstep.ddnsfree.com', '/') . '/';
$default_timezone = 'America/Sao_Paulo';
$dbconfig['log_sql'] = false;