pimatic-dht-sensors
================

Support for the DHT11 and DHT22 temperature and humidity sensor.

**This plugin requires the [BCM2835](http://www.airspayce.com/mikem/bcm2835/) 
library to be installed on your Raspberry Pi before you can actually use this module.!**

### Plugin Configuration

Add the plugin to the plugin section:

```json
{ 
  "plugin": "dht-sensors"
}
```

### Device Configuration

Add a `DHTSensor` device for your sensor to the devices section. To initialize the sensor, 
you have to specify the sensor type and the GPIO pin where the sensor is connected to. 
It should work for DHT11, DHT22 and AM2302 sensors. The `type` property need to bet set as follows:

| Value | Sensor          |
|-------|:---------------:|
| 11    | DHT11           |
| 22    | DHT22 or AM2302 |

By default, the WiringPi pin numbering scheme is used assuming a Revision 2 
board which is identifiable by the presence of the 2 mounting holes next to the ends to 
GPIO pin header. Alternatively, you can set the `pinType` to "BCM GPIO" for 
BCM pin numbering or "WiringPi R1" for WiringPi pin numbering 
on a Revision 1 board.

```json
{
  "id": "my-sensor",
  "name": "dht22 example",
  "class": "DHTSensor",
  "type": 22,
  "pin": 7,
  "interval": 60000
}
```