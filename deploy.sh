#!/bin/bash
# Lädt die Website auf das hosttech-Webhosting hoch.
# Zugangsdaten stehen in .deploy.env (wird nicht ins GitHub übertragen).
set -e
cd "$(dirname "$0")"
[ -f .deploy.env ] || { echo "Bitte zuerst .deploy.env anlegen (Vorlage: deploy.env.beispiel)"; exit 1; }
source .deploy.env
echo "Lade site/ nach $SFTP_USER@$SFTP_HOST:$ZIELORDNER hoch ..."
scp -P "${SFTP_PORT:-22}" -r site/* "$SFTP_USER@$SFTP_HOST:$ZIELORDNER/"
echo "Fertig. Prüfen: https://kulturpunkt-flawil.ch"
