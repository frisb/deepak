surreal = require('surreal')

### Modelled on https://github.com/leaflevellabs/node-foundationdblayers/blob/master/lib/utils.js

Copyright (c) 2013 Alex Gadea, All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE
###

packUIntByte = (val, buf) ->
  buf = new Buffer(1) if !buf
  buf.writeUInt8(val, 0)
  buf

packBuffer = (typeCode, buf) ->
  len = 1
  len += buf.length if buf

  packedVal = new Buffer(len)
  packUIntByte(typeCode, packedVal)

  buf.copy(packedVal, 1) if buf

  packedVal

module.exports = (val) ->
  return val if val is '\xff'

  switch typeof val
    when 'undefined' then packBuffer(0)                           # undefined

    when 'string' then packBuffer(1, new Buffer(val, 'ascii'))    # string

    when 'number'
      if (val % 1 is 0)
        packBuffer(2, new Buffer('' + val, 'ascii'))              # integer
      else
        packBuffer(3, new Buffer('' + val, 'ascii'))              # decimal

    when 'boolean'
      packBuffer(4, packUIntByte(if val then 1 else 0))           # boolean

    else
      if (val is null)
        packBuffer(5)                                             # null

      else if (val instanceof Date)
        packBuffer(6, new Buffer('' + val.getTime(), 'ascii'))    # dates

      else if (val instanceof Array)
        packBuffer(7, @fdb.tuple.pack(@packArray(val)))           # array

      else if (val instanceof Object)
        packBuffer(8, new Buffer(surreal.serialize(val), 'ascii')) # object

      else
        throw new Error("the packValue function only accepts string, number, boolean, date, array and object")
