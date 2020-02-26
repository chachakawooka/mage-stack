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


until nc -z -v -w30 ${MAGE_DB_HOST} 3306
do
    echo "${yellow}Waiting for database connection...${normal}"
    # wait for 5 seconds before check again
    sleep 5
done

######################
# INSTALL MAGENTO
######################
echo "${blue}${bold}php bin/magento setup:config:set \
    --db-host ${MAGE_DB_HOST} \
    --db-name ${MAGE_DB_NAME} \
    --db-user ${MAGE_DB_USER} \
--db-password=${MAGE_DB_PASSWORD}${normal}"

php bin/magento setup:config:set \
--db-host ${MAGE_DB_HOST} \
--db-name ${MAGE_DB_NAME} \
--db-user ${MAGE_DB_USER} \
--db-password=${MAGE_DB_PASSWORD}

php bin/magento setup:config:set \
--cache-backend=redis \
--cache-backend-redis-server=redis \
--cache-backend-redis-db=0

php bin/magento setup:config:set \
--session-save=redis \
--session-save-redis-host=redis \
--session-save-redis-log-level=3 \
--session-save-redis-db=1

MAGENTO_STATUS=$(bin/magento setup:db:status)
if [[ $MAGENTO_STATUS =~ "Magento application is not installed."$ ]]; then
    echo "${blue}${bold}INSTALLING MAGENTO CORE${normal}"
    
    echo "${blue}${bold}php bin/magento setup:install \
    --admin-firstname $MAGENTO_FIRST_NAME \
    --admin-lastname $MAGENTO_LAST_NAME \
    --admin-email $MAGENTO_EMAIL \
    --admin-user $MAGENTO_USER \
    --admin-password $MAGENTO_PASSWORD \
    --backend-frontname $MAGE_ADMIN_URL${normal}"
    
    php bin/magento setup:install \
    --admin-firstname $MAGENTO_FIRST_NAME \
    --admin-lastname $MAGENTO_LAST_NAME \
    --admin-email $MAGENTO_EMAIL \
    --admin-user $MAGENTO_USER \
    --admin-password $MAGENTO_PASSWORD \
    --backend-frontname $MAGE_ADMIN_URL
    
    
    php bin/magento cache:enable
else
    php bin/magento setup:db:status
    export ME=$?
    echo "${blue}${bold}DB STATUS: $ME ${normal}"
fi


######################
# COMPILE
######################
php bin/magento setup:upgrade
php bin/magento setup:di:compile
php bin/magento setup:static-content:deploy en_GB en_US -f

######################
# ALPACA GULP
######################
echo "${blue}${bold}STARTING GULP${normal}"
cd /app/vendor/snowdog/frontools
source $NVM_DIR/nvm.sh
gulp svg
gulp babel
gulp styles

cd /app


######################
# PERMISSIONS
######################
chmod -R ugoa+rwX var vendor generated pub/static pub/media app/etc
chgrp -R www-data pub var 
chmod -R g+rwX pub var 

######################
# START SERVICES
######################
echo "${blue}${bold}STARTING SUPERVISORD${normal}"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf