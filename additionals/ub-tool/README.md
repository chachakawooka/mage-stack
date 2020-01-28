# Ubermigration

Use this to add Ubermigration to your development stack to migrate M1 to M2.  This is commercial module avaiable from https://www.ubertheme.com/magento-extensions-2-x/magento-2-data-migration-pro/

## How to use

##### Export your M1 Database

Place your magento1 db.sql into additionals/ub-tool/sql/db1.sql

##### Start The stack with UB tool
```
docker-compose -f docker-compose-dev.yml -f additionals/ub-tool/docker-compose.yml up
```


You can access the tool from http://localhost:32734/ub-tool/ and migrate using the values configured in the mariadb docker variables