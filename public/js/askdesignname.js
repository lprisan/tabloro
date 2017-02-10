var askdesignlink = $('#captureDesignLink');
if(askdesignlink){
  askdesignlink.on('click', function (e) {
      var designName = prompt('Please insert your design\'s name','');
      if(designName && designName.length>0){
        if(validateTitle(designName)){
          var linkUrl = "/designs/new/?setupName=COMPLETE%204TS%20SETUP%20EN&capture=true&designName="+encodeURIComponent(designName);
          window.location.href = linkUrl;
        }else{
          alert('Design names should contain only letters, numbers, spaces and underscores');
        }
      }
  });

}

var askdesignlinkmenu = $('#captureDesignLinkMenu');
if(askdesignlinkmenu){
  askdesignlinkmenu.on('click', function (e) {
      var designName = prompt('Please insert your design\'s name','');
      if(designName && designName.length>0){
        if(validateTitle(designName)){
          var linkUrl = "/designs/new/?setupName=COMPLETE%204TS%20SETUP%20EN&capture=true&designName="+encodeURIComponent(designName);
          window.location.href = linkUrl;
        }else{
          alert('Design names should contain only letters, numbers, spaces and underscores');
        }


      }
  });

}


var askDesignCopy = function(url){

  var designName = prompt('Please insert your design\'s name','');
  if(designName && designName.length>0){
    if(validateTitle(designName)){
      var linkUrl = url+"?designName="+encodeURIComponent(designName);
      window.location.href = linkUrl;
    }else{
      alert('Design names should contain only letters, numbers, spaces and underscores');
    }
  }

};


var askDesignDescription = function(original,url){
  var versionDesc = prompt('Please add a short description of this version',original);
  if(versionDesc || versionDesc===''){
    var linkUrl = url+"?desc="+encodeURIComponent(versionDesc);
    window.location.href = linkUrl;
  }
}


var validateTitle = function (string) {
  var match = string.match(/[a-zA-Z0-9_ ]/gi);
  return match && match.join('').length === string.length;
  return true; //We allow special characters, accents, etc.
};
