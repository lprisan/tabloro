/*global Phaser, R, T, log, game, Utils, dynamicInvoke, stacks, console*/
"use strict";

var G = {};

G._groups = {};
G._tiles = {};
G.AreaMap100 = {"capture":[[3.270803270803271,0],[20.105820105820104,14.075286415711947]],"context":[[3.751803751803752,18.821603927986907],[20.105820105820104,31.26022913256956]],"goals":[[3.751803751803752,35.3518821603928],[20.105820105820104,68.08510638297872]],"content":[[3.751803751803752,72.50409165302783],[20.105820105820104,104.9099836333879]],"c1-csw-technique":[[22.02982202982203,4.25531914893617],[40.4040404040404,23.895253682487724]],"c1-aba-css-task":[[22.02982202982203,24.713584288052374],[31.072631072631072,44.189852700490995]],"c1-aba-css-team":[[31.457431457431458,24.713584288052374],[40.4040404040404,44.189852700490995]],"c1-aba-css-tec1":[[22.02982202982203,44.84451718494272],[31.072631072631072,64.48445171849427]],"c1-aba-css-tec2":[[31.457431457431458,44.84451718494272],[40.4040404040404,64.48445171849427]],"c1-abb-css-task":[[22.02982202982203,65.13911620294598],[31.072631072631072,84.61538461538461]],"c1-abb-css-team":[[31.457431457431458,65.13911620294598],[40.4040404040404,84.61538461538461]],"c1-abb-css-tec1":[[22.02982202982203,85.27004909983633],[31.072631072631072,104.74631751227496]],"c1-abb-css-tec2":[[31.457431457431458,85.27004909983633],[40.4040404040404,104.74631751227496]],"c2-csw-technique":[[40.78884078884079,4.25531914893617],[59.06685906685907,23.895253682487724]],"c2-aba-css-task":[[40.78884078884079,24.713584288052374],[49.735449735449734,44.189852700490995]],"c2-aba-css-team":[[50.12025012025012,24.713584288052374],[59.06685906685907,44.189852700490995]],"c2-aba-css-tec1":[[40.78884078884079,44.84451718494272],[49.735449735449734,64.48445171849427]],"c2-aba-css-tec2":[[50.12025012025012,44.84451718494272],[59.06685906685907,64.48445171849427]],"c2-abb-css-task":[[40.78884078884079,65.13911620294598],[49.735449735449734,84.61538461538461]],"c2-abb-css-team":[[50.12025012025012,65.13911620294598],[59.06685906685907,84.61538461538461]],"c2-abb-css-tec1":[[40.78884078884079,85.27004909983633],[49.735449735449734,104.74631751227496]],"c2-abb-css-tec2":[[50.12025012025012,85.27004909983633],[59.06685906685907,104.74631751227496]],"c3-csw-technique":[[59.45165945165945,4.25531914893617],[77.82587782587782,23.895253682487724]],"c3-aba-css-task":[[59.45165945165945,24.713584288052374],[68.3982683982684,44.189852700490995]],"c3-aba-css-team":[[68.78306878306879,24.713584288052374],[77.82587782587782,44.189852700490995]],"c3-aba-css-tec1":[[59.45165945165945,44.84451718494272],[68.3982683982684,64.48445171849427]],"c3-aba-css-tec2":[[68.78306878306879,44.84451718494272],[77.82587782587782,64.48445171849427]],"c3-abb-css-task":[[59.45165945165945,65.13911620294598],[68.3982683982684,84.61538461538461]],"c3-abb-css-team":[[68.78306878306879,65.13911620294598],[77.82587782587782,84.61538461538461]],"c3-abb-css-tec1":[[59.45165945165945,85.27004909983633],[68.3982683982684,104.74631751227496]],"c3-abb-css-tec2":[[68.78306878306879,85.27004909983633],[77.82587782587782,104.74631751227496]],"c4-csw-technique":[[78.21067821067821,4.25531914893617],[96.48869648869649,23.895253682487724]],"c4-aba-css-task":[[78.21067821067821,24.713584288052374],[87.06108706108706,44.189852700490995]],"c4-aba-css-team":[[87.44588744588745,24.713584288052374],[96.48869648869649,44.189852700490995]],"c4-aba-css-tec1":[[78.21067821067821,44.84451718494272],[87.06108706108706,64.48445171849427]],"c4-aba-css-tec2":[[87.44588744588745,44.84451718494272],[96.48869648869649,64.48445171849427]],"c4-abb-css-task":[[78.21067821067821,65.13911620294598],[87.06108706108706,84.61538461538461]],"c4-abb-css-team":[[87.44588744588745,65.13911620294598],[96.48869648869649,84.61538461538461]],"c4-abb-css-tec1":[[78.21067821067821,85.27004909983633],[87.06108706108706,104.74631751227496]],"c4-abb-css-tec2":[[87.44588744588745,85.27004909983633],[96.48869648869649,104.74631751227496]]};
//Board dimensions and how much of it we actually use (between the centers of the corner tags)
G.boardw = 1412;
G.boardh = 875;
G.board_efw = 1299;
G.board_efh = 764;
G.offsetx = 55;
G.offsety = 55;

