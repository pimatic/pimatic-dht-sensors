pimatic-dht-sensors
================

Support for the DHT11 and DHT22 temperature and humidity sensor.

### Example config

Add the plugin to the plugin section:

```json
{ 
  "plugin": "dht-sensors"
}
```

Then add a sensor for your device to the devices section:

```json
{
  "id": "my-sensor",
  "name": "dht22 example",
  "class": "DHTSensor",
  "type": 22,
  "gpio": 18,
  "interval": 60000
}
```

Thank you <a href="https://github.com/momenso">David Jose</a> for <a href="https://github.com/momenso/node-dht-sensor">node-dht-sensor</a>