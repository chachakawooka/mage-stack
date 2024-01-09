#!/usr/bin/env bash

######################
# JUST SETTINGS
######################

# see if it supports colors...
export TERM=xterm
ncolors=$(tput colors)
bold="$(tput bold)"
underline="$(tput smul)"
standout="$(tput smso)"
normal="$(tput sgr0)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"

source $NVM_DIR/nvm.sh
nvm use 20

    
    echo "${blue}${bold}INSTALL: ${normal}"

    php bin/magento setup:install \
    --db-host ${MAGE_DB_HOST} \
    --db-name ${MAGE_DB_NAME} \
    --db-user ${MAGE_DB_USER} \
    --db-password=${MAGE_DB_PASSWORD} \
    --admin-firstname $MAGENTO_FIRST_NAME \
    --admin-lastname $MAGENTO_LAST_NAME \
    --admin-email $MAGENTO_EMAIL \
    --admin-user $MAGENTO_USER \
    --admin-password $MAGENTO_PASSWORD \
    --backend-frontname $MAGE_ADMIN_URL \
    --elasticsearch-host=es01 \
    --search-engine=elasticsearch8

    echo "${blue}${bold}SET REDIS ${normal}"

    
    php bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1
    php bin/magento setup:config:set --amqp-host="rabbitmq" --amqp-port="5672" --amqp-user="guest" --amqp-password="guest" --amqp-virtualhost="/"
    php bin/magento cache:enable

    # run custom.sh
    if [ -f /custom.sh ]; then
        echo "${blue}${bold}INSTALL ADDITIONAL MODULES ${normal}"
        /custom.sh
    fi

######################
# PERMISSIONS
######################
php bin/magento setup:upgrade
php bin/magento setup:di:compile

php bin/magento indexer:reindex
rm -rf var