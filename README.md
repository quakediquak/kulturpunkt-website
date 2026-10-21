# Kulturpunkt Flawil – Website

Neue Website für den Kulturpunkt Flawil (kulturpunkt-flawil.ch).

## Ordner
- `site/` – die Website
- `deploy.sh` – lädt `site/` per FTP aufs hosttech-Webhosting (Ordner `web`)
- `golive-ftp.sh` – einmalige Umstellung von der alten Drupal-Seite (erledigt am 21.10.2026, alte Seite liegt auf dem Server in `_drupal-alt-2026-10-21`)
- `backup-alte-seite.sh` – sichert eine Kopie der alten Website
- `Dockerfile`, `docker-compose.yml` – nur für die lokale Vorschau

## Lokal ansehen
`open site/index.html` oder mit Docker: `docker compose up -d` → http://localhost:8085

## Veröffentlichen
1. Einmalig: `cp deploy.env.beispiel .deploy.env` und ausfüllen
2. `./deploy.sh`

## Sichern
`./sichern.sh "was geändert wurde"` – ins GitHub und als ZIP nach `~/Kulturpunkt-Backup/projekt`.
Täglich automatisch um 18:00, eingerichtet mit `./auto-sicherung-einrichten.sh`.

## Konzerte eintragen
In `site/programm.js` (oder Claude Code fragen: «Trag ein Konzert am … ein»).

## Neuer Mac
`bash kunden-mac-einrichten.sh` installiert Claude Code, holt das Projekt und richtet die Sicherung ein.

## GitHub
Repository: https://github.com/quakediquak/kulturpunkt-website (privat)
Auf einem neuen Mac holen: `git clone https://github.com/quakediquak/kulturpunkt-website.git`

## Server
hosttech Webhosting mit Plesk, FTP-Server 181.hosttech.eu, Webordner `web`. Kein SSH.
Falls `deploy.sh` scheitert: im Plesk-Dateimanager `site/index.html` in den Ordner `web` hochladen.
