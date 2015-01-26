

module.exports = (tr, begin, end, options) ->
  if (!options)
    options = tr
    tr = null
  else if (typeof(options) is 'function')
    callback = options
    options = tr
    tr = null

  options.fdb = @fdb

  transactionalCount = @fdb.transactional(count)
  transactionalCount(tr || @db, options, callback)
