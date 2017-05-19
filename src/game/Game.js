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
}



G.saveDesign = function saveDesign() {
    console.log('saving Design');
    // Convert tiles to rawchilitags coordinates wrt board, and add to room (how?)
    var rawchilitags = G.getRawChilitagsFromTiles();
    //TODO: get cardRegions from raw chilitags, and add to room (how?)
    var boardRegions = G.getBoardRegions(rawchilitags);
    //TODO: ensure saveDesign also takes the cardboard and raw chilitags!
    Network.server.saveDesign();
    UI.chat('Saved design', gameName);
    //TODO: Do syntax checks and show feedback

    //TODO: Query the KB and show feedback
};
