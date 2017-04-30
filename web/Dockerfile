FROM debian:jessie

MAINTAINER Aurélien GIRY <aurelien.giry@gmail.com>

COPY . /usr/local/docker
RUN chmod -R 777 /usr/local/docker

# Add Dotdeb depot
RUN apt-get update && apt-get -y -q install wget
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list
RUN wget https://www.dotdeb.org/dotdeb.gpg
RUN apt-key add dotdeb.gpg
RUN apt-get update --fix-missing

# https://www.noobunbox.net/serveur/auto-hebergement/installer-php-7-1-sous-debian-et-ubuntu
RUN apt-get install -y apt-transport-https lsb-release ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN apt-get update

# Delete PHP5
RUN apt-get autoremove --purge php5*

# Delete PHP 7.0
RUN apt-get autoremove --purge php7*

# PHP 7.1
RUN apt-get update --fix-missing && apt-get install -y autoconf \
    php7.1 \
    libapache2-mod-php7.1 \
    php7.1-apcu \
    php7.1-apcu-bc \
    php7.1-cli \
    php7.1-mysql \
    php7.1-curl \
    php7.1-json \
    php7.1-gd \
    php7.1-mcrypt \
    php7.1-msgpack \
    php7.1-intl \
    php7.1-sqlite3 \
    php7.1-gmp \
    php7.1-geoip \
    php7.1-mbstring \
    php7.1-xml \
    php7.1-zip \
    php7.1-mongodb \
    php7.1-xdebug \
    php7.1-xmlrpc \
    php7.1-xsl \
    php7.1-dev \
    php-pear

# Tools
RUN apt-get update --fix-missing && apt-get install -y autoconf \
    git \
    default-jre \
    acl \
    curl \
    make \
    vim \
    mysql-client

# Python
RUN apt-get update && apt-get install -y python-pip \
    python-dev

RUN pip install --upgrade pip virtualenv Sphinx

RUN \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install phpunit
RUN \
    wget https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit 

RUN echo 'date.timezone = Europe/Paris' >> /etc/php/7.1/cli/php.ini
RUN echo 'date.timezone = Europe/Paris' >> /etc/php/7.1/apache2/php.ini

RUN pecl update-channels

RUN \
    export PHP_VERSION=`/usr/bin/php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;"` && \
    curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/${PHP_VERSION} && \
    export PHP_EXT_DIR=`/usr/bin/php -r "echo ini_get('extension_dir');"` && \
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp && mv /tmp/blackfire-*.so ${PHP_EXT_DIR}/blackfire.so && \
    chown root ${PHP_EXT_DIR}/blackfire.so && chown :root ${PHP_EXT_DIR}/blackfire.so && chmod 0755 ${PHP_EXT_DIR}/blackfire.so

RUN usermod -u 1000 www-data

ENTRYPOINT ["/usr/local/docker/run.sh"]
