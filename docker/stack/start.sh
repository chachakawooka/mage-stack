until nc -z -v -w30 ${MAGE_DB_HOST} 3306
do
    echo "${yellow}Waiting for database connection...${normal}"
    # wait for 5 seconds before check again
    sleep 5
done

until nc -z -v -w30 es01 9200
do
    echo "${yellow}Waiting for elastic connection...${normal}"
    # wait for 5 seconds before check again
    sleep 5
done

su -s /bin/bash www-data -c /setup.sh

######################
# START SERVICES
######################
echo "${blue}${bold}STARTING SUPERVISORD${normal}"
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