G.KB_BASE_URL = "/kbproxy/check_from_XML?board=";


G.init = function (game) {
    G.created = true;
    G._masterGroup = game.add.group();
};


G.addTile = function (tile) {
    G._tiles[tile.id] = tile;
};


G.groups = {
    add: function (groupName, index, asset) {
        // console.log('adding group', groupName);
        index = index || 0;
        var group = G._masterGroup.add(game.add.group());
        group.z = index;
        group.name = groupName;
        group.flipable = asset.flipable;
        group.handable = asset.handable;
        group.lockable = asset.lockable;
        group.icon = G.getIcon(asset);

        G._groups[groupName] = group;
        return group;
    },
    get: function (groupName) {
        return G._groups[groupName];
    },
    all: function () {
        return G._groups;
    }
};



G.getIcon = function (asset) {
    if (asset.method === 'spritesheet') {
        if (asset.isDice) {
            return 'fa-random';
        }
        return 'fa-th';
    }
    if (asset.method === 'atlasJSONHash') {
        return 'fa-th-list';
    }
    return 'fa-photo';
};



G.addText = R.curryN(2, function (text, button, fn, fill) {
    fill = fill || '#ccc';
    var txtField = game.add.text(20, 20, text, {
        fontSize: '32px',
        fill: fill
    });
    if (fn) {
        fn(txtField, button);
    }
    button.setText = txtField.setText.bind(txtField);
    button.addChild(txtField);
    return button;
});

G.updatePositions = [];

G.update = function () {
    R.forEach(function (tile) {
        if (tile.follower && tile.follower.input.draggable) {
            if (tile.follower.relativePosition) {
                Utils.alignRelativePosition(tile.follower, tile.target);
                return;
            }
            Utils.alignPosition(tile.follower, tile.target);
        }
        if (tile.startRotatePosition) {
            var delta = Utils.delta(tile.startRotatePosition, Utils.getMousePosition());
            var rotateByDeg = Utils.rad2Deg(tile.rotateBy);
            var rotationInDegree = Math.floor((- delta.x * 2 + delta.y  * 2 ) / rotateByDeg) * rotateByDeg;
            var rotationInRad = Utils.deg2Rad(rotationInDegree);
            tile.rotation = tile.startRotation + rotationInRad;
        }
    })(G.updatePositions);
};

G.addUpdatePosition = function (tile) {
    G.updatePositions.push(tile);
};

G.removeUpdatePosition = function (target) {
    G.updatePositions = R.reject(R.propEq('target', target))(G.updatePositions);
};

G.removeRotationPosition = function (id) {
    G.updatePositions = R.reject(R.propEq('id', id))(G.updatePositions);
};

G.findTile = function (tileId) {
    // tileId = Number(tileId);
    return G._tiles[tileId] || {};
};



G.findTiles = function (tileIds) {
    return R.map(function (tileId) {
        return G.findTile(tileId);
    })(tileIds);
};



G.saveSetup = function saveSetup() {
    console.log('saving Game Setup');
    Network.server.saveSetup();
    UI.chat('Saved setup', gameName);
};

/// TABLORO 4Ts MODs

// REturns the board tile (by looking at which one has the right dimensions)
G.getBoardTile = function getBoardTile() {
    var tile;
    for(var i in G._tiles){
      var current = G._tiles[i];
      if(current.height==G.boardh && current.width==G.boardw){
        tile=current;
        break;
      }
    }
    return tile;
};

