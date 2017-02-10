/*global next*/
/**
 * Module dependencies.
 */

"use strict";

var mongoose = require('mongoose');
var Setup = mongoose.model('Setup');
var Piece = mongoose.model('Piece');
var Table = mongoose.model('Table');
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
 * Load
 */

exports.load = function (req, res, next, title) {
    Setup.load(title, function (err, setup) {
        if (err) return next(err);
        if (!setup) return next(new Error('not found'));
        req.setup = setup;
        next();
    });
};

/**
 * List
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

    Setup.list(options, function (err, setups) {
        if (err) return res.render('500');

        Setup.count(options.criteria).exec(function (err, count) {
            res.render('setups/index', {
                title: req.query.pick ? req.i18n.__('Pick game setup') : req.param('userId') ? req.i18n.__('Your Setups'): req.i18n.__('Game Setups'),
                subtitle: req.query.pick ? req.i18n.__('Pick a game setup for your ') + req.query.pick : '',
                setups: setups,
                page: page + 1,
                pages: Math.ceil(count / perPage),
                pick: req.query.pick
            });
        });
    });
};


/**
 * New setup
 */

exports.new = function (req, res) {
    res.render('setups/new', {
        title: req.i18n.__('New Game Setup'),
        setup: new Setup({}),
        box: req.box
    });
};



/**
 * Create a setup
 */

exports.create = function (req, res) {
    console.log('create setup', req.body);
    var setup = new Setup(req.body);

    var box = req.box;
    setup.box = box;

    setup.user = req.user;
    setup.tiles = new TILE_DEFAULTS();
    setup.counts = box.counts;
    setup.pieces = box.pieces;
    setup.isPrivate = box.isPrivate;

    setup.save(function (err) {
        if (!err) {
            req.flash('success', req.i18n.__('Successfully created game setup!'));
            return res.redirect('/boxes/' + box.id + '/setups/' + setup.title);
        }
        console.log(err);
        res.render('setups/new', {
            title: req.i18n.__('New Game Setup'),
            setup: setup,
            box: req.box,
            errors: utils.errors(err.errors || err)
        });
    });
};



/**
 * Show
 */

exports.show = function (req, res) {
    var setup = req.setup;


    Setup.load(setup.title, function (err, setup) {
        if (err) return next(err);
        if (!setup) return next(new Error('not found'));
        req.setup = setup;
        res.render('setups/show', {
            title: req.i18n.__('Game Setup'),
            setup: setup,
            box: req.box,
            isOwner: setup.user.id === req.user.id
        });
    });

};



/**
 * Test a setup
 */

exports.test = function (req, res) {
    var setup = req.setup;
    var box = setup.box;
    setup.order = setup.box.order;


    Piece.list({ criteria: {'_id': {$in: setup.pieces }}}, function (err, unsortedPieces) {
        if (err) {
            req.flash('alert', req.i18n.__('Cannot test game stup!'));
            return res.redirect('/boxes/' + box._id + '/setups/' + setup.title);
        }

        var assets = utils.generateAssets(setup, unsortedPieces);
        var isOwner = setup.user.id === req.user.id;


        res.render('game/test', {
            title: req.i18n.__('Test Game Setup: ') + setup.title,
            game: setup.box,
            room: setup,
            user: req.user,
            assets: assets,
            mode: 'setup',
            isOwner: isOwner,
            backUrl: '/boxes/' + setup.box.id + '/setups/' + setup.title
        });

    });
};


/**
 * Delete a setup
 */

 exports.destroy = function (req, res) {
     var setup = req.setup;

     Table.find({setup: setup}, function (err, tables) {
         if (err) {
             req.flash('error', req.i18n.__('Could not delete setup'));
             res.redirect('/boxes/' + setup.box.id + '/setups/' + setup.title);

             return;
         }
         if (tables.length > 0) {
             req.flash('error', req.i18n.__('Could not delete setup, its currently used by ') + tables.length + req.i18n.__(' tables! Please delete the tables >> ') + R.join(',', R.pluck('title')(tables)) + req.i18n.__(' << before deleting this setup.'));
             res.redirect('/boxes/' + setup.box.id + '/setups/' + setup.title);
             return;
         }

         setup.remove(function (err) {
             if (err) {
                 req.flash('alert', req.i18n.__('Could not delete game setup'));
                 return;
             }
             req.flash('info', req.i18n.__('Deleted successfully'));
             res.redirect('/setups');
         });
     });

 };
