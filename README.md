# Magento 2 Docker Stack

This stack is designed as a starting point for Alpaca theme based on the Magento2 Platform; however essentially it can be used for any development

## Developing

##### Create Enviroment Variables
```
cp .env.example .env.dev
```

- open up .env.dev and set MAGENTO_COMPOSER_USER & MAGENTO_COMPOSER_PASSWORD to your own credentials

##### Start The Stack
```
docker-compose -f docker-compose-dev.yml up
```

The site will startup on port http://localhost:32733 (unless you changed it)
admin url is http://localhost:32733/admin (unless you changed it)

### GET STARTED WITH ALPACA

###### Setup Theme and Frontools
```
docker-compose -f docker-compose-dev.yml exec app bash
cd /app/vendor/snowdog/frontools
nvm use 12
npm install gulp -g
npm install 
gulp setup
exit
```

###### Setup Theme and Frontools
```
cd vendor/snowdog/frontools
nvm use 12
npm install gulp -g
npm install
gulp svg 
gulp babel 
gulp styles 
gulp watch
```

