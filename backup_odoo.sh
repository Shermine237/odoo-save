#!/bin/bash

# Configuration
BACKUP_DIR="/backups/odoo"          # Répertoire de stockage des sauvegardes
DB_NAME="nom_de_la_base"            # Nom de la base de données Odoo
DB_USER="utilisateur_postgres"      # Utilisateur PostgreSQL
ODOO_DATA_DIR="/var/lib/odoo"       # Répertoire des données Odoo
DATE=$(date +%Y%m%d_%H%M%S)         # Date et heure actuelles
BACKUP_NAME="odoo_backup_$DATE"     # Nom de la sauvegarde
RETENTION_DAYS=30                   # Nombre de jours de rétention des sauvegardes

# Créer le répertoire de sauvegarde s'il n'existe pas
mkdir -p "$BACKUP_DIR"

# Fonction pour logger les messages
log_message() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1"
}

# Sauvegarde de la base de données PostgreSQL
log_message "Début de la sauvegarde de la base de données PostgreSQL..."
pg_dump -U "$DB_USER" -h localhost -F c -b -f "$BACKUP_DIR/${BACKUP_NAME}.dump" "$DB_NAME"
if [ $? -eq 0 ]; then
    log_message "Sauvegarde de la base de données terminée : $BACKUP_DIR/${BACKUP_NAME}.dump"
else
    log_message "Erreur lors de la sauvegarde de la base de données."
    exit 1
fi

# Sauvegarde des fichiers Odoo
log_message "Début de la sauvegarde des fichiers Odoo..."
tar -czvf "$BACKUP_DIR/${BACKUP_NAME}.tar.gz" "$ODOO_DATA_DIR"
if [ $? -eq 0 ]; then
    log_message "Sauvegarde des fichiers Odoo terminée : $BACKUP_DIR/${BACKUP_NAME}.tar.gz"
else
    log_message "Erreur lors de la sauvegarde des fichiers Odoo."
    exit 1
fi

# Nettoyage des anciennes sauvegardes
log_message "Nettoyage des anciennes sauvegardes (plus de $RETENTION_DAYS jours)..."
find "$BACKUP_DIR" -type f -name "*.dump" -mtime +$RETENTION_DAYS -exec rm -f {} \;
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm -f {} \;
log_message "Nettoyage terminé."

log_message "Sauvegarde hebdomadaire terminée avec succès."