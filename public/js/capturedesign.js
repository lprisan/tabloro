var video = document.getElementById('webcam');
var canvas = document.getElementById('snapshot');
var ctx = canvas.getContext('2d');
var localMediaStream = null;

var continuous = true;

var lastTags;

//Elements to style for capture
var videoContBG = document.getElementById('snapshot');
var captureBtn = document.getElementById('captureBtn');
var retryBtn = document.getElementById('captureBtn');

var framesSinceCapture = 999; //This counts the frames since last capture, to avoid capture
var FRAMESBETWEENCAPTURES = 10;

var BOARD_TAGS = ["2","3","4","5"];
var OBJECTIVE_TAG = "6";
var CONTEXT_TAG = "7";
var CONTENT_TAG = "8";
var CAPTURE_TAG = "0";
var QUESTION_TAG = "1";
var AreaMap100 = {"capture":[[3.270803270803271,0],[20.105820105820104,14.075286415711947]],"context":[[3.751803751803752,18.821603927986907],[20.105820105820104,31.26022913256956]],"goals":[[3.751803751803752,35.3518821603928],[20.105820105820104,68.08510638297872]],"content":[[3.751803751803752,72.50409165302783],[20.105820105820104,104.9099836333879]],"c1-csw-technique":[[22.02982202982203,4.25531914893617],[40.4040404040404,23.895253682487724]],"c1-aba-css-task":[[22.02982202982203,24.713584288052374],[31.072631072631072,44.189852700490995]],"c1-aba-css-team":[[31.457431457431458,24.713584288052374],[40.4040404040404,44.189852700490995]],"c1-aba-css-tec1":[[22.02982202982203,44.84451718494272],[31.072631072631072,64.48445171849427]],"c1-aba-css-tec2":[[31.457431457431458,44.84451718494272],[40.4040404040404,64.48445171849427]],"c1-abb-css-task":[[22.02982202982203,65.13911620294598],[31.072631072631072,84.61538461538461]],"c1-abb-css-team":[[31.457431457431458,65.13911620294598],[40.4040404040404,84.61538461538461]],"c1-abb-css-tec1":[[22.02982202982203,85.27004909983633],[31.072631072631072,104.74631751227496]],"c1-abb-css-tec2":[[31.457431457431458,85.27004909983633],[40.4040404040404,104.74631751227496]],"c2-csw-technique":[[40.78884078884079,4.25531914893617],[59.06685906685907,23.895253682487724]],"c2-aba-css-task":[[40.78884078884079,24.713584288052374],[49.735449735449734,44.189852700490995]],"c2-aba-css-team":[[50.12025012025012,24.713584288052374],[59.06685906685907,44.189852700490995]],"c2-aba-css-tec1":[[40.78884078884079,44.84451718494272],[49.735449735449734,64.48445171849427]],"c2-aba-css-tec2":[[50.12025012025012,44.84451718494272],[59.06685906685907,64.48445171849427]],"c2-abb-css-task":[[40.78884078884079,65.13911620294598],[49.735449735449734,84.61538461538461]],"c2-abb-css-team":[[50.12025012025012,65.13911620294598],[59.06685906685907,84.61538461538461]],"c2-abb-css-tec1":[[40.78884078884079,85.27004909983633],[49.735449735449734,104.74631751227496]],"c2-abb-css-tec2":[[50.12025012025012,85.27004909983633],[59.06685906685907,104.74631751227496]],"c3-csw-technique":[[59.45165945165945,4.25531914893617],[77.82587782587782,23.895253682487724]],"c3-aba-css-task":[[59.45165945165945,24.713584288052374],[68.3982683982684,44.189852700490995]],"c3-aba-css-team":[[68.78306878306879,24.713584288052374],[77.82587782587782,44.189852700490995]],"c3-aba-css-tec1":[[59.45165945165945,44.84451718494272],[68.3982683982684,64.48445171849427]],"c3-aba-css-tec2":[[68.78306878306879,44.84451718494272],[77.82587782587782,64.48445171849427]],"c3-abb-css-task":[[59.45165945165945,65.13911620294598],[68.3982683982684,84.61538461538461]],"c3-abb-css-team":[[68.78306878306879,65.13911620294598],[77.82587782587782,84.61538461538461]],"c3-abb-css-tec1":[[59.45165945165945,85.27004909983633],[68.3982683982684,104.74631751227496]],"c3-abb-css-tec2":[[68.78306878306879,85.27004909983633],[77.82587782587782,104.74631751227496]],"c4-csw-technique":[[78.21067821067821,4.25531914893617],[96.48869648869649,23.895253682487724]],"c4-aba-css-task":[[78.21067821067821,24.713584288052374],[87.06108706108706,44.189852700490995]],"c4-aba-css-team":[[87.44588744588745,24.713584288052374],[96.48869648869649,44.189852700490995]],"c4-aba-css-tec1":[[78.21067821067821,44.84451718494272],[87.06108706108706,64.48445171849427]],"c4-aba-css-tec2":[[87.44588744588745,44.84451718494272],[96.48869648869649,64.48445171849427]],"c4-abb-css-task":[[78.21067821067821,65.13911620294598],[87.06108706108706,84.61538461538461]],"c4-abb-css-team":[[87.44588744588745,65.13911620294598],[96.48869648869649,84.61538461538461]],"c4-abb-css-tec1":[[78.21067821067821,85.27004909983633],[87.06108706108706,104.74631751227496]],"c4-abb-css-tec2":[[87.44588744588745,85.27004909983633],[96.48869648869649,104.74631751227496]]};

