HeaderControl = (req, res, next) ->
  res.setHeader("Pragma", "no-cache")
  res.setHeader("Cache-Control", "no-cache")
  next()
  return
module.exports = HeaderControl
