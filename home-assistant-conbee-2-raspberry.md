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

Before we start, let's discuss the pre-requisites. I like Docker a lot, since it allows me to keep software packaged and well-contained.
I won't pollute my Raspbian installation with old Python versions or outdated libraries because evth. I need is run from within a container. Easy to start, easy to stop, easy to get rid off and keep the host clean.

Therefore, having a Docker installation on your Raspberry Pi is a pre-requisite. You can find more about how to install it [here](https://fwinkler79.github.io/blog/docker-on-raspberry.html).

## Installing Conbee II on Raspberry Pi


## Running deCONZ Docker Image

❗ Conbee II should be connected to USB 2.0 slots only and I highly recommend using a USB extension cable, if you are connecting it to Raspberry Pi. 

> Fun fact: The reason for the extension cable is, that the Raspberry PI WiFi antenna is interfering with the Conbee II Zigbee signal, which runs on a very similar frequency. This can lead to severe signal interference, leading to Zigbee signal loss and suddenly not being able to control your Zigbee devices anymore. It happened to me, when I had connected Conbee II directly to my Raspi and then started Kodi media center on Raspi to watch / stream video on my TV. Since Kodi streamed evth. over WiFi the Raspi WiFi was firing away with the result that I could not reliably control the Zigbee devices via Conbee II anymore. Adding an extension cable fixed it!

## Updating Conbee II Firmware

## Running Home Assistant Docker Image

## Adding OSRAM Smart+ Plugs Home Assistant

## Controlling Your Home with HassApp and Home Assistant Companion App

## References

* [Installing Docker on Raspberry Pi](https://fwinkler79.github.io/blog/docker-on-raspberry.html)
* [Home Assistant](https://www.home-assistant.io/) | [Home Assistant Docker Image](https://hub.docker.com/r/homeassistant/raspberrypi4-homeassistant)
* [Conbee II](https://phoscon.de/en/conbee2) | [deCONZ](https://phoscon.de/en/conbee2/software#deconz) | [deCONZ Docker Image](https://hub.docker.com/r/marthoc/deconz) ([Github](https://github.com/marthoc/docker-deconz)) | [Phoscon App](https://phoscon.de/en/app/doc) | [Supported Devices](https://github.com/dresden-elektronik/deconz-rest-plugin/wiki/Supported-Devices#lights)
* [OSRAM Smart+ Plug]() | [OSRAM Smart+ Plug Reset](https://www.smarthomeassistent.de/osram-smart-plug-steckdose-reset-zuruecksetzen-kopplungsmodus/)
* [Philips Hue](https://www.philips-hue.com/en-us) | [Hue Bridge](https://www.philips-hue.com/en-us/p/hue-bridge/046677458478)
* [Ikea Trådfri](https://www.ikea.com/de/de/product-guides/tradfri-home-smart-beleuchtung-pub61503271)
