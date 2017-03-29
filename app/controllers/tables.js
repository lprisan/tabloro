/*global next*/
/**
 * Module dependencies.
 */

"use strict";

var mongoose = require('mongoose');
var Table = mongoose.model('Table');
var Setup = mongoose.model('Setup');
var Piece = mongoose.model('Piece');
var utils = require('../../lib/utils');
var extend = require('util')._extend;

var R = require('../../public/js/ramda.js');


/**
 * Load
 */

exports.load = function (req, res, next, title) {
    Table.load(title, function (err, table) {
        if (err) return next(err);
        if (!table) return next(new Error('not found'));
        req.table = table;
        next();
    });
};


/**
 * LoadID - load by id instead of title
 */

exports.loadID = function (req, res, next, id) {
    Table.loadById(id, function (err, table) {
        if (err) return next(err);
        if (!table) return next(new Error('not found'));
        req.table = table;
        next();
    });
};


/**
 * List
 */

exports.index = function (req, res) {
    var page = (req.param('page') > 0 ? req.param('page') : 1) - 1;
    var perPage = 20;
    var options = {
        perPage: perPage,
        page: page
    };


    if (req.param('userId')) {
        options.criteria = {
            user: req.user
        };
    }


    // res.render('game/index', {layout: false, title: 'game room'});

    Table.list(options, function (err, tables) {
        if (err) return res.render('500');

        R.forEach(function (table) {
            table.players = req.eurecaServer.getPlayerIds(table.title);
        })(tables);

        Table.count(options.criteria).exec(function (err, count) {
            res.render('tables/index', {
                title: req.param('userId') ? req.i18n.__('Your Tables') : req.i18n.__('Public Tables'),
                tables: tables,
                page: page + 1,
                pages: Math.ceil(count / perPage),
            });
        });
    });
};


/**
 * New table
 */

exports.new = function (req, res) {
    var table = new Table({});
    table.setupName = req.query.setupName;
    if(!req.query.capture){ // If not capturing, just return the new table form
      res.render('tables/new', {
          title: req.i18n.__('New Table'),
          table: table,
      });
    }else{ //If capturing, we need to get the pieces in the setup

      //Load the setup, if not empty
      Setup.findOne({title: table.setupName}).exec(function (err, setup) {
          if (err || !setup) {
              console.log(err);
              return res.render('tables/new', {
                  title: req.i18n.__('New Table'),
                  table: table,
                  errors: [req.i18n.__('Setup: ') + setupName + req.i18n.__(' could not be found!')]
              });
          }
          table.setup = setup;
          table.box = setup.box;
          table.tiles = setup.tiles || {};
          //Load the pieces in the setup
          Piece.list({ criteria: {'_id': {$in: setup.pieces }}}, function (err, unsortedPieces) {
              if (err) {
                  console.log(err);
                  return res.render('tables/new', {
                      title: req.i18n.__('New Table'),
                      table: table,
                      errors: [req.i18n.__('Error finding pieces for this this setup')]
                  });
              }
              //Return the new/capture form, along with the data
              return res.render('tables/new', {
                  title: req.i18n.__('New Table'),
                  table: table,
                  setupPieces: unsortedPieces,
                  capture: true
              });
          });


      });
    } //else



};



/**
 * Create a table
 */

exports.create = function (req, res) {
    console.log('create table', req.body);
    var table = new Table(req.body);
    var setupName = req.body.setupName;
    table.setupName = setupName;

    table.user = req.user;
    table.stacks = {};

    Setup.findOne({title: setupName}).exec(function (err, setup) {
        if (err || !setup) {
            console.log(err);
            return res.render('tables/new', {
                title: req.i18n.__('New Table'),
                table: table,
                errors: [req.i18n.__('Setup: ') + setupName + req.i18n.__(' could not be found!')]
            });
        }
        table.setup = setup;
        table.box = setup.box;
        table.tiles = setup.tiles || {};

        console.log('setup', setup, setupName);
        table.save(function (err) {
            if (!err) {
                req.flash('success', req.i18n.__('Successfully created table!'));
                return res.redirect('/tables/' + table.title);
            }
            console.log(err);
            res.render('tables/new', {
                title: req.i18n.__('New Table'),
                table: table,
                errors: utils.errors(err.errors || err)
            });
        });
    });


};



/**
 * Show
 */

