:- module(parserXML, [parseXMLBoardRepr/2,
                      isColumnEmpty/1,
                      parseAllTestCases/0,
                      toXML/2]).
:- use_module(knowledgeBase).
:- use_module(library(sgml)).
:- use_module(library(http/http_parameters)).


%%	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

doTestFromString(XMLString) :-
    open_any(string(XMLString), read, XMLBoardRepr, Close, []),
    parseXMLBoardRepr(XMLBoardRepr, PrologBoardRepr),
    %print_term(PrologBoardRepr, []),
    checkBoard(PrologBoardRepr, IncorrectSlots, IncompleteSlots, Suggestions),
    print_term(IncorrectSlots, []),
    print_term(IncompleteSlots, []),
    print_term(Suggestions, []),
    close_any(Close).

doTestFromFile(XMLFile) :-
    write('\n\nTesting file: '),
    writeln(XMLFile),
    read_file_to_string(XMLFile, Str, []),
    doTestFromString(Str).

parseXMLBoardRepr(XMLBoardRepr, PrologBoardRepr) :-
    new_dtd(board, Dtd),
    load_dtd(Dtd, 'kb_in.dtd'),
    load_xml(stream(XMLBoardRepr), ParsedList, [dtd(Dtd)]),
    %print_term(ParsedList,[]),
    buildBoardRepr(ParsedList, PrologBoardRepr).


/*
 *	Board representation:
 *  board(Context, Goals, Content, ListOfColumns)
 *
*/
buildBoardRepr(
    [ element(board,
              [],
              [ element(context, [], [ContextRepr]),
                element(goals, [], GoalList),
                element(content, [], [ContentRepr]),
                element(columns, [], Columns) ])],
    board(ContextRepr, GoalsRepr, ContentRepr, ColumnsRepr)) :-
    buildGoalsRepr(GoalList, GoalsRepr),
    buildColumnsRepr(Columns, ColumnsRepr).

buildGoalsRepr([], []).
buildGoalsRepr([ element(goal, [], [GoalRepr]) | Goals ],
               [ GoalRepr | GoalsRepr ]) :-
    buildGoalsRepr(Goals, GoalsRepr).

/*
 *  Column representation:
 *   column(ColNumber, HasStar, Technique, Phase,
 *          TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
 *          TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
 *
 *   A 'call-for-suggestion' card in the technique slot is
 *   dealt with by a special case of the buildColumnsRepr predicate.
 *
 *   A 'call-for-suggestion' card in any other slot is
 *   dealt with by the extractName/2 predicate.
 *
 *   Whenever the parser reports an empty card slot, the corresonding
 *   element in the Prolog column term is left free.
 *
*/
buildColumnsRepr([], []).
buildColumnsRepr([ element(column,              % base case
                           [ id=ColumnId, hasStar=HasStar ],
                           [ element('csw-technique', [],
                                     [ element('technique-name', [],
                                               TechniqueNameL),
                                       element('technique-phase', [],
                                               TechniquePhaseL) ]),
                             element('aba-css-task', [], AbaTaskL),
                             element('aba-css-team', [], AbaTeamL),
                             element('aba-css-tec1', [], AbaTec1L),
                             element('aba-css-tec2', [], AbaTec2L),
                             element('abb-css-task', [], AbbTaskL),
                             element('abb-css-team', [], AbbTeamL),
                             element('abb-css-tec1', [], AbbTec1L),
                             element('abb-css-tec2', [], AbbTec2L) ])
                 | Columns ],
                 [ column(ColNumber, HasStar,   TechniqueId, TechniquePhase,
                          AbaTaskId, AbaTeamId, AbaTec1Id,   AbaTec2Id,
                          AbbTaskId, AbbTeamId, AbbTec1Id,   AbbTec2Id)
                 | ColumnsRepr ]) :-
    !,
    atom_number(ColumnId, ColNumber),
    extractTechniqueId(TechniqueNameL, TechniqueId),
    extractTechniquePhase(TechniquePhaseL, TechniquePhase),
    extractTaskId(AbaTaskL, AbaTaskId),
    extractTeamId(AbaTeamL, AbaTeamId),
    extractTechnologyId(AbaTec1L, AbaTec1Id),
    extractTechnologyId(AbaTec2L, AbaTec2Id),
    extractTaskId(AbbTaskL, AbbTaskId),
    extractTeamId(AbbTeamL, AbbTeamId),
    extractTechnologyId(AbbTec1L, AbbTec1Id),
    extractTechnologyId(AbbTec2L, AbbTec2Id),
    buildColumnsRepr(Columns, ColumnsRepr).
