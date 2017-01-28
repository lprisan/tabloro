var askdesignlink = $('#captureDesignLink');
if(askdesignlink){
  askdesignlink.on('click', function (e) {
      var designName = prompt('Please insert your design\'s name','');
      var linkUrl = "/designs/new/?setupName=COMPLETE%204TS%20SETUP%20EN&capture=true&designName="+encodeURIComponent(designName);
      window.location.href = linkUrl;
  });

}

var askdesignlinkmenu = $('#captureDesignLinkMenu');
if(askdesignlinkmenu){
  askdesignlinkmenu.on('click', function (e) {
      var designName = prompt('Please insert your design\'s name','');
      var linkUrl = "/designs/new/?setupName=COMPLETE%204TS%20SETUP%20EN&capture=true&designName="+encodeURIComponent(designName);
      window.location.href = linkUrl;
  });

}
