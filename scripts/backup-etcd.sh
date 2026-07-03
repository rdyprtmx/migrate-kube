#!/bin/bash
# etcd Backup Script
# Usage: ./backup-etcd.sh [output-file]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR="${SCRIPT_DIR}/../certs"
BACKUP_DIR="/var/backups/etcd"

# Default output file
OUTPUT_FILE="${1:-${BACKUP_DIR}/etcd-backup-$(date +%Y-%m-%d_%H%M%S).db}"

# etcd endpoints
ENDPOINTS="https://127.0.0.1:2379"

# Certificate paths
CA_CERT="${CERT_DIR}/ca.crt"
SERVER_CERT="${CERT_DIR}/server.crt"
SERVER_KEY="${CERT_DIR}/server.key"

# Validate certificates exist
if [ ! -f "$CA_CERT" ] || [ ! -f "$SERVER_CERT" ] || [ ! -f "$SERVER_KEY" ]; then
    echo "ERROR: Certificate files not found in ${CERT_DIR}"
    echo "Expected files: ca.crt, server.crt, server.key"
    exit 1
fi

# Create backup directory
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "Starting etcd backup..."
echo "Endpoint: ${ENDPOINTS}"
echo "Output: ${OUTPUT_FILE}"

# Perform backup
ETCDCTL_API=3 etcdctl \
    --endpoints="${ENDPOINTS}" \
    --cacert="${CA_CERT}" \
    --cert="${SERVER_CERT}" \
    --key="${SERVER_KEY}" \
    snapshot save "${OUTPUT_FILE}"

# Verify backup
ETCDCTL_API=3 etcdctl snapshot status "${OUTPUT_FILE}" --write-out=table

echo ""
echo "Backup completed successfully!"
echo "File: ${OUTPUT_FILE}"
echo "Size: $(du -h "${OUTPUT_FILE}" | cut -f1)"
