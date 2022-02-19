# Een Zephyr OS programma flashen op Windows en Linux

## Installatie

### Windows

De software kan op Windows 10 geflashed worden naar de ESP32 chip met gebruik van de [esptool](https://github.com/espressif/esptool/tree/release/v2). Om deze te installeren zal je Python 3.4 of later op je systeem geïnstalleerd moeten hebben. Op het moment is Python 3.10 de laatste versie en deze is dan ook geïnstalleerd. Het is ook vereist dat de seriële driver voor de ESP32 geïnstalleerd is. De drivers zijn te vinden op de [site van silabs](https://www.silabs.com/developers/usb-to-uart-bridge-vcp-drivers) (CP210x). Er is ook nog een andere driver, te vinden op de [site van espressif](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/establish-serial-connection.html).

Nadat de driver gedownload is kan deze uitgepakt worden in een eigen map. Door rechts te klikken op het *.inf* bestand komt het opties menu naar voren. Kies hier *installeren*.

Nadat je Python geïnstalleerd hebt open een terminal en installeer esptool. Daarnaast wordt ook direct een dependency van esptool geinstalleerd, [pySerial](https://github.com/pyserial/pyserial).

```sh
pip install esptool pyserial
```

Nu kan de tool gebruikt worden om de gecompileerde software te flashen.

### Linux

Zorg er eerst voor dat het systeem bijgwerkt is.

```sh
apt update
apt upgrade
```

Voor het flashen van de gecompileerde software op Linux moet er eerst wat vereiste software geïnstalleerd worden. Dit wordt gedaan met apt en vervolgens met pip. Python, esptool en pyserial zullen geïnstalleerd worden.

```sh
apt install -y python3-pip
pip install esptool pyserial
```

## Flashen

Na het downloaden van de artifacts moet het zip bestand uitgepakt worden in een map. Open een terminal in deze map. Op Windows kan dit gedaan worden door shift in gedrukt te houden en tegelijkertijd rechts te klikken in het *Explorer venster* van Windows. Bij de opties zal dan de optie *Powershell venster hier openen* staan. Op Linux kan dit gedaan worden door rechts te klikken in de map. Hier zal een soort gelijke optie staan.

Om de bestanden naar de ESP32 te flashen kan het volgende commando gebruikt worden.

```sh
esptool.py --chip auto --baud 921600 --before default_reset --after hard_reset write_flash -u --flash_mode dio --flash_freq 40m --flash_size detect 0x1000 ./bootloader.bin 0x8000 ./partitions_singleapp.bin 0x10000 ./zephyr.bin
```

Als de tool niet naar de juiste poort flasht (COMx of /dev/ttyUSBx) dan -p argument toegevoegd worden aan het commando met de naam van de juiste poort.
