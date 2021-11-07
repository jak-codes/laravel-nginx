#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y

#install nginx
sudo apt-get install nginx -y

#configuration nginx
sudo cat << EOF > /etc/nginx/sites-available/default
server {
        listen 80;
        server_name _;
	root /var/www/html;

        index index.html index.htm index.nginx-debian.html index.php;

        location / {
		try_files $uri $uri/ /index.php?$query_string;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        }
}

EOF

#install php8.0 with extensions
sudo add-apt-repository ppa:ondrej/php -y
grep ^ /etc/apt/sources.list /etc/apt/sources.list.d/* | grep ondrej/php
sudo apt-get update
sudo apt install php8.0-{common,cli,bcmath,curl,dev,fpm,gd,mbstring,mysql,opcache,pgsql,xml,zip} -y
php --version

#restart nginx
sudo nginx -s reload

#install composer
sudo curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
