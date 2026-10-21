#!/bin/bash
# Schaltet die neue Website per FTP live (für Webhosting ohne SSH).
# 1. verschiebt die alte Seite in einen Ordner _drupal-alt-DATUM
# 2. lädt index.html und .htaccess hoch
# Daten aus .deploy.env (SFTP_HOST, SFTP_USER, ZIELORDNER), z. B. ZIELORDNER=web
set -e
cd "$(dirname "$0")"
[ -f .deploy.env ] || { echo "Bitte zuerst .deploy.env ausfüllen"; exit 1; }
source .deploy.env
# Pfade relativ zum FTP-Hauptverzeichnis, z. B. ZIELORDNER=web
ZO="${ZIELORDNER#/}"; ZO="${ZO%/}"
ELTERN="$(dirname "$ZO")"; [ "$ELTERN" = "." ] && ELTERN=""
P="${ELTERN:+$ELTERN/}"
ALT="_drupal-alt-$(date +%Y-%m-%d)"
BASIS="ftp://$SFTP_HOST"

read -s -p "FTP-Passwort für $SFTP_USER: " PW; echo
NETRC=$(mktemp); chmod 600 "$NETRC"
printf "machine %s login %s password %s\n" "$SFTP_HOST" "$SFTP_USER" "$PW" > "$NETRC"
trap 'rm -f "$NETRC"' EXIT
C=(curl -s -S --netrc-file "$NETRC" --ssl-reqd --ftp-pasv)

echo "Inhalt von $ZO:"
LISTE=$("${C[@]}" --list-only "$BASIS/$ZO/") || { echo "Verbindung fehlgeschlagen. Server, Benutzer, Passwort und Ordner prüfen."; exit 1; }
echo "$LISTE" | sed 's/^/  /'
echo
read -p "Diese Dateien nach $ALT verschieben und die neue Seite hochladen? (ja/nein) " OK
[ "$OK" = "ja" ] || { echo "Abgebrochen, nichts geändert."; exit 0; }

# Ordner für die alte Seite: neben dem Webordner, sonst darin (dann gesperrt)
if "${C[@]}" -Q "MKD $P$ALT" "$BASIS/" -o /dev/null 2>/dev/null; then
  D="$P$ALT"
else
  D="$ZO/$ALT"
  "${C[@]}" -Q "MKD $D" "$BASIS/" -o /dev/null
  printf 'Require all denied\nDeny from all\n' | "${C[@]}" -T - "$BASIS/$D/.htaccess"
fi
echo "Alte Seite kommt nach: $D"

echo "$LISTE" | while IFS= read -r f; do
  f="${f##*/}"
  case "$f" in ""|.|..|"$ALT"|_drupal-alt-*|.well-known|cgi-bin) continue;; esac
  if "${C[@]}" -Q "RNFR $ZO/$f" -Q "RNTO $D/$f" "$BASIS/" -o /dev/null 2>/dev/null; then
    echo "  verschoben: $f"
  else
    echo "  NICHT verschoben: $f"
  fi
done

"${C[@]}" -T site/index.html "$BASIS/$ZO/index.html"
"${C[@]}" -T site/.htaccess  "$BASIS/$ZO/.htaccess"
echo
echo "Fertig. Neue Seite: https://kulturpunkt-flawil.ch"
echo "Test Umleitung:     https://kulturpunkt-flawil.ch/de/programm"