//Converts the coordinates of all tiles inside the board to the 0-100 coords system
G.convertXYToBoardCoords = function convertXYToBoardCoords(board) {
  var rawtags = {};
  var srcCorners = [(board.x-(G.board_efw/2)), (board.y-(G.board_efh/2)),
                    (board.x+(G.board_efw/2)), (board.y-(G.board_efh/2)),
                    (board.x+(G.board_efw/2)), (board.y+(G.board_efh/2)),
                    (board.x-(G.board_efw/2)), (board.y+(G.board_efh/2))];
  var dstCorners = [0,0,100,0,100,100,0,100]; //Ideal board (sides 0-100%)
  var perspT = PerspT(srcCorners, dstCorners);
  console.log("converting from "+JSON.stringify(srcCorners)+" to "+JSON.stringify(dstCorners));

  for(var i in G._tiles){
    var current = G._tiles[i];
    if((current.key != board.key) &&
    (current.x > srcCorners[0]) && (current.x < srcCorners[2]) &&
    (current.y > srcCorners[1]) && (current.y < srcCorners[5])){
        console.log("tile "+current.key+" is in the board!");
        var tagno;
        for(var j=0; j<pieces.length; j++){
          if(pieces[j].title == current.key){
            tagno = ""+pieces[j].chilitags[0];
          }
        }
        rawtags[tagno] = perspT.transform(current.x, current.y);
    }

  }

  console.log("Detected tags on board: "+JSON.stringify(rawtags));
  return rawtags;
}

// Gets the array of raw chilitags/cards positions (only those within the board!)
G.getRawChilitagsFromTiles = function getRawChilitagsFromTiles() {
    var rawchilitags = {};
    var boardTile = G.getBoardTile();
    if(boardTile){
      rawchilitags = G.convertXYToBoardCoords(boardTile);
    }

    return rawchilitags;
};



//Get the board regions and which cards are in them, and returns that javascript object
G.getBoardRegions = function getBoardRegions(transTagPositions){
  //Clone the object
  var tagsBoard = $.extend(true, {}, G.AreaMap100);
  tagsBoard.noarea = []; //For tags in the board but outside the delimited areas (will flag up in syntactic check)
  // Go through the tags, and see if they are in any of the areas
  for(var tag in transTagPositions){ //go through the detected tags...
      var tagcoords = transTagPositions[tag];
      var found = false;
      for(var area in tagsBoard){ // For every area...
          if(area != "noarea"){
            var coords = G.AreaMap100[area];
            if(tagcoords[0]>coords[0][0] && tagcoords[0]<coords[1][0] &&
              tagcoords[1]>coords[0][1] && tagcoords[1]<coords[1][1]){ // The tag is in this area
                  //we check whether it is a string (we create an array with both),
                  if(typeof tagsBoard[area] == "string"){
                      tagsBoard[area] = [tagsBoard[area], tag];
                      found=true;
                  }
                  //or an array of strings (we add to it)
                  else if(typeof tagsBoard[area] == "object" && tagsBoard[area][0] && typeof tagsBoard[area][0] == "string"){
                      tagsBoard[area].push(tag);
                      found=true;
                  }
                  //an array of numbers (we substitute it by a string),
                  else if(typeof tagsBoard[area]=="object" && tagsBoard[area][0] && tagsBoard[area][0][0] && typeof tagsBoard[area][0][0] == "number"){
                      tagsBoard[area] = tag; //We set the area value to the tag nr
                      found = true;
                  }
              }
          }
      }
      // Once we go through all areas, if the tag was in none (and it is within the board), we add it to the noarea field
      if(!found && transTagPositions[tag][0]>0 && transTagPositions[tag][0]<100 &&
        transTagPositions[tag][1]>0 && transTagPositions[tag][1]<100){
          tagsBoard.noarea.push(tag);
      }
  }
  // We check that all the boards got a tag or an empty string
  for(var area in tagsBoard){
      if(area != "noarea" &&
          (typeof tagsBoard[area] != "string" && (typeof tagsBoard[area]=="object" && tagsBoard[area][0] && typeof tagsBoard[area][0]!="string"))){
          tagsBoard[area]="";
      }
  }

  //Alternative:
  //Go through the areas and see if there is any of the tags inside
  // for(area in tagsBoard){ // For every area...
  //     var coords = tagsBoard[area];
  //     for(tag in transTagPositions){ //go through the detected tags...
  //         tagcoords = transTagPositions[tag];
  //         if(tagcoords[0]>coords[0][0] && tagcoords[0]<coords[1][0] &&
  //           tagcoords[1]>coords[0][1] && tagcoords[1]<coords[1][1]){ // The tag is in this area
  //               tagsBoard[area] = tag; //We set the area value to the tag nr
  //           }
  //     }
  //     //If the value of the area is not a string, we did not find any tag in this area, we set it to empty
  //     if(typeof tagsBoard[area] != "string"){
  //         tagsBoard[area] = "";
  //     }
  //
  // }

  //Return the object
  return tagsBoard;
};


