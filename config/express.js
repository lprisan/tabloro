
/**
 * Module dependencies.
 */

var express = require('express'),
    i18n = require('i18n-2');
var session = require('express-session');
var compression = require('compression');
var morgan = require('morgan');
var cookieParser = require('cookie-parser');
var cookieSession = require('cookie-session');
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var csrf = require('csurf');
var multer = require('multer');
var swig = require('swig');

var mongoStore = require('connect-mongo')(session);
var flash = require('connect-flash');
var winston = require('winston');
var helpers = require('view-helpers');
var config = require('config');
var pkg = require('../package.json');
var utils = require('../lib/utils');


var env = process.env.NODE_ENV || 'development';


/**
 * Expose
 */

module.exports = function (app, passport, eurecaServer) {

  // Compression middleware (should be placed before express.static)
  app.use(compression({
    threshold: 512
  }));

  // Static files middleware
  app.use(express.static(config.root + '/public'));
  app.use(express.static(config.root + '/build'));

  if (env === 'development') {
    app.use(express.static(config.root + '/src/game'));
  }


  // Use winston on production
  var winston_log;
  if (env !== 'development') {
    winston_log = {
      stream: {
        write: function (message, encoding) {
          winston.info(message);
        }
      }
    };
  } else {
    winston_log = 'dev';
  }

  // Don't winston_log during tests
  // Logging middleware
  if (env !== 'test') app.use(morgan(winston_log));

  // Swig templating engine settings
  if (env === 'development' || env === 'test') {
    swig.setDefaults({
      cache: false
    });
  }

  // set views path, template engine and default layout
  app.engine('html', swig.renderFile);
  app.set('views', config.root + '/app/views');
  app.set('view engine', 'html');

  app.use(function (req, res, next) {
    req.eurecaServer = eurecaServer;
    return next();
  });


  // expose package.json to views
  app.use(function (req, res, next) {
    res.locals.pkg = pkg;
    res.locals.env = env;
    next();
  });

  // bodyParser should be above methodOverride
  app.use(bodyParser.json());
  app.use(bodyParser.urlencoded({ extended: true }));
  app.use(multer());
  app.use(methodOverride(function (req, res) {
    if (req.body && typeof req.body === 'object' && '_method' in req.body) {
      // look in urlencoded POST bodies and delete it
      var method = req.body._method;
      delete req.body._method;
      return method;
    }
  }));

  // CookieParser should be above session
  app.use(cookieParser());
  app.use(cookieSession({ secret: 'secret' }));
  app.use(session({
    resave: true,
    saveUninitialized: true,
    secret: pkg.name,
    store: new mongoStore({
      url: config.db,
      collection : 'sessions'
    })
  }));

  // use passport session
  app.use(passport.initialize());
  app.use(passport.session());


  // connect flash for flash messages - should be declared after sessions
  app.use(flash());

  // should be declared after session and flash
  app.use(helpers(pkg.name));



  // This could be moved to view-helpers :-)
  app.use(function (req, res, next) {
    res.locals.isAdmin = utils.isAdmin(req.user);
    next();
  });

  // adds CSRF support
  if (process.env.NODE_ENV !== 'test') {
    app.use(csrf());

    // This could be moved to view-helpers :-)
    app.use(function (req, res, next) {
      res.locals.csrf_token = req.csrfToken();
      next();
    });
  }


  // Attach the i18n property to the express request object
  // And attach helper methods for use in templates
  i18n.expressBind(app, {
      // setup some locales - other locales default to en silently
      locales: ['it', 'en', 'es'],
      // change the cookie name from 'lang' to 'locale'
      cookieName: 'locale'
  });



  // This is how you'd set a locale from req.cookies.
  // Don't forget to set the cookie either on the client or in your Express app.
  app.use(function(req, res, next) {
      req.i18n.setLocaleFromCookie();
      next();
  });

};
