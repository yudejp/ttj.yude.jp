#!/bin/bash

docker compose up -d
sleep 3
docker compose exec -it app sh -c "echo '\$config[\"product_name\"] = \"soine.site Web メール\";' >> /var/www/html/config/config.inc.php"
docker compose exec -it app sh -c "echo '\$config[\"mail_domain\"] = \"soine.site\";' >> /var/www/html/config/config.inc.php"
docker compose exec -it app sh -c "grep -v "mail_domain" /var/www/html/config/defaults.inc.php > tmpfile && mv tmpfile /var/www/html/config/defaults.inc.php"
docker compose restart app