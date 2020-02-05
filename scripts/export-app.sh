rm -rf ./backup/app
docker cp "$(docker-compose -f docker-compose-dev.yml ps -q app)":/app ./backup/app
