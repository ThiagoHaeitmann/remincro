$dbconfig['db_server']   = getenv('VT_DB_HOST') ?: 'db';
$dbconfig['db_port']     = ':' . (getenv('VT_DB_PORT') ?: '3306');
$dbconfig['db_username'] = getenv('VT_DB_USER') ?: 'remincro';
$dbconfig['db_password'] = getenv('VT_DB_PASS') ?: '@Senhaboa10';
$dbconfig['db_name']     = getenv('VT_DB_NAME') ?: 'vtiger_clone';

$site_URL = rtrim(getenv('VT_SITE_URL') ?: 'https://crm2vliftstep.ddnsfree.com', '/') . '/';
