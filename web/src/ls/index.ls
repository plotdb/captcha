ldld = new ldLoader className: 'ldld full'
window.run = ->
  ldld.on!
  recaptcha.v2.set-config captcha-config
  recaptcha.v2.get!
    .finally -> ldld.off!
    .then ({token}) -> console.log "token: ", token
    .catch  (e) -> console.log "error: ", e