//Canvas dimensions
var width = canvas.width;
var height = canvas.height;


//Board dimensions and how much of it we actually use (between the centers of the corner tags)
var boardw = 1412;
var boardh = 875;
var board_efw = 1299;
var board_efh = 764;
var offsetx = 55;
var offsety = 55;





var fps = document.getElementById('fps');
var fpsText = document.createTextNode('');
fps.appendChild(fpsText);

//Takes an xml document, a field in the board and a value,
//and modifies the xmldoc accordingly
var modifyXMLField = function(xmlDoc,field,value,displaySuggest=true){
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
}


//returns the XML string corresponding to a query to the DB that mimics a board object passed
//displaySuggest indicates whether to include the ? card (not needed on certain KB calls)
var getXMLFromBoard = function(board, displaySuggest=true){
    //get the base XML template
    var emptyXML = '<?xml version="1.0"?><!DOCTYPE board SYSTEM "kb_in.dtd"><board><context>This is a text describing the context</context><goals><goal>This is a text describing a goal</goal><goal>This is a text describing another goal</goal></goals><content>This is a text describing some content</content><columns><column id="1"><csw-technique><technique-name/><technique-phase/></csw-technique><aba-css-task/><aba-css-team/><aba-css-tec1/><aba-css-tec2/><abb-css-task/><abb-css-team/><abb-css-tec1/><abb-css-tec2/></column><column id="2"><csw-technique><technique-name/><technique-phase/></csw-technique><aba-css-task/><aba-css-team/><aba-css-tec1/><aba-css-tec2/><abb-css-task/><abb-css-team/><abb-css-tec1/><abb-css-tec2/></column><column id="3"><csw-technique><technique-name/><technique-phase/></csw-technique><aba-css-task/><aba-css-team/><aba-css-tec1/><aba-css-tec2/><abb-css-task/><abb-css-team/><abb-css-tec1/><abb-css-tec2/></column><column id="4"><csw-technique><technique-name/><technique-phase/></csw-technique><aba-css-task/><aba-css-team/><aba-css-tec1/><aba-css-tec2/><abb-css-task/><abb-css-team/><abb-css-tec1/><abb-css-tec2/></column></columns></board>';
    var parser = new DOMParser();
    var xmlDoc = parser.parseFromString(emptyXML, "text/xml"); //important to use "text/xml"

    //Modify the empty xml file with the board data
    for(field in board){
        xmlDoc = modifyXMLField(xmlDoc,field,board[field],displaySuggest);
    }

    //var tech1 = xmlDoc.getElementById("1").getElementsByTagName("csw-technique")[0].getElementsByTagName("technique-name")[0];
    //tech1.textContent = "?";

    //Serialize the object to XML
    var serializer = new XMLSerializer();
    var xmlString = serializer.serializeToString(xmlDoc);
    console.log(xmlString);
    return xmlString;
}

