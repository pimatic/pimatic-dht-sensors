module.exports = (env) ->

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  sensorLib = require 'node-dht-sensor'

  class DHTPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>

      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("DHTSensor", {
        configDef: deviceConfigDef.DHTSensor,
        createCallback: (config, lastState) ->
          device = new DHTSensor(config, lastState)
          return device
      })


  class DHTSensor extends env.devices.TemperatureSensor
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
      @id = @config.id
      @name = @config.name
      @_temperature = lastState?.temperature?.value
      @_humidity = lastState?.humidity?.value
      super()

      @requestValue()
      setInterval( ( => @requestValue() ), @config.interval)

    requestValue: ->
      try
        readout = sensorLib.readSpec(@config.type, @config.pin)
        @_temperature = readout.temperature
        @_humidity = readout.humidity
        @emit "temperature", @_temperature
        @emit "humidity", @_humidity
      catch err
        env.logger.error("Error reading DHT-Sensor: #{err.message}")
        env.logger.debug(err.stack)

    getTemperature: -> Promise.resolve(@_temperature)
    getHumidity: -> Promise.resolve(@_humidity)

  plugin = new DHTPlugin

  return plugin