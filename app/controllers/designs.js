/*global next*/
/**
 * Module dependencies.
 */

"use strict";

var mongoose = require('mongoose');
var Setup = mongoose.model('Setup');
var Piece = mongoose.model('Piece');
var Table = mongoose.model('Table');
var Box = mongoose.model('Box');
var utils = require('../../lib/utils');
var R = require('../../public/js/ramda.js');

var STACK_DEFAULTS = function () {
    return {
    };
};

var TILE_DEFAULTS = function () {
    return {
    };
};


/**
 * Load design
 */

exports.load = function (req, res, next, id) {
    Setup.loadById(id, function (err, setup) {
        if (err) return next(err);
        if (!setup) return next(new Error('not found'));
        req.setup = setup;
        next();
    });
};

/**
 * List designs
 */

exports.index = function (req, res) {
    var page = (req.param('page') > 0 ? req.param('page') : 1) - 1;
    var perPage = 30;
    var options = {
        perPage: perPage,
        page: page
    };

    if (req.param('userId')) {
        options.criteria = {
            user: req.user
        };
    }
    //Designs are setups with is4Ts=true
    options.criteria.is4Ts = true;

    Setup.list(options, function (err, setups) {
        if (err) return res.render('500');

        Setup.count(options.criteria).exec(function (err, count) {
            res.render('designs/index', {
                title: req.query.pick ? req.i18n.__('Pick design') : req.param('userId') ? req.i18n.__('Your Designs'): req.i18n.__('Designs'),
                subtitle: req.query.pick ? req.i18n.__('Pick a design for your ') + req.query.pick : '',
                setups: setups,
                page: page + 1,
                pages: Math.ceil(count / perPage),
                pick: req.query.pick
            });
        });
    });
};


/**
 * New design (create base setup by copying the original one, and redirect to capture page)
 */

exports.new = function (req, res) {
    //Duplicate the original setup with all the cards and everything, and the provided name
    if (req.param('setupName') && req.param('designName')) {
      Setup.load(req.param('setupName'), function (err, setup) {
          if (err) return next(err);
          if (!setup) return next(new Error('not found'));

          setup._id = mongoose.Types.ObjectId();
          setup.isNew = true; //<--------------------IMPORTANT
          setup.is4Ts = true;
          setup.title = req.param('designName');
          setup.save(function (err) {
              if (!err) {
                  req.flash('success', req.i18n.__('Successfully created design starting point!'));
                  res.redirect('/designs/'+setup._id+'/capture');
              }else{
                  console.log(err);
                  req.flash('alert', err);
                  return res.redirect('/');
                  //TODO: Fix this redirection and showing of error message!
              }

          }); //end setup.save
      });//end setup.load
    }//end if
};//end exports.new


exports.capture = function (req, res) {
  console.log('entering capture req '+req.body);
  // var capture=false;
  // if(req.param('capture')){
  //     capture = (req.param('capture') === 'true');
  // }
  var capture=true; //By default, this is always true now
  var table = new Table({});
  table.setup = req.setup;
  table.box = req.setup.box;
  table.tiles = req.setup.tiles || {};
  //Load the pieces in the setup
  Piece.list({ criteria: {'_id': {$in: req.setup.pieces }}}, function (err, unsortedPieces) {
      if (err) {
          console.log(err);
          req.flash('alert', err);
          return res.redirect('/');
          //TODO: Fix this redirection and showing of error message!
      }
      //Getting the box too IS NOT NEEDED, it comes with the table, we need it to know the board piece
      res.render('designs/new', {
          title: req.i18n.__('New Design') + ': ' + req.setup.title,
          setup: req.setup,
          capture: capture,
          setupPieces: unsortedPieces,
          table: table
      });//end render
  });//end piece list




} // end exports.capture

/**
 * Create a table, or as we call it, a "designVersion"
 */

