######################
# PHP STARTING
######################
FROM php:7.3-fpm

RUN apt-get update && apt-get install -y --fix-missing --no-install-recommends \
    apt-utils \
    gnupg

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libxml2-dev \
    libxslt1-dev \
    libmemcached-dev \
    sendmail-bin \
    sendmail \
    libicu-dev \
    libzip-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    bcmath \
    intl \
    pdo_mysql \
    zip \
    gd \
    soap \
    xsl \
    mysqli \
    sockets


ADD etc/zz-settings.ini /usr/local/etc/php/conf.d/zz-settings.ini

######################
# SETUP COMPOSER
######################
ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

######################
# NGINX SETUP
######################
RUN apt-get install -y nginx
COPY nginx-conf.d /etc/nginx/conf.d
RUN rm -rf /etc/nginx/sites-enabled/*

######################
# NODE SETUP
######################
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

RUN /bin/bash -c "source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default"

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

######################
# SETUP MAGENTO APP
######################
WORKDIR /app

ARG MAGENTO_COMPOSER_USER
ARG MAGENTO_COMPOSER_PASSWORD
RUN composer config --global http-basic.repo.magento.com $MAGENTO_COMPOSER_USER $MAGENTO_COMPOSER_PASSWORD
RUN composer create-project --repository=https://repo.magento.com/ magento/project-community-edition:2.3.5-p2 .

######################
# START
######################
RUN apt-get install -y --no-install-recommends supervisor netcat
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf4

######################
# CLEANUP
######################
RUN rm $COMPOSER_HOME/auth.json
RUN rm -rf $COMPOSER_HOME/cache
RUN rm -rf /var/lib/apt/lists/*

COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/bin/bash", "/start.sh"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/