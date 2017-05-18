:- module(completeness, [checkCompleteness/2]).
:- use_module(knowledgeBase).
:- dynamic missingSlot/1.


checkCompleteness(ListOfColumns, IncompleteCardPositionPairs) :-
    debug_format('<br/>~n--- Completeness:<br/>~n', []),
    interco(ListOfColumns, ICPP1s),
    intraco(ListOfColumns, ICPP2s),
    append(ICPP1s, ICPP2s, IncompleteCardPositionPairs).

/*  No technique cards are present in any column: inter-column checks succeed */
interco([Col1, Col2, Col3, Col4], []):-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    is_empty(T2),
    is_empty(T3),
    is_empty(T4),
    !,
    debug_format('interco: all techniques are empty, check succeeds<br/>~n', []).
interco([Col1, Col2, Col3, Col4], []) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    debug_format('interco tq1=\'~w\' tq2=\'~w\' tq3=\'~w\' tq4=\'~w\'<br/>~n',
                 [T1, T2, T3, T4]).



intraco(Column, []) :-
    % if a question mark card is present, no completeness check is performed
    has_question_mark_card(Column),
    !.
intraco(_Column, []).   % to be removed when predicate is implemented

/*
 * This predicate should return an empty list () when current_board_state is complete, and a list of couples (card, position) indicating which cards are missing and where, when the board is incomplete.
	Example1
(when a technique card is present and entailing two tasks and only one task is present), missing cards should be:
(task, task_position1), (team, team_position), (technology, technology_position)

Completeness inter-column rules:

4.	If phase n of a technique is used in column m, then all the phases j with j>n should be used in non-empty columns after m

5.	If there is a card in Column n, there should be at least one card in Column m (for all m<n).


Completeness intra-column rules (to be checked only if there is no '?'
card):

3. For each red card, there must be a yellow card or a question
mark (or a white card) in the adjacent yellow cell, and at least one
green card or question mark card (or white card) anywhere in the green
cell below.

4. For each yellow card, there must be a red card or a
question mark (or a white card) in the adjacent red cell, and at least
one green card or question mark card (or white card) anywhere in the
green cell below.

5. For each green card, there must be a red card or a
question mark (or a white card) in the above red cell, and one yellow
card or question mark card (or white card) in the yellow cell above. If
there are two green adjacent cards, one and only one task and one
team are needed.

6. If there is a card in Cn-ABB., there should be at least
one card in Cn-ABA (for all n.).


*/