exports.show = function (req, res) {
    var table = req.table;
    table.update({
        $addToSet: {
            users: req.user
        }
    }, function (err) {
        if (err) {
            console.log(err);
            req.flash('warning', req.i18n.__('Could not join table! Please register'));
            // return res.redirect('/tables');
        }

        Table.load(table.title, function (err, table) {
            if (err) return next(err);
            if (!table) return next(new Error('not found'));
            req.table = table;
            res.render('tables/show', {
                title: req.i18n.__('Table: ') + table.title,
                table: table,
                players: req.eurecaServer.getPlayers(table.title),
                isOwner: req.user && table.user.id === req.user.id
            });
        });

    });
};

/**
 * Edit a table
 */

exports.edit = function (req, res) {
  res.render('tables/edit', {
    title: req.i18n.__('Edit ') + req.table.title,
    table: req.table
  });
};



/**
 * Update table
 */

exports.update = function (req, res){
  var table = req.table;

  // make sure no one changes the user
  delete req.body.user;
  table = extend(table, req.body);


  table.save(function (err) {
    if (!err) {
      return res.redirect('/tables/' + table.title);
    }
    console.log(req.body);
    console.error(err);
    res.render('tables/edit', {
        title: req.i18n.__('Edit ') + req.table.title,
        table: table,
        errors: utils.errors(err.errors || err)
    });
  });

};


/**
 * Update table's description only
 */

exports.updateDesc = function (req, res){
  var table = req.table;

  // make sure no one changes the user
  //delete req.body.user;
  //table = extend(table, req.body);
  console.log('Updating desc for table '+table._id+' '+table.setup._id+': '+JSON.stringify(req.param('desc')));
  table.description = req.param('desc');

  table.save(function (err) {
    if (err) {
      console.error(err);
      req.flash('warning', req.i18n.__('Could not update version description'));
      return res.redirect('/designs/' + table.setup._id);
    }
    console.log(req.body);
    req.flash('success', req.i18n.__('Version description successfully updated!'));
     return res.redirect('/designs/' + table.setup._id);
  });

};


 /**
  * Play a normal Tabloro table
  */

exports.play = function (req, res) {

     var table = req.table;
     var setup = table.setup;
     setup.order = table.box.order;

     Piece.list({ criteria: {'_id': {$in: setup.pieces }}}, function (err, unsortedPieces) {
         if (err) {
             req.flash('alert', req.i18n.__('Cannot test game stup!'));
             return res.redirect('/boxes/' + box._id + '/setups/' + setup.id);
         }

         var assets = utils.generateAssets(setup, unsortedPieces);
         console.log('assets', assets);

         res.render('game/play', {
             title: req.i18n.__('Play - ') + table.title,
             game: table.setup,
             room: table,
             user: req.user,
             assets: assets,
             mode: 'play'
         });

     });

};

/**
 * Play a 4Ts table: create a new copy of the table and open it
 */

exports.play4Ts = function (req, res) {

    var table = req.table;
    var oldid = table._id;
    table._id = mongoose.Types.ObjectId();
    table.description = undefined;
    table.isNew = true; //<--------------------IMPORTANT
    table.title = table.setup.title+" "+Date.now();
    table.createdAt = Date.now();

    table.save(function (err) {
      if (err) {
        console.error(err);
        req.flash('alert', req.i18n.__('Could not create new version of the design to play virtually!'));
        return res.render('500');
      }
      console.log('created copy of the design version '+oldid+' --> '+table._id);
      return res.redirect('/tables/'+table.title+'/playNomod');

    });
};


/**
 * Play a 4Ts mode Tabloro table - database edits have to be explicit!
 */

exports.playNomod = function (req, res) {

    var table = req.table;
    var setup = table.setup;
    setup.order = table.box.order;

    Piece.list({ criteria: {'_id': {$in: setup.pieces }}}, function (err, unsortedPieces) {
        if (err) {
            req.flash('alert', req.i18n.__('Cannot test game stup!'));
            return res.redirect('/boxes/' + box._id + '/setups/' + setup.id);
        }

        var assets = utils.generateAssets(setup, unsortedPieces);
        console.log('assets', assets);

        res.render('game/test', {
            title: req.i18n.__('PlayNomod - ') + table.title,
            game: table.setup,
            room: table,
            user: req.user,
            assets: assets,
            backUrl: '/designs/' + setup.id,
            mode: 'playNomod'
        });

    });

};


/**
 * Delete a table
 */

exports.destroy = function (req, res) {
    var table = req.table;
    table.remove(function (err) {
        if (err) {
            req.flash('alert', req.i18n.__('Could not delete table'));
            return;
        }
        req.flash('info', req.i18n.__('Deleted successfully'));
        res.redirect('/tables');
    });
};
