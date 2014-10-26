pimatic-dhtxx
================

Support for the DHTxx temperature/humidity sensor.

### Example config

Add the plugin to the plugin section:

```json
{ 
  "plugin": "dhtxx"
}
```

Then add a sensor for your device to the devices section:

```json
{
  "id": "my-sensor",
  "name": "dhtxx example",
  "class": "DHTxxSensor",
  "type": 22,
  "gpio": 18,
  "interval": 10000
}
```

Thank you <a href="https://github.com/momenso">David Jose</a> for <a href="https://github.com/momenso/node-dht-sensor">node-dht-sensor</a> and <a href="https://github.com/sweetpi">sweet pi</a> for inspiration and his work on best automatization software <a href="https://github.com/pimatic/pimatic">Pimatic</a>.
