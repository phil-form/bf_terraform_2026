#!/bin/bash

# Lancer la configuration contenue dans le docker compose
docker compose up -d

# Ici je dis d'exécuter la commande bash dans le container localstack (contenu dans le docker-compose.yml)
docker compose exec localstack bash

cd /terraform
chmod 750 *.sh