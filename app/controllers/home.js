
/**
 * Module dependencies.
 */
"use strict";

var mongoose = require('mongoose');
var Article = mongoose.model('Article');
var Table = mongoose.model('Table');
var Setup = mongoose.model('Setup');
var utils = require('../../lib/utils');
var extend = require('util')._extend;
var R = require('../../public/js/ramda.js');


exports.index = function (req, res){
  // var tableOptions = {
  //   perPage: 7,
  //   criteria: {
  //     isPrivate: false
  //   }
  // };
  var designOptions = {
    perPage: 7,
    criteria: {
      _id : { "$ne": mongoose.Types.ObjectId("583f1c5f6d504c9100d6ff8b") }, //TODO: This is the 'original' setup for designs. Maybe add other exceptions later (in other languages)
      isPrivate: false,
      is4Ts: true
    }
  };

  // Table.list(tableOptions, function (err, tables) {
  //   if (err) return res.render('500');
  //
  //   R.forEach(function (table) {
  //     table.players = req.eurecaServer.getPlayerIds(table.title);
  //   })(tables);
  //
  //   Table.count().exec(function (err, count) {
  //     Article.list({}, function (err, articles) {
  //       if (err) return res.render('500');
  //       Article.count().exec(function (err, count) {
  //         res.render('home/index', {
  //           title: 'tabloro',
  //           articles: articles,
  //           tables: tables
  //         });
  //       });
  //     });
  //   });
  // });
  Setup.list(designOptions, function (err, designs) {
    if (err) return res.render('500');

    Setup.count().exec(function (err, count) {
      Article.list({}, function (err, articles) {
        if (err) return res.render('500');
        Article.count().exec(function (err, count) {
          res.render('home/index', {
            title: '4T4LD',
            articles: articles,
            designs: designs
          });
        });
      });
    });
  });
};
