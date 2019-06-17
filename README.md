# HackBIZ
HackBIZ ist ein in Ruby geschriebenes Dashboard, welches das Gem Smashing(http://smashing.github.io/smashing) nutzt.

Inspired By: http://wiki.chaotikum.org/hackerspace:infrastruktur:dashboard

Bisher gibt es Kacheln für Temperatur, Uhrzeit, Bus- und Zug Abfahrtszeiten.

# Installation/Start
Mit dem Kommando 'bundle install' im Hauptverzeichnis des Ordners werden zunächst die benötigten Gems installiert.

Im Anschluss kann mit dem Kommando 'smashing start' die Anwendung gestartet werden.
Sie ist zunächst unter der Adresse http://localhost:3030 erreicht werden.

Mit dem Kommando 'smashing start -d' kann die Anwendung im Hintergrund gestartet werden.
Um die Anwendung zu stoppen wird 'smashing stop' verwendet.

Der Port der Anwendung kann mit dem Befehl 'smashing start -p 5000' angegeben werden.
