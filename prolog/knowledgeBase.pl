:- module(knowledgeBase, [technique/5,
                          task/2,
                          team/2,
                          technology/2,
                          blue_card/2,
                          fourT/5,
                          describe_task/2,
                          describe_team/2,
                          describe_technology/2,
                          checkBoard/4,
                          controlCard/1,
                          doAllTestCases/0,
                          doSemanticCheck/2,
                          describe/1,
                          version/2,
                          debug_writeln/1,
                          debug_format/2,
                          is_empty/1,
                          is_not_empty/1,
                          has_question_mark_card/1,
                          not_both_empty/2,
                          technique_column/2]).
:- use_module(parserXML).
:- use_module(correctness).
:- use_module(completeness).

version('2.9', 'May 16, 2017').

/*
 *
 * Card reference
 * https://docs.google.com/spreadsheets/d/17aQHUptQw1W779G23sNhume_IS5h2TMmsOJVh2vo4B0/edit#gid=0
 *
 */

%
% tecnique/5: id, name, sequence, n_phase, n_max_phases
%    0 < id < 100
technique('1', 'JIGSAW - PHASE I (EXPERT GROUPS)', jigsaw, 1, 2).
technique('2', 'JIGSAW - PHASE II (JIGSAW GROUPS)', jigsaw, 2, 2).
technique('3', 'PEER REVIEW - PHASE I', peerreview, 1, 3).
technique('4', 'PEER REVIEW - PHASE II', peerreview, 2, 3).
technique('5', 'PEER REVIEW - PHASE III', peerreview, 3, 3).
technique('6', 'CASE STUDY - PHASE I', casestudy, 1, 2).
technique('7', 'CASE STUDY - PHASE II', casestudy, 2, 2).
technique('8', 'PYRAMID (FOR LIST PREPARATION) - PHASE I', pyramid, 1, 3).
technique('9', 'PYRAMID (FOR LIST PREPARATION) - PHASE II', pyramid, 2, 3).
technique('10', 'PYRAMID (FOR LIST PREPARATION) - PHASE III', pyramid, 3, 3).
technique('11', 'PYRAMID (FOR PROBLEM SOLVING) - PHASE I', pyramid, 1, 3).
technique('12', 'PYRAMID (FOR PROBLEM SOLVING) - PHASE II', pyramid, 2, 3).
technique('13', 'PYRAMID (FOR PROBLEM SOLVING) - PHASE III', pyramid, 3, 3).
technique('14', 'DISCUSSION - PHASE I (ALL CASES)', discussion, 1, 2).
technique('15', 'DISCUSSION (TOWARDS ASSIGNMENT) - PHASE II', discussion, 2, 2).
technique('16', 'DISCUSSION (TOWARDS ARTEFACT) - PHASE II', discussion, 2, 2).
technique('17', 'DISCUSSION (TOWARDS REPORT) - PHASE II', discussion, 2, 2).
technique('18', 'ROLE PLAY - PHASE I', roleplay, 1, 2).
technique('19', 'ROLE PLAY - PHASE II', roleplay, 2, 2).

% Further technique definitions, that provide synonims
% for the above techniques, to accommodate for lexical
% variations in Luis Pablo's XML code
technique('1', 'JIGSAW _ PHASE I _EXPERT GROUPS_', jigsaw, 1, 2).
technique('2', 'JIGSAW _ PHASE II _JIGSAW GROUPS_', jigsaw, 2, 2).
technique('3', 'PEER REVIEW _ PHASE I', peerreview, 1, 3).
technique('4', 'PEER REVIEW _ PHASE II', peerreview, 2, 3).
technique('5', 'PEER REVIEW _ PHASE III', peerreview, 3, 3).
technique('6', 'CASE STUDY _ PHASE I', casestudy, 1, 2).
technique('7', 'CASE STUDY _ PHASE II', casestudy, 2, 2).
technique('8', 'PYRAMID _FOR LIST PREPARATION_ _ PHASE I', pyramid, 1, 3).
technique('9', 'PYRAMID _FOR LIST PREPARATION_ _ PHASE II', pyramid, 2, 3).
technique('10', 'PYRAMID _FOR LIST PREPARATION_ _ PHASE III', pyramid, 3, 3).
technique('11', 'PYRAMID _FOR PROBLEM SOLVING_ _ PHASE I', pyramid, 1, 3).
technique('12', 'PYRAMID _FOR PROBLEM SOLVING_ _ PHASE II', pyramid, 2, 3).
technique('13', 'PYRAMID _FOR PROBLEM SOLVING_ _ PHASE III', pyramid, 3, 3).
technique('14', 'DISCUSSION _ PHASE I _ALL CASES_', discussion, 1, 2).
technique('15', 'DISCUSSION _TOWARDS ASSIGNMENT_ _ PHASE II', discussion, 2, 2).
technique('16', 'DISCUSSION _TOWARDS ARTEFACT_ _ PHASE II', discussion, 2, 2).
technique('17', 'DISCUSSION _TOWARDS REPORT_ _ PHASE II', discussion, 2, 2).
technique('18', 'ROLE PLAY _ PHASE I', roleplay, 1, 2).
technique('19', 'ROLE PLAY _ PHASE II', roleplay, 2, 2).


