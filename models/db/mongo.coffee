conf = require('config').config
mongoose = require('mongoose')
mongo_user = ''
if conf.mongo.user
  mongo_user = conf.mongo.user + ':' + conf.mongo.password + '@'
mongo_uri = 'mongodb://' + mongo_user + conf.mongo.host + ':' + conf.mongo.port + '/' + conf.mongo.name
mongoose.connect(mongo_uri)
Schema = mongoose.Schema

#######################################################################################
# ユーザーモデル
#######################################################################################
userSchema = new Schema({
  name: String
  ip: String
  webId: String
  email: {type: String, default: null}
  password: String
  is_premium: {type: Boolean, default: false}
  is_admin: {type: Boolean, default: false}
  language: {type: String, default: 'ja'}
  enabled: {type: Boolean, default: true}
  logged_in: {type: Boolean, default: true}
  last_login: {type: Date, default: Date.now }
  last_access: {type: Date, default: Date.now }
  last_location: [Number, Number]
  locations: [[Number, Number]]
  shops: {type: [Schema.Types.ObjectId], ref: 'Shop'}
  created_at: {type: Date, default: Date.now }
  updated_at: {type: Date, default: Date.now }
})
#
User = mongoose.model('User', userSchema)
exports.User = User

#######################################################################################
# ショップモデル
#######################################################################################
shopSchema = new Schema({
  name: String
  email: String
  tel: String
  fax: String
  url: String
  zipcode: String
  address: String
  address1: String
  address2: String
  address3: String
  location: [Number, Number]
  users: {type: [Schema.Types.ObjectId], ref: 'User'}
  enabled: {type: Boolean, default: true}
  created_at: {type: Date, default: Date.now }
  updated_at: {type: Date, default: Date.now }
})
#
Shop = mongoose.model('Shop', shopSchema)
exports.Shop = Shop
