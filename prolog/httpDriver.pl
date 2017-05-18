:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(knowledgeBase).
:- use_module(parserXML).

% The predicate server(+Port) starts the server. It simply creates a
% number of Prolog threads and then returns to the toplevel, so you can
% (re-)load code, debug, etc.
server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Declare a handler, binding an HTTP path to a predicate.
:- http_handler(root(ping), doPing, []).
:- http_handler(root(semantic_check), doCheck, []).
:- http_handler(root(check_from_XML), doCheckXML, []).
:- http_handler(root(listTechniques), doListTechniques, []).
:- http_handler(root(toXML), doToXML, []).

/* The implementation of /. The single argument provides the request
details, which we ignore for now. Our task is to write a CGI-Document:
a number of name: value -pair lines, followed by two newlines, followed
by the document content, The only obligatory header line is the
Content-type: <mime-type> header.
Printing can be done using any Prolog printing predicate, but the
format-family is the most useful. See format/2.   */

doPing(_Request) :-
    format('Content-type: text/html~n~n'),
    format('<!DOCTYPE html>~n<html><body><h1>SWI-PL server is active!</h1>~n'),
	%writeln(Request),
	version(X, Data),
	format('Version: ~s, date: ~s~n</body></html>~n', [X, Data]).
doCheck(Request) :-
    format('Content-type: text/html~n~n'),
    format('<!DOCTYPE html>~n<html><body><h1>Semantic Check</h1><p>'),
	%writeln(Request),
    buildBoard(Request, Board),
    doSemanticCheck(Board, Result),
    Result = result(InconsistentSlots,IncompleteSlots,Suggestions),
    format('<h2>Inconsistent slots</h2>~n<ul>~n'),
    listU(InconsistentSlots),
    format('</ul>~n'),
    format('<h2>Incomplete slots</h2>~n<ul>~n'),
    listU(IncompleteSlots),
    format('</ul>~n'),
    format('<h2>Suggestions</h2>~n<ul>~n'),
    listU(Suggestions),
    format('</ul>~n'),
    format('</p></body></html>').

listU([]).
listU([H|T]) :-
    format('<li>~s</li>~n', [H]),
    listU(T).

doCheckXML(Request) :-
    format('Content-type: text/*~n~n'),
    format('<?xml version="1.0"?>~n', []),
    format('<!DOCTYPE kb-response SYSTEM "kb_out.dtd">~n', []),
    %writeln(Request),
    format('<kb-response>~n', []),
    buildBoardXML(Request, XMLString),
    open_any(string(XMLString), read, XMLBoardRepr, Close, []),
    parseXMLBoardRepr(XMLBoardRepr, PrologBoardRepr),
    %format('board=~w~n', [PrologBoardRepr]),
    close_any(Close),
    doSemanticCheck(PrologBoardRepr, Result),
    Result = result(InconsistentSlots,IncompleteSlots,Suggestions),
    format('  <inconsistent-slots>~n'),
    listPos(InconsistentSlots),
    format('  </inconsistent-slots>~n'),
    format('  <missing-cards>~n'),
    listPos(IncompleteSlots),
    format('  </missing-cards>~n'),
    format('  <suggested-cards>~n'),
    listPos(Suggestions),
    format('  </suggested-cards>~n'),
    format('</kb-response>~n', []).

listPos([]).
listPos([H|T]) :-
    format('    <position>~s</position>~n', [H]),
    listPos(T).

doListTechniques(_Request) :-
    format('Content-type: text/html~n~n'),
    format('<!DOCTYPE html>~n<html><body><h1>Listing of all Techniques</h1><ul>'),
	%writeln(Request),
    describeAllTechniquesHTML(),
    format('</ul></body></html>').

describeAllTechniquesHTML() :-
    technique(TechniqueId, Name, Sequence, NPhase, NMaxPhases),
    format('<li>Technique ~s<br />Phase ~d of ~d in sequence ~s<br />',
           [Name, NPhase, NMaxPhases, Sequence]),
    describe_blueCardsHTML(TechniqueId),
    format('</li>'),
    fail.
describeAllTechniquesHTML().

describe_blueCardsHTML(TechniqueId) :-
    blue_card(TechniqueId, ListOFourTIds),
    %format('Blue Card: ~w~n', [ListOFourTIds]),
    format('Blue Card:<ul>'),
    describe_fourTsHTML(ListOFourTIds),
    format('</ul>'),
    fail.
describe_blueCardsHTML(_TechniqueId).

describe_fourTsHTML([]).
describe_fourTsHTML([FourTId | _FourTIds]) :-
    fourT(FourTId, TaskId, TeamId, TechnologySpec, Time),
    describe_task(TaskId, TaskName),
    describe_team(TeamId, TeamName),
    describe_technology(TechnologySpec, TechnologyNames),
    %format('4Tid: ~d, ', [FourTId]),
    format('<li>task: ~w,<br />team: ~w,<br />technology: ~w (~w),<br />time: ~w</li>~n',
           [TaskName, TeamName, TechnologyNames, TechnologySpec, Time]),
    fail.
describe_fourTsHTML([_FourTId | FourTIds]) :-
    describe_fourTsHTML(FourTIds).

doToXML(Request) :-
    format('Content-type: text/*~n~n'),
    format('<?xml version="1.0"?>~n', []),
    format('<!DOCTYPE board SYSTEM "kb_in.dtd">~n', []),
    toXML(Request, XML_Doc),
    format('~w~n', [XML_Doc]).