//Finds y value of given object
var findPos = function(obj) {
    var curtop = 0;
    if (obj.offsetParent) {
        do {
            curtop += obj.offsetTop;
        } while (obj = obj.offsetParent);
    return [curtop];
    }
}


//Style elements taking into account the board tags present
var checkAndStyleBoardCapture = function(tags, videocont, button){
    var board_present = 0;
    for (tag in tags){
        if(BOARD_TAGS.indexOf(tag)!=-1){
            board_present++;
        }
    }
    if(board_present==4){ //All tags present, paint the frame with green border
        videocont.style.borderWidth = '20px';
        videocont.style.borderColor = 'green';
        videocont.style.borderStyle = 'solid';
        if(continuous) button.classList.remove("disabled");
    }else if(board_present==0){ //No tags present, paint frame with red border and disable button
        videocont.style.borderWidth = '20px';
        videocont.style.borderColor = 'red';
        videocont.style.borderStyle = 'solid';
        if(continuous) button.classList.add("disabled");
    }else if(board_present>0 && board_present<4){ //Some tags present, paint frame with yellow-orange border and disable button
        videocont.style.borderWidth = '20px';
        videocont.style.borderColor = 'orange';
        videocont.style.borderStyle = 'solid';
        if(continuous) button.classList.add("disabled");
    }else{
        //Remove border and disable capture button, just in case
        videocont.style.borderStyle = 'none';
        if(continuous) button.classList.remove("disabled");
    }
    return board_present;
}

//gets a set of 4 pairs of numbers (tag corners x,y) and calculates the center
var getTagCenter = function(tag){
  var center = [];
  center = [(tag[0][0]+tag[1][0]+tag[2][0]+tag[3][0])/4, // x
            (tag[0][1]+tag[1][1]+tag[2][1]+tag[3][1])/4] // y
  return center;
}

// do homography of corners and get which tags are where, see https://uncorkedstudios.com/blog/perspective-transforms-in-javascript
var getTransformedTags = function(tags, logging=false){
    var transTagPos = {};
    var srcCorners = [].concat.apply([],[ getTagCenter(tags['2']) ,
                                        getTagCenter(tags['3']) ,
                                        getTagCenter(tags['4']) ,
                                        getTagCenter(tags['5'])]); //Detected board tags
    var dstCorners = [0,0,100,0,100,100,0,100]; //Ideal board (sides 0-100%)
    var perspT = PerspT(srcCorners, dstCorners);
    if(logging) console.log('Board detected at '+srcCorners);

    var newCoords = {};
    count = 0;
    for(tag in tags){
        if($.inArray(tag, BOARD_TAGS)==-1){ //We check only non-board tags
            var srcPt = getTagCenter(tags[tag]);
            var dstPt = perspT.transform(srcPt[0], srcPt[1]);
            newCoords[tag] = dstPt;
            count++;
        }
    }
    if(logging) console.log('Found '+count+' non-board tags: '+JSON.stringify(newCoords));
    return newCoords;
}


