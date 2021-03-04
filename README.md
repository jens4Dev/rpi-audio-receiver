# Raspberry Pi Audio Receiver

A simple, light weight audio receiver with Bluetooth (A2DP), AirPlay, Spotify Connect and UPnP.

Fork of [nicokaiser/rpi-audio-receiver](https://github.com/nicokaiser/rpi-audio-receiver):

* added script to install upmpdcli & mpd for UPnP-render (I had issues using gmrender with my Music App)
* added enabling standard sound (onboard e.g. HDMI, headphone-jack) or USB-PnP-devices to enable-hifiberry-script

Future of this fork:

* Created PR to get enable standard sound devices into main (nicokaiser/rpi-audio-receiver#80).
* Looking for a way to get the "either - or" of both DLNA / UPnP-implementation better checked in the script (assure that users
do not install both). Until then I try to keep this fork up to other changes in upstream.
## Features

Devices like phones, tablets and computers can play audio via this receiver.

## Requirements

- Raspberry Pi with Bluetooth support (tested with Raspberry Pi 3, 4 and Zero W) or USB dongle (highly recommended!)
- Raspberry Pi OS Buster Lite (tested with August 2020 version)
- Internal audio, HDMI, USB or I2S Audio adapter (tested with [Adafruit USB Audio Adapter](https://www.adafruit.com/product/1475),  [pHAT DAC](https://shop.pimoroni.de/products/phat-dac), and [HifiBerry DAC+](https://www.hifiberry.com/products/dacplus/))

## Installation

The installation script asks whether to install each component. You can start with a freshly installed raspbian, the only thing to do is changing the user's password.. It will also update the raspbian system and change the hostname from the default.

    wget -q https://github.com/jens4Dev/rpi-audio-receiver/archive/upmpdcli.zip
    unzip upmpdcli.zip
    rm rpi-audio-receiver-upmpdcli.zip

    cd rpi-audio-receiver-upmpdcli
    ./install.sh

### Basic setup

Lets you choose the hostname and the visible device name ("pretty hostname") which is displayed as Bluetooth name, in AirPlay clients and in Spotify.

### Bluetooth

Sets up Bluetooth, adds a simple agent that accepts every connection, and enables audio playback through [BlueALSA](https://github.com/Arkq/bluez-alsa). A udev script is installed that disables discoverability while connected.

### AirPlay

Installs [Shairport Sync](https://github.com/mikebrady/shairport-sync) AirPlay Audio Receiver.

This script comes with a backported version of shairport-sync from Raspberry Pi OS Bullseye (see [SimpleBackportCreation](https://wiki.debian.org/SimpleBackportCreation) for details) and can be replaced with the original (but older) one in Raspberry Pi OS Buster or a sef-compiled one (not part of this project).

### Spotify Connect

Installs [Raspotify](https://github.com/dtcooper/raspotify), an open source Spotify client for Raspberry Pi).

### UPnP

Installs [gmrender-resurrect](http://github.com/hzeller/gmrender-resurrect) UPnP Renderer.

### UPnP (upmpdcli)

Installs [upmpdcli](https://www.lesbonscomptes.com/upmpdcli/index.html) UPnP Renderer which is a UPnP Media Renderer front-end for MPD, the Music Player Daemon.
Please install only one of UPnP-renderer at the same time - I'd expect some trouble otherwise...

### Snapcast

Installs [snapclient](https://github.com/badaix/snapcast), the client component of the Snapcast Synchronous multi-room audio player.

### Enable sound

The script helps you to enable and configure the sound devices. It will list the cards known to ALSA. You were asked whether you want to simply
set one of the cards (like HDMI-output, headset-jack or e.g. an UPnP-USB-sounddevice) as the default audio device or you can enable a HifiBerry-board.

### Read-only mode

To avoid SD card corruption when powering off, you can boot Raspberry Pi OS in read-only mode. This is described by Adafruit in [this tutorial](https://learn.adafruit.com/read-only-raspberry-pi/) and cannot be undone.

## Limitations

- Only one Bluetooth device can be connected at a time, otherwise interruptions may occur.
- The device is always open, new clients can connect at any time without authentication.
- To permanently save paired devices when using read-only mode, the Raspberry has to be switched to read-write mode (`mount -o remount,rw /`) until all devices have been paired once.
- You might want to use a Bluetooth USB dongle or have the script disable Wi-Fi while connected (see `bluetooth-udev`), as the BCM43438 (Raspberry Pi 3, Zero W) has severe problems with both switched on, see [raspberrypi/linux/#1402](https://github.com/raspberrypi/linux/issues/1402).
- The Pi Zero may not be powerful enough to play 192 kHz audio, you may want to change the values in `/etc/asound.conf` accordingly.

## Wiki

There are some further examples, tweaks and how-tos in the [GitHub Wiki](https://github.com/nicokaiser/rpi-audio-receiver/wiki).

## Disclaimer

These scripts are tested and work on a current (as of September 2020) Raspberry Pi OS setup on Raspberry Pi. Depending on your setup (board, configuration, sound module, Bluetooth adapter) and your preferences, you might need to adjust the scripts. They are held as simple as possible and can be used as a starting point for additional adjustments.

## Upgrading

This project does not really support upgrading to newer versions of this script. It is meant to be adjusted to your needs and run on a clean Raspberry Pi OS install. When something goes wrong, the easiest way is to just wipe the SD card and start over. Since apart from Bluetooth pairing information all parts are stateless, this should be ok.

Updating the system using `apt-get upgrade` should work however.

## Contributing

Package and configuration choices are quite opinionated but as close to the Debian defaults as possible. Customizations can be made by modifying the scripts, but the installer should stay as simple as possible, with as few choices as possible. That said, pull requests and suggestions are of course always welcome. However I might decide not to merge changes that add too much complexity.

## References

- [BlueALSA: Bluetooth Audio ALSA Backend](https://github.com/Arkq/bluez-alsa)
- [Shairport Sync: AirPlay Audio Receiver](https://github.com/mikebrady/shairport-sync)
- [Raspotify: Spotify Connect client for the Raspberry Pi that Just Works™](https://github.com/dtcooper/raspotify)
- [gmrender-resurrect: Headless UPnP Renderer](http://github.com/hzeller/gmrender-resurrect)
- [Snapcast: Synchronous audio player](https://github.com/badaix/snapcast)
- [pivumeter: ALSA plugin for displaying VU meters on various Raspberry Pi add-ons](https://github.com/pimoroni/pivumeter)
- [Adafruit: Read-Only Raspberry Pi](https://github.com/adafruit/Raspberry-Pi-Installer-Scripts/blob/master/read-only-fs.sh)
- [upmpdcli: An UPnP Audio Media Renderer based on MPD](https://www.lesbonscomptes.com/upmpdcli/index.html)