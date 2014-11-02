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
    _temperature: null
    _humidity: null

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
      @_temperature = lastState?.temperature?.value
      @_humidity = lastState?.humidity?.value
      super()

      @requestValue()
      setInterval( ( => @requestValue() ), @config.interval)

    requestValue: ->
      sensorLib.initializeAsync(@type, @gpio)
      readout = sensorLib.read()
      @_temperature = readout.temperature
      @_humidity = readout.humidity
      @emit "temperature", @_temperature
      @emit "humidity", @_humidity

    getTemperature: -> Promise.resolve(@_temperature)
    getHumidity: -> Promise.resolve(@_humidity)

  plugin = new DHTxxPlugin

  return plugin