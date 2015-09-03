express = require('express')
path = require('path')
conf = require('config').config
favicon = require('serve-favicon')
logger = require('morgan')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
app = express()

#######################################################################################
# view engine setup
#######################################################################################
app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'

#######################################################################################
# coofee & stylus
#######################################################################################
coffeeMiddleware = require('coffee-middleware')
stylus = require('stylus')
nib = require('nib')
app.use stylus.middleware(
  src: path.join(__dirname, 'public')
  compile: (str, path) ->
    stylus(str).set('filename', path).set('compress', true).use nib()
)
app.use coffeeMiddleware(
  src: path.join(__dirname, 'public')
  compress: true)

# uncomment after placing your favicon in /public
#app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)

#######################################################################################
# セッションをmongoで管理
#######################################################################################
app.use cookieParser()
session = require('express-session')
store = null
if conf.session.type == 'mongo'
  MongoStore = require('connect-mongo')(session)
  mongo_user = ''
  if conf.session.mongo.user
    mongo_user = conf.session.mongo.user + ':' + conf.session.mongo.password + '@'
  mongo_uri = 'mongodb://' + mongo_user + conf.session.mongo.host + ':' + conf.session.mongo.port + '/' + conf.session.mongo.dbname
  store = new MongoStore
    url: mongo_uri
else if conf.session.type == 'redis'
  RedisStore = require('connect-redis')(session)
  store=  new RedisStore
    host: conf.session.redis.host
    port: conf.session.redis.port
    prefix: conf.session.redis.prefix
    ttl: conf.session.redis.ttl
    disableTTL: conf.session.redis.disable_ttl

#######################################################################################
# セッションの設定
#######################################################################################
app.use session
  secret: conf.session.secret
  resave: false
  saveUninitialized: true
  store: store
  cookie:
    path: '/'
    httpOnly: false
    # maxAge: new Date(Date.now() + 24 * 60 * 60 * 1000)
  # clear_interval: 60 * 60

#######################################################################################
# i18n(多言語設定)
#######################################################################################
i18n = require("i18n")
i18n.configure
  locales: ['ja', 'en']
  defaultLocale: 'ja'
  directory: __dirname + "/locales"
  objectNotation: true
app.use i18n.init
app.use (req, res, next) ->
  if req.session.locale
    res.locals.locales = [{lang: 'ja', name: '日本語'}, {lang: 'en', name: 'English'}]
    res.locals.locale = req.session.locale
    i18n.setLocale(req, req.session.locale)
  else
    req.session.locale = 'ja'
    res.locals.locales = 'ja'
  next()

#######################################################################################
# フラッシュメッセージとユーザー名を埋め込み
#######################################################################################
app.use (req, res, next) ->
  res.locals.username = req.session.username
  if req.session.flash
    res.locals.flash = req.session.flash
  req.session.flash = null
  next()
#######################################################################################
# ルーティングの設定
#######################################################################################
HeaderControl = require('./models/server/header_control')
routes = require('./routes/index')
app.use express.static(path.join(__dirname, 'public'))

#######################################################################################
# デフォルトルート
#######################################################################################
app.use '/', HeaderControl, routes

#######################################################################################
# Restfull API(MongoDB)
#######################################################################################
allowAPIModels = require('./models/db/allow_api_models')
dbAPI = require('./routes/db/api')
for modelInfo in allowAPIModels
  app.use '/db/' + modelInfo.name, HeaderControl, dbAPI[modelInfo.name]

#######################################################################################
# catch 404 and forward to error handler
#######################################################################################
app.use (req, res, next) ->
  err = new Error('Not Found')
  err.status = 404
  next err
  return
#######################################################################################
# error handlers
# development error handler
# will print stacktrace
#######################################################################################
if app.get('env') == 'development'
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render 'error',
      message: err.message
      error: err
    return
#######################################################################################
# production error handler
# no stacktraces leaked to user
#######################################################################################
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render 'error',
    message: err.message
    error: {}
  return
module.exports = app
