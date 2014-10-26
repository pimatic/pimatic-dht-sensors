module.exports = {
  title: "pimatic-dhtxx device config schemas"
  DHTxxSensor: {
    title: "DHTxxSensor config options"
    type: "object"
    extensions: ["xLink"]
    properties:
      type:
        description: "the type of the sensor (11 or 22)"
        type: "number"
      gpio:
        description: "The gpio pin"
        type: "number"
      interval:
        interval: "Interval in ms so read the sensor"
        type: "integer"
        default: 10000
  }
}
