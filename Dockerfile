FROM	debian:buster

RUN		apt-get update
RUN		apt-get upgrade -y
RUN		apt-get -y install wget
RUN		apt-get -y install nginx
RUN		apt-get -y install mariadb-server

COPY   nginx/nginx.conf /etc/nginx/sites-available/nginx.conf
RUN    ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
RUN    rm -rf /etc/nginx/sites-enabled/default
