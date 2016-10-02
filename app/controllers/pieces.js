/*global next*/
/**
 * Module dependencies.
 */

"use strict";

var mongoose = require('mongoose');
var Piece = mongoose.model('Piece');
var Box = mongoose.model('Box');
var utils = require('../../lib/utils');
var R = require('../../public/js/ramda.js');
var extend = require('util')._extend;




/**
 * Load
 */

exports.load = function (req, res, next, id) {
    Piece.load(id, function (err, piece) {
        if (err) return next(err);
        if (!piece) return next(new Error('piece not found'));
        req.piece = piece;
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

    Piece.list(options, function (err, pieces) {
        if (err) return res.render('500');

        Piece.count(options.criteria).exec(function (err, count) {
            console.log('count', count);
            res.render('pieces/index', {
                title: req.param('userId') ? req.i18n.__('Your Gaming Pieces') : req.i18n.__('Gaming Pieces'),
                pieces: pieces,
                page: page + 1,
                pages: Math.ceil(count / perPage),
            });
        });
    });
};


/**
 * New piece
 */

exports.new = function (req, res) {
    res.render('pieces/new', {
        title: req.i18n.__('New Gaming Piece(s)'),
        piece: new Piece({})
    });
};



/**
 * Create a piece
 */

exports.create = function (req, res) {
    console.log('create piece', req.body);
    var piece = new Piece(req.body);
    piece.user = req.user;

    var images;
    images = req.files.image ? [req.files.image] : undefined;
    images = req.files.resized ? [req.files.resized] : images;

    piece.user = req.user;
    if(piece.jsonAtlas) piece.jsonAtlas = JSON.parse(piece.jsonAtlas);


    piece.uploadAndSave(images, function (err) {
        if (!err) {
            req.flash('success', req.i18n.__('Successfully created piece!'));

            if(req.xhr) {
                return res.json(piece.id);
            }
            return res.redirect('/pieces/' + piece._id);
        }

        console.log(err);
        if(req.xhr) {
            return res.status(500).json(err);
        }
        res.render('pieces/new', {
            title: req.i18n.__('New Gaming Piece(s)'),
            piece: piece,
            errors: utils.errors(err.errors || err)
        });
    });
};


/**
 * Edit a piece
 */

exports.edit = function (req, res) {
  res.render('pieces/edit', {
    title: req.i18n.__('Edit')+' ' + req.piece.title,
    piece: req.piece
  });
};



/**
 * Update piece
 */

exports.update = function (req, res){
  var piece = req.piece;

    var images;
    images = req.files.image ? [req.files.image] : undefined;
    images = req.files.resized ? [req.files.resized] : images;


  // make sure no one changes the user
  delete req.body.user;

  piece = extend(piece, req.body);

  try {
    if(piece.jsonAtlas) piece.jsonAtlas = JSON.parse(piece.jsonAtlas);
  } catch(e) {
    res.render('pieces/edit', {
      title: req.i18n.__('Edit Piece(s)'),
      piece: piece,
      errors: ['Json format wrong']
    });
    return;
  }




  piece.uploadAndSave(images, function (err) {
    if (!err) {
        if(req.xhr) {
            return res.json(piece.id);
        }
        return res.redirect('/pieces/' + piece._id);
    }

    res.render('pieces/edit', {
      title: req.i18n.__('Edit Piece(s)'),
      piece: piece,
      errors: utils.errors(err.errors || err)
    });
  });

};



/**
 * Show
 */

exports.show = function (req, res) {
    var piece = req.piece;

    Piece.load(piece.id, function (err, piece) {
        if (err) return next(err);
        if (!piece) return next(new Error('piece not found'));
        req.piece = piece;
        res.render('pieces/show', {
            title: req.i18n.__('Piece')+': ' + piece.title,
            piece: piece,
            isOwner: piece.user.id === req.user.id
        });
    });
};



/**
 * json
 */

exports.json = function (req, res) {
    var piece = req.piece;

    Piece.load(piece.id, function (err, piece) {
        if (err) return next(err);
        if (!piece) return next(new Error('piece not found'));
        req.piece = piece;
        res.json(piece.jsonAtlas);
    });
};


/**
 * Test a piece
 */

exports.test = function (req, res) {
    var piece = req.piece;



        var assets = utils.generateAssets({counts: 1, pieces: [piece.id]}, [piece]);


        res.render('game/test', {
            title: req.i18n.__('Test Piece')+': ' + piece.title,
            game: piece,
            room: piece,
            roomName: 'Piece test: ' + piece.title,
            user: req.user,
            assets: assets,
            mode: 'test',
            backUrl: '/pieces/' + piece._id
        });

};


/**
 * Delete a piece
 */

exports.destroy = function (req, res) {
    var piece = req.piece;

    Box.find({pieces: { $in: [piece.id] }}, function (err, boxes) {
        if (err) {
            req.flash('error', req.i18n.__('Could not delete piece'));
            res.redirect('/pieces/' + piece.id);
            return;
        }
        if (boxes.length > 0) {
            req.flash('error', req.i18n.__('Could not delete piece, its currently used by ') + boxes.length + req.i18n.__(' boxes! Please delete the boxes >') + R.join(',', R.pluck('title')(boxes)) + req.i18n.__('< first. Or remove the piece from these boxes'));
            res.redirect('/pieces/' + piece.id);
            return;
        }

        piece.remove(function (err) {
            if (err) {
                req.flash('alert', req.i18n.__('Could not delete piece'));
                return;
            }
            req.flash('info', req.i18n.__('Deleted successfully'));
            res.redirect('/pieces');
        });
    });
};