exports.createVersion = function (req, res) {
    console.log('create design version for setup '+req.setup._id);
    var formtable = JSON.parse(req.body.table);
    formtable._id = mongoose.Types.ObjectId();
    formtable.user = req.user;
    formtable.stacks = {};
    formtable.tags = ""; //For now, we do not use tags of the tables/designversions
    console.log('DELETEME parsed table from form, and added new fields: '+ formtable._id);
    var table = new Table(formtable);

    //Setup findOne not needed anymore, it comes from load already?
    //table.setup = req.body.table.setup;
    //table.box = req.body.table.setup.box;
    table.isNew = true; //<--------------------IMPORTANT

    console.log('DELETEME createVersion before table save: '+JSON.stringify(table));
    table.save(function (err) {
        if (!err) {
            if(req.xhr) {
                return res.json(table.id);
            }
            req.flash('success', req.i18n.__('Successfully created designVersion/table!'));
            return res.redirect('/designs/' + table.setup._id + '/capture');
        }
        console.log(err);
        if(req.xhr) {
            return res.status(500).json(err);
        }
        req.flash('alert', req.i18n.__('Failed to create designVersion/table!'));
        return res.redirect('/designs/' + table.setup._id + '/capture');
    });

};





/**
 * Create a design
 */
// TODO!!!
// exports.create = function (req, res) {
//     console.log('create design', req.body);
//     var setup = new Setup(req.body);
//
//     var box = req.box;
//     setup.box = box;
//
//     setup.user = req.user;
//     setup.tiles = new TILE_DEFAULTS();
//     setup.counts = box.counts;
//     setup.pieces = box.pieces;
//     setup.isPrivate = box.isPrivate;
//
//     setup.save(function (err) {
//         if (!err) {
//             req.flash('success', req.i18n.__('Successfully created game setup!'));
//             return res.redirect('/boxes/' + box.id + '/setups/' + setup.title);
//         }
//         console.log(err);
//         res.render('setups/new', {
//             title: req.i18n.__('New Game Setup'),
//             setup: setup,
//             box: req.box,
//             errors: utils.errors(err.errors || err)
//         });
//     });
// };
//
//
//
// /**
//  * Show
//  */
//
// exports.show = function (req, res) {
//     var setup = req.setup;
//
//
//     Setup.load(setup.title, function (err, setup) {
//         if (err) return next(err);
//         if (!setup) return next(new Error('not found'));
//         req.setup = setup;
//         res.render('setups/show', {
//             title: req.i18n.__('Game Setup'),
//             setup: setup,
//             box: req.box,
//             isOwner: setup.user.id === req.user.id
//         });
//     });
//
// };
//
//
//
// /**
//  * Test a setup
//  */
//
// exports.test = function (req, res) {
//     var setup = req.setup;
//     var box = setup.box;
//     setup.order = setup.box.order;
//
//
//     Piece.list({ criteria: {'_id': {$in: setup.pieces }}}, function (err, unsortedPieces) {
//         if (err) {
//             req.flash('alert', req.i18n.__('Cannot test game stup!'));
//             return res.redirect('/boxes/' + box._id + '/setups/' + setup.title);
//         }
//
//         var assets = utils.generateAssets(setup, unsortedPieces);
//         var isOwner = setup.user.id === req.user.id;
//
//
//         res.render('game/test', {
//             title: req.i18n.__('Test Game Setup: ') + setup.title,
//             game: setup.box,
//             room: setup,
//             user: req.user,
//             assets: assets,
//             mode: 'setup',
//             isOwner: isOwner,
//             backUrl: '/boxes/' + setup.box.id + '/setups/' + setup.title
//         });
//
//     });
// };
//
//
// /**
//  * Delete a setup
//  */
//
// exports.destroy = function (req, res) {
//     var setup = req.setup;
//
//     Table.find({setup: setup}, function (err, tables) {
//         if (err) {
//             req.flash('error', req.i18n.__('Could not delete setup'));
//             res.redirect('/boxes/' + setup.box.id + '/setups/' + setup.title);
//
//             return;
//         }
//         if (tables.length > 0) {
//             req.flash('error', req.i18n.__('Could not delete setup, its currently used by ') + tables.length + req.i18n.__(' tables! Please delete the tables >> ') + R.join(',', R.pluck('title')(tables)) + req.i18n.__(' << before deleting this setup.'));
//             res.redirect('/boxes/' + setup.box.id + '/setups/' + setup.title);
//             return;
//         }
//
//         setup.remove(function (err) {
//             if (err) {
//                 req.flash('alert', req.i18n.__('Could not delete game setup'));
//                 return;
//             }
//             req.flash('info', req.i18n.__('Deleted successfully'));
//             res.redirect('/setups');
//         });
//     });
//
// };
