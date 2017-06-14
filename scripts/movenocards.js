

var db = connect('127.0.0.1:27017/noobjs_dev');
var setupToModify = "COMPLETE 4TS SETUP EN";

var nocnt = ObjectId("5825e7c181933d7b00352787");
var noobj = ObjectId("5825e758d3c3c15d00198072");
var noctx = ObjectId("5825e79781933d7b00352785");

var setup = db.setups.findOne({"title": setupToModify});

newtiles = setup.tiles;

for(var i=0; i<setup.pieces.length; i++){
  var p = setup.pieces[i];
  if(p.toString() == nocnt.toString()){
    print('found nocnt -- '+JSON.stringify(setup.tiles[i]));
    newtiles[i].x = 100;
    newtiles[i].y = 600;
  }else if(p.toString() == noobj.toString()){
    print('found noobj -- '+JSON.stringify(setup.tiles[i]));
    newtiles[i].x = 100;
    newtiles[i].y = 400;
  }else if(p.toString() == noctx.toString()){
    print('found noctx -- '+JSON.stringify(setup.tiles[i]));
    newtiles[i].x = 100;
    newtiles[i].y = 800;
  }


}

db.setups.update(
   {"title": setupToModify},
   {
     $set: { "tiles": newtiles }
   }
)
