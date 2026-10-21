# Kulturpunkt Flawil – Website

Neue Website für den Kulturpunkt Flawil (kulturpunkt-flawil.ch).

## Ordner
- `site/` – die Website
- `deploy.sh` – lädt `site/` aufs hosttech-Webhosting
- `backup-alte-seite.sh` – sichert eine Kopie der alten Website
- `Dockerfile`, `docker-compose.yml` – nur für die lokale Vorschau

## Lokal ansehen
`open site/index.html` oder mit Docker: `docker compose up -d` → http://localhost:8085

## Veröffentlichen
1. Einmalig: `cp deploy.env.beispiel .deploy.env` und ausfüllen
2. `./deploy.sh`

## Sichern
Änderungen ins GitHub: `git add -A && git commit -m "Beschreibung" && git push`

## GitHub
Repository: https://github.com/quakediquak/kulturpunkt-website (privat)
Auf einem neuen Mac holen: `git clone https://github.com/quakediquak/kulturpunkt-website.git`