/*
doTest1(_Request) :-
    format('Content-type: text/xml~n~n'),
    format('<?xml version="1.0"?>~n'),
    format('<!DOCTYPE board SYSTEM "kb_out.dtd">~n'),
    format('<cards>~n'),
    format('  <alternative>~n'),
    format('    <task-card>solve a problem</task-card>~n'),
    format('    <task-card>prepare a list of questions</task-card>~n'),
    format('  </alternative>~n'),
    format('  <ground-card>~n'),
    format('    <technique-card>~n'),
    format('      <technique-name>Pyramid</technique-name>~n'),
    format('      <technique-phase>2</technique-phase>~n'),
    format('    </technique-card>~n'),
    format('    <position>C2-CSW-TECHNIQUE</position>~n'),
    format('  </ground-card>~n'),
    format('</cards>~n').
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	Board representation:
% board(Context, Goals, Content, ListOfColumns).
%
%       Each column:
% column(ColNumber, HasStar, Technique, Phase,
%      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
%      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2).
%

buildBoardXML(Request, Board) :-
    http_parameters(Request, ['board'(Board, [default('')])]).

buildBoard(Request, Board) :-
    http_parameters(Request,
                    ['C1-CSW-TECHNIQUE'(Technique1, [default('')]),
                     'C1-CSW-PHASE'(Phase1, [default('')]),
                     'C2-CSW-TECHNIQUE'(Technique2, [default('')]),
                     'C2-CSW-PHASE'(Phase2, [default('')]),
                     'C3-CSW-TECHNIQUE'(Technique3, [default('')]),
                     'C3-CSW-PHASE'(Phase3, [default('')]),
                     'C4-CSW-TECHNIQUE'(Technique4, [default('')]),
                     'C4-CSW-PHASE'(Phase4, [default('')]),
                     'C1-ABA-CSS-TASK'(Task1a,  [default('')]),
                     'C1-ABA-CSS-TEAM'(Team1a,  [default('')]),
                     'C2-ABA-CSS-TASK'(Task2a,  [default('')]),
                     'C2-ABA-CSS-TEAM'(Team2a,  [default('')]),
                     'C3-ABA-CSS-TASK'(Task3a,  [default('')]),
                     'C3-ABA-CSS-TEAM'(Team3a,  [default('')]),
                     'C4-ABA-CSS-TASK'(Task4a,  [default('')]),
                     'C4-ABA-CSS-TEAM'(Team4a,  [default('')]),
                     'C1-ABA-CSS-TEC1'(Tecnology1a1,  [default('')]),
                     'C1-ABA-CSS-TEC2'(Tecnology1a2,  [default('')]),
                     'C2-ABA-CSS-TEC1'(Tecnology2a1,  [default('')]),
                     'C2-ABA-CSS-TEC2'(Tecnology2a2,  [default('')]),
                     'C3-ABA-CSS-TEC1'(Tecnology3a1,  [default('')]),
                     'C3-ABA-CSS-TEC2'(Tecnology3a2,  [default('')]),
                     'C4-ABA-CSS-TEC1'(Tecnology4a1,  [default('')]),
                     'C4-ABA-CSS-TEC2'(Tecnology4a2,  [default('')]),
                     'C1-ABB-CSS-TASK'(Task1b,  [default('')]),
                     'C1-ABB-CSS-TEAM'(Team1b,  [default('')]),
                     'C2-ABB-CSS-TASK'(Task2b,  [default('')]),
                     'C2-ABB-CSS-TEAM'(Team2b,  [default('')]),
                     'C3-ABB-CSS-TASK'(Task3b,  [default('')]),
                     'C3-ABB-CSS-TEAM'(Team3b,  [default('')]),
                     'C4-ABB-CSS-TASK'(Task4b,  [default('')]),
                     'C4-ABB-CSS-TEAM'(Team4b,  [default('')]),
                     'C1-ABB-CSS-TEC1'(Tecnology1b1,  [default('')]),
                     'C1-ABB-CSS-TEC2'(Tecnology1b2,  [default('')]),
                     'C2-ABB-CSS-TEC1'(Tecnology2b1,  [default('')]),
                     'C2-ABB-CSS-TEC2'(Tecnology2b2,  [default('')]),
                     'C3-ABB-CSS-TEC1'(Tecnology3b1,  [default('')]),
                     'C3-ABB-CSS-TEC2'(Tecnology3b2,  [default('')]),
                     'C4-ABB-CSS-TEC1'(Tecnology4b1,  [default('')]),
                     'C4-ABB-CSS-TEC2'(Tecnology4b2,  [default('')])
                    ]),
    Col1 =.. [
        column,
        1,
        false,                                  % has star
        Technique1,
        Phase1,
        Task1a,
        Team1a,
        Tecnology1a1,
        Tecnology1a2,
        Task1b,
        Team1b,
        Tecnology1b1,
        Tecnology1b2
    ],
    Col2 =.. [
        column,
        2,
        false,                                  % has star
        Technique2,
        Phase2,
        Task2a,
        Team2a,
        Tecnology2a1,
        Tecnology2a2,
        Task2b,
        Team2b,
        Tecnology2b1,
        Tecnology2b2
    ],
    Col3 =.. [
        column,
        3,
        false,                                  % has star
        Technique3,
        Phase3,
        Task3a,
        Team3a,
        Tecnology3a1,
        Tecnology3a2,
        Task3b,
        Team3b,
        Tecnology3b1,
        Tecnology3b2
    ],
    Col4 =.. [
        column,
        4,
        false,                                  % has star
        Technique4,
        Phase4,
        Task4a,
        Team4a,
        Tecnology4a1,
        Tecnology4a2,
        Task4b,
        Team4b,
        Tecnology4b1,
        Tecnology4b2
    ],
    Board =.. [
        board,
        '',                                     % context
        '',                                     % goals
        '',                                     % content
        [Col1, Col2, Col3, Col4]].              % list of columns





:- server(8000).






















