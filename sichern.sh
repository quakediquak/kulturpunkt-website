#!/bin/bash
# Sichert das Projekt: ins GitHub und als ZIP-Kopie in ~/Kulturpunkt-Backup
# Aufruf: ./sichern.sh "was geändert wurde"   (ohne Text: automatische Sicherung)
cd "$(dirname "$0")"
MSG="${1:-Automatische Sicherung $(date '+%d.%m.%Y %H:%M')}"
git pull --rebase --autostash -q 2>/dev/null
git add -A
git diff --cached --quiet || git commit -q -m "$MSG"
if git push -q 2>/dev/null; then echo "GitHub: gesichert"; else echo "GitHub: nicht erreichbar, nur lokal gesichert"; fi
ZIEL="$HOME/Kulturpunkt-Backup/projekt"
mkdir -p "$ZIEL"
zip -qr "$ZIEL/kulturpunkt-website-$(date +%Y-%m-%d).zip" . -x ".git/*"
ls -1t "$ZIEL"/kulturpunkt-website-*.zip 2>/dev/null | tail -n +31 | xargs rm -f 2>/dev/null
echo "Lokal:  $ZIEL (die letzten 30 Tage)"
