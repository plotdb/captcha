// Generated by LiveScript 1.6.0
(function(){
  var captcha;
  captcha = function(opt){
    opt == null && (opt = {});
    this.lc = opt.lc || {};
    this.opt = opt;
    this.config = opt.config || {};
    this.alt = !opt.alt
      ? null
      : new captcha(opt.alt);
    this._init = opt.init;
    this._get = opt.get;
    this.inited = false;
    this.ready = false;
    this.queue = [];
    return this;
  };
  captcha.prototype = import$(Object.create(Object.prototype), {
    init: function(){
      var this$ = this;
      if (this.inited) {
        return Promise.resolve();
      }
      this.inited = true;
      return Promise.resolve().then(function(){
        if (this$._init) {
          return this$._init();
        }
      }).then(function(it){
        this$.ready = true;
        this$.queue.map(function(it){
          return it.res();
        });
        this$.queue.splice(0);
        return it;
      });
    },
    setConfig: function(it){
      return this.config = it;
    },
    get: function(opt){
      var this$ = this;
      opt == null && (opt = {});
      return Promise.resolve().then(function(){
        if (!this$.inited) {
          return this$.init();
        } else {
          return Promise.resolve();
        }
      }).then(function(){
        if (this$.ready) {
          return Promise.resolve();
        } else {
          return new Promise(function(res, rej){
            return this$.queue.push({
              res: res,
              rej: rej
            });
          });
        }
      }).then(function(){
        if (this$._get) {
          return this$._get(opt);
        } else {
          return {
            token: ""
          };
        }
      });
    },
    execute: function(opt, cb){
      var this$ = this;
      opt == null && (opt = {});
      return this.get(opt).then(function(ret){
        return cb(ret);
      })['catch'](function(e){
        if (this$.isCaptchaFailed(e) && this$.alt) {
          return this$.alt.execute(cb);
        }
        return Promise.reject(e);
      });
    }
  });
  if (typeof window != 'undefined' && window !== null) {
    window.captcha = captcha;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);