#!/bin/bash
# Einmalige Einrichtung auf dem Mac des Kulturpunkts.
# Aufruf: Datei per AirDrop oder USB auf den Mac kopieren, dann im Terminal:
#   bash ~/Downloads/kunden-mac-einrichten.sh
set -e
echo "== 1/5 Entwicklerwerkzeuge (git, python3) =="
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install || true
  echo "Bitte das Fenster «Installieren» bestätigen, warten bis fertig, dann dieses Skript nochmals starten."; exit 0
fi
git --version

echo "== 2/5 Claude Code =="
if ! command -v claude >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/claude" ]; then
  curl -fsSL https://claude.ai/install.sh | bash
fi
grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
export PATH="$HOME/.local/bin:$PATH"
claude --version || true

echo "== 3/5 Projekt von GitHub holen =="
mkdir -p "$HOME/Kulturpunkt"
cd "$HOME/Kulturpunkt"
if [ ! -d kulturpunkt-website/.git ]; then
  echo "GitHub fragt gleich nach Benutzername (quakediquak) und Passwort (= Token von github.com/settings/tokens)."
  git config --global credential.helper osxkeychain
  git clone https://github.com/quakediquak/kulturpunkt-website.git
fi
cd kulturpunkt-website
git config user.name >/dev/null || git config user.name "Kulturpunkt Flawil"
git config user.email >/dev/null || git config user.email "info@kulturpunkt-flawil.ch"
chmod +x *.sh

echo "== 4/5 FTP-Daten =="
if [ ! -f .deploy.env ]; then
  cp deploy.env.beispiel .deploy.env
  read -p "FTP-Benutzername (aus Plesk): " U
  sed -i '' "s/^SFTP_USER=.*/SFTP_USER=$U/" .deploy.env
fi

echo "== 5/5 Automatische Sicherung =="
./auto-sicherung-einrichten.sh

echo
echo "Fertig! Arbeiten mit Claude Code:"
echo "  cd ~/Kulturpunkt/kulturpunkt-website"
echo "  claude"
echo "Beim ersten Start meldet sich Claude im Browser an (Claude-Konto mit Pro-Abo nötig)."
