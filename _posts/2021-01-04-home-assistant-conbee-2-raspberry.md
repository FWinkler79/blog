---
modify_date: 2021-01-04 00:06:00
title: Automating your Home with Home Assistant, Conbee II and Raspberry Pi
tags: raspberry-pi
cover: /images/homeassistant_cover.jpg
---

![Image](./images/homeassistant.jpg){:.rounded}

In this post, I will show, how to use the [Conbee II](https://phoscon.de/en/conbee2) stick from Dresden Electronics with Home Assistant on a Raspberry Pi to automate your home!

<!--more-->

I recently received a [Conbee II](https://phoscon.de/en/conbee2) stick from Dresden Electronics for Christmas. This little USB stick is quite a powerful tool when it comes to automating your home using the Zigbee protocol. In this post I will show how to use it with Home Assistant to automate your home!

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

With everything up and running, deCONZ should be available on port `80` of your raspberry PI, i.e. by the following URL: `http://<your raspi DNS name or IP>`. If you have any Zigbee devices to attach already, you can add them now. See section [Adding OSRAM Smart+ Plugs Home Assistant](#adding-osram-smart-plugs-home-assistant) for details on how to do that.
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

Running Home Assistant from Docker is just as easy as running deCONZ. All you need is a docker-compose file like this:

```dockerfile
version: "3.7"
services:
  home-assistant:
    image: homeassistant/raspberrypi4-homeassistant:stable 
    container_name: hass
    network_mode: host
    restart: always
    init: true 
    volumes:
      - ./storage:/config
    environment:
      - TZ=Europe/Berlin
```

Then you can start Home Assistant using:

```bash
docker-compose up
```

Finally, confirm a container with name `hass` was created and is running, using:

```bash
docker container ls
```

With everything up and running, Home Assistant should now be available on port `8123` of your raspberry Pi, i.e by the URL `http://<raspi DNS name or IP>:8123`.

## Enabling Home Assistant Integrations

Home Assistant comes with a variety of [integrations](https://www.home-assistant.io/integrations/).

The [deConz integration](https://www.home-assistant.io/integrations/deconz/) is amongst them, and usually is detected automatically by Home Assistant. But there is also one for [mobile companion applications](https://www.home-assistant.io/integrations/mobile_app/) and [iOS](https://www.home-assistant.io/integrations/ios/).

You can add or remove integrations in Home Assistant via _Configurations > Integrations_.

In case the deCONZ integration was not detected, make sure you add it manually. You will need it to connect the deCONZ application to Home Assistant and control devices detected by deCONZ through Home Assistant.

Once added click the _Configure_ button on the deCONZ integration and follow the steps displayed on screen.
## Adding OSRAM Smart+ Plugs Home Assistant

Home Assistant has a lot of integrations to sensors that you probably did not even consider to be ones. For example your iPhone can act as a variety of sensors that Home Assistant can use for automation and defining special actions.

However, it becomes real fun, when you actually add Zigbee hardware to your home.
There are plenty available already, and most of them should work with Conbee II! As a rule of thumb: whenever you find a Zigbee device that is compatible with either IKEA Trådfri or Philips Hue, it should also work on Conbee II.

One rather inexpensive Zigbee device (that can be surprisingly useful despite its simplicity) is the [OSRAM / Ledvance Smart+ Plug](https://www.amazon.de/-/en/LEDVANCE-switchable-Directly-compatible-Compatible/dp/B07VCG5G7H/ref=pd_lpo_60_img_0/261-4298904-8029155?_encoding=UTF8&pd_rd_i=B07SFZ81SK&pd_rd_r=ee82a327-28f9-4824-b942-1358971cdb11&pd_rd_w=GPpl3&pd_rd_wg=jmJg8&pf_rd_p=d5c9797d-0238-4119-b220-af4cc3420918&pf_rd_r=174AMG84CDYW713ZPBYD&refRID=174AMG84CDYW713ZPBYD&th=1). It's a Zigbee-controlled power socket, that you plug into your wall outlet. You then plug a conventional device, e.g. a lamp, light strip or coffee machine into it and you can then switch on and of the device via Home Assistant and deCONZ. This allows you to control your lights from your mobile, allows you to automate your home based on events, and generally opens up a whole new world of smart opportunities for your home and life!

You can find the Smart+ plug on various sites, best prices ranging from 7€ to 11€.

Once you have one, adding it to deCONZ and Home Assistant is very easy:

1. Open your deCONZ app in your browser, e.g. `http://<raspi DNS name or IP>` and login to your _Phoscon GW_ (aka. Conbee II).
2. Click on the "burger menu" icon in the top left.
3. Under _Devices_ select _Lights_ (a plug / binary actuator will be a _light_ in deCONZ for now)
4. Click the _Add new lights_ button. deCONZ will now scan for approx. 3 minutes for new devices.
5. Plug in your Smart+ plug into a power outlet, and **press and hold its power button for approx. 10 seconds until you hear a clicking noise**. The plug is now reset and in pairing mode.
6. deCONZ should now detect the new plug, it might take a few seconds, until it has detected it fully.

That's it. Once it is detected, you can go back to the deCONZ main page and add the plug to a group - although that is not strictly required:

1. Click _Add Group_ and give it a name (e.g. "Living Room" or "Lamp" or "Coffee Machine")
2. Click the _Edit_ button and select _Manage Lights_.
3. From the _Available Lights_ find your plug and press the _+_ button on it to add it to the group.
4. Save the group.
5. Back on the main page, click on your group and tap the _Lights_ button.
6. There you see your plug, and if you click on its icon, you can switch it on and off, this is good for testing if evth. works.

With that done, your plug is ready to be used.

Open Home Assistant from your browser now. After a short while, Home Assistant (via the deCONZ integration) should now detect the newly added plug and you can then add it as a device on your HassApp mobile app, if you like. See the [Controlling Your Home with your Mobile](#controlling-your-home-with-your-mobile) section for details.

You can also reload the deCONZ integration to refresh / re-trigger device detection. To do so:
1. In Home Assistant go to _Configurations_ > _Integrations_
2. On the _deCONZ_ integration find the three dots / elipsis button and click it.
3. Select _Reload_

> Note: if you created a group in deCONZ, Home Assistant will detect **two** devices: one for your actual plug, and one for the group.
> Both can be useful, as with groups you can put several device into a single logical room, or group them by functionality. You can then simply add the group as a device in your mobile HassApp and controll all of the Zigbee devices with a single switch.  
> You could also use Home Assistant _Scenes_ for that kind of grouping, but since Scenes always capture a target state of Zigbee devices you would have to create two scenes in Home Assitant - one for the "on" state and one for the "off" state.

Play around with it a little. You'll get the hang of it... 😉
## Controlling Your Home with your Mobile

There are two noteworhy apps, you might want to install:

1. [Home Assistant](https://www.home-assistant.io/integrations/mobile_app/) (official companion app)
2. [HassApp](https://community.home-assistant.io/t/hassapp-an-alternative-ios-app-to-empower-your-ha/97713) (native iOS app)

It's best to read up on them online. The first one is basically providing you with the same (HTML-based) interface to Home Assistant that you see in your browser. The second one is a fully native iOS app.

Both are useful, and I use the first one to control the Home Assistant application itself and its configurations. The second one is a beautifully written, userfriendly and fully native iOS app that I use to control my home and install on devices of my family members, whom I don't want to mess with the configurations. You can create rooms in it and add devices from Home Assistant to it. Then you can control them easily from your phone by switching lights, etc.

See and decide for yourself!
## Troubleshooting

Home Assistant, Zigbee and Conbee II are not without quirks - although generally things are very stable. Here are some tips if you run into trouble nonetheless.

### Problems Finding or Controlling Devices

> The Raspberry PI WiFi antenna can interfere with the Conbee II Zigbee signal, which runs on a very similar frequency. When plugged directly into the Raspi, your Conbee II stick can suffer from interference resulting in signal loss or unreliable Zigbee transmission. As a result, you suddenly might not be able to control your Zigbee devices anymore!

❗ Make sure Conbee II is connected to a USB 2.0 slot! These are the black ones on your Raspberry Pi (as opposed to the blue ones that aree USB 3.x)
 
❗ If you are suffering from unreliable device control (devices not reacting or only after a second switching attempt) make sure to use a USB extension cable, if you are connecting Conbee II it to the Raspberry Pi. Rather than directly plugging the stick into the Raspi, plug it into an extenion cable or USB hub and the other end of the cable into the Rasperry Pi!
### Docker Container / Startup Problems
In case of problems with the docker containers, deCONZ or Home Assistant startup, you can inspect the startup logs within the containers like this:

```bash
docker logs <container name>    # the latest logs.
docker logs -f <container name> # automatically updating logs.
```
### Mobile App Problems
For problems with the mobile apps make sure your mobile device is in the same WLAN network as your raspberry pi.
Also make sure the URL pointing to Home Assistant is correct. It usually is `http://<your raspi DNS name or IP>:8123`.

Sometimes it also helps to completely reset the mobile apps and start fresh. As a last resort, uninstall the app, re-install it and then set it up again. 

Also note that Home Assistant keeps a list of devices and entities for your mobile app's - make sure to remove those as well, if the problems persist. You can do so via _Configurations_ > _Integrations_, or via _Configurations_ > _Devices_ and _Configurations_ > _Entities_. After that you may need to restart Home Assistant.

## References

* [Installing Docker on Raspberry Pi](https://fwinkler79.github.io/blog/docker-on-raspberry.html)
* [Home Assistant](https://www.home-assistant.io/) 
* [Home Assistant Docker Image](https://hub.docker.com/r/homeassistant/raspberrypi4-homeassistant)
* [Conbee II](https://phoscon.de/en/conbee2)
* [deCONZ](https://phoscon.de/en/conbee2/software#deconz)
* [deCONZ Docker Image](https://hub.docker.com/r/marthoc/deconz) ([Github](https://github.com/marthoc/docker-deconz))
* [Phoscon App](https://phoscon.de/en/app/doc)
* [Supported Devices](https://github.com/dresden-elektronik/deconz-rest-plugin/wiki/Supported-Devices#lights)
* [Raspbee II](https://phoscon.de/en/raspbee2) 
* [OSRAM Smart+ Plug](https://www.amazon.de/-/en/LEDVANCE-switchable-Directly-compatible-Compatible/dp/B07VCG5G7H/ref=pd_lpo_60_img_0/261-4298904-8029155?_encoding=UTF8&pd_rd_i=B07SFZ81SK&pd_rd_r=ee82a327-28f9-4824-b942-1358971cdb11&pd_rd_w=GPpl3&pd_rd_wg=jmJg8&pf_rd_p=d5c9797d-0238-4119-b220-af4cc3420918&pf_rd_r=174AMG84CDYW713ZPBYD&refRID=174AMG84CDYW713ZPBYD&th=1)
* [OSRAM Smart+ Plug Reset](https://www.smarthomeassistent.de/osram-smart-plug-steckdose-reset-zuruecksetzen-kopplungsmodus/)
* [Philips Hue](https://www.philips-hue.com/en-us)
* [Hue Bridge](https://www.philips-hue.com/en-us/p/hue-bridge/046677458478)
* [Ikea Trådfri](https://www.ikea.com/de/de/product-guides/tradfri-home-smart-beleuchtung-pub61503271)
