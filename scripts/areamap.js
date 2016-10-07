var AreaMapMM = {
"capture": [[78,44],[253,130]],
"context": [[83,159],[253,235]],
"goals": [[83,260],[253,460]],
"content": [[83,487],[253,685]],
"c1-csw-technique": [[273,70],[464,190]],
"c1-aba-css-task": [[273,195],[367,314]],
"c1-aba-css-team": [[371,195],[464,314]],
"c1-aba-css-tec1": [[273,318],[367,438]],
"c1-aba-css-tec2": [[371,318],[464,438]],
"c1-abb-css-task": [[273,442],[367,561]],
"c1-abb-css-team": [[371,442],[464,561]],
"c1-abb-css-tec1": [[273,565],[367,684]],
"c1-abb-css-tec2": [[371,565],[464,684]],
"c2-csw-technique": [[468,70],[658,190]],
"c2-aba-css-task": [[468,195],[561,314]],
"c2-aba-css-team": [[565,195],[658,314]],
"c2-aba-css-tec1": [[468,318],[561,438]],
"c2-aba-css-tec2": [[565,318],[658,438]],
"c2-abb-css-task": [[468,442],[561,561]],
"c2-abb-css-team": [[565,442],[658,561]],
"c2-abb-css-tec1": [[468,565],[561,684]],
"c2-abb-css-tec2": [[565,565],[658,684]],
"c3-csw-technique": [[662,70],[853,190]],
"c3-aba-css-task": [[662,195],[755,314]],
"c3-aba-css-team": [[759,195],[853,314]],
"c3-aba-css-tec1": [[662,318],[755,438]],
"c3-aba-css-tec2": [[759,318],[853,438]],
"c3-abb-css-task": [[662,442],[755,561]],
"c3-abb-css-team": [[759,442],[853,561]],
"c3-abb-css-tec1": [[662,565],[755,684]],
"c3-abb-css-tec2": [[759,565],[853,684]],
"c4-csw-technique": [[857,70],[1047,190]],
"c4-aba-css-task": [[857,195],[949,314]],
"c4-aba-css-team": [[953,195],[1047,314]],
"c4-aba-css-tec1": [[857,318],[949,438]],
"c4-aba-css-tec2": [[953,318],[1047,438]],
"c4-abb-css-task": [[857,442],[949,561]],
"c4-abb-css-team": [[953,442],[1047,561]],
"c4-abb-css-tec1": [[857,565],[949,684]],
"c4-abb-css-tec2": [[953,565],[1047,684]]
}

var to100 = function(coords){

    var newx1 = (coords[0][0]-44)*100/1039.5;
    var newy1 = (coords[0][1]-44)*100/611;
    var newx2 = (coords[1][0]-44)*100/1039.5;
    var newy2 = (coords[1][1]-44)*100/611;
    var newcoords = [[newx1,newy1],[newx2,newy2]];
    return newcoords;
}


var AreaMap100 = {
"capture": to100(AreaMapMM['capture']),
"context": to100(AreaMapMM['context']),
"goals": to100(AreaMapMM['goals']),
"content": to100(AreaMapMM['content']),
"c1-csw-technique": to100(AreaMapMM['c1-csw-technique']),
"c1-aba-css-task": to100(AreaMapMM['c1-aba-css-task']),
"c1-aba-css-team": to100(AreaMapMM['c1-aba-css-team']),
"c1-aba-css-tec1": to100(AreaMapMM['c1-aba-css-tec1']),
"c1-aba-css-tec2": to100(AreaMapMM['c1-aba-css-tec2']),
"c1-abb-css-task": to100(AreaMapMM['c1-abb-css-task']),
"c1-abb-css-team": to100(AreaMapMM['c1-abb-css-team']),
"c1-abb-css-tec1": to100(AreaMapMM['c1-abb-css-tec1']),
"c1-abb-css-tec2": to100(AreaMapMM['c1-abb-css-tec2']),
"c2-csw-technique": to100(AreaMapMM['c2-csw-technique']),
"c2-aba-css-task": to100(AreaMapMM['c2-aba-css-task']),
"c2-aba-css-team": to100(AreaMapMM['c2-aba-css-team']),
"c2-aba-css-tec1": to100(AreaMapMM['c2-aba-css-tec1']),
"c2-aba-css-tec2": to100(AreaMapMM['c2-aba-css-tec2']),
"c2-abb-css-task": to100(AreaMapMM['c2-abb-css-task']),
"c2-abb-css-team": to100(AreaMapMM['c2-abb-css-team']),
"c2-abb-css-tec1": to100(AreaMapMM['c2-abb-css-tec1']),
"c2-abb-css-tec2": to100(AreaMapMM['c2-abb-css-tec2']),
"c3-csw-technique": to100(AreaMapMM['c3-csw-technique']),
"c3-aba-css-task": to100(AreaMapMM['c3-aba-css-task']),
"c3-aba-css-team": to100(AreaMapMM['c3-aba-css-team']),
"c3-aba-css-tec1": to100(AreaMapMM['c3-aba-css-tec1']),
"c3-aba-css-tec2": to100(AreaMapMM['c3-aba-css-tec2']),
"c3-abb-css-task": to100(AreaMapMM['c3-abb-css-task']),
"c3-abb-css-team": to100(AreaMapMM['c3-abb-css-team']),
"c3-abb-css-tec1": to100(AreaMapMM['c3-abb-css-tec1']),
"c3-abb-css-tec2": to100(AreaMapMM['c3-abb-css-tec2']),
"c4-csw-technique": to100(AreaMapMM['c4-csw-technique']),
"c4-aba-css-task": to100(AreaMapMM['c4-aba-css-task']),
"c4-aba-css-team": to100(AreaMapMM['c4-aba-css-team']),
"c4-aba-css-tec1": to100(AreaMapMM['c4-aba-css-tec1']),
"c4-aba-css-tec2": to100(AreaMapMM['c4-aba-css-tec2']),
"c4-abb-css-task": to100(AreaMapMM['c4-abb-css-task']),
"c4-abb-css-team": to100(AreaMapMM['c4-abb-css-team']),
"c4-abb-css-tec1": to100(AreaMapMM['c4-abb-css-tec1']),
"c4-abb-css-tec2": to100(AreaMapMM['c4-abb-css-tec2'])
}

