FROM ubuntu:16.04

LABEL maintainer "devops@web-essentials.asia"

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    apt-utils \
    apache2 \
    libapache2-mod-rpaf \
    git \
    snmp \
    curl \
    wget \
    mariadb-client-10.0 \
    openssl \
    php7.0 \
    php7.0-cli \
    php7.0-gd \
    libapache2-mod-php7.0 \
    php7.0-mbstring \
    php7.0-curl \
    php7.0-snmp \
    php7.0-mysql \
    php7.0-mcrypt \
    php7.0-opcache \
    php7.0-xml \
    php7.0-xsl \
    php7.0-zip \
    php-redis \
    php-imagick \
    php7.0-bcmath

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN dpkg --add-architecture i386

RUN a2enmod actions alias expires headers mpm_prefork proxy proxy_http rewrite ssl

RUN a2dissite 000-default.conf
RUN ln -sf /usr/share/zoneinfo/Asia/Phnom_Penh /etc/localtime

ENV WWW_USER guest
ENV WWW_USER_ID 1000

COPY Configuration/apache2.conf /etc/apache2/apache2.conf
COPY Configuration/sites-enabled/apache-vhost.conf /etc/apache2/teampass.conf

RUN adduser --system --shell /bin/bash --no-create-home --uid ${WWW_USER_ID} --group --disabled-password --disabled-login ${WWW_USER}
RUN sed -i -e "s~###DEFAULT_WWW_USER###~${WWW_USER}~g" /etc/apache2/apache2.conf

WORKDIR /var/www

# Copy php.ini
COPY Configuration/php-cli.ini /etc/php/7.0/cli/php.ini
COPY Configuration/php.ini /etc/php/7.0/apache2/php.ini

# Entry point script which wraps all commands for app container
COPY Configuration/startup.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