//Get the board regions and which cards are in them, and returns that javascript object
var getBoardRegions = function(transTagPositions, AreaMap100){
  //Clone the object
  tagsBoard = $.extend(true, {}, AreaMap100);
  tagsBoard.noarea = []; //For tags in the board but outside the delimited areas (will flag up in syntactic check)
  // Go through the tags, and see if they are in any of the areas
  for(tag in transTagPositions){ //go through the detected tags...
      tagcoords = transTagPositions[tag];
      var found = false;
      for(area in tagsBoard){ // For every area...
          if(area != "noarea"){
            var coords = AreaMap100[area];
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
      // Once we go through all areas, if the tag was in none, we add it to the noarea field
      if(!found){
          tagsBoard.noarea.push(tag);
      }
  }
  // We check that all the boards got a tag or an empty string
  for(area in tagsBoard){
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


//Checking camera
var hasGetUserMedia = function() {
    return !!(navigator.getUserMedia || navigator.webkitGetUserMedia ||
            navigator.mozGetUserMedia || navigator.msGetUserMedia);
}
//Error
var onFailSoHard = function(e) {
    console.log('Error!', e);
};

//Camera capture
var snapshot = function() {
    if (localMediaStream && preloaded) {
        ctx.drawImage(video, 0, 0, video.width, video.height);
        var start = new Date();
        var obj = Chilitags.findTagsOnImage(canvas, true);
        lastTags = obj;
        var end = new Date();
        var str = 'tag: ';
        for(var tag in obj){
            str += tag + ", ";
        }
        fpsText.nodeValue = video.width+"x"+video.height+"--Chilitags processing = " + (end.getTime() - start.getTime()) + "ms  " + str;
        // We color the video's containters bg color, and disable the capture button,
        // so that we can know when the capture is possible
        var rancapture = false;
        var board_present = checkAndStyleBoardCapture(lastTags, videoContBG, captureBtn);
        if(board_present==4){
          // do homography of corners and get which tags are where, see https://uncorkedstudios.com/blog/perspective-transforms-in-javascript
          transTagPositions = getTransformedTags(lastTags);
          if(transTagPositions[CAPTURE_TAG] && transTagPositions[CAPTURE_TAG][0]>AreaMap100['capture'][0][0] &&
                    transTagPositions[CAPTURE_TAG][0]<AreaMap100['capture'][1][0] &&
                    transTagPositions[CAPTURE_TAG][1]>AreaMap100['capture'][0][1] &&
                    transTagPositions[CAPTURE_TAG][1]<AreaMap100['capture'][1][1] && framesSinceCapture>FRAMESBETWEENCAPTURES){
              // if the capture card is inside the capture area, we call capture()
              capture();
              rancapture=true;
          }
        }
        if(rancapture && framesSinceCapture>FRAMESBETWEENCAPTURES){
            framesSinceCapture=0;
        }else{
            framesSinceCapture++;
        }

    }
    if(continuous) requestAnimationFrame(snapshot);
}

var lookupCardTypeInPieces = function(cardvalue, pieces){

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
var doSyntaxChecks = function(cardRegions,pieces){
  var errors = [];
  console.log('Syntax check of cardRegions:\n'+JSON.stringify(cardRegions));
  // 0. No card should be outside the designated areas of the board??
  if(cardRegions.noarea && cardRegions.noarea.length>0){
      var error = {};
      error.message = MSG_NOTCLEARPLACE;
      error.refs = [];
      for(var i=0; i<cardRegions.noarea.length; i++){
          error.message = error.message + lookupCardTitleInPieces(cardRegions.noarea[i],pieces) +', ';
          error.refs.push(cardRegions.noarea[i]);
      }
      error.message = error.message.substring(0,error.message.length-2)
      errors.push(error);
  }
  // 1.	There can only be zero or ONE card in single-card cells (all colours except green).
  // 2.	There can only be zero or one or two cards in a double-card green cell.
  // I.E. Only one card per slot
  for (region in cardRegions){
      value = cardRegions[region];
      if(region!="noarea" && value && typeof value != "string" && value.length && value.length>1){ // it is an array or an object in the slot, so something's wrong!
          var error = {};
          error.message = MSG_TOOMANY;
          error.refs = [];
          for(var i=0; i<value.length; i++){
              error.message = error.message + lookupCardTitleInPieces(value[i],pieces) +', ';
              error.refs.push(value[i]);
          }
          error.message = error.message.substring(0,error.message.length-2)
          errors.push(error);
      }
  }

  var occupiedCols = [false, false, false, false];
  for (region in cardRegions){
      value = cardRegions[region];
      //console.log('Syntax checking types of '+JSON.stringify(value));
      //If There is a card in the slot
      if(region!="noarea" && value && typeof value == "string"){

          // We get the type of card we found, and compare it with the slot type
          var cardtype = lookupCardTypeInPieces(value, pieces);
          if(cardtype){
              // 3.	Blue cards can only be on blue cells
              if(cardtype == "Technique" && region.indexOf('csw-technique')==-1){
                  var error = {};
                  error.message = MSG_BLUECARDSLOTS;
                  error.refs = [];
                  error.message = error.message + lookupCardTitleInPieces(value,pieces);
                  error.refs.push(value);
                  errors.push(error);
              }
              // 4.	Red cards can only be on red cells
              else if(cardtype == "Task" && region.indexOf('css-task')==-1){
                  var error = {};
                  error.message = MSG_REDCARDSLOTS;
                  error.refs = [];
                  error.message = error.message + lookupCardTitleInPieces(value,pieces);
                  error.refs.push(value);
                  errors.push(error);
              }
              // 5.	Yellow cards can only be on yellow cells
              else if(cardtype == "Team" && region.indexOf('css-team')==-1){
                  var error = {};
                  error.message = MSG_YELLOWCARDSLOTS;
                  error.refs = [];
                  error.message = error.message + lookupCardTitleInPieces(value,pieces);
                  error.refs.push(value);
                  errors.push(error);
              }
              // 6.	Green cards can only be on green cells
              else if(cardtype == "Technology" && region.indexOf('css-tec')==-1){
                  var error = {};
                  error.message = MSG_GREENCARDSLOTS;
                  error.refs = [];
                  error.message = error.message + lookupCardTitleInPieces(value,pieces);
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
  for (region in cardRegions){
      value = cardRegions[region];
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

}


//Looks up a chilitag number in the array of pieces, and returns the title (without the last part of language and tagno)
var lookupCardTitleInPieces = function(cardNo, pieces){

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

}


//Converts an object with regions and the associated Chilitags
//To a similar object with the card titles instead, for later XML generation
var lookupCardRegions = function(cardRegions,pieces){
    var board = {};
    for(vars in cardRegions){
        var cardsInRegion = cardRegions[vars];
        if(!cardsInRegion){
            board[vars] = "";
        }else{
            if(typeof cardsInRegion == "string"){
                board[vars] = lookupCardTitleInPieces(cardsInRegion,pieces);
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


//Gets a xmlBoard in a string, and POSTs it (directly or through our server)
//to the KB, redirecting the response to a callback and putting a loading icon
var doSemanticChecks = function(xmlstring){
    //TODO!
    var message = 'Will be sending this file to the KB: '+xmlstring;
    console.log(message);
    $('#fblist').append('<li class="list-group-item" id="fbZZ"></li>');
    $('#fbZZ').append(document.createTextNode(message));
}

var displaySyntaxErrors = function(errors){
    $('#fblist').empty();
    $('#fblist').append('<li class="list-group-item fb-head lead" id="fb0"> <strong>Feedback</strong> </li>');
    $('#fblist').append('<li class="list-group-item fb-head lead" id="fb0s1"> I. '+MSG_FBSECTION1+'</li>');
    if(errors.length==0){
        //We display a no errors found message
        $('#fblist').append('<li class="list-group-item fb-item lead" id="fb1"> <i class="fa fa-check"></i> '+MSG_SYNTAXCORRECT+' </li>');
    }else{
        if(errors.length>0){
          console.log("Displaying feedback for "+errors.length+" errors... actually, "+Math.min(errors.length, 4));
          // Generate and place the error messages
          for(var i=0;i<Math.min(errors.length, 4);i++){
              var fbid = "fb"+(i+1);
              $('#fblist').append('<li class="list-group-item fb-item lead" id="'+fbid+'"> <span class="bignumber">'+(i+1)+'</span><p> '+errors[i].message+' </p></li>');

              //var elem = $('#'+fbid)[0];
              //console.log('added element '+elem.innerHTML);
              var elem = {};
              elem.refs = errors[i].refs;
              addCardContourStatic(elem, (i+1));
              //elem.addEventListener("mouseover",addCardContour,false);
              //elem.addEventListener("mouseout",backToOriginalMap,false);
          }
          if(errors.length>4){
              $('#fblist').append('<li class="list-group-item lead" id="fbdots"> <p> ... </p></li>');
          }
        }

    }
}

var drawnMap = {}; //here we will put the image data for the drawn map
var drawnCards = {}; //here we will put the positions/sizes of the drawn cards

//Draws a countour around an image of a card drawn
var CONTOUR_WIDTH = 5;
var addCardContour = function(){
    console.log("addCardContour "+this.refs);
    errorrefs = this.refs;
    var c = document.getElementById("boardcanvas");
    var ctx = c.getContext("2d");
    for(var i=0;i<errorrefs.length;i++){
        var tag = errorrefs[i];
        var dcard = drawnCards[tag];
        console.log('drawing contour on '+JSON.stringify(dcard));
        ctx.beginPath();
        ctx.lineWidth=""+CONTOUR_WIDTH;
        //ctx.strokeStyle="red";
        ctx.rect(dcard.xpos-(99/2)-(CONTOUR_WIDTH/2),dcard.ypos-(140/2)-(CONTOUR_WIDTH/2),99,140);//TODO: change this to take it from the image
        ctx.stroke();
    }
}

var addCardContourStatic = function(elem, bignumber){
    console.log("addCardContourStatic "+JSON.stringify(elem));
    errorrefs = elem.refs;
    var c = document.getElementById("boardcanvas");
    var ctx = c.getContext("2d");
    for(var i=0;i<errorrefs.length;i++){
        var tag = errorrefs[i];
        var dcard = drawnCards[tag];
        console.log('drawing contour on '+JSON.stringify(dcard));
        ctx.beginPath();
        ctx.lineWidth=""+CONTOUR_WIDTH;
        //ctx.strokeStyle="red";
        ctx.rect(dcard.xpos-(99/2)-(CONTOUR_WIDTH/2),dcard.ypos-(140/2)-(CONTOUR_WIDTH/2),99,140);//TODO: change this to take it from the image
        ctx.stroke();
        ctx.font="90px Arial";
        ctx.fillText(""+bignumber,dcard.xpos-10,dcard.ypos);
    }
}


//Returns the drawn canvas to the un-contoured one
var backToOriginalMap = function(){
    var c = document.getElementById("boardcanvas");
    var ctx = c.getContext("2d");
    ctx.putImageData(drawnMap,0,0);
}


var preloaded = false;
var n_preload = 0;
var n_images = 0;
//TODO: fix image loading order!
//Function that loads all pieces images (id=canvascardXX) at initialization time
var preloadImages = function(){

    var c = document.getElementById("boardcanvas");
    var ctx = c.getContext("2d");
    var images = pieces.map(function(elem){
          var url = elem['image']['cdnUri']+'/original_'+elem['image']['files'][0];
          return url;
      });
    n_images = images.length;
    //console.log('images ('+pieces.length+'): '+JSON.stringify(images));
    for(var i=0;i<images.length;i++){
        var image = images[i];
        var piece = pieces[i];
        var img = new Image();
        img.id = "img"+piece['image']['files'][0].substring(0,piece['image']['files'][0].indexOf('.'));
        //console.log('Creating image '+img.id+' from '+image);
        img.crossOrigin = "anonymous";
        img.style.display = "none";
        img.onload = function() {
            //console.log("Preloaded "+this.src);
            n_preload++;
            if(n_preload>=n_images){
                preloaded=true;
                console.log("Finished preloading images!");
                //capturetest();
            }
        };
        img.src = image;
        document.getElementById('invisibleimgs').appendChild(img);
    }

}


//This function takes the raw chilitags position within the board (in 0-100 scale)
// and modifies the table's tiles to put the cards in the correct position
// when the digital version of the table is opened
var updateTableTilesCapture = function(tags100){

  var boardpieceid = "";
  for(var piece in table.box.order){
      if(table.box.order[piece]==1){
          boardpieceid = piece;
          break;
      }
  }
  var boardtile = {};
  for(var index in table.setup.pieces){
      if(table.setup.pieces[index]==boardpieceid){
          boardtile = table.tiles[index];
          break;
      }
  }
  console.log("Board piece: "+boardpieceid+"\nTile: "+JSON.stringify(boardtile));
  for(tag in tags100){
      if(tags100[tag][0]>0 &
          tags100[tag][0]<100 &
          tags100[tag][1]>0 &
          tags100[tag][1]<100){ // We update only the cards INSIDE the four board tags -- that are not contesto, objettivi, contenuto!
            var piece = {};
            //Find the piece for this tag
            for(var i = 0; i < pieces.length; i++){
                var tmppiece = pieces[i];
                if(tmppiece['chilitags'] && tmppiece['chilitags'][0] && tmppiece['chilitags'][0].toString()===tag){
                    console.log("DELETEME found piece during update"+JSON.stringify(tmppiece));
                    piece = tmppiece;
                    break;
                }
            }
            //Modify the tiles of the table to reflect positions
            //Find the tile index for this piece
            var tileindex = 0;
            for(var index=0; index<table.setup.pieces.length; index++){
                if(table.setup.pieces[index]==piece._id){
                    console.log("DELETEME piece has an index "+index);
                    tileindex = index;
                    break;
                }
            }
            //Calculate the position x,y with respect to the board's top/left?
            xpos = offsetx+(tags100[tag][0]*board_efw/100);
            ypos = offsety+(tags100[tag][1]*board_efh/100);
            //Translate accourding to the board position
            absx = boardtile.x - (boardw/2) + xpos;
            absy = boardtile.y - (boardh/2) + ypos;
            //Update the tile position
            console.log("DELETEME trying to update piece "+JSON.stringify(table.tiles[tileindex]));
            table.tiles[tileindex].x = Math.floor(absx);
            table.tiles[tileindex].y = Math.floor(absy);
            console.log('DELETEME: updated tile position for piece: '+piece._id+' - '+JSON.stringify(table.tiles[tileindex]));
      }
  }

}


//This function is triggered by the capture button/card. Performs all the corresponding checks
//and stores the board in DB
var capture = function() {
  if(preloaded && framesSinceCapture>FRAMESBETWEENCAPTURES){ //We only allow capture once all piece images have been preloaded and can be drawn
    continuous=false;
    var str = JSON.stringify(lastTags);
    var captured = document.getElementById('capturedElements');
    var capturedText = document.createTextNode(str);
    captured.appendChild(capturedText);
    captureBtn.classList.add("disabled");

    var board_present = checkAndStyleBoardCapture(lastTags, videoContBG, captureBtn);
    if(board_present==4){
        // do homography of corners and get which tags are where, see https://uncorkedstudios.com/blog/perspective-transforms-in-javascript
        var transTagPositions = getTransformedTags(lastTags, true); //activate console logging
        console.log('DELETEME: Capture! transformed tag positions: '+JSON.stringify(transTagPositions));
        table.rawchilitags = transTagPositions;
        drawBoard();
        drawCards(transTagPositions, pieces);
        console.log('Tiles before update: '+table.tiles);
        updateTableTilesCapture(transTagPositions);
        console.log('Tiles after update: '+table.tiles);

        var cardRegions = getBoardRegions(transTagPositions, AreaMap100);
        var capturedBoard = lookupCardRegions(cardRegions,pieces);
        console.log('DELETEME: Capture! card regions: '+JSON.stringify(capturedBoard));
        table.cardsboard = capturedBoard;
        //save board as a table into the database
        table.title = table.setup.title + ' ' + Date.now();
        console.log('DELETEME: try to insert in db the table: '+JSON.stringify(table));
        var fd = new FormData(document.forms[0]); //To get the csrf token and other stuff
        fd.append('table', JSON.stringify(table));
        $.ajax({
          url: "/designs/"+table.setup._id+"/createVersion",
          type: "POST",
          data: fd,
          processData: false,
          contentType: false,
          success: function(id) {
            console.log('id', id);
            $('#title').val(table.title+' ('+id+')');
            //TODO: establish two semaphores for both this call and the call to KB?
            //document.location.pathname = '/pieces/' + id;
          },
          error: function (err) {
            console.error(err);
            alert(err.responseJSON ? err.responseJSON.errors.title.message + ': ' + err.responseJSON.errors.title.value : err.statusText );
            //TODO: establish two semaphores for both this call and the call to KB?
            return false;
          }
        });


        var errors=[];
        errors = doSyntaxChecks(cardRegions,pieces);
        displaySyntaxErrors(errors);
        if(errors.length==0){
            var xmlBoard = getXMLFromBoard(capturedBoard);
            doSemanticChecks(xmlBoard);
            //TODO: should probably have some kind of callback to the next part of the code (via semaphores?)
        }




        //scroll to the board map and feedback
        //$('mapareahead').collapse('show'); //For now, the map is always visible
        window.scroll(0,findPos(document.getElementById("mapcontainer")));
    }
  }
}

var retry = function() {
    continuous=true;
    var captured = document.getElementById('capturedElements');
    var capturedText = document.createTextNode('');
    //captured.removeChild(captured.firstChild);
    captured.innerHTML='';
    captured.appendChild(capturedText);
    captureBtn.classList.add("disabled");
    requestAnimationFrame(snapshot);
}

var backCapture = function(){
    window.scroll(0,findPos(document.getElementById("captureWindow")));
    retry();
}

var drawCards = function(tags100, allpieces){
    var c = document.getElementById("boardcanvas");
    var ctx = c.getContext("2d");
    drawnCards = {}; //we erase the data of previously drawn cards
    for(tag in tags100){
        if(tags100[tag][0]>0 &
            tags100[tag][0]<100 &
            tags100[tag][1]>0 &
            tags100[tag][1]<100){ // We draw only the cards INSIDE the four board tags -- that are not contesto, objettivi, contenuto!
              //console.log('found tag '+tag+' at position '+tags100[tag]);
              piece = {};
              for(var i = 0; i < allpieces.length; i++){
                  var tmppiece = allpieces[i];
                  if(tmppiece['chilitags'] && tmppiece['chilitags'][0] && tmppiece['chilitags'][0]===tag){
                      piece = tmppiece;
                      break;
                  }
              }
              if(piece['image'] && piece['image']['files'] && piece['image']['files'][0]){ //If the piece has an image --i.e. we found a piece with that chilitag
                  imgid = "img"+piece['image']['files'][0].substring(0,piece['image']['files'][0].indexOf('.'));
                  //console.log('Retrieving image '+imgid);
                  var img = $('#'+imgid)[0];
                  img.xpos = offsetx+(tags100[tag][0]*board_efw/100);
                  img.ypos = offsety+(tags100[tag][1]*board_efh/100);
                  //console.log("Trying to draw "+img.src+" at "+img.xpos+","+img.ypos+" size "+img.width+"x"+img.height);
                  ctx.drawImage(img, img.xpos-(img.width/2), img.ypos-(img.height*11/20)); //we draw the image with the center where the detected tag is
                  drawnMap = ctx.getImageData(0,0,c.width,c.height);
                  drawnCards[tag] = {
                      xpos: img.xpos,
                      ypos: img.ypos
                  };
                  //console.log('added to drawnCards: '+JSON.stringify(drawnCards[tag]));
              }
        }
    }
}

var drawBoard = function(){
    var c = document.getElementById("boardcanvas");
    var ctx = c.getContext("2d");
    //Look for the board piece _id  57f58b985dcddd50009e8b1a or lockable true
    boardpiece = {};
    for(var i = 0; i < pieces.length; i++){
        piece = pieces[i];
        if(piece['_id']=='57f58b985dcddd50009e8b1a'){
            boardpiece = piece;
            break;
        }
    }
    boardid = "img"+boardpiece['image']['files'][0].substring(0,boardpiece['image']['files'][0].indexOf('.'));
    //console.log('Retrieving image '+boardid);
    var img = $('#'+boardid)[0];
    //console.log("Trying to draw "+img.src);
    ctx.drawImage(img, 0, 0);

}

if (hasGetUserMedia()) {
    console.log("Camera OK");
} else {
    alert("Invalid!");
}

preloadImages();
//drawBoard();

window.URL = window.URL || window.webkitURL;
navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia ||
navigator.mozGetUserMedia || navigator.msGetUserMedia;

navigator.getUserMedia({video: //true
   {
     optional: [
       {minWidth: 320},
       {minWidth: 640},
       {minWidth: 1024},
       {minWidth: 1280},
  //     {minWidth: 1920},
  //     {minWidth: 2560},
     ]
   }
}, function(stream) {
        video.src = window.URL.createObjectURL(stream);
        localMediaStream = stream;
        video.play();
        }, onFailSoHard);

video.addEventListener('play', function() {setTimeout('snapshot()', 2500);}, false);