buildColumnsRepr([ element(column,              % call-for-suggestion in technique
                           [ id=ColumnId, hasStar=HasStar ],
                           [ element('csw-technique', [],
                                     [ element(CallForSuggestionName, [], [])]),
                             element('aba-css-task', [], AbaTaskL),
                             element('aba-css-team', [], AbaTeamL),
                             element('aba-css-tec1', [], AbaTec1L),
                             element('aba-css-tec2', [], AbaTec2L),
                             element('abb-css-task', [], AbbTaskL),
                             element('abb-css-team', [], AbbTeamL),
                             element('abb-css-tec1', [], AbbTec1L),
                             element('abb-css-tec2', [], AbbTec2L) ])
                 | Columns ],
                 [ column(ColNumber, HasStar, '?', 0,
                          AbaTaskId, AbaTeamId, AbaTec1Id,   AbaTec2Id,
                          AbbTaskId, AbbTeamId, AbbTec1Id,   AbbTec2Id)
                 | ColumnsRepr ]) :-
    atom_number(ColumnId, ColNumber),
    controlCard(CallForSuggestionName),
    extractTaskId(AbaTaskL, AbaTaskId),
    extractTeamId(AbaTeamL, AbaTeamId),
    extractTechnologyId(AbaTec1L, AbaTec1Id),
    extractTechnologyId(AbaTec2L, AbaTec2Id),
    extractTaskId(AbbTaskL, AbbTaskId),
    extractTeamId(AbbTeamL, AbbTeamId),
    extractTechnologyId(AbbTec1L, AbbTec1Id),
    extractTechnologyId(AbbTec2L, AbbTec2Id),
    buildColumnsRepr(Columns, ColumnsRepr).


/* The parser often builds lists of one or zero elements.
The predicates extract<XXX>Id/2 unify the 2nd arg with the single
element if it exists, or with an empty atom '' if the list is empty.
The 1st arg list should never contain more than one element.
The 1st arg should always be a list.
*/
extractTechniqueId([], '') :- !.
extractTechniqueId(TechniqueNameL, TechniqueId) :-
    extractName(TechniqueNameL, TechniqueName),
    technique(TechniqueId, TechniqueName, _, _, _),
    !.
extractTechniqueId(TechniqueNameL, _TechniqueId) :-
    write("Unknown technique: "),
    writeln(TechniqueNameL).

extractTechniquePhase([], _) :- !.
extractTechniquePhase(TechniquePhaseL, TechniquePhase) :-
    extractName(TechniquePhaseL, TechniquePhase).

extractTaskId([], '') :- !.
extractTaskId(TaskNameL, TaskId) :-
    extractName(TaskNameL, TaskName),
    task(TaskId, TaskName),
    !.
extractTaskId(TaskNameL, '?') :-
    extractName(TaskNameL, '?'),
    !.
extractTaskId(TaskNameL, _TaskId) :-
    write("Unknown task: "),
    writeln(TaskNameL).

extractTeamId([], '') :- !.
extractTeamId(TeamNameL, TeamId) :-
    extractName(TeamNameL, TeamName),
    team(TeamId, TeamName),
    !.
extractTeamId(TeamNameL, '?') :-
    extractName(TeamNameL, '?'),
    !.
extractTeamId(TeamNameL, _TeamId) :-
    write("Unknown team: "),
    writeln(TeamNameL).

extractTechnologyId([], '') :- !.
extractTechnologyId(TechnologyNameL, TechnologyId) :-
    extractName(TechnologyNameL, TechnologyName),
    technology(TechnologyId, TechnologyName),
    !.
extractTechnologyId(TechnologyNameL, '?') :-
    extractName(TechnologyNameL, '?'),
    !.
