//TODO: add title characters check in the prompts, to match the db restrictions!!

var askdesignlink = $('#captureDesignLink');
if(askdesignlink){
  askdesignlink.on('click', function (e) {
      var designName = prompt('Please insert your design\'s name','');
      if(designName && designName.length>0){
        var linkUrl = "/designs/new/?setupName=COMPLETE%204TS%20SETUP%20EN&capture=true&designName="+encodeURIComponent(designName);
        window.location.href = linkUrl;
      }
  });

}

var askdesignlinkmenu = $('#captureDesignLinkMenu');
if(askdesignlinkmenu){
  askdesignlinkmenu.on('click', function (e) {
      var designName = prompt('Please insert your design\'s name','');
      if(designName && designName.length>0){
        var linkUrl = "/designs/new/?setupName=COMPLETE%204TS%20SETUP%20EN&capture=true&designName="+encodeURIComponent(designName);
        window.location.href = linkUrl;
      }
  });

}


var askDesignCopy = function(url){

  var designName = prompt('Please insert your design\'s name','');
  if(designName && designName.length>0){
    var linkUrl = url+"?designName="+encodeURIComponent(designName);
    window.location.href = linkUrl;
  }

};
