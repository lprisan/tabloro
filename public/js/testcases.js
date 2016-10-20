//TODELETE: Tests for Luigi
var emptyBoard = $.extend(true, {}, AreaMap100);
for (area in emptyBoard){ //We just empty the board fields to a string
    emptyBoard[area] = "";
}
emptyBoard.noarea = []; //For tags in the board but outside the delimited areas (will flag up in syntactic check)

var convertTestCases = function(emptyBoard){
    var jscases = {}; //Dictionary where we will put all the test cases board objects
    var singlecase = {};
    //Array of test cases, numbered as the ppt page
    //2
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "?";
    jscases['2'] = singlecase;
    //3
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "?";
    jscases['3'] = singlecase;
    //4
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "?";
    jscases['4'] = singlecase;
    //5
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "?";
    jscases['5'] = singlecase;
    //6
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "SELECTED STUDY MATERIALS";
    singlecase['c1-aba-css-tec2'] = "?";
    jscases['6'] = singlecase;
    //7
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "?";
    singlecase['c1-aba-css-tec2'] = "SELECTED STUDY MATERIALS";
    jscases['7'] = singlecase;
    //8
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "PEER REVIEW - PHASE I";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "SELECTED STUDY MATERIALS";
    singlecase['c2-aba-css-team'] = "?";
    jscases['8'] = singlecase;
    //9
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "ROLE PLAY - PHASE I";
    singlecase['c1-aba-css-task'] = "ASSUMING ROLES";
    singlecase['c1-aba-css-team'] = "SMALL GROUPS";
    singlecase['c1-aba-css-tec1'] = "NO TECHNOLOGY";
    singlecase['c1-abb-css-team'] = "?";
    jscases['9'] = singlecase;
    //10
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "DISCUSSION - PHASE I (ALL CASES)";
    singlecase['c2-csw-technique'] = "?";
    jscases['10'] = singlecase;
    //11
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "PEER REVIEW - PHASE I";
    singlecase['c2-csw-technique'] = "?";
    jscases['11'] = singlecase;
    //12
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "PEER REVIEW - PHASE I";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "SELECTED STUDY MATERIALS";
    singlecase['c1-abb-css-task'] = "?";
    jscases['12'] = singlecase;
    //13
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "SELECTED STUDY MATERIALS";
    singlecase['c2-aba-css-task'] = "PREPARING A PRESENTATION";
    singlecase['c2-aba-css-team'] = "SMALL GROUPS";
    singlecase['c2-aba-css-tec1'] = "FORUM";
    singlecase['c2-abb-css-task'] = "GIVING A PRESENTATION";
    singlecase['c2-abb-css-team'] = "PLENARY";
    singlecase['c2-abb-css-tec1'] = "VIDEOCONFERENCING SYSTEM";
    jscases['13'] = singlecase;
    //14
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "SELECTED STUDY MATERIALS";
    singlecase['c2-aba-css-task'] = "PREPARING A PRESENTATION";
    singlecase['c2-aba-css-team'] = "PLENARY";
    jscases['14'] = singlecase;
    //15
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "SELECTED STUDY MATERIALS";
    singlecase['c1-abb-css-task'] = "PREPARING A PRESENTATION";
    singlecase['c1-abb-css-team'] = "SMALL GROUPS";
    singlecase['c1-abb-css-tec1'] = "FORUM";
    jscases['15'] = singlecase;
    //16
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE I (EXPERT GROUPS)";
    singlecase['c1-aba-css-task'] = "STUDYING";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "SELECTED STUDY MATERIALS";
    singlecase['c2-aba-css-task'] = "PREPARING A PRESENTATION";
    singlecase['c2-aba-css-team'] = "SMALL GROUPS";
    singlecase['c2-aba-css-tec1'] = "FORUM";
    singlecase['c2-abb-css-task'] = "GIVING A PRESENTATION";
    singlecase['c2-abb-css-team'] = "PLENARY";
    singlecase['c2-abb-css-tec1'] = "VIDEOCONFERENCING SYSTEM";
    singlecase['c3-csw-technique'] = "DISCUSSION - PHASE I (ALL CASES)";
    jscases['16'] = singlecase;
    //17
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "JIGSAW - PHASE II (JIGSAW GROUPS)";
    singlecase['c1-aba-css-task'] = "WRITING A REPORT";
    singlecase['c1-aba-css-team'] = "SMALL GROUPS";
    singlecase['c1-aba-css-tec1'] = "TEXT EDITOR";
    singlecase['c1-aba-css-tec2'] = "FORUM";
    jscases['17'] = singlecase;
    //19
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-aba-css-task'] = "WRITING A REPORT";
    singlecase['c1-aba-css-team'] = "SMALL GROUPS";
    singlecase['c1-aba-css-tec1'] = "TEXT EDITOR";
    singlecase['c1-aba-css-tec2'] = "FORUM";
    jscases['19'] = singlecase;
    //20
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-aba-css-task'] = "WRITING A REPORT";
    singlecase['c1-aba-css-team'] = "SMALL GROUPS";
    singlecase['c1-aba-css-tec2'] = "TEXT EDITOR";
    singlecase['c1-aba-css-tec1'] = "FORUM";
    jscases['20'] = singlecase;
    //21
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-aba-css-task'] = "WRITING A REPORT";
    singlecase['c1-aba-css-team'] = "?";
    jscases['21'] = singlecase;
    //22
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-aba-css-task'] = "WRITING A REPORT";
    singlecase['c1-abb-css-task'] = "GIVING A PRESENTATION";
    singlecase['c2-aba-css-task'] = "?";
    jscases['22'] = singlecase;
    //23
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-aba-css-task'] = "?";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    jscases['23'] = singlecase;
    //24
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-aba-css-task'] = "?";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    singlecase['c1-aba-css-tec1'] = "__________";
    jscases['24'] = singlecase;
    //25
    singlecase = $.extend(true, {}, emptyBoard);
    singlecase['c1-csw-technique'] = "?";
    singlecase['c1-aba-css-task'] = "FINDING MATERIALS";
    singlecase['c1-aba-css-team'] = "INDIVIDUAL LEARNERS";
    jscases['25'] = singlecase;

    //For each test case, generate and print an xml file in the console
    for (singlecase in jscases){
        console.log(singlecase+'.xml ==============================================');
        var jscase = jscases[singlecase];
        //Convert to XML and print
        var xmlcase = getXMLFromBoard(jscase);
    }

}
convertTestCases(emptyBoard);
//TODELETE: End
