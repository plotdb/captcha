captcha = (opt={}) ->
  @lc = opt.lc or {}
  @opt = opt
  # local configuration used by specific recaptcha module.
  @config = opt.config or {}
  @alt = if !opt.alt => null else if (opt.alt instanceof captcha) => opt.alt else new captcha(opt.alt)
  @_init = opt.init
  @_get = opt.get
  @_failed = opt.is-verify-failed or (-> false)
  @ <<< {inited: false, ready: false, queue: []}
  @

captcha.prototype = Object.create(Object.prototype) <<< do
  init: ->
    if @inited => return Promise.resolve!
    @inited = true
    Promise.resolve!
      .then ~> if @_init => @_init!
      .then ~>
        @ready = true
        @queue.map -> it.res!
        @queue.splice 0
        return it

  set-config: -> @config = it

  # somehow verify user in frontend to get a token
  # we can't still trust this token so we will verify it in backend. 
  get: (opt={}) ->
    Promise.resolve!
      .then ~> if !@inited => @init! else Promise.resolve!
      .then ~>
        if @ready => Promise.resolve! else new Promise (res, rej) ~> @queue.push {res, rej}
      .then ~> if @_get => @_get(opt) else {token: ""}

  # cb: callback function which accept {token} as input and return Promise.
  execute: (opt={},cb) ->
    @get(opt)
      .then (ret) -> cb ret
      .catch (e) ~>
        # if verify failed + alternative approach exists ...
        if @_failed(e) and @alt => return @alt.execute(cb)
        # otherwise, simply return error
        return Promise.reject(e)

if window? => window.captcha = captcha
