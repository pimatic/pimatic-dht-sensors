module.exports = {
  title: "pimatic-dht-sensors device config schemas"
  DHTSensor: {
    title: "DHTSensor config options"
    type: "object"
    extensions: ["xLink", "xAttributeOptions"]
    properties:
      type:
        description: "The type of the sensor (11 or 22)"
        enum: [11, 22]
      pinType:
        description: "Defines the GPIO pin numbering scheme to be applied"
        enum: ["BCM GPIO", "WiringPi R1", "WiringPi R2"]
        default: "WiringPi R2"
      pin:
        description: "The GPIO pin"
        type: "integer"

      interval:
        interval: "Interval in ms to read the sensor, the minimal reading interval should be 2500"
        type: "integer"
        default: 10000
  }
}
