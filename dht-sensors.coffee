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
        description: "The measured temperature"
        type: "number"
        unit: '°C'
      humidity:
        description: "The actual degree of Humidity"
        type: "number"
        unit: '%'

    constructor: (@config, lastState) ->
      @id = @config.id
      @name = @config.name
      @bcmPin = @mapPin @config.pinType, @config.pin
      @_temperature = lastState?.temperature?.value
      @_humidity = lastState?.humidity?.value
      super()

      @requestValue()
      @requestValueIntervalId = setInterval( ( => @requestValue() ), @config.interval)

    destroy: () ->
      clearInterval @requestValueIntervalId if @requestValueIntervalId?
      super()

    mapPin: (pinType, pin) ->
      gpio = [ -1, -1,  8, -1,  9, -1,  7, 15, -1, 16,
        0,  1,  2, -1,  3,  4, -1,  5, 12, -1,
        13,  6, 14, 10, -1, 11, -1, -1, 21, -1,
        22, 26, 23, -1, 24, 27, 25, 28, -1, 29 ]
      bcm1 = [ -1, -1,  0, -1,  1, -1,  4, 14, -1, 15,
        17, 18, 21, -1, 22, 23, -1, 24, 10, -1,
        9, 25, 11,  8, -1,  7, -1, -1,  5, -1,
        6, 12, 13, -1, 19, 16, 26, 20, -1, 21 ]
      bcm2 = [ -1, -1,  2, -1,  3, -1,  4, 14, -1, 15,
        17, 18, 27, -1, 22, 23, -1, 24, 10, -1,
        9, 25, 11,  8, -1,  7, -1, -1,  5, -1,
        6, 12, 13, -1, 19, 16, 26, 20, -1, 21 ]

      switch pinType
        when "BCM GPIO"
          return pin
        when "WiringPi R1"
          for own index, key of gpio
            return bcm1[index] if key is pin
        when "WiringPi R2"
          for own index, key of gpio
            return bcm2[index] if key is pin
        else
          throw new Error "Invalid pinType #{pinType}"

      throw new Error "Invalid pin number #{pin}"

    requestValue: ->
      try
        readout = sensorLib.read(@config.type, @bcmPin)
        if readout.isValid
          @_temperature = readout.temperature
          @_humidity = readout.humidity
          @emit "temperature", @_temperature
          @emit "humidity", @_humidity
        else
          env.logger.debug("Couldn't read DHT-Sensor")
      catch err
        env.logger.error("Error reading DHT-Sensor: #{err.message}")
        env.logger.debug(err.stack)

    getTemperature: -> Promise.resolve(@_temperature)
    getHumidity: -> Promise.resolve(@_humidity)

  plugin = new DHTPlugin

  return plugin