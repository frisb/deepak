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

module.exports = (tuple) ->
  packValue = (val) ->
    switch typeof val
      when 'undefined' then tuple.pack([0])                         # undefined
      when 'string' then tuple.pack([1, new Buffer(val, 'ascii')])  # string
      when 'number' then packNumber(val)                            # number
      when 'boolean' then tuple.pack([4, (if val then 1 else 0)])   # boolean
      else packObject(val)

  packNumber = (val) ->
    if (val % 1 is 0) then tuple.pack([2, val])         # integer
    else tuple.pack([3, new Buffer('' + val, 'ascii')]) # decimal

  packObject = (val) ->
    if (val is null) then tuple.pack([5])                                                           # null
    else if (val instanceof Date) then tuple.pack([6, val.getTime()])                               # dates
    else if (val instanceof Array) then tuple.pack([7, packArray(val)])                             # array
    else if (val instanceof Object) then tuple.pack([8, new Buffer(surreal.serialize(val), 'ascii')])  # object

    else
      throw new Error("the packValue function only accepts string, number, boolean, date, array and object")

  packArray = (val) ->
    arr = []
    arr.push(packValue(child)) for child in val
    tuple.pack(arr)

  packValue
