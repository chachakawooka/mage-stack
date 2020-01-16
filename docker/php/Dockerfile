######################
# PHP STARTING
######################
ARG PHP_VERSION
FROM php:$PHP_VERSION

RUN apt-get update && apt-get install -y --fix-missing \
    apt-utils \
    gnupg

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libxml2-dev \
    libxslt1-dev \
    libmemcached-dev \
    sendmail-bin \
    sendmail \
    libicu-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
    bcmath \
    intl \
    pdo_mysql \
    zip \
    gd \
    soap \
    xsl

ADD etc/zz-settings.ini /usr/local/etc/php/conf.d/zz-settings.ini

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
ARG MAGENTO_VERSION
ARG MAGENTO_COMPOSER_USER
ARG MAGENTO_COMPOSER_PASSWORD
RUN composer config --global http-basic.repo.magento.com $MAGENTO_COMPOSER_USER $MAGENTO_COMPOSER_PASSWORD
RUN composer create-project --repository=https://repo.magento.com/ magento/project-community-edition:$MAGENTO_VERSION .

######################
# CLEANUP
######################
RUN rm $COMPOSER_HOME/auth.json

######################
# START
######################
COPY start.sh /start.sh
RUN chmod +x /start.sh

VOLUME [ "/app/app/etc" ]

CMD ["/bin/bash", "/start.sh"]