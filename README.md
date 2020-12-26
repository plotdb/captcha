# captcha

Captcha wrapper for captcha services.


## Usage

include `captcha.js`:

    <script src="dist/captcha.js"></script>


use `captcha` object to create captcha service wrappers like this:

    mycaptcha = new captcha({
      init: function() { Promise.resolve('...'); },
      get: function(opt) { Promise.resolve('...'); }
      isVerifyFailed: function(err) { ... }
      alt: { ... },
      config: { ... }
      lc: { ... }
    });

with following options:

 - `init()`: function for initializing your captcha.
   - will be called only once and always called automatically when get is called.
   - should return Promise.
 - `get(opt)`: function used to getting captcha token for verifying through backend.
   - should return Promise resolving object with `token` field ( `{token: ... }` ).
   - `opt` is defined by user.

   - if captcha verification failed, reject with an error which can be recognize with `isVerifyFailed`.

 - isVerifyFailed(err): optional function to check if a given error object `err` is for verification failure.
   - if `alt` is provided and when `execute` calls callback function but an error for verification failure is returned by the callback function, then `captcha` will try again with another captcha object corresponding to `alt`.
   - check below section for how `execute` works.
 - `alt`: optional. either an object for captcha constructor options, or a captcha object.
    - if set, `alt` will be used when veritification failed with the owner `captcha` object.
 - `config`: default config object for this `captcha` object.
    - this is designed for providing configuration to user defined `get` and `init` functions.
 - `lc`: object storing default value for storing variables defined by `get` and `init` functions.
 
Once constructed, you can get a token by:

    mycaptcha.get().then(function(opt) { opt.token; });

Since `token` usually involves server-side verification, you can use `execute` for alt captcha

    postData = function({ .../* object returned by `get` */... }) {
      /* should return promise */
      Promise.resolve!
        .then -> /* fetch, ajax with the `get` returned object */
    };

    mycaptcha.execute({ ... /* options to `get` */ ... }, postData).then(function() { ... });


## API

 - `get(opt)`: get captcha token. should return Promise resolving `{token}` object.
   - `opt`: user defined option for using in user defined `get` function.
 - `execute(opt, cb)`: execute cb with get returned object. return promise
   - `opt`: options passed to `get`.
   - `cb(ret)`: callback functions with `get` returned object as option ( `ret` ).
     - `cb` should return Promise.
       If verification failed, `cb` can optionally rejects with error object recognizable by `isVerifyFailed`. 
 - `setConfig`: update `config` object.

## ReCaptcha

`captcha` ships with predefined Google Recaptcha wrapper. use it by first including the needed js:

    <script src="dist/captcha.js"></script>
    <script src="dist/recaptcha.js"></script>


then:

    recaptcha.v2.setConfig({sitekey: '....', enabled: ture});
    recaptcha.v2.get();

    recaptcha.v3.setConfig({sitekey: '....', enabled: ture});
    recaptcha.v3.get();


## License

MIT
