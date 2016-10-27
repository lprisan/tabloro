//TODELETE: short-circuit the capture to test the functionality
var capturetest = function(){
  var transTagPositions = {'28': [52.0,50.0]};
  var cardRegions = getBoardRegions(transTagPositions, AreaMap100);
  console.log('cardRegions:\n'+JSON.stringify(cardRegions));
  var errors=[];
  errors = doSyntaxChecks(cardRegions,pieces);
  console.log('errors:\n'+JSON.stringify(errors));
  displaySyntaxErrors(errors);
  if(errors.length==0){
      var capturedBoard = lookupCardRegions(cardRegions,pieces);
      console.log('capturedBoard:\n'+JSON.stringify(capturedBoard));
      var xmlBoard = getXMLFromBoard(capturedBoard);
      doSemanticChecks(xmlBoard); //TODO: should probably have some kind of callback to the next part of the code
  }
  //TODO: save board as a table into the database
  //scroll to the board map and feedback
  //$('mapareahead').collapse('show'); //For now, the map is always visible
  drawBoard();
  drawCards(transTagPositions, pieces, 1412, 875);
  window.scroll(0,findPos(document.getElementById("mapcontainer")));
}
capturetest();
