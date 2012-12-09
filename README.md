Script for uploading DHT11 readings to Cosm using Curl/JSON on Raspberry Pi running Arch Linux
----------------------------------------------------------------------------------------------

For instructions, see the following two blog posts:
http://www.electronicsfaq.com/2012/12/getting-vodafone-3g-to-work-on.html
and       
http://www.electronicsfaq.com/2012/12/script-for-uploading-dht11-readings-to.html

Description of each file is given below.

19d2_1175
----------
- USB Mode Switch configuration file for Vodafone K3770-Z 3G USB Modem
- This file needs to be placed in /etc/usb_modeswitch.d on the SD Card of your Raspberry Pi and renamed to "19d2:1175

sakis3.conf
-----------
- Sakis3G automation configuration file to be placed in /etc on the SD Card of your Raspberry Pi

DHT.c
-----
- C program to read temperature and humidity values from DHT11 using bitbanging.
- Uses the bcm2835 library : http://www.open.com.au/mikem/bcm2835/index.html
- Based on sources taken from Adafruit's Repository: https://github.com/adafruit/Adafruit-Raspberry-Pi-Python-Code/tree/master/Adafruit_DHT_Driver

Makefile
--------
- Makefile for DHT.c
- Place DHT.c and Makefile in your root's home directory (/root) on your SD Card and compile the program on your Raspberry Pi
- DHT.out will be created. Execute it for DHT11 connected to pin 4 of Raspberry Pi (with 4.7K pullup) like so: `./DHT.out 11 4`

cosm-curl-DHT11.sh
------------------
- Bash script program which will use DHT.out to take readings from DHT11 connected to Pin 4 and upload them to Cosm.com using curl in JSON format.
- Change the values of API_KEY and FEED_ID for your own feeds
- You may also want to update the various parameters of the JSON structure in the script for your own specific settings: title, website, lat, lon etc..