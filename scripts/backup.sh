#!/bin/bash

# Automated Backup Script
# Run daily: 0 2 * * * ~/tech-helper-business/scripts/backup.sh

BACKUP_DIR=~/tech-helper-business/backups/$(date +%Y%m%d-%H%M%S)
BUCKET=tech-simple-website-84d8430bbbdc5b3b

echo "Creating backup: $BACKUP_DIR"
mkdir -p $BACKUP_DIR

# Backup S3 content
aws s3 sync s3://$BUCKET/ $BACKUP_DIR/

# Backup Terraform state
cp ~/tech-helper-business/terraform/terraform.tfstate $BACKUP_DIR/

# Keep only last 7 backups
cd ~/tech-helper-business/backups
ls -t | tail -n +8 | xargs rm -rf

echo "Backup complete: $(du -sh $BACKUP_DIR)"
