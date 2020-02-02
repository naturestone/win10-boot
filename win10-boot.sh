# win10-boot
#
# Windows 10 Startmedium erstellen unter Linux (Ubuntu/Mint)
#
# Basierend auf der wunderbaren Beschreibung von admin:
# https://www.admlife.de/2016/08/20/windows-10-installation-usb-stick-unter-linux-erstellen/
# Posted on August 20, 2016 by admin	
# 
# In meinem Fall waren einige Anpassungen erforderlich, die unten auch entsprechend
#   markiert wurden.
#
# Für die Ausführung ist root-Berechtigung erforderlich.
# 
# Es wird empfohlen, die Anleitung Step-by-Step in einem Terminal auszuführen.

# Annahme: ein Win10-ISO-File liegt unter ~/Downloads
cd ~Downloads
ISOFILE=$(find . -name "Win10*" | head -1)

# Partitionierung / Geräte anzeigen und auswählen
# Muss durch den Anwender entsprechend geändert werden - VORSICHT!
# lsblk oder sudo fdisk -l
# DEVICE=/dev/sdx
DEVICE=/dev/xyc

# Partitionierung auf dem USB Stick löschen
sudo dd if=/dev/zero of=$DEVICE bs=1M count=1

# Partitionen einrichten
# Wichtige Anpassungen:
# - mit Option g zuerst GPT-Partitionstabelle anlegen
# - ersetze Partitionstyp c mit 11 („Microsoft basic data“)
# - entfernen von Option a (Bootable), da bei Typ=11 nicht erforderlich
sudo fdisk ${DEVICE}
g
n
p
1
ENTER
ENTER
t
11
w

# Formatierung, mounten des Laufwerks
# Anpassung: umount hinzugefügt
# Anpassung: mkfs um Option -n erweitert
sudo umount ${DEVICE}1
sudo mkfs.vfat ${DEVICE}1 -n WIN10-USB

sudo mkdir /mnt/usb
sudo mount ${DEVICE}1 /mnt/usb

# Win10-ISO mounten
sudo mkdir -p /mnt/Win10
# sudo mount -o loop Win10_1909_German_x64.iso /mnt/Win10
sudo mount -o loop $ISOFILE /mnt/Win10

# Inhalt kopieren
# Anpassung: optimierte rsync-Optionen für Kopiervorgang
# sudo rsync -avP --exclude='sources/install.wim' /mnt/Win10/ /mnt/usb/
sudo rsync -vrh --exclude='sources/install.wim' /mnt/Win10/ /mnt/usb/

# wimsplit: splitten zu großer Dateien für FAT32 (größer 4GB)
#
# Voraussetzung: wimtools sind installiert
# Installation der nötigen Tools um die wim Dateien zu splitten, denn vfat 
# kann keine Dateien > 4GB behandeln
# sudo apt-get install wimtools
#
sudo wimsplit /mnt/Win10/sources/install.wim /mnt/usb/sources/install.swm 2500

# Aushängen der Laufwerke
sudo umount /mnt/usb
sudo umount /mnt/Win10
echo; echo "USB-Startmedium entfernen!"

# Aufräumen (optional)
# Prüfen, dass umount erfolgreich, bevor Verzeichnis gelöscht wird
sudo rm -Rf ./Win10
if [! -f "/mnt/usb/setup.exe" ]; then
    sudo rm -Rf /mnt/usb
fi

echo; echo "Completed!"; echo
exit 0
