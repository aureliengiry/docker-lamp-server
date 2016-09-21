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

# Delete PHP5
RUN apt-get autoremove --purge php5*

# PHP 7
RUN apt-get update --fix-missing && apt-get install -y autoconf \
    php7.0 \
    libapache2-mod-php7.0 \
    php7.0-apcu \
    php7.0-apcu-bc \
    php7.0-cli \
    php7.0-mysql \
    php7.0-curl \
    php7.0-json \
    php7.0-gd \
    php7.0-mcrypt \
    php7.0-msgpack \
    php7.0-intl \
    php7.0-sqlite3 \
    php7.0-gmp \
    php7.0-geoip \
    php7.0-mbstring \
    php7.0-xml \
    php7.0-zip \
    php7.0-mongodb \
    php7.0-xdebug \
    php7.0-xmlrpc \
    php7.0-xsl \
    php7.0-dev \
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
RUN apt-get install -y -f phpunit

RUN echo 'date.timezone = Europe/Paris' >> /etc/php/7.0/cli/php.ini
RUN echo 'date.timezone = Europe/Paris' >> /etc/php/7.0/apache2/php.ini

RUN pecl update-channels

RUN \
    export PHP_VERSION=`/usr/bin/php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;"` && \
    curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/${PHP_VERSION} && \
    export PHP_EXT_DIR=`/usr/bin/php -r "echo ini_get('extension_dir');"` && \
    tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp && mv /tmp/blackfire-*.so ${PHP_EXT_DIR}/blackfire.so && \
    chown root ${PHP_EXT_DIR}/blackfire.so && chown :root ${PHP_EXT_DIR}/blackfire.so && chmod 0755 ${PHP_EXT_DIR}/blackfire.so

RUN usermod -u 1000 www-data

ENTRYPOINT ["/usr/local/docker/run.sh"]
