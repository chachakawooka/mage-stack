composer config --global http-basic.repo.magento.com ${MAGENTO_USER} ${MAGENTO_PASSWORD}
composer create-project --repository=https://repo.magento.com/ magento/project-community-edition .
