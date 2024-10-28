#!/bin/bash
BACKUP_DIR="/opt/database/backup"
TIMESTAMP=$(date +\%Y-\%m-\%d)
BACKUP_FILE="$BACKUP_DIR/txn_info_$TIMESTAMP.tar"
ENCRYPTED_FILE="$BACKUP_FILE.enc"
KEY="mykey" 
BUCKET="s3://xxxxx"

pg_dump -F t -h localhost -U psp_kg_user -d txn_info > "$BACKUP_FILE"
openssl enc -aes-256-cbc -salt -pbkdf2 -in "$BACKUP_FILE" -out "$ENCRYPTED_FILE" -k "$KEY"
rm "$BACKUP_FILE"
s3cmd put "$ENCRYPTED_FILE" "$BUCKET" 
ls -t | tail -n +3 | xargs -d '\n' rm --
# find "$BACKUP_DIR" -type f -name "*.tar.enc" -mtime +2 -exec rm {} \;
