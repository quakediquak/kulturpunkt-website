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

## Wo liegen die Dateien auf dem Mac
- Projekt (hier wird gearbeitet): `/Users/patricia/Kulturpunkt/kulturpunkt-website`
  - Website-Dateien im Unterordner `site` (`programm.js` = Konzerte, `index.html` = Texte)
- Sicherungen (ZIP, die letzten 30 Tage): `/Users/patricia/Kulturpunkt-Backup/projekt`
- Im Finder öffnen: **Cmd + Shift + G**, Pfad einfügen, Enter.

## GitHub
Repository: https://github.com/quakediquak/kulturpunkt-website (privat)
Auf einem neuen Mac holen: `git clone https://github.com/quakediquak/kulturpunkt-website.git`

### GitHub-Anmeldung (Schlüssel)
Der Mac meldet sich bei GitHub mit einem **classic-Schlüssel** an (eingerichtet am 21.10.2026,
gespeichert im Mac-Schlüsselbund). Meldet `./sichern.sh` «GitHub: nicht erreichbar», ist der
Schlüssel meist abgelaufen. Dann einen neuen erstellen:

1. github.com → Profilbild → **Settings** → **Developer settings**
2. **Personal access tokens → Tokens (classic)** → **Generate new token (classic)**
3. Note: `Kulturpunkt Mac`, Expiration: z. B. 1 Jahr, Häkchen bei **repo**
4. **Generate token**, Schlüssel (beginnt mit `ghp_`) kopieren
5. Im **Terminal-Programm** (nicht im Claude-Chat, dort kann nicht nach dem Passwort gefragt werden):
   `cd ~/Kulturpunkt/kulturpunkt-website && git push`
   Username: `quakediquak`, Password: den Schlüssel einfügen (es ist nichts zu sehen – normal)

Hinweise:
- Fine-grained-Schlüssel haben hier nicht funktioniert (Fehler 403) – classic verwenden.
- Fehler 403 = Schlüssel gültig, aber ohne Schreibrecht → Häkchen bei **repo** prüfen.
- Den Schlüssel nie in einen Chat oder eine Datei schreiben. Falls doch passiert: auf GitHub löschen.

## Server
hosttech Webhosting mit Plesk, FTP-Server 181.hosttech.eu, Webordner `web`. Kein SSH.
Falls `deploy.sh` scheitert: im Plesk-Dateimanager `site/index.html` in den Ordner `web` hochladen.
