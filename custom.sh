######################
# INSTALL ADDITIONAL COMPOSER MODULES
######################
composer config --global http-basic.repo.magento.com ${MAGENTO_COMPOSER_USER} ${MAGENTO_COMPOSER_PASSWORD}

# we are working local, no need for 2FA
php bin/magento module:disable Magento_TwoFactorAuth Magento_AdminAdobeImsTwoFactorAuth