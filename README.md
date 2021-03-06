# Magento 2 Docker Stack

This stack is designed as a starting point for Alpaca theme based on the Magento2 Platform; however essentially it can be used for any development

## Developing

##### Create Enviroment Variables
```
cp .env.example .env
```

- open up .env and set MAGENTO_COMPOSER_USER & MAGENTO_COMPOSER_PASSWORD to your own credentials

##### Start The Stack
```
docker-compose -f docker-compose-dev.yml up
```

The site will startup on port http://localhost:32733 (unless you changed it)
admin url is http://localhost:32733/admin (unless you changed it)

### GET STARTED WITH ALPACA

There is already a start theme in app/design/frontend;  However if you wish to rename this, you must also change the frontools/config/theme.json to register in gulp

###### Run Gulp
```
docker-compose -f docker-compose-dev.yml exec app bash
cd vendor/snowdog/frontools
nvm use 12
npm install gulp -g
npm install
gulp svg 
gulp babel 
gulp styles 
gulp watch
```
## Additionals

useful containers can be found in the ./additionals folder

- Ubermigration - migrate M1 to M2
[see documentation here](additionals/ub-tool/README.md)


## Helper Scripts

###### Take a database backup

```
./scripts/db-backup.sh
```

This can be mounted to the db container on startup

```
services:
  db: 
    volumes:
      - ./backup/sql:/docker-entrypoint-initdb.d
```

###### Export complete app code

```
./scripts/export-app.sh
```