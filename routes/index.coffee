express = require('express')
router = express.Router()

### GET home page. ###

router.get '/', (req, res, next) ->

  req.session.cnt += 1

  res.locals.test = req.session.cnt
  res.render 'index', title: 'Express'
  return
module.exports = router
