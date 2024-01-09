# Magento 2 Docker Stack

This stack is designed as a starting point for the Magento2 Platform

## Developing

##### Create Enviroment Variables

```
cp .env.example .env
```

- open up .env and set MAGENTO_COMPOSER_USER & MAGENTO_COMPOSER_PASSWORD to your own credentials

##### Extend with Docker to install additional modules

##### Mound a custom.sh file to run commands post upgrade

e.g. install new modules or disable 2fa

```
php bin/magento module:disable Magento_TwoFactorAuth Magento_AdminAdobeImsTwoFactorAuth
```

##### Start The Stack

```
docker-compose -f docker-compose-dev.yml up
```

The site will startup on port http://localhost:32733 (unless you changed it)
admin url is http://localhost:32733/admin (unless you changed it)
