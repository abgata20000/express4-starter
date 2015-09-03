rootPath = '../'
express = require('express')
router = express.Router()
Mongo = require(rootPath + 'models/db/mongo')

#######################################################################################
#
#######################################################################################
router.get '/', (req, res, next) ->
  req.session.cnt += 1
  res.locals.test = req.session.cnt
  res.render 'index', title: 'Express'
  return

#######################################################################################
#
#######################################################################################
router.get '/test', (req, res, next) ->
  ret = {}
  ret.result = true
  

  res.send ret
  return




#
module.exports = router