//Looks up a chilitag number in the array of pieces, and returns the title (without the last part of language and tagno)
G.lookupCardTitleInPieces = function lookupCardTitleInPieces(cardNo){

    var response = "";
    var result = $.grep(pieces, function(e){  if(e.chilitags && e.chilitags[0]){
                                                return (e.chilitags[0] == parseInt(cardNo,10));
                                              }else{
                                                return false;
                                              };});
    if(result.length>=1){//we found a card with that chilitag
        //console.log('found one');
        var res = result[0];
        response = res.title.substring(0,res.title.lastIndexOf(' ',res.title.lastIndexOf(' ')-1));
        if(response.length==0){//if we cut out too much of the title, we just cut the last number
            response = res.title.substring(0,res.title.lastIndexOf(' '));
        }
    }else{
        //Do nothing
    }
    return response;

};




//Converts an object with regions and the associated Chilitags
//To a similar object with the card titles instead, for later XML generation
G.lookupCardRegions = function lookupCardRegions(cardRegions){
    var board = {};
    for(var vars in cardRegions){
        var cardsInRegion = cardRegions[vars];
        if(!cardsInRegion){
            board[vars] = "";
        }else{
            if(typeof cardsInRegion == "string"){
                board[vars] = G.lookupCardTitleInPieces(cardsInRegion);
            }else{ //it's and object i.e. an array
                for(var i = 0;i<cardsInRegion.length;i++){
                    var card = cardsInRegion[i];
                    var result = $.grep(pieces, function(e){  if(e.chilitags && e.chilitags[0]){
                                                                return (e.chilitags[0] == parseInt(card,10));
                                                              }else{
                                                                return false;
                                                              };});
                    if(result.length>=1){//we found a card with that chilitag
                        console.log('found one');
                        var res = result[0];
                        board[vars] = res.title.substring(0,res.title.lastIndexOf(' ',res.title.lastIndexOf(' ')-1)); //TODO: eliminate the part of the title with tag number and language
                    }else{
                        board[vars] = "";
                    }
                }
            }

        }
    }
    console.log('Looked up card regions:\n'+JSON.stringify(board));
    return board;
}



G.lookupCardTypeInPieces = function lookupCardTypeInPieces(cardvalue){

    var response = "";
    var result = $.grep(pieces, function(e){  if(e.chilitags && e.chilitags[0]){
                                                return (e.chilitags[0] == parseInt(cardvalue,10));
                                              }else{
                                                return false;
                                              };});
    if(result.length>=1){//we found a card with that chilitag
        console.log('found one');
        var res = result[0];
        response = res.type4ts;
    }else{
        //Do nothing
    }
    return response;

}




