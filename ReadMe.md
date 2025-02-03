# Solution de Sauvegarde Odoo entre Serveur cloud et Serveur Local

## Utilisation du Script backup_odoo.sh sur le serveur cloud
### Créer le répertoire de sauvegarde :

```bash
sudo mkdir -p /backups/odoo
sudo chown -R $USER:$USER /backups/odoo
```

### Rendre le script exécutable :

```bash
chmod +x /chemin/vers/backup_odoo.sh
```
### Tester le script :
#### Exécutez le script manuellement pour vérifier qu'il fonctionne correctement :

```bash
/chemin/vers/backup_odoo.sh
```

### Automatiser avec cron :
#### Ouvrez le fichier crontab :

```bash
crontab -e
```

#### Ajoutez la ligne suivante pour exécuter le script tous les dimanches à 3h du matin :

```bash
0 3 * * 0 /chemin/vers/backup_odoo.sh >> /var/log/odoo_backup.log 2>&1
```

## Récupérer les sauvegardes via PowerShell sur le serveur local