%
% task/2: id, name
%    100 < id < 200
task('101', 'WRITING A REPORT').
task('102', 'STUDYING').
task('103', 'FINDING MATERIALS').
task('104', 'PREPARING A LIST OF QUESTIONS').
task('105', 'COMMENTING ON SOMEONE ELSE\'S WORK').
task('106', 'PREPARING A PRESENTATION').
task('107', 'CARRYING OUT AN ASSIGNMENT').
task('108', 'GIVING A PRESENTATION').
task('109', 'SOLVING A PROBLEM').
task('110', 'INTERVIEWING AN EXPERT').
task('111', 'ASSUMING ROLES').
task('112', 'PRODUCING AN ARTEFACT').
task('113', 'DEBATING').

% Further task definitions, that provide synonims
% for the above tasks, to accommodate for lexical
% variations in Luis Pablo's XML code
task('105', 'COMMENTING ON SOMEONE ELSE’S WORK').
task('112', 'PRODUCING AN ARTEFACT ').


%
% team/2: id, name
%    200 < id < 300
team('201', 'INDIVIDUAL LEARNERS').
team('202', 'PAIRS').
team('203', 'SMALL GROUPS').
team('204', 'MEDIUM-SIZED GROUPS').
team('205', 'LARGE GROUPS').
team('206', 'PLENARY').

% Further team definitions, that provide synonims
% for the above teams, to accommodate for lexical
% variations in Luis Pablo's XML code
team('204', 'MEDIUM_SIZED GROUPS').


%
% technology/2: id, name
%    300 < id < 400
technology('301', 'FORUM').
technology('302', 'PRESENTATION SOFTWARE').
technology('303', 'INTERACTIVE WHITEBOARD (IWB)').
technology('304', 'WIKI SOFTWARE').
technology('305', 'VIDEOCONFERENCING SYSTEM').
technology('306', 'SELECTED STUDY MATERIALS').
technology('307', 'SOURCE OF MATERIALS FOR LEARNING').
technology('308', 'TEXT EDITOR').
technology('309', 'PROJECTOR').
technology('310', 'NO TECHNOLOGY').
technology('311', 'MATERIALS AND TOOLS FOR PRACTICE').

% Further technology definitions, that provide synonims
% for the above technologies, to accommodate for lexical
% variations in Luis Pablo's XML code
technology('303', 'INTERACTIVE WHITEBOARD _IWB_').


%
% control cards/1: name
%
controlCard('call-for-suggestion').

/*
 *   Board representation:
 *
 *   board(Context, Goals, Content, ListOfColumns).
 *   column(ColNumber, HasStar, Technique, Phase,
 *          TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
 *          TaskABB, TeamABB, TechnologyABB1, TechnologyABB2).
 *
*/

/*
 * Rules for Technique Cards
 *
 * BLUE CARDS --- TECHNIQUES
 * blue_card/2 (techniqueId,
 *              list-of-fourTIds(taskId, teamId, technologyId, time))
 * fourT/5     (fourTId, taskId, teamId, technologyId, time)
 *   400 < fourTId < 500
 *
 * The list-of-fourTIds represents a sequence of tasks with
 * corresponding team and technology. When three tasks are listed, the
 * third is a synchronous plenary activity.
 *
 */

