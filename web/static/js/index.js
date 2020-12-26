var ldld;
ldld = new ldLoader({
  className: 'ldld full'
});
window.run = function(){
  ldld.on();
  recaptcha.v2.setConfig(captchaConfig);
  return recaptcha.v2.get()['finally'](function(){
    return ldld.off();
  }).then(function(arg$){
    var token;
    token = arg$.token;
    return console.log("token: ", token);
  })['catch'](function(e){
    return console.log("error: ", e);
  });
};