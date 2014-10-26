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
