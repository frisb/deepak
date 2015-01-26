(function() {
  module.exports = function(tr, begin, end, options) {
    var callback, transactionalCount;
    if (!options) {
      options = tr;
      tr = null;
    } else if (typeof options === 'function') {
      callback = options;
      options = tr;
      tr = null;
    }
    options.fdb = this.fdb;
    transactionalCount = this.fdb.transactional(count);
    return transactionalCount(tr || this.db, options, callback);
  };

}).call(this);
