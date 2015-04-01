module.exports = {
  title: "pimatic-dht-sensors device config schemas"
  DHTSensor: {
    title: "DHTSensor config options"
    type: "object"
    extensions: ["xLink"]
    properties:
      type:
        description: "the type of the sensor (11 or 22)"
        type: "integer"
      gpio:
        description: "The gpio pin"
        type: "integer"
      interval:
        interval: "Interval in ms so read the sensor, the minimal reading interal should be 2500"
        type: "integer"
        default: 10000
  }
}