var AreaMap100 = {"capture":[[3.270803270803271,0],[20.105820105820104,14.075286415711947]],"context":[[3.751803751803752,18.821603927986907],[20.105820105820104,31.26022913256956]],"goals":[[3.751803751803752,35.3518821603928],[20.105820105820104,68.08510638297872]],"content":[[3.751803751803752,72.50409165302783],[20.105820105820104,104.9099836333879]],"c1-csw-technique":[[22.02982202982203,4.25531914893617],[40.4040404040404,23.895253682487724]],"c1-aba-css-task":[[22.02982202982203,24.713584288052374],[31.072631072631072,44.189852700490995]],"c1-aba-css-team":[[31.457431457431458,24.713584288052374],[40.4040404040404,44.189852700490995]],"c1-aba-css-tec1":[[22.02982202982203,44.84451718494272],[31.072631072631072,64.48445171849427]],"c1-aba-css-tec2":[[31.457431457431458,44.84451718494272],[40.4040404040404,64.48445171849427]],"c1-abb-css-task":[[22.02982202982203,65.13911620294598],[31.072631072631072,84.61538461538461]],"c1-abb-css-team":[[31.457431457431458,65.13911620294598],[40.4040404040404,84.61538461538461]],"c1-abb-css-tec1":[[22.02982202982203,85.27004909983633],[31.072631072631072,104.74631751227496]],"c1-abb-css-tec2":[[31.457431457431458,85.27004909983633],[40.4040404040404,104.74631751227496]],"c2-csw-technique":[[40.78884078884079,4.25531914893617],[59.06685906685907,23.895253682487724]],"c2-aba-css-task":[[40.78884078884079,24.713584288052374],[49.735449735449734,44.189852700490995]],"c2-aba-css-team":[[50.12025012025012,24.713584288052374],[59.06685906685907,44.189852700490995]],"c2-aba-css-tec1":[[40.78884078884079,44.84451718494272],[49.735449735449734,64.48445171849427]],"c2-aba-css-tec2":[[50.12025012025012,44.84451718494272],[59.06685906685907,64.48445171849427]],"c2-abb-css-task":[[40.78884078884079,65.13911620294598],[49.735449735449734,84.61538461538461]],"c2-abb-css-team":[[50.12025012025012,65.13911620294598],[59.06685906685907,84.61538461538461]],"c2-abb-css-tec1":[[40.78884078884079,85.27004909983633],[49.735449735449734,104.74631751227496]],"c2-abb-css-tec2":[[50.12025012025012,85.27004909983633],[59.06685906685907,104.74631751227496]],"c3-csw-technique":[[59.45165945165945,4.25531914893617],[77.82587782587782,23.895253682487724]],"c3-aba-css-task":[[59.45165945165945,24.713584288052374],[68.3982683982684,44.189852700490995]],"c3-aba-css-team":[[68.78306878306879,24.713584288052374],[77.82587782587782,44.189852700490995]],"c3-aba-css-tec1":[[59.45165945165945,44.84451718494272],[68.3982683982684,64.48445171849427]],"c3-aba-css-tec2":[[68.78306878306879,44.84451718494272],[77.82587782587782,64.48445171849427]],"c3-abb-css-task":[[59.45165945165945,65.13911620294598],[68.3982683982684,84.61538461538461]],"c3-abb-css-team":[[68.78306878306879,65.13911620294598],[77.82587782587782,84.61538461538461]],"c3-abb-css-tec1":[[59.45165945165945,85.27004909983633],[68.3982683982684,104.74631751227496]],"c3-abb-css-tec2":[[68.78306878306879,85.27004909983633],[77.82587782587782,104.74631751227496]],"c4-csw-technique":[[78.21067821067821,4.25531914893617],[96.48869648869649,23.895253682487724]],"c4-aba-css-task":[[78.21067821067821,24.713584288052374],[87.06108706108706,44.189852700490995]],"c4-aba-css-team":[[87.44588744588745,24.713584288052374],[96.48869648869649,44.189852700490995]],"c4-aba-css-tec1":[[78.21067821067821,44.84451718494272],[87.06108706108706,64.48445171849427]],"c4-aba-css-tec2":[[87.44588744588745,44.84451718494272],[96.48869648869649,64.48445171849427]],"c4-abb-css-task":[[78.21067821067821,65.13911620294598],[87.06108706108706,84.61538461538461]],"c4-abb-css-team":[[87.44588744588745,65.13911620294598],[96.48869648869649,84.61538461538461]],"c4-abb-css-tec1":[[78.21067821067821,85.27004909983633],[87.06108706108706,104.74631751227496]],"c4-abb-css-tec2":[[87.44588744588745,85.27004909983633],[96.48869648869649,104.74631751227496]]}