% CARD JIGSAW - PHASE I (EXPERT GROUPS)
blue_card('1', ['401', '402', '403']).

% CARD JIGSAW - PHASE II (JIGSAW GROUPS)
blue_card('2', ['404', '403']).

% CARD PEER REVIEW - PHASE I
blue_card('3', ['401', '405']).

% CARD PEER REVIEW - PHASE II
blue_card('4', ['406']).

% CARD PEER REVIEW - PHASE III
blue_card('5', ['405', '403']).

% CARD CASE STUDY - PHASE I
blue_card('6', ['401', '408']).                       % asynchronous
blue_card('6', ['401', '409']).                       % synchronous

% CARD CASE STUDY - PHASE II
blue_card('7', ['410', '411']).                       % asynchronous
blue_card('7', ['410', '412']).                       % synchronous

% CARD PYRAMID (FOR LIST PREPARATION) - PHASE I
blue_card('8', ['401', '413']).

% CARD PYRAMID (FOR LIST PREPARATION) - PHASE II
blue_card('9', ['414']).

% CARD PYRAMID (FOR LIST PREPARATION) - PHASE III
blue_card('10', ['415']).

% CARD PYRAMID (FOR PROBLEM SOLVING) - PHASE I
blue_card('11', ['401', '416']).

% CARD PYRAMID (FOR PROBLEM SOLVING) - PHASE II
blue_card('12', ['417']).

% CARD PYRAMID (FOR PROBLEM SOLVING) - PHASE III
blue_card('13', ['418']).

% CARD DISCUSSION - PHASE I (ALL CASES)
blue_card('14', ['419', '420']).                      % both asynchronous & synchronous

% CARD DISCUSSION (TOWARDS ASSIGNMENT) - PHASE II
blue_card('15', ['422']).

% CARD DISCUSSION (TOWARDS ARTEFACT) - PHASE II
blue_card('16', ['423']).

% CARD DISCUSSIONN (TOWARDS REPORT) - PHASE II
blue_card('17', ['424']).

% CARD ROLE PLAY - PHASE I
blue_card('18', ['425', '401']).

% CARD ROLE PLAY - PHASE II
blue_card('19', ['426', '403']).

% fourT(Id, TaskId, TeamId, TechnologyId1, Time)

% fourT(404, 101, 203, aut([and([308, 310]), and([308, 301])]),
% time(week(1), _)).
fourT('404', '101', '203', and(['308', '310']), time(week(1), _)).
fourT('404', '101', '203', and(['308', '301']), time(week(1), _)).

%fourT(426, 101, 203, and([308, aut([301, 310])]), time(week(1), _)).
fourT('426', '101', '203', '308', time(week(1), _)).
fourT('426', '101', '203', and(['308', '301']), time(week(1), _)).

%fourT(424, 101, aut([201, 202, 203]), and([308, aut([301, 308])]),
% time(week(2), _)).
fourT('424', '101', '201', '308', time(week(1), _)).
fourT('424', '101', '201', '308', time(week(1), _)).
fourT('424', '101', '202', '308', time(week(1), _)).
fourT('424', '101', '202', and(['308', '301']), time(week(1), _)).
fourT('424', '101', '203', and(['308', '301']), time(week(1), _)).
fourT('424', '101', '203', and(['308', '301']), time(week(1), _)).

fourT('401', '102', '201', '306', time(week(1), _)).

%fourT(410, 102, aut([201, 202, 203]), 306, time(week(1), _)).
fourT('410', '102', '201', '306', time(week(1), _)).
fourT('410', '102', '202', '306', time(week(1), _)).
fourT('410', '102', '203', '306', time(week(1), _)).

%discussion - phase I - all cases - asynchronous
fourT('419', '103', '201', '307', time(week(1), _)).
fourT('420', '113', '206', '305', time(week(1), _)).
fourT('420', '113', '206', '301', time(week(1), _)).
fourT('420', '113', '206', '310', synchronousEvent).


