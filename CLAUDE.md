# Kulturpunkt Flawil – Website

Diese Website gehört dem Verein Kulturpunkt Flawil (kulturpunkt-flawil.ch).
Wer hier mit Claude Code arbeitet, ist meist keine Programmiererin. Deshalb:

## So arbeitest du in diesem Projekt
- Antworte immer auf Deutsch (Schweizer Schreibweise, «ss» statt «ß»), einfach und ohne Fachjargon.
- Erkläre kurz, was du änderst, bevor du es tust. Keine grossen Umbauten ohne Rückfrage.
- Nach jeder Änderung: lokal prüfen (`open site/index.html`), dann fragen, ob veröffentlicht werden soll.
- Veröffentlichen erst nach ausdrücklichem «Ja»: `./deploy.sh` (fragt selbst nach dem FTP-Passwort – nie ein Passwort in Dateien schreiben oder ausgeben).
- Nach jeder Änderung sichern: `./sichern.sh "kurze Beschreibung"`.

## Wo steht was
- `site/programm.js` – **alle Konzerte und Anlässe**. Neue Einträge oben in die Liste `PROGRAMM` einfügen.
  Felder: typ ("konzert" oder "bar"), datum ("JJJJ-MM-TT"), zeit ("20:00"), titel, text, preis.
  Kommende Anlässe erscheinen automatisch im Programm, vergangene im Archiv.
  Die offenen Donnerstagabende (Bar ab 17 Uhr) erzeugt die Seite selbst – nicht eintragen.
- `site/index.html` – Aufbau, Texte, Vermietung (Raumtabelle, Ausstattung), Verein, Kontakt, Farben.
- `site/.htaccess` – Umleitungen der alten Drupal-Adressen. Nur mit Grund ändern.

## Gestaltung
- Logofarbe Türkis #0FB3AF (Flächen), dunkleres Türkis #0A7F7C für Buttons und Links.
- Tropfenform aus dem Logo (runde Ecken, unten links eckig), Kleinschreibung in Überschriften.
- Hell- und Dunkelmodus beibehalten.

## Wichtige Fakten (nicht erfinden, nur ändern, wenn die Nutzerin es sagt)
- Adresse: St.Gallerstrasse 13, 9230 Flawil · Telefon +41 79 224 82 88
- Vermietung: Patricia Jagodic, 078 903 07 59, info@kulturpunkt-flawil.ch
- Jeden Donnerstag ab 17 Uhr offen, Eintritt frei

## Technik
- Statische Seite ohne Datenbank. Hosting: hosttech Webhosting mit Plesk, FTP 181.hosttech.eu, Webordner `web`, kein SSH.
- Zugangsdaten stehen nur lokal in `.deploy.env` (nicht im GitHub).
- Code liegt privat auf GitHub: quakediquak/kulturpunkt-website.
  Anmeldung per classic-Schlüssel im Mac-Schlüsselbund. Scheitert `git push`, ist er meist abgelaufen:
  Anleitung in README.md («GitHub-Anmeldung») – `git push` muss die Nutzerin im Terminal-Programm machen.
- Falls `./deploy.sh` scheitert: Dateien aus `site/` im Plesk-Dateimanager in den Ordner `web` hochladen.