//Gets the captured board with cards, and checks if they breach
//any of the game's syntax rules.
//Returns an array of error messages to be displayed
G.doSyntaxChecks = function doSyntaxChecks(cardRegions){
  var errors = [];
  console.log('Syntax check of cardRegions:\n'+JSON.stringify(cardRegions));
  // 0. No card should be outside the designated areas of the board??
  if(cardRegions.noarea && cardRegions.noarea.length>0){
      var error = {};
      error.message = MSG_NOTCLEARPLACE;
      error.refs = [];
      for(var i=0; i<cardRegions.noarea.length; i++){
          error.message = error.message + G.lookupCardTitleInPieces(cardRegions.noarea[i],pieces) +', ';
          error.refs.push(cardRegions.noarea[i]);
      }
      error.message = error.message.substring(0,error.message.length-2)
      errors.push(error);
  }
  // 1.	There can only be zero or ONE card in single-card cells (all colours except green).
  // 2.	There can only be zero or one or two cards in a double-card green cell.
  // I.E. Only one card per slot
  for (var region in cardRegions){
      value = cardRegions[region];
      if(region!="noarea" && value && typeof value != "string" && value.length && value.length>1){ // it is an array or an object in the slot, so something's wrong!
          var error = {};
          error.message = MSG_TOOMANY;
          error.refs = [];
          for(var i=0; i<value.length; i++){
              error.message = error.message + G.lookupCardTitleInPieces(value[i],pieces) +', ';
              error.refs.push(value[i]);
          }
          error.message = error.message.substring(0,error.message.length-2)
          errors.push(error);
      }
  }

  var occupiedCols = [false, false, false, false];
  for (var region in cardRegions){
      var value = cardRegions[region];
      //console.log('Syntax checking types of '+JSON.stringify(value));
      //If There is a card in the slot
      if(region!="noarea" && value && typeof value == "string"){

          // We get the type of card we found, and compare it with the slot type
          var cardtype = G.lookupCardTypeInPieces(value, pieces);
          if(cardtype){
              // 3.	Blue cards can only be on blue cells
              if(cardtype == "Technique" && region.indexOf('csw-technique')==-1){
                  var error = {};
                  error.message = MSG_BLUECARDSLOTS;
                  error.refs = [];
                  error.message = error.message + G.lookupCardTitleInPieces(value,pieces);
                  error.refs.push(value);
                  errors.push(error);
              }
              // 4.	Red cards can only be on red cells
              else if(cardtype == "Task" && region.indexOf('css-task')==-1){
                  var error = {};
                  error.message = MSG_REDCARDSLOTS;
                  error.refs = [];
                  error.message = error.message + G.lookupCardTitleInPieces(value,pieces);
                  error.refs.push(value);
                  errors.push(error);
              }
              // 5.	Yellow cards can only be on yellow cells
              else if(cardtype == "Team" && region.indexOf('css-team')==-1){
                  var error = {};
                  error.message = MSG_YELLOWCARDSLOTS;
                  error.refs = [];
                  error.message = error.message + G.lookupCardTitleInPieces(value,pieces);
                  error.refs.push(value);
                  errors.push(error);
              }
              // 6.	Green cards can only be on green cells
              else if(cardtype == "Technology" && region.indexOf('css-tec')==-1){
                  var error = {};
                  error.message = MSG_GREENCARDSLOTS;
                  error.refs = [];
                  error.message = error.message + G.lookupCardTitleInPieces(value,pieces);
                  error.refs.push(value);
                  errors.push(error);
              }
              // 9.	Objectives, contents and context cards must be on board before starting filling in cells.
              else if(value == CONTENT_TAG){
                  var error = {};
                  error.message = MSG_CONTENTBOX;
                  error.refs = [];
                  error.message = error.message;
                  error.refs.push(value);
                  errors.push(error);
              }else if(value == CONTEXT_TAG){
                  var error = {};
                  error.message = MSG_CONTEXTBOX;
                  error.refs = [];
                  error.message = error.message;
                  error.refs.push(value);
                  errors.push(error);
              }else if(value == OBJECTIVE_TAG){
                  var error = {};
                  error.message = MSG_OBJECTIVEBOX;
                  error.refs = [];
                  error.message = error.message;
                  error.refs.push(value);
                  errors.push(error);
              }
              // 10. (nothing to do)	Blue cells can be empty, even when other cells of the column are full.
              // 11.	Request for check card can only be placed on the top left slot devoted to it.
              else if(value == CAPTURE_TAG && region!="capture"){
                  var error = {};
                  error.message = MSG_CAPTURECARDSLOT;
                  error.refs = [];
                  error.message = error.message;
                  error.refs.push(value);
                  errors.push(error);
              }

              //We set which columns have non-? stuff, for later processing
              if(value != QUESTION_TAG ||
                  value != CAPTURE_TAG){

                    if(region.startsWith("c1-")) occupiedCols[0] = true;
                    else if(region.startsWith("c2-")) occupiedCols[1] = true;
                    else if(region.startsWith("c3-")) occupiedCols[2] = true;
                    else if(region.startsWith("c4-")) occupiedCols[3] = true;

              }

          }



      }
  }

  //7.	Question mark cards can be on any cell of a column that already contains some card(s), or of a column that is directly adjacent to a complete column
  //TODO: Completeness is checked later! we just check that ? does not have an empty column to its left
  for (var region in cardRegions){
      var value = cardRegions[region];
      if(value == QUESTION_TAG){
          if((region.startsWith("c2") && !occupiedCols[0])||
              (region.startsWith("c3") && (!occupiedCols[0] || !occupiedCols[1]))||
              (region.startsWith("c4") && (!occupiedCols[0] || !occupiedCols[1] || !occupiedCols[2]))){
                  var error = {};
                  error.message = MSG_QUESTIONEMPTY;
                  error.refs = [];
                  error.message = error.message;
                  error.refs.push(value);
                  errors.push(error);
              }

      }
  }

  //8. (nothing to do)	White cards can be on any cell (-> this is still to be defined, because it has to do with the wild cards  !!!)
  return errors;

};


