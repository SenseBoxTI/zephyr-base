# Een Zephyr programma compileren en flashen

## Introductie

In deze handleiding wordt er uitgelegd hoe een Zephyr OS programma op een ESP32 development kit geflasht kan worden. Hierbij wordt er van uit gegaan dat je begint met een verse installatie van Ubuntu Desktop (versie 20.04). In de handleiding zal er gebruik gemaakt worden van docker, dus het is handig als je hier al enige kennis van hebt.

Aan het einde van de handleiding zal uitgelegd worden hoe de bestanden op Windows 10 geflashed kunnen worden naar de ESP32 chip.

## Installatie

### Het systeem updaten

Open de terminal op Ubuntu Desktop, alle volgende stappen zullen ook gedaan worden in de terminal. Het zou ook mogelijk zijn om alle stappen vanuit een server installatie van Ubuntu te doen.

```sh
sudo apt update
sudo apt upgrade -y
```

### Docker installeren

Voordat we docker kunnen gebruiken moet dit geïnstalleerd worden op het systeem. Docker wordt gebruikt om gemakkelijk een omgeving te creëren waarin de code gecompileerd kan worden

```sh
sudo apt install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
newgrp docker
```

### Een bestaand zephyr project downloaden

We gaan uiteindelijk het hello-world programma van Zephyr OS compileren. De code hiervoor is overgezet naar een Github repository om het gemakkelijker te maken. Daarnaast zijn er ook een aantal dependencies uitgezet die je niet nodig zal hebben op een ESP32 bordje, dit is terug te vinden in *west.yml*.

Met de volgende commando’s wordt het programma gedownload naar *~/zephyr-base*.

```sh
cd ~/
git clone https://github.com/senseboxti/zephyr-base
```

### De docker container starten

We gaan nu de docker container starten waarin de compilers en andere benodigde tools al geïnstalleerd zijn. Dit scheelt een hoop tijd en is makkelijk over te nemen.

Het argument *--device* duid aan dat we een device willen doorgeven aan de container zodat we deze in de container kunnen gebruiken. Sluit daarom nu alvast je ESP32 aan op de computer. Normaal zou deze dan onder */dev/ttyUSB0* moeten komen. Als je meerdere *ttyUSBx* hebt dan zal het waarschijnlijk de laatste zijn.

```sh
docker run -it --name zephyr-build -v ~/zephyr-base:/workdir -w /workdir --device /dev/ttyUSB0 -e ZEPHYR_TOOLCHAIN_VARIANT="espressif" -e ESPRESSIF_TOOLCHAIN_PATH="${HOME}/.espressif/tools/zephyr" zephyrprojectrtos/ci
```

Doordat we de container een naam hebben gegeven kunnen we de volgende keer de container weer starten door het volgende commando in te voeren.

```sh
west init -l app
west update
west espressif install
```

Aan het einde van dit commando zal er aangegeven worden om twee export commando’s uit te voeren. Echter is dit niet nodig omdat we deze environment variabelen al ingesteld hebben bij het starten van de container.

## Compileren en flashen

Nu zijn we klaar om de code te compileren en flashen. Gebruik de volgende commando’s om dit automatisch door Zephyr te laten doen.

```sh
west build -b esp32 app
west flash
```

Als je een andere usb poort hebt dan /dev/ttyUSB0 voeg deze dan toe met het argument -p toe met het de juiste poort.
