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
    Setup.loadById(id, function (err, setup) { // the function already includes non-null delete (do not load deleted ones)
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
        page: page,
        criteria: {
          is4Ts: true,     //Designs are setups with is4Ts=true
          deleted: null,
          _id : { "$ne": mongoose.Types.ObjectId("583f1c5f6d504c9100d6ff8b") } //TODO: This is the 'original' setup for designs. Maybe add other exceptions later (in other languages)
        }
    };

    if (req.param('userId')) {
        options.criteria.user = req.user;
    }

    Setup.list(options, function (err, designs) {
        if (err) return res.render('500');

        Setup.count(options.criteria).exec(function (err, count) {
            res.render('designs/index', {
                title: req.query.pick ? req.i18n.__('Pick design') : req.param('userId') ? req.i18n.__('Your Designs'): req.i18n.__('Designs'),
                subtitle: req.query.pick ? req.i18n.__('Pick a design for your ') + req.query.pick : '',
                designs: designs,
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
          setup.user = req.user;

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


/**
 * Copy design (create base setup by copying the original one, as well as a table with the latest version, and redirect to show page)
 */

exports.copy = function (req, res) {
    //Duplicate the original setup with all the cards and everything, and the provided name and current owner
    if (req.setup && req.setup._id && req.param('designName')) {
      var setup = req.setup;
      var oldid = req.setup._id;

      setup._id = mongoose.Types.ObjectId();
      setup.user = req.user;
      setup.isNew = true; //<--------------------IMPORTANT
      setup.is4Ts = true;
      setup.title = req.param('designName');
      setup.createdAt = Date.now();
      setup.save(function (err) {
          if (!err) {
              req.flash('success', req.i18n.__('Successfully created design starting point!'));

              var criteria = {
                setup: oldid
              }

              //Plus, if there's versions/tables of the design, copy also the latest one, associated with the new design
              Table.list({ criteria , sort: {createdAt:-1} }, function (err, sortedTables) {
                  if (err) {
                      console.log(err);
                      req.flash('alert', err);
                      return res.render('500');
                      //TODO: Fix this redirection and showing of error message!
                  }
                  console.log("listing tables for design to copy: "+criteria.setup+" - "+sortedTables.length);
                  if(sortedTables && sortedTables.length>0){
                    //Copy latest version of the table
                    var table = sortedTables[0];
                    table._id = mongoose.Types.ObjectId();
                    table.user = req.user;
                    table.isNew = true; //<--------------------IMPORTANT
                    table.setup = setup._id;
                    table.title = req.param('designName')+" "+Date.now();
                    table.createdAt = Date.now();
                    table.save(function (err) {
                        if (err){
                          console.log(err);
                          //req.flash('alert', err);
                          //return res.render('500');
                          //TODO: Since the design was created, we silently fail...
                        }
                      } );

                  }//end if sorted tables


                  //req.flash('success', req.i18n.__('Successfully created design starting point!'));
                  res.redirect('/designs/'+setup._id);
              });//end piece list

          }else{
              console.log(err);
              req.flash('alert', err);
              return res.render('500');
              //TODO: Fix this redirection and showing of error message!
          }

      }); //end setup.save

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
  table.user = req.user;
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
    formtable.createdAt = Date.now();
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
 * Show
 */

exports.show = function (req, res) {
    var setup = req.setup;

    var criteria = {
      setup: setup._id,
      deleted: null
    }

    Table.list({ criteria , sort: {createdAt:-1} }, function (err, sortedTables) {
        if (err) {
            console.log(err);
            req.flash('alert', err);
            return res.redirect('/designs');
            //TODO: Fix this redirection and showing of error message!
        }
        req.setup = setup;

        Piece.list({ criteria: {'_id': {$in: req.setup.pieces }}}, function (err, unsortedPieces) {
            if (err) {
                console.log(err);
                req.flash('alert', err);
                return res.redirect('/designs');
                //TODO: Fix this redirection and showing of error message!
            }

            console.log('rendering design with pieces '+unsortedPieces.length+' and versions '+sortedTables.length)
            //Getting the box too IS NOT NEEDED, it comes with the table, we need it to know the board piece
            res.render('designs/show', {
              title: req.i18n.__('Design'),
              setup: setup,
              box: req.box,
              versions: sortedTables,
              setupPieces: unsortedPieces,
              isOwner: setup.user.id === req.user.id
            });//end render

        });//end piece list


    });//end table list

};


/**
 * Delete a design (actually, for now just mark it as deleted, we may want to preserve it for analysis)
 */

 exports.destroy = function (req, res) {
     var setup = req.setup;

     Table.list({setup: setup}, function (err, tables) {
         if (err) {
             req.flash('error', req.i18n.__('Could not delete setup'));
             res.redirect('/designs');
             return;
         }
         console.log(tables.length+' versions of the design ['+Object.prototype.toString.call(tables)+']: '+JSON.stringify(tables));
         if (tables.length > 0) {
           tables.forEach(function(tab) {
             console.log('Deleting table '+tab._id+' from design '+setup._id);
             tab.deleted = Date.now();
             tab.save(function (err) {
                 if (err) {
                     req.flash('alert', req.i18n.__('Could not delete design completely'));
                     res.redirect('/designs');
                 }
                 req.flash('info', req.i18n.__('Deleted design version successfully'));
              });
            });
         }
         setup.deleted = Date.now();
         setup.save(function (err) {
             if (err) {
                 req.flash('alert', req.i18n.__('Could not delete design completely'));
                 res.redirect('/designs');
             }
             req.flash('info', req.i18n.__('Deleted design successfully'));
             res.redirect('/designs');
         });
     });

 };
