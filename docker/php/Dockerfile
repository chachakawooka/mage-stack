######################
# PHP STARTING
######################
ARG PHP_VERSION
FROM php:$PHP_VERSION

RUN apt-get update && apt-get install -y --fix-missing \
    apt-utils \
    gnupg

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg62-turbo-dev

RUN docker-php-ext-configure \
  	gd
  	
RUN docker-php-ext-install \
    bcmath \
    intl \
    pdo_mysql \
    zip

######################
# SETUP COMPOSER
######################
ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

######################
# NODE SETUP
######################

######################
# SETUP MAGENTO APP
######################
WORKDIR /app
ARG MAGENTO_USER
ARG MAGENTO_PASSWORD
RUN composer config --global http-basic.repo.magento.com $MAGENTO_USER $MAGENTO_PASSWORD
RUN composer create-project --repository=https://repo.magento.com/ magento/project-community-edition .
