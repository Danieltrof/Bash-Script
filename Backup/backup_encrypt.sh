#!/bin/bash

# Use: ./backup_encrypt.sh <folder_to_backup> <output-folder> <receivers_email>

SOURCE_DIR=$1
BACKUP_DIR=$2
GPG_RECIPIENT=$3

# Check input
if [ "$#" -ne 3 ]; then
    echo "Use: $0 <sourcefolder> <backupfolder> <GPG-email or ID>"
    echo "Example: $0 /home/user/Documents /home/user/backups user@example.com"
    exit 1
fi

# Timestamp and filename
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BASENAME=$(basename "$SOURCE_DIR")
ARCHIVE_NAME="${BASENAME}_backup_${TIMESTAMP}.tar.gz"
ENCRYPTED_NAME=${ARCHIVE_NAME}.gpg

# Create backupfolder if not exists
mkdir -p "$BACKUP_DIR"

# Create archive
echo " Compiling $SOURCE_DIR ..."
tar -czf "$BACKUP_DIR/$ARCHIVE_NAME" -C "$(dirname "$SOURCE_DIR")" "$BASENAME"

# Encrypt archive
echo "Encrypting $ARCHIVE_NAME with gpg for receiver: $GPG_RECIPIENT ..."

# Asymmetric encryption
gpg --yes --encrypt --recipient "$GPG_RECIPIENT" "$BACKUP_DIR/$ARCHIVE_NAME"

# Symmetric encryption
# gpg --yes --symmetric --cipher-algo AES256 "$BACKUP_DIR/$ARCHIVE_NAME"

# Delete noncrypted archive
rm "$BACKUP_DIR/$ARCHIVE_NAME"

echo "Done! Encrypted backup saved as: $BACKUP_DIR/$ENCRYPTED_NAME"
