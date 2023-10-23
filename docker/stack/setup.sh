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
nvm use 16

######################
# INSTALL MAGENTO
######################
php bin/magento setup:config:set \
--db-host ${MAGE_DB_HOST} \
--db-name ${MAGE_DB_NAME} \
--db-user ${MAGE_DB_USER} \
--db-password=${MAGE_DB_PASSWORD}


MAGENTO_STATUS=$(bin/magento setup:db:status)
if [[ $MAGENTO_STATUS =~ "Magento application is not installed."$ ]]; then
    
    php bin/magento setup:install \
    --admin-firstname $MAGENTO_FIRST_NAME \
    --admin-lastname $MAGENTO_LAST_NAME \
    --admin-email $MAGENTO_EMAIL \
    --admin-user $MAGENTO_USER \
    --admin-password $MAGENTO_PASSWORD \
    --backend-frontname $MAGE_ADMIN_URL \
    --elasticsearch-host=es01
    
    php bin/magento setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1
    php bin/magento cache:enable
else
    php bin/magento setup:db:status
    export ME=$?
    echo "${blue}${bold}DB STATUS: $ME ${normal}"
fi


######################
# INSTALL ADDITIONAL COMPOSER REPOSITORIES
######################
export IFS=";"
for repo in ${COMPOSER_REPOS}; do
    echo "${blue}${bold}ADDING REPO ${cyan}${repo} ${normal}"
    composer config repositories.$repo composer https://$repo
done

######################
# INSTALL ADDITIONAL COMPOSER MODULES
######################
composer config --global http-basic.repo.magento.com ${MAGENTO_COMPOSER_USER} ${MAGENTO_COMPOSER_PASSWORD}

export IFS=";"
for module in ${COMPOSER_MODULES}; do
    echo "${blue}${bold}INSTALLING ${cyan}${module} ${normal}"
    composer require $module
done


######################
# PERMISSIONS
######################
php bin/magento setup:upgrade
php bin/magento setup:di:compile

php bin/magento indexer:reindex
rm -rf var