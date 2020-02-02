# Windows 10 Startmedium erstellen unter Linux (Ubuntu/Mint)

Basierend auf der wunderbaren Beschreibung von `Posted on August 20, 2016 by admin`:

> https://www.admlife.de/2016/08/20/windows-10-installation-usb-stick-unter-linux-erstellen/
 
In meinem Fall waren einige Anpassungen erforderlich, die im Skript entsprechend
markiert sind.

Für die Ausführung ist root-Berechtigung erforderlich.

Es wird empfohlen, die Anleitung Step-by-Step in einem Terminal auszuführen.

## Hintergrund

Für die Vorbereitung einer Windows 10 Installation soll ein USB-Stick als Startmedium erstellt werden.  Ein Upgrade der vorhandenen Windows 7 Installation kommt nicht in Frage, da die Installation zwischenzeitlich diverse Ausfallerscheinungen zeigt. Ich selbst habe keine Windows-Systeme mehr laufen, weshalb ich den Stick unter Linux MINT 19 erstellen darf. Heruntergeladen wurde Windows 10 als Datenträgerabbild `.ISO` über folgende URL:

- https://www.microsoft.com/de-de/software-download/windows10

Das ISO-File kann problemlos als Datenträger für eine VirtualBox VM Installation herangezogen werden. Dabei wird das ISO als CD/DVD eingebunden (bootbar/auto-mount). 

Nicht so einfach gelingt das Erstellen eines bootbaren USB-Sticks unter Linux. Folgende Ansätze funktionieren nicht:

- Datenträgerabbild via `dd` auf einen Stick kopieren
- Startmedienersteller für Ubuntu und Mint

Andere Lösungsansätze waren ebenfalls häufig nicht erfolgreich oder verlangten die Installation alter Linuxprogramme oder das hinzufügen neuer Paketeverzeichnisse. Damit war ich nicht glücklich und es musste eine andere Lösung her.

Grundsätzlich verfolgt der hier dargestellte Lösungsansatz folgendes Szenario:

- das USB-Startmedium benötigt eine GPT-Partitionstabelle (gparted oder fdisk)
- als Partitionstyp soll Typ=11 *Microsoft basic data* verwendet werden (fdisk)
- beim Kopieren von Dateien größer 4GB muss gesplitted werden (wimtools, wimsplit)

Letztendlich wird das ISO-Datenträgerabbild unter Linux gemounted und alle Verzeichnisse und Dateien auf den USB-Stick übertragen.
