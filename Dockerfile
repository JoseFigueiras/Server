# Use debian:buster as virtual OS
FROM debian:buster

ENV AUTOINDEX on

# Update and download dependencies
RUN		apt-get update && apt-get install -y \
		nginx \
		mariadb-server \
		php-fpm \
		php-mysql \
		php-mbstring \
		wget \
		&& rm -rf /var/lib/apt/lists/*

# NGINX
RUN		echo "daemon off;" >> /etc/nginx/nginx.conf && \ 
		rm var/www/html/index.nginx-debian.html
COPY	srcs/nginx/*.conf /tmp/

# PHPMYADMIN
RUN		wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz && \
		tar -xzvf phpMyAdmin-5.0.2-english.tar.gz && \
		mv phpMyAdmin-5.0.2-english/ /var/www/html/phpmyadmin && \
		rm -rf phpMyAdmin-5.0.2-english.tar.gz
COPY	srcs/phpmyadmin/config.inc.php /var/www/html/phpmyadmin

# WordPress
RUN		wget https://wordpress.org/latest.tar.gz && \
		tar -xzvf latest.tar.gz && \
		mv wordpress /var/www/html/ && \
		rm -rf latest.tar.gz
COPY	srcs/wordpress/wp-config.php /var/www/html/wordpress

# SLL
RUN		mkdir ~/mkcert && cd ~/mkcert && \
		wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-linux-amd64 && \
		mv mkcert-v1.4.1-linux-amd64 mkcert && chmod +x mkcert && \
		./mkcert -install && ./mkcert localhost

# Giving nginx's user-group rights over page files
RUN		chown -R www-data:www-data /var/www/html/*

# Scripts: start.sh && change_autoindex.sh
COPY	srcs/start.sh ./
COPY	srcs/change_autoindex.sh ./
# Ports that needs to be exposed at run time with -p [host port]:[container port]
EXPOSE	80 443

CMD		bash start.sh