%fourT(406, 105, aut([201, 202, 203]), aut([301, 308]), time(week(1), _)).
fourT('406', '105', '201', '301', time(week(1), _)).
fourT('406', '105', '202', '308', time(week(1), _)).
fourT('406', '105', '203', '301', time(week(1), _)).
fourT('406', '105', '201', '308', time(week(1), _)).
fourT('406', '105', '202', '301', time(week(1), _)).
fourT('406', '105', '203', '308', time(week(1), _)).

%fourT(402, 106, 203, aut([302, and([302, 301])]), time(week(1), _)).
fourT('402', '106', '203', and(['302', '310']), time(week(1), _)).
fourT('402', '106', '203', and(['302', '301']), time(week(1), _)).

%fourT(422, 107, aut([201, 202]), and([311, aut([301, 310])]),
% time(week(2), _)).
fourT('422', '107', '201', and(['311', '301']), time(week(2), _)).
fourT('422', '107', '202', and(['311', '301']), time(week(2), _)).
fourT('422', '107', '201', and(['311', '310']), time(week(2), _)).
fourT('422', '107', '202', and(['311', '310']), time(week(2), _)).

%fourT(403, 108, 206, aut([309, 305']), synchronousEvent).
fourT('403', '108', '206', '305', synchronousEvent).
fourT('403', '108', '206', '309', synchronousEvent).

%fourT(408', 109, aut([202, 203]), 301, time(week(1), _)).
fourT('408', '109', '202', '301', time(week(1), _)).
fourT('408', '109', '203', '301', time(week(1), _)).
%fourT(409, 109, aut([202, 203]), aut([310, 305]), synchronousEvent).
fourT('409', '109', '202', '310', synchronousEvent).
fourT('409', '109', '203', '310', synchronousEvent).
%fourT(416, 109, aut([201, 202]), aut([308, 301, and([301, 308])]),
% time(week(1), _)).
fourT('416', '109', '201', '308', time(week(1), _)).
fourT('416', '109', '201', '301', time(week(1), _)).
fourT('416', '109', '201', and(['301', '308']), time(week(1), _)).
fourT('416', '109', '202', '308', time(week(1), _)).
fourT('416', '109', '202', '301', time(week(1), _)).
fourT('416', '109', '202', and(['301', '308']), time(week(1), _)).
%fourT(417, 109, aut([202, 203]), aut([308, 301, and([301, 308])]),
% time(week(1), _)).
fourT('417', '109', '202', '308', time(week(1), _)).
fourT('417', '109', '202', '301', time(week(1), _)).
fourT('417', '109', '202', and(['301', '308']), time(week(1), _)).
fourT('417', '109', '203', '308', time(week(1), _)).
fourT('417', '109', '203', '301', time(week(1), _)).
fourT('417', '109', '203', and(['301', '308']), time(week(1), _)).
%fourT(418, 109, 206, aut([308, 301, and([301, 308])]), time(week(1),
% _)).
fourT('418', '109', '206', '308', time(week(1), _)).
fourT('418', '109', '206', '301', time(week(1), _)).
fourT('418', '109', '206', and(['301', '308']), time(week(1), _)).

%fourT(425, 111, 203, aut([310, 305]), synchronousEvent).
fourT('425', '111', '203', '305', synchronousEvent).
fourT('425', '111', '203', '310', synchronousEvent).

% fourT(405, 112, aut([201, 202, 203]), and([311, aut([301, 310])]),
% time(week(1), _)).
fourT('405', '112', '201', and(['311', '301']), time(week(1), _)).
fourT('405', '112', '202', and(['311', '301']), time(week(1), _)).
fourT('405', '112', '203', and(['311', '301']), time(week(1), _)).
fourT('405', '112', '201', and(['311', '310']), time(week(1), _)).
fourT('405', '112', '202', and(['311', '310']), time(week(1), _)).
fourT('405', '112', '203', and(['311', '310']), time(week(1), _)).
%fourT(423, 112, aut([202, 203, 206]), and([311, aut([301, 310])]),
% time(week(2), _)).
fourT('423', '112', '202', and(['311', '301']), time(week(2), _)).
fourT('423', '112', '203', and(['311', '301']), time(week(2), _)).
fourT('423', '112', '206', and(['311', '301']), time(week(2), _)).
fourT('423', '112', '202', and(['311', '310']), time(week(2), _)).
fourT('423', '112', '203', and(['311', '310']), time(week(2), _)).
fourT('423', '112', '206', and(['311', '310']), time(week(2), _)).

%fourT(411, 113, aut([202, 203, 206]), 301, time(week(1), _)).
fourT('411', '113', '202', '301', time(week(1), _)).
fourT('411', '113', '203', '301', time(week(1), _)).
fourT('411', '113', '206', '301', time(week(1), _)).
%fourT(412, 113, aut([202, 203, 206]), aut([310, 305]),
% synchronousEvent).
fourT('412', '113', '202', '305', synchronousEvent).
fourT('412', '113', '203', '305', synchronousEvent).
fourT('412', '113', '206', '305', synchronousEvent).
fourT('412', '113', '202', '310', synchronousEvent).
fourT('412', '113', '203', '310', synchronousEvent).
fourT('412', '113', '206', '310', synchronousEvent).
%fourT(421, 113, 206, aut([301, 305]), synchronousEvent).
fourT('421', '113', '206', '301', synchronousEvent).
fourT('421', '113', '206', '305', synchronousEvent).
% prepare a list of question - indiv. learners or pairs
fourT('413', '104', '201', '301', time(week(1), _)).
fourT('413', '104', '201', '308', time(week(1), _)).
fourT('413', '104', '201', and(['308', '301']), time(week(1), _)).
fourT('413', '104', '202', '301', time(week(1), _)).
fourT('413', '104', '202', '308', time(week(1), _)).
fourT('413', '104', '202', and(['308', '301']), time(week(1), _)).
% prepare a list of question - pairs or small groups
fourT('414', '104', '202', '301', time(week(1), _)).
fourT('414', '104', '202', '308', time(week(1), _)).
fourT('414', '104', '202', and(['308', '301']), time(week(1), _)).
fourT('414', '104', '203', '301', time(week(1), _)).
fourT('414', '104', '203', '308', time(week(1), _)).
fourT('414', '104', '203', and(['308', '301']), time(week(1), _)).
% prepare a list of question - plenary
fourT('415', '104', '206', '301', time(week(1), _)).
fourT('415', '104', '206', '308', time(week(1), _)).
fourT('415', '104', '206', and(['308', '301']), time(week(1), _)).


describe(TechniqueId) :-
    technique(TechniqueId, Name, Sequence, NPhase, NMaxPhases),
    format('Technique ~s~nPhase ~d of ~d in sequence ~s~n',
           [Name, NPhase, NMaxPhases, Sequence]),
    describe_blueCards(TechniqueId).

describe_blueCards(TechniqueId) :-
    blue_card(TechniqueId, ListOFourTIds),
    %format('Blue Card: ~w~n', [ListOFourTIds]),
    format('Blue Card:~n'),
    describe_fourTs(ListOFourTIds),
    fail.
describe_blueCards(_TechniqueId).


describe_fourTs([]).
describe_fourTs([FourTId | _FourTIds]) :-
    fourT(FourTId, TaskId, TeamId, TechnologySpec, Time),
    describe_task(TaskId, TaskName),
    describe_team(TeamId, TeamName),
    describe_technology(TechnologySpec, TechnologyNames),
    format('<blockquote>4Tid: ~d<br/>', [FourTId]),
    format('task: ~w,<br/>team: ~w,<br/>technology: ~w (~w),<br/>time: ~w</blockquote>',
           [TaskName, TeamName, TechnologyNames, TechnologySpec, Time]),
    fail.
describe_fourTs([_FourTId | FourTIds]) :-
    describe_fourTs(FourTIds).

describe_task(TaskId, TaskName) :-
    task(TaskId, TaskName),
    !.
describe_task(TaskId, ErrorMessage) :-
    swritef(ErrorMessage, 'Unknown task id ~d', [TaskId]).

describe_team(TeamId, TeamName) :-
    team(TeamId, TeamName),
    !.
describe_team(TeamId, ErrorMessage) :-
    swritef(ErrorMessage, 'Unknown team id ~d', [TeamId]).

describe_technology(and([Tech1Id, Tech2Id]), [Tech1Name, Tech2Name]) :-
    technology(Tech1Id, Tech1Name),
    technology(Tech2Id, Tech2Name),
    !.
describe_technology(TechId, TechName) :-
    technology(TechId, TechName),
    !.
describe_technology(TechnologySpec, ErrorMessage) :-
    swritef(ErrorMessage, 'Unknown technology spec ~d', [TechnologySpec]).


/*****************************************************************/

checkBoard(board(_Context, _Goals, _Content, ListOfColumns),
           InconsistentCardPositions, IncompleteCardPositionPairs,
           SuggestionPairs) :-
    %print_term(ListOfColumns, []),
    checkCorrectness(ListOfColumns, InconsistentCardPositions),
    checkCompleteness(ListOfColumns, IncompleteCardPositionPairs),
    provideSuggestions(ListOfColumns, SuggestionPairs).











% questa maschera le successive, a suo tempo rimuovila.
provideSuggestions(_Cols, []) :- !.
provideSuggestions([], []).
provideSuggestions([ Column | Columns ], Suggestions) :-
    provideSuggestion(Column, Suggestion_thisColumn),
    provideSuggestions(Columns, Suggestion_otherColumns),
    append(Suggestion_thisColumn, Suggestion_otherColumns, Suggestions).

provideSuggestion(Column, Suggestion) :-
    has_question_mark_card(Column),
    !,
    doProvideSuggestion(Column, Suggestion).
provideSuggestion(_Column, []). % no question mark card in this column

doProvideSuggestion(_,_).





    /*
     * +++++++++++ U T I L I T I E S +++++++++++
     *
     * (don't forget to export them)
     */

/*
 *  debug_write  &  debug_format
 *
 *  To remove debugging info just turn the debug/0 predicate to true.
 */

debug :- false.

debug_writeln(X) :-
    debug,
    !,
    writeln(X).
debug_writeln(_X).

debug_format(X, Y) :-
    debug,
    !,
    format(X, Y).
debug_format(_X, _Y).

is_empty(Atom) :- var(Atom) ; atom_length(Atom, 0).
is_not_empty(Atom) :- nonvar(Atom), atom_length(Atom, L), L @>0.

not_both_empty(T1, T2) :-
    is_empty(T1),
    is_empty(T2),
    !,
    fail.
not_both_empty(_T1, _T2).

technique_column(column(_ColNumber, _HasStar, Technique, _Phase,
                        _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
                        _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2),
                 Technique).


append_dl(Xs-Ys, Ys-Zs, Xs-Zs).

has_question_mark_card(
    column(_ColNumber, _HasStar, Technique, _Phase,
           _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
           _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2)) :-
    nonvar(Technique),
    Technique = '?',
    !.
has_question_mark_card(
    column(_ColNumber, _HasStar, _Technique, _Phase,
           TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
           _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2)) :-
    nonvar(TaskABA),
    TaskABA = '?',
    !.
has_question_mark_card(
    column(_ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, TeamABA, _TechnologyABA1, _TechnologyABA2,
           _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2)) :-
    nonvar(TeamABA),
    TeamABA = '?',
    !.
has_question_mark_card(
    column(_ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, TechnologyABA1, _TechnologyABA2,
           _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2)) :-
    nonvar(TechnologyABA1),
    TechnologyABA1 = '?',
    !.
has_question_mark_card(
    column(_ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, _TechnologyABA1, TechnologyABA2,
           _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2)) :-
    nonvar(TechnologyABA2),
    TechnologyABA2 = '?',
    !.
has_question_mark_card(
    column(_ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
           TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2)) :-
    nonvar(TaskABB),
    TaskABB = '?',
    !.
has_question_mark_card(
    column(_ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
           _TaskABB, TeamABB, _TechnologyABB1, _TechnologyABB2)) :-
    nonvar(TeamABB),
    TeamABB = '?',
    !.
has_question_mark_card(
    column(_ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
           _TaskABB, _TeamABB, TechnologyABB1, _TechnologyABB2)) :-
    nonvar(TechnologyABB1),
    TechnologyABB1 = '?',
    !.
has_question_mark_card(
    column(_ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
           _TaskABB, _TeamABB, _TechnologyABB1, TechnologyABB2)) :-
    nonvar(TechnologyABB2),
    TechnologyABB2 = '?',
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	doSemanticCheck: entry point from testdriver module
%
doSemanticCheck(Board,
                result(InconsistentCardPositions,
                       IncompleteCardPositions,
                       Suggestions)) :-
    checkBoard(Board,
               InconsistentCardPositions,
               IncompleteCardPositions,
               Suggestions).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TESTS
%

doSemanticCheckFromFile(XMLFile,
                        result(InconsistentCardPositions,
                               IncompleteCardPositions,
                               Suggestions)) :-
    read_file_to_string(XMLFile, XMLString, []),
    open_any(string(XMLString), read, XMLBoardRepr, Close, []),
    parseXMLBoardRepr(XMLBoardRepr, PrologBoardRepr),

    checkBoard(PrologBoardRepr, InconsistentCardPositions,
               IncompleteCardPositions, Suggestions),
    !,
    /*
    write("Inconsistent card positions: "),
    writeln(InconsistentCardPositions),
    write("Incomplete card positions: "),
    writeln(IncompleteCardPositions),
    write("Suggestions: "),
    writeln(Suggestions),
    write('---\n'),
    */
    close_any(Close).

doAllTestCases :-
    expand_file_name('testCases/AC/*.xml', Fs),
    doTestCases(Fs).

doTestCases([]).
doTestCases([F|Fs]) :-
    doTestCase(F),
    doTestCases(Fs).

doTestCase(F) :-
    file_base_name(F, FBN),
    file_name_extension(Base, _Ext, FBN),
    format('~nTesting case ~w~n', [F]),
    doSemanticCheckFromFile(F, Result),
    matchOracle(Base, Result).

matchOracle(Base, result(ActualInconsistent,
                         ActualIncomplete,
                         ActualSuggested)) :-
    oracle(Base, result(ExpectedInconsistent,
                        ExpectedIncomplete,
                        ExpectedSuggested)),
    matchInconsistent(ActualInconsistent, ExpectedInconsistent),
    matchIncomplete(ActualIncomplete, ExpectedIncomplete),
    matchSuggested(ActualSuggested, ExpectedSuggested),
    !,
    format('Oracle ~w matches~n', [Base]).
matchOracle(Base, ActualResult) :-
    oracle(Base, ExpectedResult),
    !,
    format('Oracle ~w does not match: Expected ~w, Actual ~w~n',
          [Base, ExpectedResult, ActualResult]).
matchOracle(Base, _Result) :-
    format('Oracle ~w not found~n', [Base]).

matchInconsistent(ActualInconsistent, ExpectedInconsistent) :-
    same_length(ActualInconsistent, ExpectedInconsistent),
    matchInconsistent1(ActualInconsistent, ExpectedInconsistent).

matchInconsistent1([], _).
matchInconsistent1([ActualString|Actuals], ExpectedList) :-
    atom_string(ActualAtom, ActualString),
    memberchk(ActualAtom, ExpectedList),
    !,
    matchInconsistent1(Actuals, ExpectedList).


matchIncomplete(_, _).                          % TO DO
matchSuggested(_, _).                           % TO DO

/*
 * testQM scans the set of test cases and, for each test case,
 * checks if a question mark card is present in the board
 * representation.
 * These predicatse have been used to test has_question_mark_card/1,
 * and are now commented out.
 *
testQM :-
    expand_file_name('testCases/??.xml', Fs),
    forall(member(F, Fs), dotestQM(F)).
dotestQM(XMLFile) :-
    read_file_to_string(XMLFile, XMLString, []),
    open_any(string(XMLString), read, XMLBoardRepr, Close, []),
    format('TestQM ~s~n', [XMLFile]),
    parseXMLBoardRepr(XMLBoardRepr, PrologBoardRepr),
    doTestQM1(PrologBoardRepr),
    write('---\n'),
    close_any(Close).
doTestQM1(board(_Context, _Goals, _Content, ListOfColumns)) :-
    doTestQM2(ListOfColumns).
doTestQM2([]).
doTestQM2([Col | Cols]) :-
    doTestQM3(Col),
    doTestQM2(Cols).
doTestQM3(Col) :-
    has_question_mark_card(Col),
    !,
    Col = column(ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
           _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2),
    format('Col ~w has a QM~n', ColNumber).
doTestQM3(column(ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
           _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2)) :-
    format('Col ~w has not a QM~n', ColNumber).
 */

