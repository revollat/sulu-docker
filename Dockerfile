FROM php:5.6-fpm

MAINTAINER Olivier Revollat <revollat@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN echo "Europe/Paris" > /etc/timezone; dpkg-reconfigure tzdata

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y git ca-certificates curl mysql-server nginx supervisor

COPY config/php.ini /usr/local/etc/php/

# Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# CONF Nginx
ADD vhost.conf /etc/nginx/sites-enabled/default

# SUPERVISOR
ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# Install Sulu CMS
WORKDIR /var/www
RUN git clone https://github.com/sulu/sulu-standard.git
WORKDIR /var/www/sulu-standard
RUN git checkout master
RUN composer install --prefer-source
COPY webspaces/sulu.io.xml app/Resources/webspaces/sulu.io.xml
RUN cp app/Resources/pages/default.xml.dist app/Resources/pages/default.xml  && \
    cp app/Resources/pages/overview.xml.dist app/Resources/pages/overview.xml && \
    cp app/Resources/snippets/default.xml.dist app/Resources/snippets/default.xml
RUN rm -rf app/cache/* && rm -rf app/logs/*
RUN docker-php-ext-install pdo_mysql

RUN chown -R www-data /var/www/sulu-standard/

# Allow shell for www-data (to make symfony console and composer commands)
RUN sed -i -e 's/\/var\/www:\/usr\/sbin\/nologin/\/var\/www:\/bin\/bash/' /etc/passwd
#RUN sed -i -e 's/^UMASK *[0-9]*.*/UMASK    002/' /etc/login.defs

EXPOSE 80

CMD ["/usr/bin/supervisord", "--nodaemon", "-c", "/etc/supervisor/supervisord.conf"]
