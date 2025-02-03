# Odoo Backup Solution between Cloud and Local Servers

## Cloud Server Script (`backup_odoo.sh`)

### Backup Directory Preparation

```bash
# Create backup directory
sudo mkdir -p /backups/odoo

# Set permissions
sudo chown -R $USER:$USER /backups/odoo
```

### Script Execution Permissions

```bash
# Make script executable
chmod +x /path/to/backup_odoo.sh
```

### Script Testing

Run the script manually to verify functionality:

```bash
/path/to/backup_odoo.sh
```

### Cron Automation

1. Open crontab:
   ```bash
   crontab -e
   ```

2. Add scheduling line (runs every Sunday at 3 AM):
   ```bash
   0 3 * * 0 /path/to/backup_odoo.sh >> /var/log/odoo_backup.log 2>&1
   ```

## Local Server Backup Retrieval

### Task Scheduler Configuration

1. Open Task Scheduler
2. Create New Task
   - **Trigger**: Weekly schedule
   - **Action**: 
     ```powershell
     powershell.exe -ExecutionPolicy Bypass -File C:\Scripts\retrieve_backup.ps1
     ```

## Best Practices

- Replace script paths with actual paths
- Verify file permissions
- Test backup and retrieval processes thoroughly