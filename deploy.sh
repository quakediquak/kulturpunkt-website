#!/bin/bash
# Lädt die Website per FTP auf das hosttech-Webhosting (Ordner aus .deploy.env, z. B. web).
# Anmeldung verschlüsselt, Datenübertragung unverschlüsselt (Server lehnt verschlüsselte Uploads ab).
set -e
cd "$(dirname "$0")"
[ -f .deploy.env ] || { echo "Bitte zuerst .deploy.env anlegen (Vorlage: deploy.env.beispiel)"; exit 1; }
source .deploy.env
ZO="${ZIELORDNER#/}"; ZO="${ZO%/}"
read -s -p "FTP-Passwort für $SFTP_USER: " PW; echo
NETRC=$(mktemp); chmod 600 "$NETRC"
printf "machine %s login %s password %s\n" "$SFTP_HOST" "$SFTP_USER" "$PW" > "$NETRC"
trap 'rm -f "$NETRC"' EXIT
DATEIEN="index.html programm.js .htaccess"
for b in site/bilder/*.jpg; do [ -f "$b" ] && DATEIEN="$DATEIEN bilder/$(basename "$b")"; done
for f in $DATEIEN; do
  curl -s -S --netrc-file "$NETRC" --ftp-ssl-control --ftp-pasv --ftp-create-dirs -T "site/$f" "ftp://$SFTP_HOST/$ZO/$f"
  echo "  hochgeladen: $f"
done
echo "Fertig. Prüfen: https://kulturpunkt-flawil.ch (Cmd+Shift+R)"
