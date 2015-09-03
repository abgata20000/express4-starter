rootPath = '../../'
express = require('express')
Mongo = require(rootPath + 'models/db/mongo')
myAPI = require('./api_class')
models = require(rootPath + 'models/db/allow_api_models')

#
for modelInfo in models
  #
  router = express.Router()
  myModel = Mongo[modelInfo.model]
  myClass = new myAPI(router, myModel)

  module.exports[modelInfo.name] = myClass.get_router()
