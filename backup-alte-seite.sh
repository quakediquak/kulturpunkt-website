#!/bin/bash
# Sichert eine lesbare Kopie der alten Website kulturpunkt-flawil.ch
# Braucht nur python3 (auf dem Mac mit den Entwicklerwerkzeugen vorhanden).
# Aufruf: ./backup-alte-seite.sh
set -e
ZIEL="$HOME/Kulturpunkt-Backup/alte-website-$(date +%Y-%m-%d)"
mkdir -p "$ZIEL"
python3 - "$ZIEL" <<'PY'
import sys, os, re, time, hashlib, urllib.request, urllib.parse
from html.parser import HTMLParser

ZIEL = sys.argv[1]
START = "https://kulturpunkt-flawil.ch/de"
HOSTS = {"kulturpunkt-flawil.ch", "www.kulturpunkt-flawil.ch"}
MAX = 2000

def lokal(url, is_page):
    u = urllib.parse.urlsplit(url)
    pfad = urllib.parse.unquote(u.path) or "/"
    if is_page:
        if pfad.endswith("/"): pfad += "index"
        if u.query:
            pfad += "_" + hashlib.md5(u.query.encode()).hexdigest()[:8]
        if not pfad.endswith(".html"): pfad += ".html"
    else:
        if pfad.endswith("/"): pfad += "index"
        if u.query and not os.path.splitext(pfad)[1]:
            pfad += "_" + hashlib.md5(u.query.encode()).hexdigest()[:8]
    return os.path.join(ZIEL, pfad.lstrip("/"))

class Links(HTMLParser):
    def __init__(self):
        super().__init__(); self.found = []
    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        for k in ("href", "src"):
            if a.get(k): self.found.append((tag, k, a[k]))
        if a.get("srcset"):
            for part in a["srcset"].split(","):
                p = part.strip().split(" ")[0]
                if p: self.found.append((tag, "src", p))

def holen(url):
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 Kulturpunkt-Backup"})
    for versuch in range(3):
        try:
            with urllib.request.urlopen(req, timeout=60) as r:
                return r.read(), r.headers.get("Content-Type", "")
        except Exception:
            if versuch == 2: raise
            time.sleep(3)

def intern(url):
    return urllib.parse.urlsplit(url).netloc in HOSTS

def schreiben(pfad, daten):
    os.makedirs(os.path.dirname(pfad), exist_ok=True)
    with open(pfad, "wb") as f: f.write(daten)

def relativ(von, nach):
    return os.path.relpath(nach, os.path.dirname(von))

seiten, gesehen, assets = [START], set(), {}
anzahl = 0
while seiten and anzahl < MAX:
    url = urllib.parse.urldefrag(seiten.pop(0))[0]
    if url in gesehen: continue
    gesehen.add(url)
    try:
        daten, typ = holen(url)
    except Exception as e:
        print("  übersprungen:", url, e); continue
    anzahl += 1
    if "text/html" not in typ:
        schreiben(lokal(url, False), daten); continue
    html = daten.decode("utf-8", "replace")
    ziel = lokal(url, True)
    p = Links(); p.feed(html)
    ersatz = {}
    for tag, attr, wert in p.found:
        if wert.startswith(("mailto:", "tel:", "javascript:", "#", "data:")): continue
        abs_ = urllib.parse.urldefrag(urllib.parse.urljoin(url, wert))[0]
        if not intern(abs_): continue
        ist_seite = tag == "a" and not re.search(r"\.(pdf|jpe?g|png|gif|svg|webp|mp3|mp4|zip|docx?)$", abs_, re.I)
        if ist_seite:
            if abs_ not in gesehen: seiten.append(abs_)
            ersatz[wert] = relativ(ziel, lokal(abs_, True))
        else:
            assets[abs_] = True
            ersatz[wert] = relativ(ziel, lokal(abs_, False))
    for alt in sorted(ersatz, key=len, reverse=True):
        html = html.replace('"%s"' % alt, '"%s"' % ersatz[alt]).replace("'%s'" % alt, "'%s'" % ersatz[alt])
    schreiben(ziel, html.encode("utf-8"))
    print(f"[{anzahl}] {url}")
    time.sleep(0.3)

for a in list(assets):
    pfad = lokal(a, False)
    if os.path.exists(pfad): continue
    try:
        daten, typ = holen(a)
        if "css" in typ or a.split("?")[0].endswith(".css"):
            css = daten.decode("utf-8", "replace")
            def ers(m):
                w = m.group(2)
                if w.startswith("data:"): return m.group(0)
                ab = urllib.parse.urljoin(a, w)
                if not intern(ab): return m.group(0)
                try:
                    d2, _ = holen(ab); schreiben(lokal(ab, False), d2)
                except Exception: return m.group(0)
                return "url(%s%s%s)" % (m.group(1), relativ(pfad, lokal(ab, False)), m.group(1))
            css = re.sub(r"url\((['\"]?)([^'\")]+)\1\)", ers, css)
            daten = css.encode("utf-8")
        schreiben(pfad, daten)
    except Exception as e:
        print("  Datei übersprungen:", a, e)
print(f"\n{anzahl} Seiten und {len(assets)} Dateien gesichert.")
PY
cd "$(dirname "$ZIEL")"
zip -qr "$(basename "$ZIEL").zip" "$(basename "$ZIEL")"
echo "Ordner: $ZIEL"
echo "ZIP:    $ZIEL.zip"
echo "Ansehen: open \"$ZIEL/de.html\""
