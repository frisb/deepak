assert = require('assert')
fdb = require('fdb').apiVersion(200)
deepak = require('../lib/index')(fdb)

testType = (name, value) ->
  describe name, ->
    it 'should return ' + name, ->
      packedValue = deepak.pack(value)
      unpackedValue = deepak.unpack(packedValue)
      assert.deepEqual(value, unpackedValue)

describe 'Pack / Unpack', ->
  describe 'Types', ->
    testType('undefined', undefined)
    testType('string', 'string')
    testType('integer', 100)
    testType('decimal', 100.12345)
    testType('boolean', true)
    testType('null', null)
    testType('date', new Date())
    testType('array', [{  }, 'string', 1, [1.23]])
    testType('object', { x: 'y' })
