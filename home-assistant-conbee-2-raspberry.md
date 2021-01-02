# Automating your Home with Home Assistant, Conbee II and Raspberry Pi

I recently received a [Conbee II](https://phoscon.de/en/conbee2) stick from Dresden Electronics for Christmas. This little USB stick is quite a powerful tool when it comes to automating your home using the Zigbee protocol.

Zigbee is most notably used by the [Philips Hue](https://www.philips-hue.com/en-us) system but found its way into a variety of other products e.g. [Ikea Trådfri](https://www.ikea.com/de/de/product-guides/tradfri-home-smart-beleuchtung-pub61503271), Xiaomi devices or the inexpensive OSRAM / Ledvance Smart+ devices.

Zigbee is a wireless protocol where devices form a mesh to cover a wide range within houses and thus let the Zigbee signals even travel around obstacles. Devices with a constant power connection (those not running on batteries) act as repeaters that actively route on signals within the mesh to the next hop. Since Zigbee was designed for low power consumption in mind, Zigbee end-devices can even be battery-powered and last for years on a single battery. Those end devices do not act as router / repeaters however.

Although Zigbee devices form a mesh, there is usually a single _gateway_ required - the main controller that is used to signal commands and receive any state changes of the devices. That main controller also serves as the central access point for home automation software and usually is accessed by mobile phones or browsers. In Philips terms, such a gateway would be the [Hue Bridge](https://www.philips-hue.com/en-us/p/hue-bridge/046677458478), for Ikea it's the [Trådfri Gateway](https://www.ikea.com/gb/en/p/tradfri-gateway-white-20337807/) and many other vendors bring their own gateway as well.

However, no one wants N gateways for N vendors and since Zigbee is a standard, many of the devices are interoperable. Unfortunately though, most vendor gateways require a Cloud connection - i.e. the gateway connects to a vendor Cloud, and you access that Cloud with your browser, effectively controlling your home through their Cloud. Not only does that mean that traffic controlling your home leaves your private network, but also you are dependent on the availability and security of the vendor's Cloud.

That's where [Conbee II](https://phoscon.de/en/conbee2) comes in. Conbee II serves as a Zigbee gateway, provides a REST API (on stick) and can be plugged into any device with a USB 2.0 slot. Conbee II comes with an app called [deCONZ](https://phoscon.de/en/conbee2/software#deconz), which you can use to add devices, form device groups and control the devices from your browser. 

If you wanted to, you could even write your own programs and HTTP services that you can call from a mobile phone or your browser. Those programs would then simply call the REST API of the Conbee II stick. You could do that, but then again, there is Home Assistant that already does that for you!

[Home Assistant](https://www.home-assistant.io/) is a great piece of software to help automate your home. It's not without its quirks, but it comes with a nice, browser-based UI, tons of integrations with other hard- and software, and even mobile companion apps for iOS and Android that turn your iPhone into both a remote control and sensor. Home Assistant comes with an integration for deCONZ, and thus can be used to automate and control any devices supported by **Conbee II**.

So eventually, what we will do in this blog is the following:
* Plug **Conbee II** into our **Raspberry Pi** (I use the 4B, since it quite powerful, with a 32 GB SD card)
* Install the **deCONZ** app using Docker on Raspberry Pi
* Install **Home Assistant** using Docker on Raspberry Pi
* Install **OSRAM Smart+ Plugs** in our home and add them as devices to **deCONZ** and **Home Assistant**.

## Pre-Requisites

Before we start, let's discuss the pre-requisites.

I like Docker a lot, since it allows me to keep software packaged and well-contained.
I won't pollute my Raspbian installation with old Python versions or outdated libraries because evth. I need is run from within a container. Easy to start, easy to stop, easy to get rid off and keep the host clean.

Therefore, having a Docker installation on your Raspberry Pi is a pre-requisite. You can find more about how to install it [here](https://fwinkler79.github.io/blog/docker-on-raspberry.html).

Other than that, you need a Raspberry Pi - I use the 4B variant, but a 3-series with enough RAM should be fine as well.
You also need the [Conbee II](https://phoscon.de/en/conbee2) stick, although also the [Raspbee II](https://phoscon.de/en/raspbee2) should work, if you prefer to have everything integrated in one box.
## Installing Conbee II on Raspberry Pi

Installing is as easy as pluggin the Conbee II stick into a USB port. However, it's a bit more tricky than that.

❗ Conbee II must be connected to a USB 2.0 slot! These are the black ones on your Raspberry Pi (as opposed to the blue ones that aree USB 3.x)
 
❗ It is highly recommend to use a USB extension cable, if you are connecting Conbee II it to the Raspberry Pi. So rather than directly plugging the stick into the Raspi, plug it into an extenion cable or USB hub and the other end of the cable into the Rasperry Pi.

> **Why the extension cable?** The reason for the extension cable is, that the Raspberry PI WiFi antenna is interfering with the Conbee II Zigbee signal, which runs on a very similar frequency. This can lead to severe signal interference, leading to Zigbee signal loss and suddenly not being able to control your Zigbee devices anymore. This happened to me, when I had connected Conbee II directly to my Raspi and then started Kodi media center on Raspi to watch / stream video on my TV. Since Kodi streamed evth. over WiFi the Raspi WiFi signl interfered with Conbee II which was going crazy. The result was that I could not reliably control the Zigbee devices via Conbee II anymore nor add new devices to my mesh. Adding an extension cable fixed it!
## Running deCONZ Docker Image

To "drive" Conbee II you need the [deCONZ](https://phoscon.de/en/conbee2/software#deconz) app. You could install it directly on the Raspi, but its much easier and cleaner with Docker.

All you need is the following Docker-Compose file:

```dockerfile
version: "3"
services:
  deconz:
    image: marthoc/deconz
    container_name: deconz
    network_mode: host
    restart: always
    volumes:
      - ./storage:/root/.local/share/dresden-elektronik/deCONZ
    devices:
      - /dev/ttyACM0
    environment:
      - DECONZ_WEB_PORT=80
      - DECONZ_WS_PORT=443
      - DEBUG_INFO=1
      - DEBUG_APS=0
      - DEBUG_ZCL=0
      - DEBUG_ZDP=0
      - DEBUG_OTAU=0
```

This pulls the community Docker image of deCONZ that is referenced in the official deCONZ documentation as the one to use when using Docker. You can find the [deCONZ Docker Image](https://hub.docker.com/r/marthoc/deconz) on Docker Hub (and on [Github](https://github.com/marthoc/docker-deconz) for more information about the image).

The compose file above also maps a local `storage` folder into the container, resulting in the configurations written by deCONZ to be available from your Raspi - if you are curious or want to back them up.

It also maps the `/dev/ttyACM0` device into the container - that's the USB device name used by Conbee II. Essentially that provides deCONZ in the docker container access to your Conbee II stick.

For the rest of the environment configurations see the [image documentation on Github](https://github.com/marthoc/docker-deconz) for more information about the image).

To start deCONZ using Docker on your Raspberry Pi, execute:

```bash
docker-compose up
```

Finally confirm thet deCONZ is running using the following command and confirming that the container named `deconz` is running:

```bash
docker container ls
```
## Updating Conbee II Firmware

Before we start Home Assistant, we should first make sure that Conbee II has the latest firmware installed. Luckily we can check that and even install the latest firmware using the same Docker image we started in the section before.

To do so, we first need to stop the `deconz` container again. But first we need to get the filename of the latest firmware that can be installed. So we peek into the started `deconz` Docker container using:

```bash
docker logs deconz
```

There we find there a log output similar to this one:

```bash
GW update firmware found: /usr/share/deCONZ/firmware/deCONZ_Rpi_0x261e0500.bin.GCF
GW firmware version: 0x261c0500
GW firmware version shall be updated to: 0x261e0500
```

Copy and save the firmware file name, i.e. `deCONZ_Rpi_0x261e0500.bin.GCF` in the example above.

Now we shut down the container again, with `docker-compose` that's as easy as executing:

```bash
docker-compose down
```

Now proceed as follows:

1. Execute the following command:
   ```bash
   docker run -it --rm --entrypoint "/firmware-update.sh" --privileged --cap-add=ALL -v /dev:/dev -v /lib/modules:/lib/modules -v /sys:/sys marthoc/deconz
   ```
1. Follow the prompts and first enter the path (e.g. `/dev/ttyACM0`) that corresponds to your Conbee device in the listing.
1. Then paste the full file name that corresponds to the firmware file name that you copied from the deCONZ container logs before
1. If the device/path and file name look OK, type `Y` to start flashing!

Once that is done, you can start the container again using:

```bash
docker-compose up
```

Congratulations, your Conbee II is now updated to the latest firmware. More info on this process can be found on the [deCONZ Docker image github repository](https://github.com/marthoc/docker-deconz#updating-conbeeraspbee-firmware).
## Running Home Assistant Docker Image

## Adding OSRAM Smart+ Plugs Home Assistant

## Controlling Your Home with HassApp and Home Assistant Companion App

## References

* [Installing Docker on Raspberry Pi](https://fwinkler79.github.io/blog/docker-on-raspberry.html)
* [Home Assistant](https://www.home-assistant.io/) | [Home Assistant Docker Image](https://hub.docker.com/r/homeassistant/raspberrypi4-homeassistant)
* [Conbee II](https://phoscon.de/en/conbee2) | [deCONZ](https://phoscon.de/en/conbee2/software#deconz) | [deCONZ Docker Image](https://hub.docker.com/r/marthoc/deconz) ([Github](https://github.com/marthoc/docker-deconz)) | [Phoscon App](https://phoscon.de/en/app/doc) | [Supported Devices](https://github.com/dresden-elektronik/deconz-rest-plugin/wiki/Supported-Devices#lights)
* [Raspbee II](https://phoscon.de/en/raspbee2) 
* [OSRAM Smart+ Plug]() | [OSRAM Smart+ Plug Reset](https://www.smarthomeassistent.de/osram-smart-plug-steckdose-reset-zuruecksetzen-kopplungsmodus/)
* [Philips Hue](https://www.philips-hue.com/en-us) | [Hue Bridge](https://www.philips-hue.com/en-us/p/hue-bridge/046677458478)
* [Ikea Trådfri](https://www.ikea.com/de/de/product-guides/tradfri-home-smart-beleuchtung-pub61503271)
