#!/bin/bash
# Sichert eine lesbare Kopie der alten Website kulturpunkt-flawil.ch
# Aufruf: ./backup-alte-seite.sh
set -e
ZIEL="$HOME/Kulturpunkt-Backup/alte-website-$(date +%Y-%m-%d)"
mkdir -p "$ZIEL"
cd "$ZIEL"
if ! command -v wget >/dev/null; then
  echo "wget fehlt. Installieren mit: brew install wget"; exit 1
fi
wget --mirror --convert-links --adjust-extension --page-requisites \
     --no-parent --wait=1 --random-wait -e robots=off \
     https://kulturpunkt-flawil.ch/de
cd ..
zip -qr "$(basename "$ZIEL").zip" "$(basename "$ZIEL")"
echo "Fertig: $ZIEL"
echo "ZIP:    $ZIEL.zip"
echo "Ansehen: open \"$ZIEL/kulturpunkt-flawil.ch/de.html\""