//returns the XML string corresponding to a query to the DB that mimics a board object passed
//displaySuggest indicates whether to include the ? card (not needed on certain KB calls)
G.getXMLFromBoard = function getXMLFromBoard(board, displaySuggest=true){
    //get the base XML template
    var emptyXML = '<?xml version="1.0"?><!DOCTYPE board SYSTEM "kb_in.dtd"><board><context>This is a text describing the context</context><goals><goal>This is a text describing a goal</goal><goal>This is a text describing another goal</goal></goals><content>This is a text describing some content</content><columns><column id="1"><csw-technique><technique-name/><technique-phase/></csw-technique><aba-css-task/><aba-css-team/><aba-css-tec1/><aba-css-tec2/><abb-css-task/><abb-css-team/><abb-css-tec1/><abb-css-tec2/></column><column id="2"><csw-technique><technique-name/><technique-phase/></csw-technique><aba-css-task/><aba-css-team/><aba-css-tec1/><aba-css-tec2/><abb-css-task/><abb-css-team/><abb-css-tec1/><abb-css-tec2/></column><column id="3"><csw-technique><technique-name/><technique-phase/></csw-technique><aba-css-task/><aba-css-team/><aba-css-tec1/><aba-css-tec2/><abb-css-task/><abb-css-team/><abb-css-tec1/><abb-css-tec2/></column><column id="4"><csw-technique><technique-name/><technique-phase/></csw-technique><aba-css-task/><aba-css-team/><aba-css-tec1/><aba-css-tec2/><abb-css-task/><abb-css-team/><abb-css-tec1/><abb-css-tec2/></column></columns></board>';
    var parser = new DOMParser();
    var xmlDoc = parser.parseFromString(emptyXML, "text/xml"); //important to use "text/xml"

    //Modify the empty xml file with the board data
    for(var field in board){
        xmlDoc = G.modifyXMLField(xmlDoc,field,board[field],displaySuggest);
    }

    //var tech1 = xmlDoc.getElementById("1").getElementsByTagName("csw-technique")[0].getElementsByTagName("technique-name")[0];
    //tech1.textContent = "?";

    //Serialize the object to XML
    var serializer = new XMLSerializer();
    var xmlString = serializer.serializeToString(xmlDoc);
    console.log(xmlString);
    return xmlString;
}


//Gets a xmlBoard in a string, and POSTs it (directly or through our server)
//to the KB, redirecting the response to a callback and putting a loading icon
//Actually, the KB takes a GET, of the form: http://localhost:8000/check_from_XML?board=<board><context>... </board>
G.doSemanticChecks = function doSemanticChecks(xmlstring, cardRegions){
    //var message = 'Sending this file to the KB: '+xmlstring+'\n.........';
    var message = 'Querying the KB...';
    console.log(message);
    //$('#fblist').append('<li class="list-group-item" id="fbZZ"><img src="/img/ajax-loader.gif" alt="Loading..." /></li>');
    //)$('#fbZZ').append(document.createTextNode(message));
    var url = G.KB_BASE_URL+encodeURIComponent(xmlstring);
    $.get(url, function(data, status){
        console.log("KB Query successful.\nStatus: " + status + "\nData: " + data);
        $('#fbZZ').remove();
        //Parse and show KB output
        //$('#fblist').append('<li class="list-group-item" id="fbZZ"></li>');
        //$('#fbZZ').append(document.createTextNode(data));
        var semantic = G.parseKBResponse(data, cardRegions, pieces);
        G.displaySemanticErrors(semantic);
    });
};

