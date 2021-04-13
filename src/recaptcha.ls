recaptcha = {}
recaptcha.v3 = new captcha do
  init: ->
    (res, rej) <~ new Promise _
    tag = document.createElement(\script)
    tag.onload = ~> grecaptcha.ready ~> res!
    tag.onerror = -> rej new Error! <<< {id: 1022, name: \lderror}
    attr = do
      type: "text/javascript", async: '', defer: ''
      src: "https://www.google.com/recaptcha/api.js?render=#{@config.sitekey}"
    for k,v of attr => tag.setAttribute k, v
    document.body.appendChild tag
  get: (opt = {}) ->
    if !@config.sitekey or (@config.enabled? and !@config.enabled) => return Promise.resolve!
    (res, rej) <~ new Promise _
    grecaptcha.execute @config.sitekey, opt{action}
      .then (token) -> {token}

recaptcha.v2 = new captcha do
  init: ->
    (res, rej) <~ new Promise _
    tag = document.createElement(\script)
    attr = do
      type: "text/javascript", async: '', defer: ''
      src: "https://www.google.com/recaptcha/api.js?onload=_grecaptcha_callback"
    for k,v of attr => tag.setAttribute k, v
    window._grecaptcha_callback = -> res!
    document.body.appendChild tag
  get: ->
    if !@config.sitekey or (@config.enabled? and !@config.enabled) => return Promise.resolve!
    (res, rej) <~ new Promise _
    div = document.createElement \div
    document.body.appendChild div
    config = do
      sitekey: @config.sitekey
      size: "invisible"
      badge: "none"
      callback: (token) -> res {token}
      "error-callback": -> rej new Error(it)
      "expired-callback": -> rej new Error! <<< {name: 'lderror', id: 1013}
    id = grecaptcha.render div, config, true
    grecaptcha.execute id .then ->

if window? => window.recaptcha = recaptcha
