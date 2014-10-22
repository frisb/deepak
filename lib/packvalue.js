(function() {
  var packBuffer, packUIntByte, surreal;

  surreal = require('surreal');


  /* Modelled on https://github.com/leaflevellabs/node-foundationdblayers/blob/master/lib/utils.js
  
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
   */

  packUIntByte = function(val, buf) {
    if (!buf) {
      buf = new Buffer(1);
    }
    buf.writeUInt8(val, 0);
    return buf;
  };

  packBuffer = function(typeCode, buf) {
    var len, packedVal;
    len = 1;
    if (buf) {
      len += buf.length;
    }
    packedVal = new Buffer(len);
    packUIntByte(typeCode, packedVal);
    if (buf) {
      buf.copy(packedVal, 1);
    }
    return packedVal;
  };

  module.exports = function(val) {
    if (val === '\xff') {
      return val;
    }
    switch (typeof val) {
      case 'undefined':
        return packBuffer(0);
      case 'string':
        return packBuffer(1, new Buffer(val, 'ascii'));
      case 'number':
        if (val % 1 === 0) {
          return packBuffer(2, new Buffer('' + val, 'ascii'));
        } else {
          return packBuffer(3, new Buffer('' + val, 'ascii'));
        }
        break;
      case 'boolean':
        return packBuffer(4, packUIntByte(val ? 1 : 0));
      default:
        if (val === null) {
          return packBuffer(5);
        } else if (val instanceof Date) {
          return packBuffer(6, new Buffer('' + val.getTime(), 'ascii'));
        } else if (val instanceof Array) {
          return packBuffer(7, this.fdb.tuple.pack(this.packArray(val)));
        } else if (val instanceof Object) {
          return packBuffer(8, new Buffer(surreal.serialize(val), 'ascii'));
        } else {
          throw new Error("the packValue function only accepts string, number, boolean, date, array and object");
        }
    }
  };

}).call(this);
