#!/bin/bash

# Vérifier si Docker Compose est installé
if ! command -v docker-compose &> /dev/null; then
    echo "Erreur : docker-compose n'est pas installé. Installez-le avant de continuer."
    exit 1
fi

# Générer une clé Fernet si elle n'existe pas
if [ -z "$AIRFLOW__CORE__FERNET_KEY" ]; then
    echo "🔑 Génération de la clé Fernet..."
    export AIRFLOW__CORE__FERNET_KEY=$(python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())")
    echo "AIRFLOW__CORE__FERNET_KEY=${AIRFLOW__CORE__FERNET_KEY}" >> .env
fi

# Créer les dossiers nécessaires
echo "📁 Création des répertoires..."
mkdir -p ./dags ./logs ./plugins ./config

# Donner les permissions
echo "🔧 Configuration des permissions..."
sudo chown -R 50000:50000 ./dags ./logs ./plugins ./config

# Initialiser la base de données Airflow
echo "🗄️ Initialisation de la base de données..."
docker compose run --rm airflow-webserver airflow db init

# Créer un utilisateur admin (si non existant)
echo "👤 Création de l'utilisateur administrateur..."
docker compose run --rm airflow-webserver airflow users create \
    --username admin \
    --firstname Admin \
    --lastname User \
    --role Admin \
    --email admin@example.com \
    --password admin || true

# Démarrer les services
echo "🚀 Démarrage d'Airflow..."
docker compose up -d

echo ""
echo "✅ Airflow est en cours de démarrage..."
echo "🌐 Webserver: http://localhost:8080"
echo "👤 Username: admin"
echo "🔑 Password: admin"
