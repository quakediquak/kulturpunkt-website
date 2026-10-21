#!/bin/bash
# Richtet eine tägliche automatische Sicherung um 18:00 ein (macOS launchd).
# Ausschalten: launchctl unload ~/Library/LaunchAgents/ch.kulturpunkt.sicherung.plist
set -e
PROJ="$(cd "$(dirname "$0")" && pwd)"
PL="$HOME/Library/LaunchAgents/ch.kulturpunkt.sicherung.plist"
mkdir -p "$HOME/Library/LaunchAgents" "$HOME/Kulturpunkt-Backup"
cat > "$PL" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>ch.kulturpunkt.sicherung</string>
  <key>ProgramArguments</key><array><string>/bin/bash</string><string>$PROJ/sichern.sh</string></array>
  <key>StartCalendarInterval</key><dict><key>Hour</key><integer>18</integer><key>Minute</key><integer>0</integer></dict>
  <key>StandardOutPath</key><string>$HOME/Kulturpunkt-Backup/sicherung.log</string>
  <key>StandardErrorPath</key><string>$HOME/Kulturpunkt-Backup/sicherung.log</string>
</dict></plist>
PLIST
launchctl unload "$PL" 2>/dev/null || true
launchctl load "$PL"
echo "Automatische Sicherung eingerichtet: täglich 18:00 (Protokoll: ~/Kulturpunkt-Backup/sicherung.log)"
