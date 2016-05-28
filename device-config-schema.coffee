module.exports = {
  title: "pimatic-dht-sensors device config schemas"
  DHTSensor: {
    title: "DHTSensor config options"
    type: "object"
    extensions: ["xLink"]
    properties:
      type:
        description: "The type of the sensor (11 or 22)"
        type: "integer"
      pin:
        description: "The wiringPi pin"
        type: "integer"
      interval:
        interval: "Interval in ms to read the sensor, the minimal reading interval should be 2500"
        type: "integer"
        default: 10000
  }
}
