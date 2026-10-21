#!/bin/bash
# Schaltet die neue Website live:
# 1. verschiebt die alte Drupal-Seite auf dem Server in einen Ordner _drupal-alt-DATUM
# 2. lädt die neue Seite hoch
# Braucht SSH-Zugang zum hosttech-Webhosting. Daten aus .deploy.env.
set -e
cd "$(dirname "$0")"
[ -f .deploy.env ] || { echo "Bitte zuerst .deploy.env ausfüllen (cp deploy.env.beispiel .deploy.env)"; exit 1; }
source .deploy.env
PORT="${SFTP_PORT:-22}"
ZIEL="$SFTP_USER@$SFTP_HOST"
SOCK="/tmp/kp-ssh-$$"
ALT="_drupal-alt-$(date +%Y-%m-%d)"

# Eine Verbindung für alle Schritte, Passwort nur einmal
ssh -p "$PORT" -o ControlMaster=yes -o ControlPath="$SOCK" -o ControlPersist=120 -fN "$ZIEL"
trap 'ssh -o ControlPath="$SOCK" -O exit "$ZIEL" 2>/dev/null' EXIT
S="ssh -p $PORT -o ControlPath=$SOCK $ZIEL"

echo "Inhalt von $ZIELORDNER:"
$S "ls -la '$ZIELORDNER'"
echo
read -p "Alte Dateien jetzt nach $ALT verschieben und neue Seite hochladen? (ja/nein) " OK
[ "$OK" = "ja" ] || { echo "Abgebrochen, nichts geändert."; exit 0; }

$S "set -e; cd '$ZIELORDNER'
  if mkdir -p '../$ALT' 2>/dev/null && [ -w '../$ALT' ]; then D='../$ALT'; else
    mkdir -p '$ALT'; D='$ALT'
    printf 'Require all denied\nDeny from all\n' > '$ALT/.htaccess'
  fi
  for f in * .[!.]* ..?*; do
    [ -e \"\$f\" ] || continue
    case \"\$f\" in _drupal-alt-*|.well-known|cgi-bin) continue;; esac
    mv \"\$f\" \"\$D/\"
  done
  echo \"Alte Seite liegt jetzt in: \$D\""

scp -P "$PORT" -o ControlPath="$SOCK" site/index.html site/.htaccess "$ZIEL:$ZIELORDNER/"
echo
echo "Fertig. Neue Seite: https://kulturpunkt-flawil.ch"
echo "Test Umleitung:     https://kulturpunkt-flawil.ch/de/programm"
