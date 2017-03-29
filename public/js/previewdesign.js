var canvas = document.getElementById('previewcanvas');
var ctx = canvas.getContext('2d');

var dim_factor = (1412/500);

var preloaded = false;
var n_preload = 0;
var n_images = 0;

var offsetx = Math.floor(55/dim_factor);//dim_factor?
var offsety = Math.floor(55/dim_factor);//dim_factor?
var boardw = Math.floor(1412/dim_factor);
var boardh = Math.floor(875/dim_factor);
var board_efw = Math.floor(1299/dim_factor);
var board_efh = Math.floor(764/dim_factor);


//TODO: fix image loading order!
//Function that loads all pieces images (id=canvascardXX) at initialization time
var preloadImages = function(){
    console.log("DELETEME preloading images for pieces "+pieces.length);
    var c = document.getElementById("previewcanvas");
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
                console.log("Finished preloading images! Drawing latest version now");
                //We now can draw the board of the latest design version
                drawLatest();
            }
        };
        img.src = image;
        document.getElementById('invisibleimgs').appendChild(img);
    }
    console.log("DELETEME preload images complete");

}


var drawBoard = function(){
    var c = document.getElementById("previewcanvas");
    var ctx = c.getContext("2d");
    //Look for the board piece _id  57f58b985dcddd50009e8b1a or lockable true
    boardpiece = {};
    for(var i = 0; i < pieces.length; i++){
        var piece = pieces[i];
        if(piece['_id']=='57f58b985dcddd50009e8b1a'){
            boardpiece = piece;
            break;
        }
    }
    boardid = "img"+boardpiece['image']['files'][0].substring(0,boardpiece['image']['files'][0].indexOf('.'));
    //console.log('Retrieving image '+boardid);
    var img = document.getElementById(boardid);
    //console.log("Trying to draw "+img.src);
    ctx.drawImage(img, 0, 0, img.width,    img.height,     // source rectangle
                   0, 0, c.width, c.height); // destination rectangle

}

//TODO: add the dim_factor to scale the board down!
var drawCards = function(tags100, allpieces, dim_factor){
    var c = document.getElementById("previewcanvas");
    var ctx = c.getContext("2d");
    console.log("(re-)initializing drawnCards");
    drawnCards = {}; //we erase the data of previously drawn cards
    for(var tag in tags100){
        if(tags100[tag][0]>0 &
            tags100[tag][0]<100 &
            tags100[tag][1]>0 &
            tags100[tag][1]<100){ // We draw only the cards INSIDE the four board tags -- that are not contesto, objettivi, contenuto!
              console.log('found tag '+tag+' at position '+tags100[tag]);
              var piece = {};
              for(var i = 0; i < allpieces.length; i++){
                  var tmppiece = allpieces[i];
                  //console.log("DELETEME in drawCards "+tmppiece['chilitags']+" "+(typeof tmppiece['chilitags'][0] != 'undefined')+" "+tmppiece['chilitags'][0]+" "+tag);
                  if(tmppiece['chilitags'] && (typeof tmppiece['chilitags'][0] != 'undefined') && tmppiece['chilitags'][0]==tag){
                      piece = tmppiece;
                      break;
                  }
              }
              //console.log("DELETEME previous to drawing cards "+JSON.stringify(piece)+" \ndrawnCards "+JSON.stringify(drawnCards));
              if(piece['image'] && piece['image']['files'] && piece['image']['files'][0]){ //If the piece has an image --i.e. we found a piece with that chilitag
                  imgid = "img"+piece['image']['files'][0].substring(0,piece['image']['files'][0].indexOf('.'));
                  //console.log('Retrieving image '+imgid);
                  var img = $('#'+imgid)[0];
                  img.xpos = offsetx+(tags100[tag][0]*board_efw/100);
                  img.ypos = offsety+(tags100[tag][1]*board_efh/100);
                  //console.log("Trying to draw "+img.src+" at "+img.xpos+","+img.ypos+" size "+img.width+"x"+img.height);
                  ctx.drawImage(img, img.xpos-(img.width/(2*dim_factor)), img.ypos-(img.height*11/(20*dim_factor)), img.width/dim_factor, img.height/dim_factor); //we draw the image with the center where the detected tag is
                  drawnMap = ctx.getImageData(0,0,c.width,c.height);
                  drawnCards[tag] = {
                      xpos: img.xpos,
                      ypos: img.ypos
                  };
                  console.log('added to drawnCards: '+JSON.stringify(drawnCards[tag]));
              }
        }
    }
}


var drawLatest = function(){

  drawBoard();
  drawCards(latestversion.rawchilitags, pieces, dim_factor);

}

var drawVersion = function(id){
  drawBoard();
  var version = allversions.filter(function(obj){
    return obj._id == id;
  })[0];//Should return only one version, but just in case
  drawCards(version.rawchilitags, pieces, dim_factor);
}


var screenshotPreview = function(){
	/* CONFIG */

		xOffset = 10;
		yOffset = 30;

		// these 2 variable determine popup's distance from the cursor
		// you might want to adjust to get the right result
    //console.log("DELETEME attaching events..."+$("a.versionlink").length);
	/* END CONFIG */
	$("a.versionlink").hover(function(e){
    //console.log("DELETEME hovered");
    //not need to append - the canvas is already there, only invisible
		//$("body").append("<img id='screenshot'><img src='"+ this.rel +"' alt='url preview' />"+ c +"</p>");
		//$("#hoverPreview").css("display","inline")
		//	.css("top",(e.pageY - xOffset) + "px")
		//	.css("left",(e.pageX + yOffset) + "px")
		//	.fadeIn("fast");
    drawVersion(this.rel);
    },
	function(){
    //console.log("DELETEME UNhovered");
		//$("#hoverPreview").css("display","none");
    drawLatest();
    });
	// $("a.versionlink").mousemove(function(e){
  //   console.log("DELETEME moved");
	// 	$("#hoverPreview")
	// 		.css("top",(e.pageY - xOffset) + "px")
	// 		.css("left",(e.pageX + yOffset) + "px");
	// });
  // console.log("DELETEME ...attached!");

};



//We invoke the preloading of images and the preview of the latest board

preloadImages();

// starting the script on page load
$(document).ready(function(){
	screenshotPreview();
});
