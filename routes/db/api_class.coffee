#######################################################################################
# Restfull API 用のデフォルトクラス
#######################################################################################
class apiClass
  constructor: (router, model) ->
    @router = router
    @model = model

    @router.get '/', @index
    @router.get '/:id', @show
    @router.post '/', @create
    @router.put '/:id', @update
    @router.delete '/:id', @destroy

    return

  get_router: =>
    return @router

  index: (req, res) =>
    # TODO: findByAll 実装する
    @model.find(req.query)
    .limit(100)
    .sort({ created_at: -1 })
    .exec (err, items) ->
      res.send items
      return
    return
  show: (req, res) =>
    # TODO: findById 実装する
    @model.findById req.params.id, (err, item) ->
      res.send item
      return
    return
  create: (req, res) =>
    item = new @model(req.body)
    item.save (err) ->
      # TODO: insert 実装する
      res.send item
      return
    return
  update: (req, res) =>
    # TODO: update 実装する
    req.body.updated_at = Date.now()
    @model.update { _id: req.params.id }, { $set: req.body }, { upsert: false, multi: true }, (err, item) ->
      res.send item
      return
    return
  destroy: (req, res) =>
    # TODO: delete 実装する
    @model.remove {_id: req.params.id}, (err, item) ->
      res.send item
    return

#
module.exports = apiClass
