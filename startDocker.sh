#!/bin/bash

docker compose down

# Lancer la configuration contenue dans le docker compose
docker compose up -d

# Ici je dis d'exécuter la commande bash dans le container localstack (contenu dans le docker-compose.yml)
docker compose exec localstack bash -c "cd /localstack_config && chmod 750 *.sh && ./setupAwsLocal.sh"
