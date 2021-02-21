---
title: Backing Up Your Raspberry Pi
tags: raspberry-pi
cover: /images/backup_cover.jpg
---

![Image]({{ site.baseurl }}/images/backup.jpg){:.rounded}

My Raspi is my home automation controller and my entertainment system. I have grown used to it, and quite some time has gone into setting everything up as it is now. Now it's time to make a backup! And here is how...

<!--more-->

You probably know the feeling: You have painstakingly set up Kodi on your Raspberry Pi and finally everything is up and running.
But then after some time, a popup shows up asking you to pull an updated version of a codec library or add on.
How comfortable do you feel updating, not knowing if afterwards things will still function as before?

Never touch a running system, or living on the edge?  
Well, there is something in between - backups!

Here we show how to make a backup of your Raspberry Pi SD card on your Mac.

# Finding the SD Card Device

Ok, let's get started. First, you'll need an SD card reader attached to your Mac.  
Before entering the SD card into the reader, run the following command from your Terminal:

```
diskutil list
```

This will give you a list of active disks and their device paths. Copy that list somewhere, or keep it in mind roughly.

Now enter the SD card you have pulled out of your Raspberry Pi and execute the command again.
You should notice one more disk, e.g. like so:

```
/dev/disk0 (internal, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      GUID_partition_scheme                        *1.0 TB     disk0
   1:                        EFI ⁨EFI⁩                     314.6 MB   disk0s1
   2:                 Apple_APFS ⁨Container disk1⁩         1.0 TB     disk0s2

/dev/disk1 (synthesized):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:      APFS Container Scheme -                      +1.0 TB     disk1
                                 Physical Store disk0s2
   1:                APFS Volume ⁨Macintosh HD - Data⁩     194.6 GB   disk1s1
   2:                APFS Volume ⁨Macintosh HD⁩            15.1 GB    disk1s2
   3:              APFS Snapshot ⁨com.apple.os.update-...⁩ 15.1 GB    disk1s2s1
   4:                APFS Volume ⁨Preboot⁩                 368.6 MB   disk1s3
   5:                APFS Volume ⁨Recovery⁩                613.7 MB   disk1s4
   6:                APFS Volume ⁨VM⁩                      11.8 GB    disk1s5

/dev/disk2 (external, physical):
   #:                       TYPE NAME                    SIZE       IDENTIFIER
   0:     FDisk_partition_scheme                        *127.9 GB   disk2
   1:             Windows_FAT_32 ⁨boot⁩                    268.4 MB   disk2s1
   2:                      Linux ⁨⁩                        127.6 GB   disk2s2
```

In my case, the last disk is the one I want to create a backup for. It's a 128 GB SD card and its device path is `/dev/disk2`

## Creating the Backup Image

On your Mac, create a folder, where you want to store the backup image you are about to create.
Make sure you have enough disk space, depending on your SD card's size.

Then, on the command line `cd` into the backup folder and execute:

```
sudo dd bs=4096 if=<device path of your SD card> of=PiOS.img
```

For example, in my case this is: 

```
sudo dd bs=4096 if=/dev/disk2 of=PiOS.img
```

This will create a file name `PiOS.img` and blockwise copy all raw data from the SD card into the file.

There you go, that's your backup!

## Restoring the Backup

To restore the backup, we simply to the reverse. All you need is an SD card big enough to host your backup.

Again, find out the device path to your SD card, then execute:

```
sudo dd bs=4096 if=PiOS.img of=<device path to your SD card>
```

For example, in my case this is:

```
sudo dd bs=4096 if=PiOS.img of=/dev/disk2
```

:exclamation: Warning: Make sure the device path to your SD card is correct. If you pick the wrong disk, you might damage your Mac's main partition.

## Compressing Backups

The backups can be quite large and usually compress well. To create a compressed backup right away, you can use:

```
sudo dd bs=4096 if=<device path of your SD card> | gzip > PiOS.img.gz
```

To restore a compressed backup, you can use:

```
gunzip --stdout PiOS.img.gz | sudo dd bs=4096 of=<device path to your SD card>
```

## Conclusion

It is easy to backup your Raspberry Pi SD card, and doing it every now and then will save your settings and time investment and still allow you to stay up to date with the latest and greatest development progress. If things go wrong you can always go back.

## References
* [Raspberry Pi Backups](https://www.raspberrypi.org/documentation/linux/filesystem/backup.md)