G.trimLines = function trimLines(text){
  return text.replace(/^\s+|\s+$/g, '');
};


G.parseKBResponse = function parseKBResponse(data, cardRegions){
  var semantic = {};
  semantic.inconsistent = [];
  semantic.missing = [];
  semantic.suggested = [];

  //parse the data
  var xml = $.parseXML(data),
      $xml = $( xml ),
      $inconsistent = $xml.find('inconsistent-slots'),
      $missing = $xml.find('missing-cards'),
      $suggested = $xml.find('suggested-cards');
  console.log("Parsed xml:\nInconsistent: "+$inconsistent.children().length+"\n"+$inconsistent.text()+"\nMissing: "+$missing.children().length+"\n"+$missing.text()+"\nSuggested: "+$suggested.children().length+"\n"+$suggested.text());

  //TODO: For now it only gets the positions mentioned in each of the fields... probably the responses will change in the future!
  if($inconsistent.children().length>0){
      $inconsistent.find('position').each(function(){
        var obj = {};
        obj.position = G.trimLines($(this).text()).toLowerCase();
        var tag = cardRegions[obj.position];
        console.log("found inconsistent card "+tag);
        obj.message = MSG_INCONSISTENT + G.lookupCardTitleInPieces(tag);
        obj.refs = [ tag ];
        semantic.inconsistent.push(obj);
      });
  }
  if($missing.children().length>0){
      $missing.find('position').each(function(){
        var obj = {};
        obj.position = G.trimLines($(this).text()).toLowerCase();
        var tag = cardRegions[obj.position];
        console.log("found missing card "+tag);
        obj.message = MSG_MISSING + G.lookupCardTitleInPieces(tag);
        obj.refs = [ tag ];
        semantic.missing.push(obj);
      });
  }
  if($suggested.children().length>0){
      $suggested.find('position').each(function(){
        var obj = {};
        obj.position = G.trimLines($(this).text()).toLowerCase();
        var tag = cardRegions[obj.position];
        console.log("found suggested card "+tag);
        obj.message = MSG_SUGGESTED + G.lookupCardTitleInPieces(tag);
        obj.refs = [ tag ];
        semantic.suggested.push(obj);
      });
  }
  console.log("Semantic response parsing finished: "+JSON.stringify(semantic));
  return semantic;
};


//Takes an xml document, a field in the board and a value,
//and modifies the xmldoc accordingly
G.modifyXMLField = function modifyXMLField(xmlDoc,field,value,displaySuggest=true){
    var QUESTIONTAG = "call-for-suggestion";
    //var tech1 = xmlDoc.getElementById("1").getElementsByTagName("csw-technique")[0].getElementsByTagName("technique-name")[0];
    //tech1.textContent = "?";
    var col;
    if(field.startsWith('c1')){
        col = xmlDoc.getElementById('1');
    } else if(field.startsWith('c2')){
          col = xmlDoc.getElementById('2');
    } else if(field.startsWith('c3')){
          col = xmlDoc.getElementById('3');
    } else if(field.startsWith('c4')){
          col = xmlDoc.getElementById('4');
    }

    if(col){ //If it was a good column value, we dig further
        var restfield = field.substring(3);
        var fieldtag = col.getElementsByTagName(restfield)[0];
        // If the value is empty, we do nothing
        if(!value){
            //Do nothing
        }
        // If value is a ?, we add the special question tag (if displaySuggest=true)
        else if(value=="?"){
            if(displaySuggest){
                //If the ? is in the technique tag, we have to remove the two subtags
                if(restfield=="csw-technique"){
                    while (fieldtag.firstChild) {
                        fieldtag.removeChild(fieldtag.firstChild);
                    }
                }

                var qtag = xmlDoc.createElement(QUESTIONTAG);
                fieldtag.appendChild(qtag);
            }
        }
        // If it is a technique field, we have to split the value in two tags
        else if(restfield=="csw-technique"){
            var tagname = fieldtag.getElementsByTagName("technique-name")[0];
            tagname.textContent = value;
            //We add the phase tag
            var tagphase = fieldtag.getElementsByTagName("technique-phase")[0];
            if(value.indexOf("PHASE III")!=-1){ //It is a phase 3
                tagphase.textContent = "3";
            }else if(value.indexOf("PHASE II")!=-1){ //It is a phase 2
                tagphase.textContent = "2";
            }else if(value.indexOf("PHASE I")!=-1){ //It is a phase 1
                tagphase.textContent = "1";
            }
        }
        // If value is normal, just add the corresponding text
        else{
            fieldtag.textContent = value;
        }
    }


    return xmlDoc;
};


