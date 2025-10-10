#!/bin/bash

# Générer une clé Fernet si elle n'existe pas
if [ -z "$AIRFLOW__CORE__FERNET_KEY" ]; then
    echo "Génération de la clé Fernet..."
    export AIRFLOW__CORE__FERNET_KEY=$(python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")
    echo "FERNET_KEY=${AIRFLOW__CORE__FERNET_KEY}" >> .env
fi

# Créer les dossiers nécessaires
mkdir -p ./dags ./logs ./plugins ./config

# Donner les permissions
echo "Configuration des permissions..."
sudo chown -R 50000:50000 ./dags ./logs ./plugins ./config

# Démarrer les services
echo "Démarrage d'Airflow..."
docker-compose up -d

echo "Airflow est en cours de démarrage..."
echo "Webserver: http://localhost:8080"
echo "Username: admin"
echo "Password: admin"