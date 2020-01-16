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

######################
# INSTALL MAGENTO
######################
MAGENTO_STATUS=$(bin/magento setup:db:status)
if [[ $MAGENTO_STATUS =~ "Magento application is not installed."$ ]]; then
echo "${blue}${bold}INSTALLING MAGENTO CORE${normal}"

php bin/magento setup:config:set \
    --db-host ${MYSQL_HOST} \
    --db-name ${MYSQL_DATABASE} \
    --db-user ${MYSQL_USER} \
    --db-password=${MYSQL_PASSWORD} 

php bin/magento setup:install \
    --admin-firstname $MAGENTO_FIRST_NAME \
    --admin-lastname $MAGENTO_LAST_NAME \
    --admin-email $MAGENTO_EMAIL \
    --admin-user $MAGENTO_USER \
    --admin-password $MAGENTO_PASSWORD
else
magento setup:db:status
export ME=$?
echo "${blue}${bold}DB STATUS: $ME ${normal}"
fi

######################
# INSTALL ADDITIONAL COMPOSER MODULES
######################
composer config --global http-basic.repo.magento.com ${MAGENTO_COMPOSER_USER} ${MAGENTO_COMPOSER_PASSWORD}

export IFS=";"
for module in ${COMPOSER_MODULES}; do
  echo "${blue}${bold}INSTALLING ${cyan}${module} ${normal}"
  composer require $module
done

php-fpm -R