extractTechnologyId(TechnologyNameL, _TechnologyId) :-
    write("Unknown technology: "),
    writeln(TechnologyNameL).

extractName([], 'doh!') :- !.                   % should never happen
extractName([ element(CallForSuggestionName,[],[]) ], '?') :-
    controlCard(CallForSuggestionName),
    !.
extractName([ Name ], '') :-
    var(Name),
    !.
extractName([ Name ], Name) :-
    nonvar(Name),
    !.
extractName([ _ | _ ], 'doh!') :- !.            % should never happen
extractName(_, 'doh!').                         % should never happen

%%%%%%%%%%%%%%%%%%

isColumnEmpty(column(_ColNumber,_HasStar, Technique, _Phase,
                     TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                     TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)) :-
    var(Technique),
    var(TaskABA),
    var(TeamABA),
    var(TechnologyABA1),
    var(TechnologyABA2),
    var(TaskABB),
    var(TeamABB),
    var(TechnologyABB1),
    var(TechnologyABB2).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TESTS
%

doTest1 :-
    doTestFromString('
<?xml version="1.0"?>
<!DOCTYPE board SYSTEM "kb_in.dtd">
<board>
  <context>This is a text describing the context</context>
  <goals>
    <goal>This is a text describing a goal</goal>
    <goal>This is a text describing another goal</goal>
  </goals>
  <content>This is a text describing some content</content>
  <columns>
    <column id="1">
      <csw-technique>
        <technique-name>JIGSAW</technique-name>
	<technique-phase>1</technique-phase>
      </csw-technique>
      <aba-css-task>study</aba-css-task>
      <aba-css-team>small group</aba-css-team>
      <aba-css-tec1>software for presentations</aba-css-tec1>
      <aba-css-tec2 />
      <abb-css-task />
      <abb-css-team />
      <abb-css-tec1 />
      <abb-css-tec2 />
    </column>
    <column id="2">
      <csw-technique>
        <technique-name>JIGSAW</technique-name>
	<technique-phase>2</technique-phase>
      </csw-technique>
      <aba-css-task>write a report</aba-css-task>
      <aba-css-team>small group</aba-css-team>
      <aba-css-tec1>text editor</aba-css-tec1>
      <aba-css-tec2 />
      <abb-css-task />
      <abb-css-team />
      <abb-css-tec1 />
      <abb-css-tec2 />
    </column>
    <column id="3">
      <csw-technique>
        <technique-name />
	<technique-phase />
      </csw-technique>
      <aba-css-task />
      <aba-css-team />
      <aba-css-tec1 />
      <aba-css-tec2 />
      <abb-css-task />
      <abb-css-team />
      <abb-css-tec1 />
      <abb-css-tec2 />
   </column>
   <column id="4">
      <csw-technique>
        <technique-name />
	<technique-phase />
      </csw-technique>
      <aba-css-task />
      <aba-css-team />
      <aba-css-tec1 />
      <aba-css-tec2 />
      <abb-css-task />
      <abb-css-team />
      <abb-css-tec1 />
      <abb-css-tec2 />
   </column>
  </columns>
</board>
    ').

parseAllTestCases :-
    expand_file_name('testCases/??.xml', Fs),
    forall(member(F, Fs), doTestFromFile(F)).

/*********************************************/

toXML(Request, XML_Doc) :-
    http_parameters(Request,
                    ['context'(Context, [default('')]),
                     'objectives'(Objectives, [default('')]),
                     'content'(Content, [default('')]),
                     'C1-CSW-TECHNIQUE'(Technique1, [default('')]),
                     %'C1-CSW-PHASE'(Phase1, [default('')]),
                     'C2-CSW-TECHNIQUE'(Technique2, [default('')]),
                     %'C2-CSW-PHASE'(Phase2, [default('')]),
                     'C3-CSW-TECHNIQUE'(Technique3, [default('')]),
                     %'C3-CSW-PHASE'(Phase3, [default('')]),
                     'C4-CSW-TECHNIQUE'(Technique4, [default('')]),
                     %'C4-CSW-PHASE'(Phase4, [default('')]),
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

    ( (var(Technique1) ; atom_length(Technique1, 0)) ->
      ( Technique1Name = '',
        Phase1 = 0) ;
      (%atom_number(Technique1, Technique1Id),
       technique(Technique1, Technique1Name, _, Phase1, _))),

    ( (var(Technique2) ; atom_length(Technique2, 0)) ->
      ( Technique2Name = '',
        Phase2 = 0) ;
      (%atom_number(Technique2, Technique2Id),
       technique(Technique2, Technique2Name, _, Phase2, _))),

    ( (var(Technique3) ; atom_length(Technique3, 0)) ->
      ( Technique3Name = '',
        Phase3 = 0) ;
      (%atom_number(Technique3, Technique3Id),
       technique(Technique3, Technique3Name, _, Phase3, _))),

    ( (var(Technique4) ; atom_length(Technique4, 0)) ->
      ( Technique4Name = '',
        Phase4 = 0) ;
      (%atom_number(Technique4, Technique4Id),
        technique(Technique4, Technique4Name, _, Phase4, _))),

    ( (var(Task1a) ; atom_length(Task1a, 0)) ->
      ( Task1aName = '') ;
      ( %atom_number(Task1a, Task1aId),
        task(Task1a, Task1aName))),

    ( (var(Task2a) ; atom_length(Task2a, 0)) ->
      ( Task2aName = '') ;
      ( %atom_number(Task2a, Task2aId),
        task(Task2a, Task2aName))),

    ( (var(Task3a) ; atom_length(Task3a, 0)) ->
      ( Task3aName = '') ;
      ( %atom_number(Task3a, Task3aId),
        task(Task3a, Task3aName))),

    ( (var(Task4a) ; atom_length(Task4a, 0)) ->
      ( Task4aName = '') ;
      ( %atom_number(Task4a, Task4aId),
        task(Task4a, Task4aName))),

    ( (var(Task1b) ; atom_length(Task1b, 0)) ->
      ( Task1bName = '') ;
      ( %atom_number(Task1b, Task1bId),
        task(Task1b, Task1bName))),

    ( (var(Task2b) ; atom_length(Task2b, 0)) ->
      ( Task2bName = '') ;
      ( %atom_number(Task2b, Task2bId),
        task(Task2b, Task2bName))),

    ( (var(Task3b) ; atom_length(Task3b, 0)) ->
      ( Task3bName = '') ;
      ( %atom_number(Task3b, Task3bId),
        task(Task3b, Task3bName))),

    ( (var(Task4b) ; atom_length(Task4b, 0)) ->
      ( Task4bName = '') ;
      ( %atom_number(Task4b, Task4bId),
        task(Task4b, Task4bName))),

    ( (var(Team1a) ; atom_length(Team1a, 0)) ->
      ( Team1aName = '') ;
      ( %atom_number(Team1a, Team1aId),
        team(Team1a, Team1aName))),

    ( (var(Team2a) ; atom_length(Team2a, 0)) ->
      ( Team2aName = '') ;
      ( %atom_number(Team2a, Team2aId),
        team(Team2a, Team2aName))),

    ( (var(Team3a) ; atom_length(Team3a, 0)) ->
      ( Team3aName = '') ;
      ( %atom_number(Team3a, Team3aId),
        team(Team3a, Team3aName))),

    ( (var(Team4a) ; atom_length(Team4a, 0)) ->
      ( Team4aName = '') ;
      ( %atom_number(Team4a, Team4aId),
        team(Team4a, Team4aName))),

    ( (var(Team1b) ; atom_length(Team1b, 0)) ->
      ( Team1bName = '') ;
      ( %atom_number(Team1b, Team1bId),
        team(Team1b, Team1bName))),

    ( (var(Team2b) ; atom_length(Team2b, 0)) ->
      ( Team2bName = '') ;
      ( %atom_number(Team2b, Team2bId),
        team(Team2b, Team2bName))),

    ( (var(Team3b) ; atom_length(Team3b, 0)) ->
      ( Team3bName = '') ;
      ( %atom_number(Team3b, Team3bId),
        team(Team3b, Team3bName))),

    ( (var(Team4b) ; atom_length(Team4b, 0)) ->
      ( Team4bName = '') ;
      ( %atom_number(Team4b, Team4bId),
        team(Team4b, Team4bName))),

    ( (var(Tecnology1a1) ; atom_length(Tecnology1a1, 0)) ->
      ( Tecnology1a1Name = '') ;
      ( %atom_number(Tecnology1a1, Tecnology1a1Id),
        technology(Tecnology1a1, Tecnology1a1Name))),

    ( (var(Tecnology1a2) ; atom_length(Tecnology1a2, 0)) ->
      ( Tecnology1a2Name = '') ;
      ( %atom_number(Tecnology1a2, Tecnology1a2Id),
        technology(Tecnology1a2, Tecnology1a2Name))),

    ( (var(Tecnology1b1) ; atom_length(Tecnology1b1, 0)) ->
      ( Tecnology1b1Name = '') ;
      ( %atom_number(Tecnology1b1, Tecnology1b1Id),
        technology(Tecnology1b1, Tecnology1b1Name))),

    ( (var(Tecnology1b2) ; atom_length(Tecnology1b2, 0)) ->
      ( Tecnology1b2Name = '') ;
      ( %atom_number(Tecnology1b2, Tecnology1b2Id),
        technology(Tecnology1b2, Tecnology1b2Name))),

    ( (var(Tecnology2a1) ; atom_length(Tecnology2a1, 0)) ->
      ( Tecnology2a1Name = '') ;
      ( %atom_number(Tecnology2a1, Tecnology2a1Id),
        technology(Tecnology2a1, Tecnology2a1Name))),

    ( (var(Tecnology2a2) ; atom_length(Tecnology2a2, 0)) ->
      ( Tecnology2a2Name = '') ;
      ( %atom_number(Tecnology2a2, Tecnology2a2Id),
        technology(Tecnology2a2, Tecnology2a2Name))),

    ( (var(Tecnology2b1) ; atom_length(Tecnology2b1, 0)) ->
      ( Tecnology2b1Name = '') ;
      ( %atom_number(Tecnology2b1, Tecnology2b1Id),
        technology(Tecnology2b1, Tecnology2b1Name))),

    ( (var(Tecnology2b2) ; atom_length(Tecnology2b2, 0)) ->
      ( Tecnology2b2Name = '') ;
      ( %atom_number(Tecnology2b2, Tecnology2b2Id),
        technology(Tecnology2b2, Tecnology2b2Name))),

    ( (var(Tecnology3a1) ; atom_length(Tecnology3a1, 0)) ->
      ( Tecnology3a1Name = '') ;
      ( %atom_number(Tecnology3a1, Tecnology3a1Id),
        technology(Tecnology3a1, Tecnology3a1Name))),

    ( (var(Tecnology3a2) ; atom_length(Tecnology3a2, 0)) ->
      ( Tecnology3a2Name = '') ;
      ( %atom_number(Tecnology3a2, Tecnology3a2Id),
        technology(Tecnology3a2, Tecnology3a2Name))),

    ( (var(Tecnology3b1) ; atom_length(Tecnology3b1, 0)) ->
      ( Tecnology3b1Name = '') ;
      ( %atom_number(Tecnology3b1, Tecnology3b1Id),
        technology(Tecnology3b1, Tecnology3b1Name))),

    ( (var(Tecnology3b2) ; atom_length(Tecnology3b2, 0)) ->
      ( Tecnology3b2Name = '') ;
      ( %atom_number(Tecnology3b2, Tecnology3b2Id),
        technology(Tecnology3b2, Tecnology3b2Name))),

    ( (var(Tecnology4a1) ; atom_length(Tecnology4a1, 0)) ->
      ( Tecnology4a1Name = '') ;
      ( %atom_number(Tecnology4a1, Tecnology4a1Id),
        technology(Tecnology4a1, Tecnology4a1Name))),

    ( (var(Tecnology4a2) ; atom_length(Tecnology4a2, 0)) ->
      ( Tecnology4a2Name = '') ;
      ( %atom_number(Tecnology4a2, Tecnology4a2Id),
        technology(Tecnology4a2, Tecnology4a2Name))),

    ( (var(Tecnology4b1) ; atom_length(Tecnology4b1, 0)) ->
      ( Tecnology4b1Name = '') ;
      ( %atom_number(Tecnology4b1, Tecnology4b1Id),
        technology(Tecnology4b1, Tecnology4b1Name))),

    ( (var(Tecnology4b2) ; atom_length(Tecnology4b2, 0)) ->
      ( Tecnology4b2Name = '') ;
      ( %atom_number(Tecnology4b2, Tecnology4b2Id),
        technology(Tecnology4b2, Tecnology4b2Name))),


    format(string(XML_Doc),
'<board>
  <context>~w</context>
  <goals>
    <goal>~w</goal>
  </goals>
  <content>~w</content>
  <columns>
    <column id="1">
      <csw-technique>
        <technique-name>~w</technique-name>
        <technique-phase>~d</technique-phase>
      </csw-technique>
      <aba-css-task>~w</aba-css-task>
      <aba-css-team>~w</aba-css-team>
      <aba-css-tec1>~w</aba-css-tec1>
      <aba-css-tec2>~w</aba-css-tec2>
      <abb-css-task>~w</abb-css-task>
      <abb-css-team>~w</abb-css-team>
      <abb-css-tec1>~w</abb-css-tec1>
      <abb-css-tec2>~w</abb-css-tec2>
    </column>
    <column id="2">
      <csw-technique>
        <technique-name>~w</technique-name>
        <technique-phase>~d</technique-phase>
      </csw-technique>
      <aba-css-task>~w</aba-css-task>
      <aba-css-team>~w</aba-css-team>
      <aba-css-tec1>~w</aba-css-tec1>
      <aba-css-tec2>~w</aba-css-tec2>
      <abb-css-task>~w</abb-css-task>
      <abb-css-team>~w</abb-css-team>
      <abb-css-tec1>~w</abb-css-tec1>
      <abb-css-tec2>~w</abb-css-tec2>
    </column>
    <column id="3">
      <csw-technique>
        <technique-name>~w</technique-name>
        <technique-phase>~d</technique-phase>
      </csw-technique>
      <aba-css-task>~w</aba-css-task>
      <aba-css-team>~w</aba-css-team>
      <aba-css-tec1>~w</aba-css-tec1>
      <aba-css-tec2>~w</aba-css-tec2>
      <abb-css-task>~w</abb-css-task>
      <abb-css-team>~w</abb-css-team>
      <abb-css-tec1>~w</abb-css-tec1>
      <abb-css-tec2>~w</abb-css-tec2>
   </column>
   <column id="4">
      <csw-technique>
        <technique-name>~w</technique-name>
        <technique-phase>~d</technique-phase>
      </csw-technique>
      <aba-css-task>~w</aba-css-task>
      <aba-css-team>~w</aba-css-team>
      <aba-css-tec1>~w</aba-css-tec1>
      <aba-css-tec2>~w</aba-css-tec2>
      <abb-css-task>~w</abb-css-task>
      <abb-css-team>~w</abb-css-team>
      <abb-css-tec1>~w</abb-css-tec1>
      <abb-css-tec2>~w</abb-css-tec2>
   </column>
  </columns>
</board>
',
           [Context, Objectives, Content,
            Technique1Name, Phase1,
            Task1aName, Team1aName, Tecnology1a1Name, Tecnology1a2Name,
            Task1bName, Team1bName, Tecnology1b1Name, Tecnology1b2Name,
            Technique2Name, Phase2,
            Task2aName, Team2aName, Tecnology2a1Name, Tecnology2a2Name,
            Task2bName, Team2bName, Tecnology2b1Name, Tecnology2b2Name,
            Technique3Name, Phase3,
            Task3aName, Team3aName, Tecnology3a1Name, Tecnology3a2Name,
            Task3bName, Team3bName, Tecnology3b1Name, Tecnology3b2Name,
            Technique4Name, Phase4,
            Task4aName, Team4aName, Tecnology4a1Name, Tecnology4a2Name,
            Task4bName, Team4bName, Tecnology4b1Name, Tecnology4b2Name]
          ).



