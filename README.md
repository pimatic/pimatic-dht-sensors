pimatic-dht-sensors
================

Support for the DHT11 and DHT22 temperature and humidity sensor.

**This plugin requries [wiringPi to be installed](http://wiringpi.com/download-and-install/)!**

### Example config

Add the plugin to the plugin section:

```json
{ 
  "plugin": "dht-sensors"
}
```

Then add a sensor for your device to the devices section. 
The Plugin uses [wiringPi pin numbers](http://wiringpi.com/pins/).

```json
{
  "id": "my-sensor",
  "name": "dht22 example",
  "class": "DHTSensor",
  "type": 22,
  "pin": 1,
  "interval": 60000
}
```