G.displaySyntaxErrors = function displaySyntaxErrors(errors){
    if(errors.length==0){
        //We display a no errors found message
        UI.fbchat("4Ts",MSG_SYNTAXCORRECT);
    }else{
        if(errors.length>0){
          console.log("Displaying feedback for "+errors.length+" errors... actually, "+Math.min(errors.length, 4));
          // Generate and place the error messages
          for(var i=0;i<Math.min(errors.length, 4);i++){
              UI.fbchat("4Ts",errors[i].message);
          }
          if(errors.length>4){
              UI.fbchat("4Ts","...")
          }
        }

    }
};


G.displaySemanticErrors = function displaySemanticErrors(semantic){

    var inconsistent = semantic.inconsistent;
    var missing = semantic.missing;
    var suggested = semantic.suggested;

    //inconsistent
    //UI.fbchat("4Ts",MSG_FBSECTION2);
    if(inconsistent.length==0){
        //We display a no errors found message
        UI.fbchat("4Ts",MSG_NO_INCONSISTENT);
    }else{
        if(inconsistent.length>0){
          console.log("Displaying feedback for "+inconsistent.length+" inconsistencies... actually, "+Math.min(inconsistent.length, 4));
          // Generate and place the error messages
          for(var i=0;i<Math.min(inconsistent.length, 4);i++){
              UI.fbchat("4Ts",inconsistent[i].message);
          }
          if(inconsistent.length>4){
            UI.fbchat("4Ts","...");
          }
        }

    }

    //missing
    //UI.fbchat("4Ts",MSG_FBSECTION3);
    if(missing.length==0){
        //We display a no errors found message
        UI.fbchat("4Ts",MSG_NO_MISSING);
    }else{
        if(missing.length>0){
          console.log("Displaying feedback for "+missing.length+" missing... actually, "+Math.min(missing.length, 4));

          // Generate and place the error messages
          for(var i=0;i<Math.min(missing.length, 4);i++){
              UI.fbchat("4Ts",missing[i].message);
          }
          if(missing.length>4){
            UI.fbchat("4Ts","...");
          }
        }

    }

    //suggested
    //UI.fbchat("4Ts",MSG_FBSECTION4);
    if(suggested.length==0){
        //We display a no errors found message
        UI.fbchat("4Ts",MSG_NO_SUGGESTION);
    }else{
        if(suggested.length>0){
          console.log("Displaying feedback for "+suggested.length+" suggested... actually, "+Math.min(suggested.length, 4));
          // Generate and place the error messages
          for(var i=0;i<Math.min(suggested.length, 4);i++){
              UI.fbchat("4Ts",suggested[i].message);
          }
          if(suggested.length>4){
            UI.fbchat("4Ts","...");
          }
        }

    }
};



G.saveDesign = function saveDesign() {
    console.log('saving Design');
    // Convert tiles to rawchilitags coordinates wrt board, and add to room (how?)
    var rawchilitags = G.getRawChilitagsFromTiles();
    //get cardRegions from raw chilitags
    var boardRegions = G.getBoardRegions(rawchilitags);
    var capturedBoard = G.lookupCardRegions(boardRegions);
    //ensure saveDesign also takes the cardboard and raw chilitags!
    Network.server.saveDesign(rawchilitags, capturedBoard);
    UI.lines = [];
    UI.fbchat("4Ts",'Saved design. Checking for feedback...');
    // //Do syntax checks and show feedback
    var errors=[];
    errors = G.doSyntaxChecks(boardRegions);
    console.log(JSON.stringify(errors));
    G.displaySyntaxErrors(errors);
    // //Query the KB and show feedback
    if(errors.length==0){
         var xmlBoard = G.getXMLFromBoard(capturedBoard);
         G.doSemanticChecks(xmlBoard, boardRegions);
    }

};
