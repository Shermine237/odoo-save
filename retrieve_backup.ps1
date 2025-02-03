# Variables
$BackupDir = "C:\OdooBackups"               # Répertoire local pour stocker les sauvegardes
$RemoteServer = "user@monserveur.ovh"       # Utilisateur et adresse du serveur OVH
$RemotePath = "/var/backups/odoo/"          # Répertoire des sauvegardes sur le serveur OVH
$LogFile = "$BackupDir\backup_log.txt"      # Fichier de log pour enregistrer les détails
$RsyncPath = "C:\Program Files\Git\usr\bin\rsync.exe"  # Chemin de rsync (Git pour Windows)
$SshPath = "C:\Program Files\Git\usr\bin\ssh.exe"      # Chemin de ssh (Git pour Windows)

# Créer le dossier de sauvegarde s'il n'existe pas
if (!(Test-Path -Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir
}

# Initialiser le fichier de log
$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $LogFile -Value "[$Timestamp] Début du processus de sauvegarde."

# Commande rsync pour récupérer les sauvegardes
try {
    & $RsyncPath -avz --progress --partial --remove-source-files `
        $RemoteServer:$RemotePath $BackupDir >> $LogFile 2>&1
    if ($LASTEXITCODE -eq 0) {
        Add-Content -Path $LogFile -Value "[$Timestamp] Transfert des sauvegardes réussi."
    } else {
        throw "Erreur lors du transfert des sauvegardes."
    }
} catch {
    Add-Content -Path $LogFile -Value "[$Timestamp] Erreur : $_"
    Write-Error "Erreur lors du transfert des sauvegardes. Voir le fichier de log : $LogFile"
    exit 1
}

# Nettoyage des fichiers vides après transfert
try {
    & $SshPath $RemoteServer "find $RemotePath -type f -empty -delete"
    if ($LASTEXITCODE -eq 0) {
        Add-Content -Path $LogFile -Value "[$Timestamp] Nettoyage des fichiers vides réussi."
    } else {
        throw "Erreur lors du nettoyage des fichiers vides."
    }
} catch {
    Add-Content -Path $LogFile -Value "[$Timestamp] Erreur : $_"
    Write-Error "Erreur lors du nettoyage des fichiers vides. Voir le fichier de log : $LogFile"
    exit 1
}

# Message de succès
Write-Output "Sauvegarde récupérée avec succès."
Add-Content -Path $LogFile -Value "[$Timestamp] Processus de sauvegarde terminé avec succès."