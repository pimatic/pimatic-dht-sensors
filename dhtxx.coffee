module.exports = (env) ->

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  sensorLib = require 'node-dht-sensor'
  Promise.promisifyAll(sensorLib)


  class DHTxxPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>

      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("DHTxxSensor", {
        configDef: deviceConfigDef.DHTxxSensor,
        createCallback: (config, lastState) ->
          device = new DHTxxSensor(config, lastState)
          return device
      })


  class DHTxxSensor extends env.devices.TemperatureSensor
    temperature: null
    humidity: null

    attributes:
      temperature:
        description: "The messured temperature"
        type: "number"
        unit: '°C'
      humidity:
        description: "The actual degree of Humidity"
        type: "number"
        unit: '%'

    constructor: (@config, lastState) ->
      @id = config.id
      @name = config.name
      @type = config.type
      @gpio = config.gpio
      @temperature = lastState?.temperature?.value
      super()

      @requestValue()
      setInterval( ( => @requestValue() ), @config.interval)

    requestValue: ->
      sensorLib.initialize @type, @gpio
      readout = sensorLib.read()
      temperature = parseInt(readout.temperature.toFixed(1), 10)
      @emit "temperature", temperature
      humidity = parseInt(readout.humidity.toFixed(1), 10)
      @emit "humidity", humidity

#     @valid = (readout.isValid)

    getTemperature: -> Promise.resolve(@temperature)
    getHumidity: -> Promise.resolve(@humidity)

  plugin = new DHTxxPlugin

  return plugin
