Besipiel f&uuml;r Verwendung:

	cat probe.json | ./grjsonplplot -dev xfig -o probe.fig

`probe.json` beschreibt das auszugebende Diagramm.  `examples`
enth&auml;lt Beispiele, die man f&uuml;r `probe.json` verwenden darf.
`xfig` gibt das Ausgabeformat an.  Hier das Dateiformat des bekannten
xfig-Programmes.  Die Ausgabe erfolgt hier in die Datei `probe.fig`.
Welche Formate zugelassen sind, kann man sich durch

	./grjsonplplot

anzeigen lassen.

	./grjsonplplot -h

listet alle Optionen f&uuml;r das `grjsonplplot`-Programm auf.


# Zu den json-Files.

mandatory sind die Schl&uuml;ssel:

* `config`,
* `config.xmin` (kleinster im Diagramm dargestellter x-Wert),
* `config.xmax` (gr&ouml;&szlig;ter im Diagramm dargesteller x-Wert),
* `config.ymin` (kleinster im Diagramm dargestellter y-Wert),
* `config.ymax` (gr&ouml;&szlig;ter im Diagramm dargesteller y-Wert),
* `config.xlabel` (Beschriftung der x-Achse),
* `config.ylabel` (Beschriftung der y-Achse),
* `config.tlabel` (Titel des Diagramms),
* `data` (darzustellende Daten)


fakultativ sind folgende Schl&uuml;ssel:

* `config.xlog` (default: `false`; ob x-Achse logarithmisch),
* `config.ylog` (default: `false`; ob y-Achse logarithmisch)
