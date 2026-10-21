// ============================================================
//  PROGRAMM KULTURPUNKT FLAWIL
//  Hier werden alle Konzerte und Anlässe eingetragen.
//  Kommende Anlässe erscheinen automatisch unter «Programm»,
//  vergangene wandern automatisch ins «Archiv».
//  Die offenen Donnerstagabende erzeugt die Seite selbst.
//
//  Felder:
//    typ:   "konzert" oder "bar"
//    datum: "JJJJ-MM-TT"   zeit: "20:00"
//    titel, text (kurze Beschreibung), preis (z. B. "CHF 25", "Kollekte")
// ============================================================
const PROGRAMM = [
  {typ:"konzert", datum:"2026-11-30", zeit:"20:00", titel:"Test", text:"", preis:"CHF 20.-"},
  {typ:"konzert", datum:"2026-06-20", zeit:"09:00", titel:"StimmSaiten zelebrieren den Frühklang", text:"Interaktive Performance für Gross und Klein, mit Helen Prates de Matos", preis:"Kollekte"},
  {typ:"bar",     datum:"2026-05-22", zeit:"17:00", titel:"Den Kulturpunkt kann man mieten!", text:"Tag der offenen Tür für Vermietungen", preis:"–"},
  {typ:"bar",     datum:"2026-04-30", zeit:"17:00", titel:"Herzlich willkommen!", text:"Offener Abend an der Bar", preis:"Eintritt frei"},
];
