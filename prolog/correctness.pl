:- module(correctness, [checkCorrectness/2]).
:- use_module(knowledgeBase).
:- dynamic wrongSlot/1.


checkCorrectness(ListOfColumns, ICPs) :-
    intercc(ListOfColumns, ICP1s),
    intracc(ListOfColumns, ICP2s),
    append(ICP1s, ICP2s, ICPs).

intercc(ListOfColumns, ICPs) :-
    intercc0(ListOfColumns, ICPs-[]).


/*  No technique cards are present in any column: inter-column checks succeed */
intercc0([Col1, Col2, Col3, Col4], Xs-Xs):-
    Col1 = column(1, _, T1, _Ph1, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _Ph2, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _Ph3, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _Ph4, _, _, _, _, _, _, _, _),
    is_empty(T1),
    is_empty(T2),
    is_empty(T3),
    is_empty(T4),
    debug_format('intercc0 1<br/>~n', []),
    !.
intercc0(ListOfColumns, Xs-Ys) :-
    debug_format('--- Correctness:<br/>~n', []),
    intercc1(ListOfColumns, Xs-Ys).

/*
 *  inter column check 1: PEER REVIEW, PYRAMID, CASE STUDY
 *
 *  If the technique slot of column 1 contains a PEER REVIEW,
 *  a PYRAMID or a CASE STUDY where both phases are online,
 *  then the whole board will eventually contain only this technique
 *
 */

/*
 *  PEER_REVIEW (ids: 3, 4, 5)
 *
 *  Legal PEER_REVIEW layouts are:
 *    Col1             Col2             Col3             Col4
 * 1. Ph1 | empty      Ph1 | empty      Ph2 | empty      Ph3 | empty
 *
 *  Illegal PEER_REVIEW layouts are:
 *    Col1             Col2             Col3             Col4
 * a. any              any              Ph1              any
 * b. any              any              any              Ph1
 * c. Ph2              any              any              any
 * d. any              Ph2              any              any
 * e. any              any              any              Ph2
 * f. Ph3              any              any              any
 * g. any              Ph3              any              any
 * h. any              any              Ph3              any
 * i. Ph1             \Ph1              any              any
 * j. Ph1              any             \Ph2              any
 * k. Ph1              any              any             \Ph3
 * l. \Ph1             Ph1              any              any
 * m. any              Ph1             \Ph2              any
 * n. any              Ph1              any             \Ph3
 * o. \Ph1             any              Ph2              any
 * p. any             \Ph1              Ph2              any
 * q. any              any              Ph2             \Ph3
 * r. \Ph1             any              any              Ph3
 * s. any             \Ph1              any              Ph3
 * t. any              any             \Ph2              Ph3
 *
 */
%   succeed
intercc1([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '3' ),
    ( is_empty(T2) ; T2 = '3' ),
    ( is_empty(T3) ; T3 = '4' ),
    ( is_empty(T4) ; T4 = '5' ),
    debug_format('icc1 peer review 1<br/>~n', []),
    !.
%   error : phase 1 in col 3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '3', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 peer review a<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
%   error : phase 1 in col 4
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _,  '3', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 peer review b<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 1
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '4', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 peer review c<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 2
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '4', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 peer review d<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 4
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _,  '4', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 peer review e<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 1
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '5', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 peer review f<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 2
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '5', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 peer review g<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '5', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 peer review h<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% i. Ph1             \Ph1              any              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '3', _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    T2 \= '3',
    debug_format('icc1 peer review i<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% j. Ph1              any             \Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '3', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    T3 \= '4',
    debug_format('icc1 peer review j<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% k. Ph1              any              any             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '3', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '5',
    debug_format('icc1 peer review k<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% l. \Ph1             Ph1              any              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,  '3', _, _, _, _, _, _, _, _, _),
    T1 \= '3',
    debug_format('icc1 peer review l<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% m. any              Ph1             \Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '3', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    T3 \= '4',
    debug_format('icc1 peer review m<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% n. any              Ph1              any             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '3', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '5',
    debug_format('icc1 peer review n<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% o. \Ph1             any              Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  '4', _, _, _, _, _, _, _, _, _),
    T1 \= '3',
    debug_format('icc1 peer review o<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% p. any             \Ph1              Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  '4', _, _, _, _, _, _, _, _, _),
    T2 \= '1',
    debug_format('icc1 peer review p<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% q. any              any              Ph2             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '4', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '5',
    debug_format('icc1 peer review q<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% r. \Ph1             any              any              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '5', _, _, _, _, _, _, _, _, _),
    T1 \= '3',
    debug_format('icc1 peer review r<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% s. any             \Ph1              any              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '5', _, _, _, _, _, _, _, _, _),
    T2 \= '3',
    debug_format('icc1 peer review s<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% t. any              any             \Ph2              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '5', _, _, _, _, _, _, _, _, _),
    T3 \= '3',
    debug_format('icc1 peer review t<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).


/*
 *  PYRAMID (FOR LIST PREPARATION) (ids: 8, 9, 10)
 *
 *  Legal PYRAMID layouts are:
 *    Col1             Col2             Col3             Col4
 * 1. Ph1 | empty      Ph1 | empty      Ph2 | empty      Ph3 | empty
 *
 *  Illegal PEER_REVIEW layouts are:
 *    Col1             Col2             Col3             Col4
 * a. any              any              Ph1              any
 * b. any              any              any              Ph1
 * c. Ph2              any              any              any
 * d. any              Ph2              any              any
 * e. any              any              any              Ph2
 * f. Ph3              any              any              any
 * g. any              Ph3              any              any
 * h. any              any              Ph3              any
 * i. Ph1             \Ph1              any              any
 * j. Ph1              any             \Ph2              any
 * k. Ph1              any              any             \Ph3
 * l. \Ph1             Ph1              any              any
 * m. any              Ph1             \Ph2              any
 * n. any              Ph1              any             \Ph3
 * o. \Ph1             any              Ph2              any
 * p. any             \Ph1              Ph2              any
 * q. any              any              Ph2             \Ph3
 * r. \Ph1             any              any              Ph3
 * s. any             \Ph1              any              Ph3
 * t. any              any             \Ph2              Ph3
 *
 */
%   succeed
intercc1([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '8' ),
    ( is_empty(T2) ; T2 = '8' ),
    ( is_empty(T3) ; T3 = '9' ),
    ( is_empty(T4) ; T4 = '10' ),
    debug_format('icc1 2<br/>~n', []),
    !.
%   error : phase 1 in col 3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '8', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) a<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
%   error : phase 1 in col 4
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _,  '8', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) b<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 1
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '9', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) c<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 2
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '9', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) d<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 4
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _,  '9', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) e<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 1
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '10', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) f<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 2
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '10', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) g<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '10', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) h<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% i. Ph1             \Ph1              any              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '8', _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    T2 \= '8',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) i<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% j. Ph1              any             \Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '8', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    T3 \= '9',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) j<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% k. Ph1              any              any             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '8', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '10',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) k<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% l. \Ph1             Ph1              any              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,  '8', _, _, _, _, _, _, _, _, _),
    T1 \= '8',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) l<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% m. any              Ph1             \Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '8', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    T3 \= '9',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) m<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% n. any              Ph1              any             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '8', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '10',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) n<br/>~n', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% o. \Ph1             any              Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  '9', _, _, _, _, _, _, _, _, _),
    T1 \= '8',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) o<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% p. any             \Ph1              Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  '9', _, _, _, _, _, _, _, _, _),
    T2 \= '1',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) p<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% q. any              any              Ph2             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '9', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '10',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) q<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% r. \Ph1             any              any              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '10', _, _, _, _, _, _, _, _, _),
    T1 \= '8',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) r<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% s. any             \Ph1              any              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '10', _, _, _, _, _, _, _, _, _),
    T2 \= '8',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) s<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% t. any              any             \Ph2              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '10', _, _, _, _, _, _, _, _, _),
    T3 \= '8',
    debug_format('icc1 PYRAMID (FOR LIST PREPARATION) t<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).



%   PYRAMID (FOR PROBLEM SOLVING) (ids: 11, 12, 13)
%   succeed
intercc1([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '11' ),
    ( is_empty(T2) ; T2 = '11' ),
    ( is_empty(T3) ; T3 = '12' ),
    ( is_empty(T4) ; T4 = '13' ),
    debug_format('icc1 18<br/>', []),
    !.
%   error : phase 1 in col 3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '11', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) a<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
%   error : phase 1 in col 4
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _,  '11', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) b<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 1
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '12', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) c<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 2
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '12', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) d<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
%   error : phase 2 in col 4
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _,  '12', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) e<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 1
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '13', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) f<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 2
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '13', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) g<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
%   error : phase 3 in col 3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '13', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) h<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% i. Ph1             \Ph1              any              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '11', _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    T2 \= '11',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) i<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% j. Ph1              any             \Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '11', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    T3 \= '12',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) j<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% k. Ph1              any              any             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  '11', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '13',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) k<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% l. \Ph1             Ph1              any              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,  '11', _, _, _, _, _, _, _, _, _),
    T1 \= '11',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) l<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% m. any              Ph1             \Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '11', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    T3 \= '12',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) m<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% n. any              Ph1              any             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  '11', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '13',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) n<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% o. \Ph1             any              Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  '12', _, _, _, _, _, _, _, _, _),
    T1 \= '11',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) o<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% p. any             \Ph1              Ph2              any
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  '12', _, _, _, _, _, _, _, _, _),
    T2 \= '1',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) p<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% q. any              any              Ph2             \Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  '12', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    T4 \= '13',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) q<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% r. \Ph1             any              any              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _,  T1, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '13', _, _, _, _, _, _, _, _, _),
    T1 \= '11',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) r<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% s. any             \Ph1              any              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '13', _, _, _, _, _, _, _, _, _),
    T2 \= '11',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) s<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% t. any              any             \Ph2              Ph3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  '13', _, _, _, _, _, _, _, _, _),
    T3 \= '11',
    debug_format('icc1 PYRAMID (FOR PROBLEM SOLVING) t<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).



%   CASE STUDY (ids: 6, 7) with both phases online
/*
 *  Illegal CASE STUDY layouts are:
 *         Col1              Col2            Col3              Col4
 * a. Ph2              any              any              any
 * b. any              any              any              Ph1
 * c. any              Ph2              Ph1              any
 *
 *  Legal CASE STUDY layouts are:
 *         Col1             Col2           Col3              Col4
 * 1. Ph1.Tk1          Ph1.Tk2(onl)     Ph2.Tk1          Ph2.Tk2(onl)
 *
 */
% a. error: Ph2 in col 1
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, '7', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 27<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% b. error: Ph1 in col 4
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _, '6', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 28<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% c. error: Ph2 in col 2, Ph1 in col 3
intercc1([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _, '7', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, '6', _, _, _, _, _, _, _, _, _),
    debug_format('icc1 29<br/>', []),
    !,
    intercc2([Col1, Col2, Col3, Col4],
             Xs-['C2-CSW-TECHNIQUE', 'C3-CSW-TECHNIQUE'|Ys]).
%   succeed #1. Ph1.Tk1       Ph1.Tk2(onl)  Ph2.Tk1       Ph2.Tk2(onl)
intercc1([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '6' ),
    ( is_empty(T2) ; T2 = '6' ),
    ( is_empty(T3) ; T3 = '7' ),
    ( is_empty(T4) ; T4 = '7' ),
    debug_format('icc1 30<br/>', []),
    !.

% catchall
intercc1(ListOfColumns, Xs-Ys) :-
    debug_format('icc1 catchall<br/>', []),
    intercc2(ListOfColumns, Xs-Ys).


/*
 *  inter column check 2 - techniques that last 3 weeks:
 *  - a JIGSAW (two weeks for Ph1, one for Ph2);
 *  - a CASE STUDY with one phase online and one phase f2f;
 *  - a DISCUSSION with the debating task online.
 *
 *  -----------------------------------------------
 *  JIGSAW (ids: 1, 2)
 *
 *  Illegal layouts are:
 *         Col1           Col2         Col3           Col4
 *  a.     Ph2            any          any            any
 *  b.     any            Ph2          any            any
 *  c.     any            any          Ph1            any
 *  d.     any            any          any            Ph1
 *  e.     Ph1            any          any            Ph2
 *  f.     Ph1      \(empty | Ph1)     any            any
 *  g.     Ph1       (empty | Ph1)  \(empty | Ph2)    any
 *  h.     any            Ph1    \(empty | Ph1)       any
 *  i.     any            Ph1     (empty | Ph1)   \(empty | Ph2)
 *
 *  Legal layouts are:
 *         Col1           Col2         Col3           Col4
 *  1.   Ph1.Tk1        Ph1.Tk2        Ph2            empty
 *  2.     empty          Ph1.Tk1      Ph1.Tk2          Ph2
 *
 */
% a. error: Ph2 in col 1
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, '2', _, _, _, _, _, _, _, _, _),
    debug_format('icc2 JIGSAW a<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% b. error: Ph2 in col 2
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _, '2', _, _, _, _, _, _, _, _, _),
    debug_format('icc2 JIGSAW b<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% c. error: Ph1 in col 3
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _, '1', _, _, _, _, _, _, _, _, _),
    debug_format('icc2 JIGSAW c<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% d. error: Ph1 in col 4
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _, '1', _, _, _, _, _, _, _, _, _),
    debug_format('icc2 JIGSAW d<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% e. error: Ph1 in col 1 and Ph2 in col 4
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, '1', _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, '2', _, _, _, _, _, _, _, _, _),
    debug_format('icc2 JIGSAW e<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4],
             Xs-['C1-CSW-TECHNIQUE', 'C4-CSW-TECHNIQUE'|Ys]).
% f.     Ph1      \(empty | Ph1)     any            any
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, '1', _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    is_not_empty(T2),
    T2 \= '1',
    debug_format('icc2 JIGSAW f<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% g.     Ph1       (empty | Ph1)    \(empty | Ph2)       any
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, '1', _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,  T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    ( is_empty(T2) ; T2 = '1' ),
    T3 \= '2',
    is_not_empty(T3),
    debug_format('icc2 JIGSAW g<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% h.     any            Ph1    \(empty | Ph1)       any
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _, '1', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    is_not_empty(T3),
    T3 \= '1',
    debug_format('icc2 JIGSAW h<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).
% i.     any            Ph1     (empty | Ph1)    \(empty | Ph2)
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _, '1', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,  T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _,  T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T3) ; T3 = '1' ),
    T4 \= '2',
    is_not_empty(T4),
    debug_format('icc2 JIGSAW i<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).

    %   succeed
%   1.   Ph1.Tk1        Ph1.Tk2        Ph2            empty
intercc2([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '1' ),
    ( is_empty(T2) ; T2 = '1' ),
    ( is_empty(T3) ; T3 = '2' ),
    is_empty(T4),
    debug_format('icc2 JIGSAW 1<br/>', []),
    !.
%   2.     empty          Ph1.Tk1      Ph1.Tk2          Ph2
intercc2([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    ( is_empty(T2) ; T2 = '1' ),
    ( is_empty(T3) ; T3 = '1' ),
    ( is_empty(T4) ; T4 = '2' ),
    debug_format('icc2 JIGSAW 2<br/>', []),
    !.

/*
 *  CASE STUDY (ids: 6, 7) with one phase online and one phase f2f
 *
 *  Some illegal CASE STUDY layouts have already been dealt with before
 *
 *  Legal CASE STUDY layouts are:
 *         Col1             Col2           Col3              Col4
 * 2. Ph1.Tk1+Tk2(f2f) Ph2.Tk1          Ph2.Tk2(onl)     empty
 * 3. empty            Ph1.Tk1+Tk2(f2f) Ph2.Tk1          Ph2.Tk2(onl)
 * 4. Ph1.Tk1          Ph1.Tk2(onl)     Ph2.Tk1+Tk2(f2f) empty
 * 5. empty            Ph1.Tk1          Ph1.Tk2(onl)    Ph2.Tk1+Tk2(f2f)
 *
 * (numbered from #2 because #1 had both phases online)
 */
%   succeed #2. Ph1.Tk1+Tk2(f2f) Ph2.Tk1    Ph2.Tk2(onl)  empty
intercc2([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '6' ),
    ( is_empty(T2) ; T2 = '7' ),
    ( is_empty(T3) ; T3 = '7' ),
    is_empty(T4),
    debug_format('icc2 CASE STUDY 2<br/>', []),
    !.
%   succeed #3. empty     Ph1.Tk1+Tk2(f2f) Ph2.Tk1       Ph2.Tk2(onl)
intercc2([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    ( is_empty(T2) ; T2 = '6' ),
    ( is_empty(T3) ; T3 = '7' ),
    ( is_empty(T4) ; T4 = '7' ),
    debug_format('icc2 CASE STUDY 3<br/>', []),
    !.
%   succeed #4. Ph1.Tk1   Ph1.Tk2(onl)   Ph2.Tk1+Tk2(f2f) empty
intercc2([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '6' ),
    ( is_empty(T2) ; T2 = '6' ),
    ( is_empty(T3) ; T3 = '7' ),
    is_empty(T4),
    debug_format('icc2 CASE STUDY 4<br/>', []),
    !.
%   succeed #5. empty  Ph1.Tk1 Ph1.Tk2(onl) Ph2.Tk1+Tk2(f2f)
intercc2([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    ( is_empty(T2) ; T2 = '6' ),
    ( is_empty(T3) ; T3 = '6' ),
    ( is_empty(T4) ; T4 = '7' ),
    debug_format('icc2 CASE STUDY 5<br/>', []),
    !.

/*
 *  DISCUSSION (ids: 14, 15/16/17)
 *  two weeks for phase 1 (with online debating), one week for phase 2.
 *
 *  Illegal layouts are:
 *      Col1             Col2             Col3             Col4
 *  a.  Ph2              any              any              any
 *  b.  empty            Ph2              any              any
 *  c.  any              any              any              Ph1
 *  d.  Ph1      \(Ph1 | Ph2 | empty)     any              any
 *  e.  any              Ph1      \(Ph1 | Ph2 | empty)     any
 *
 *  Legal layouts are:
 *      Col1             Col2             Col3             Col4
 * 1. Ph1.Tk1          Ph1.Tk2(onl)     Ph2.Tk1          empty
 * 3. empty            Ph1.Tk1          Ph1.Tk2(onl)     Ph2.Tk1
 *
 * Only #2 and #5 allow for anoher technique in the board (2 free slots)
 *
 */
% a. error: Ph2 in col 1
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    member(T1, ['15', '16', '17']),
    debug_format('icc2 DISCUSSION a<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C1-CSW-TECHNIQUE'|Ys]).
% b. error: col 1 empty, Ph2 in col 2
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    member(T2, ['15', '16', '17']),
    debug_format('icc2 DISCUSSION b<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% c. error: Ph1 in col 4
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    T4 = '14',
    debug_format('icc2 DISCUSSION c<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C4-CSW-TECHNIQUE'|Ys]).
% d.  Ph1      \(Ph1 | Ph2 | empty)     any              any
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, '14', _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _,   T2, _, _, _, _, _, _, _, _, _),
    T2 \= '14',
    T2 \= '15',
    T2 \= '16',
    T2 \= '17',
    is_not_empty(T2),
    debug_format('icc2 DISCUSSION d<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C2-CSW-TECHNIQUE'|Ys]).
% e.  any              Ph1      \(Ph1 | Ph2 | empty)     any
intercc2([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col2 = column(2, _, '14', _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _,   T3, _, _, _, _, _, _, _, _, _),
    T3 \= '14',
    T3 \= '15',
    T3 \= '16',
    T3 \= '17',
    is_not_empty(T3),
    debug_format('icc2 DISCUSSION e<br/>', []),
    !,
    intercc3([Col1, Col2, Col3, Col4], Xs-['C3-CSW-TECHNIQUE'|Ys]).

%   succeed:
%   1. Ph1.Tk1       Ph1.Tk2(onl)     Ph2.Tk1     empty
intercc2([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '14' ),
    ( is_empty(T2) ; T2 = '14' ),
    ( is_empty(T3) ; member(T3, ['15', '16', '17']) ),
    is_empty(T4),
    debug_format('icc2 DISCUSSION 1<br/>', []),
    !.
%   3. empty            Ph1.Tk1          Ph1.Tk2(onl)     Ph2.Tk1
intercc2([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    ( is_empty(T2) ; T2 = '14' ),
    ( is_empty(T3) ; T3 = '14' ),
    ( is_empty(T4) ; member(T4, ['15', '16', '17']) ),
    debug_format('icc2 DISCUSSION 2<br/>', []),
    !.

% catchall
intercc2(ListOfColumns, Xs-Ys) :-
    debug_format('icc2 catchall<br/>', []),
    intercc3(ListOfColumns, Xs-Ys).

/*
 *  inter column check 3 - techniques that require two weeks:
 *
 *  - DISCUSSION with f2f debating
 *  - CASE STUDY with both phases f2f
 *  - ROLE PLAY
 *
 *  To account for two techniques in the same board, clause intercc3 can
 *  call intercc4 with only two columns, if two have already been
 *  checked.
 *
 *  ---------------------------------------
 *
 *  DISCUSSION  (ids: 14, 15/16/17)
 *
 *  Illegal layouts have already been dealt with.
 *
 *  Legal layouts are:
 *      Col1             Col2             Col3             Col4
 * 2. Ph1.Tk1+Tk2(f2f) Ph2.Tk1          any              any
 * 4. empty            Ph1.Tk1+Tk2(f2f) Ph2.Tk1          empty
 * 5. any              any              Ph1.Tk1+Tk2(f2f) Ph2.Tk1
 *
 * Only #2 and #5 allow for anoher technique in the board (2 free slots)
 * by calling intercc4.
 *
 */
%   2. Ph1.Tk1+Tk2(f2f) Ph2.Tk1          any              any
intercc3([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '14' ),
    ( is_empty(T2) ; member(T2, ['15', '16', '17']) ),
    debug_format('icc3 1<br/>', []),
    !,
    intercc4([Col3, Col4], Xs-Ys).  % check other techniques
%   4. empty      Ph1.Tk1+Tk2(f2f)     Ph2.Tk1       empty
intercc3([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    ( is_empty(T2) ; T2 = '14' ),
    ( is_empty(T3) ; member(T3, ['15', '16', '17']) ),
    is_empty(T4),
    debug_format('icc3 2<br/>', []),
    !.
%   5. any              any              Ph1.Tk1+Tk2(f2f) Ph2.Tk1
intercc3([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T3) ; T3 = '14' ),
    ( is_empty(T4) ; member(T4, ['15', '16', '17']) ),
    not_both_empty(T3, T4),
    debug_format('icc3 3<br/>', []),
    !,
    intercc4([Col1, Col2], Xs-Ys).  % check other techniques

/*
 *  CASE STUDY (ids: 6, 7) with both phases f2f
 *
 *  Illegal CASE STUDY layouts have already been dealt with before
 *
 *  Legal CASE STUDY layouts are:
 *         Col1             Col2           Col3              Col4
 * 6. Ph1.Tk1+Tk2(f2f) Ph2.Tk1+Tk2(f2f) any              any
 * 7. empty            Ph1.Tk1+Tk2(f2f) Ph2.Tk1+Tk2(f2f) empty
 * 8. any              any             Ph1.Tk1+Tk2(f2f) Ph2.Tk1+Tk2(f2f)
 *
 * (numbered from #6 because #1-#5 had some phase online)
 */
%   succeed #6. Ph1.Tk1+Tk2(f2f)  Ph2.Tk1+Tk2(f2f)   any   any
intercc3([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '6' ),
    ( is_empty(T2) ; T2 = '7' ),
    debug_format('icc3 4<br/>', []),
    !,
    intercc4([Col3, Col4], Xs-Ys).  % check other techniques
%   succeed #7. empty    Ph1.Tk1+Tk2(f2f)   Ph2.Tk1+Tk2(f2f)   empty
intercc3([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    is_empty(T4),
    ( is_empty(T2) ; T2 = '6' ),
    ( is_empty(T3) ; T3 = '7' ),
    debug_format('icc3 5<br/>', []),
    !.
%   succeed #8. any   any     Ph1.Tk1+Tk2(f2f)    Ph2.Tk1+Tk2(f2f)
intercc3([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T3) ; T3 = '6' ),
    ( is_empty(T4) ; T4 = '7' ),
    not_both_empty(T3, T4),
    debug_format('icc3 6<br/>', []),
    !,
    intercc4([Col1, Col2], Xs-Ys).   % check other techniques

/*
 *  ROLE PLAY (ids: 18, 19).
 *
 *  Illegal layouts are:
 *      Col1             Col2             Col3             Col4
 * a.  Ph2              any              any              any
 * b.  any              any              any              Ph1
 * c.  empty            Ph2              Ph1              empty
 * d.  Ph1              \Ph2             any              any
 * e.  any              Ph1              \Ph2             any
 * f.  \Ph1             Ph2              any              any
 * g.  any              \Ph1             Ph2              any
 * h.  any              any              Ph1              \Ph2
 * i.  any              any              \Ph1             Ph2
 *
 *  Legal layouts are:
 *      Col1             Col2             Col3             Col4
 * 1. Ph1              Ph2              any              any
 * 2. empty            Ph1              Ph2              empty
 * 3. any              any              Ph1              Ph2
 *
 * Only #1 and #3 allow for anoher technique in the board (2
 * contiguous free slots) but currently this behaviour is not
 * yet implemented.
 *
 */
% a. error: Ph2 in col 1
intercc3([Col1, _Col2, _Col3, _Col4], ['C1-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    T1 = '19',
    debug_format('icc3 7<br/>', []),
    !.
% b. error: Ph1 in col 4
intercc3([_Col1, _Col2, _Col3, Col4], ['C4-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col4 = column(1, _, T4, _, _, _, _, _, _, _, _, _),
    T4 = '18',
    debug_format('icc3 8<br/>', []),
    !.
% c. error: empty       Ph2         Ph1         empty
intercc3([Col1, Col2, Col3, Col4],
         ['C2-CSW-TECHNIQUE', 'C3-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    T2 = '19',
    T3 = '18',
    is_empty(T4),
    debug_format('icc3 9<br/>', []),
    !.
% d.  Ph1     \Ph2       any        any
intercc3([Col1, Col2, _Col3, _Col4], ['C2-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    T1 = '18',
    is_not_empty(T2),
    T2 \= '19',
    debug_format('icc3 10<br/>', []),
    !.
% e.  any              Ph1              \Ph2             any
intercc3([_Col1, Col2, Col3, _Col4], ['C3-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    T2 = '18',
    is_not_empty(T3),
    T3 \= '19',
    debug_format('icc3 11<br/>', []),
    !.
% f.  \Ph1             Ph2              any              any
intercc3([Col1, Col2, _Col3, _Col4], ['C2-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    is_not_empty(T1),
    T1 \= '18',
    T2 = '19',
    debug_format('icc3 12<br/>', []),
    !.
% g.  any              \Ph1             Ph2              any
intercc3([_Col1, Col2, Col3, _Col4], ['C3-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    is_not_empty(T2),
    T2 \= '18',
    T3 = '19',
    debug_format('icc3 13<br/>', []),
    !.
%  h.  any              any              Ph1              \Ph2
intercc3([_Col1, _Col2, Col3, Col4], ['C4-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_not_empty(T4),
    T3 = '18',
    T4 \= '19',
    debug_format('icc3 14<br/>', []),
    !.
%  i.  any              any              \Ph1             Ph2
intercc3([_Col1, _Col2, Col3, Col4], ['C4-CSW-TECHNIQUE'|Xs]-Xs) :-
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_not_empty(T3),
    T3 \= '18',
    T4 = '19',
    debug_format('icc3 15<br/>', []),
    !.
% succeed
%   1. Ph1              Ph2              any              any
intercc3([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    T1 = '18',
    T2 = '19',
    debug_format('icc3 16<br/>', []),
    !,
    intercc4([Col3, Col4], Xs-Ys).
%   2. empty            Ph1              Ph2              empty
intercc3([Col1, Col2, Col3, Col4], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    is_empty(T1),
    T2 = '18',
    T3 = '19',
    is_empty(T4),
    debug_format('icc3 17<br/>', []),
    !.
%   3. any              any              Ph1              Ph2
intercc3([Col1, Col2, Col3, Col4], Xs-Ys) :-
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    T3 = '18',
    T4 = '19',
    debug_format('icc3 18<br/>', []),
    !,
    intercc4([Col1, Col2], Xs-Ys).

% catchall
intercc3(ListOfColumns, Xs-Ys) :-
    debug_format('icc3 catchall<br/>', []),
    intercc4(ListOfColumns, Xs-Ys).

/*
 *  inter column check 4 - techniques that require two weeks.
 *  Same as intercc3, but with only two (adjacent) columns to check,
 *  as the other two have already been checked ok with another
 *  technique.
 *
 *  - DISCUSSION with f2f debating
 *  - CASE STUDY with both phases f2f
 *  - ROLE PLAY
 */
% DISCUSSION
%   2. Ph1.Tk1+Tk2(f2f) Ph2.Tk1 - -
intercc4([Col1, Col2], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '14' ),
    ( is_empty(T2) ; member(T2, ['15', '16', '17']) ),
    debug_format('icc4 1<br/>', []),
    !.
%   5. - -  Ph1.Tk1+Tk2(f2f) Ph2.Tk1
intercc4([Col3, Col4], Xs-Xs) :-
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T3) ; T3 = '14' ),
    ( is_empty(T4) ; member(T4, ['15', '16', '17']) ),
    not_both_empty(T3, T4),
    debug_format('icc4 2<br/>', []),
    !.
% CASE STUDY
%   succeed #6. Ph1.Tk1+Tk2(f2f)  Ph2.Tk1+Tk2(f2f)   -   -
intercc4([Col1, Col2], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    ( is_empty(T1) ; T1 = '6' ),
    ( is_empty(T2) ; T2 = '7' ),
    debug_format('icc4 3<br/>', []),
    !.
%   succeed #8. -   -     Ph1.Tk1+Tk2(f2f)    Ph2.Tk1+Tk2(f2f)
intercc4([Col3, Col4], Xs-Xs) :-
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    ( is_empty(T3) ; T3 = '6' ),
    ( is_empty(T4) ; T4 = '7' ),
    not_both_empty(T3, T4),
    debug_format('icc4 4<br/>', []),
    !.
% ROLE PLAY
%   1. Ph1 Ph2 - -
intercc4([Col1, Col2], Xs-Xs) :-
    Col1 = column(1, _, T1, _, _, _, _, _, _, _, _, _),
    Col2 = column(2, _, T2, _, _, _, _, _, _, _, _, _),
    T1 = '18',
    T2 = '19',
    debug_format('icc4 5<br/>', []),
    !.
%   3. - - Ph1 Ph2
intercc4([Col3, Col4], Xs-Xs) :-
    Col3 = column(3, _, T3, _, _, _, _, _, _, _, _, _),
    Col4 = column(4, _, T4, _, _, _, _, _, _, _, _, _),
    T3 = '18',
    T4 = '19',
    debug_format('icc4 6<br/>', []),
    !.


% catchall
intercc4(_ListOfColumns, Xs-Xs) :-
    debug_format('icc4 catchall<br/>', []).




testInterCC :-
    expand_file_name('testCases/??.xml', Fs),
    forall(member(F, Fs), dotestInterCC(F)).

dotestInterCC(XMLFile) :-
    read_file_to_string(XMLFile, XMLString, []),
    open_any(string(XMLString), read, XMLBoardRepr, Close, []),
    format('TestInterCCM ~s~n', [XMLFile]),
    parseXMLBoardRepr(XMLBoardRepr, PrologBoardRepr),
    doTestInterCC1(PrologBoardRepr),
    write('---\n'),
    close_any(Close).
doTestInterCC1(board(_Context, _Goals, _Content, ListOfColumns)) :-
    intercc(ListOfColumns, ICPs),
    format('Returns Inconsistent Slots: ~p~n', [ICPs]).

/*
 * intracc(ListOfColumns, InconsistentCardPositions)
 *
 * sequentially applies to each column the intra column checks
 * returns a list of inconsistent positions
 *
 */
intracc([], []).
intracc([ThisColumn | OtherColumns], ICPs) :-
    isColumnEmpty(ThisColumn),
    !,
    intracc(OtherColumns, ICPs).
intracc([ThisColumn | OtherColumns], ICPs) :-
    has_question_mark_card(ThisColumn),
    !,
    intracc(OtherColumns, ICPs).
intracc([ThisColumn | OtherColumns], ICPs) :-
    /*
     * 1.	Technique-based constraints – those enforced by the presence
     *      of a technique card, that implies a subset of allowed task,
     *      team and technology cards.
     *
     */
    ThisColumn = column(_ColNumber, _HasStar, Technique, _Phase,
                    _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
                    _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2),
    is_not_empty(Technique),
    !,
    intracc_tb([ThisColumn | OtherColumns], ICPs).
intracc([ThisColumn | OtherColumns], ICPs) :-
    /*
     * 2.	3T-based constraints, only involving task, team and technology
     *      cards, without the presence of a technique card.
     *
     */
    ThisColumn = column(_ColNumber, _HasStar, Technique, _Phase,
                    _TaskABA, _TeamABA, _TechnologyABA1, _TechnologyABA2,
                    _TaskABB, _TeamABB, _TechnologyABB1, _TechnologyABB2),
    is_empty(Technique),
    intracc_3t(ThisColumn, ICP1s),
    intracc(OtherColumns, ICP2s),
    append(ICP1s, ICP2s, ICPs).

intracc_tb(Columns, ICPs) :-
    % Technique-based - dispatch over technique id
    Columns = [ThisColumn | _OtherColumns],
    technique_column(ThisColumn, Technique),
    ( Technique == '1' -> intracc_jigsaw1(Columns, NextColumns, ICP1s) ;
      Technique == '2' -> intracc_jigsaw2(Columns, NextColumns, ICP1s) ;
      Technique == '3' -> intracc_peer1(Columns, NextColumns, ICP1s) ;
      Technique == '4' -> intracc_peer2(Columns, NextColumns, ICP1s) ;
      Technique == '5' -> intracc_peer3(Columns, NextColumns, ICP1s) ;
      Technique == '6' -> intracc_case1(Columns, NextColumns, ICP1s) ;
      Technique == '7' -> intracc_case2(Columns, NextColumns, ICP1s) ;
      Technique == '8' -> intracc_pyramidL1(Columns, NextColumns, ICP1s) ;
      Technique == '9' -> intracc_pyramidL2(Columns, NextColumns, ICP1s) ;
      Technique == '10' -> intracc_pyramidL3(Columns, NextColumns, ICP1s) ;
      Technique == '11' -> intracc_pyramidS1(Columns, NextColumns, ICP1s) ;
      Technique == '12' -> intracc_pyramidS2(Columns, NextColumns, ICP1s) ;
      Technique == '13' -> intracc_pyramidS3(Columns, NextColumns, ICP1s) ;
      Technique == '14' -> intracc_disc1(Columns, NextColumns, ICP1s) ;
      Technique == '15' -> intracc_disc2ass(Columns, NextColumns, ICP1s) ;
      Technique == '16' -> intracc_disc2art(Columns, NextColumns, ICP1s) ;
      Technique == '17' -> intracc_disc2rep(Columns, NextColumns, ICP1s) ;
      Technique == '18' -> intracc_role1(Columns, NextColumns, ICP1s) ;
      Technique == '19' -> intracc_role2(Columns, NextColumns, ICP1s) ;
      debug_format('Unknown Technique in intracc_tb: ~w<br>', [Technique])
    ),
    checkNoTechnologiesReplicated(ThisColumn, ICP3s),
    intracc(NextColumns, ICP2s),
    append(ICP1s, ICP3s, ICP4s),
    append(ICP4s, ICP2s, ICPs).
intracc_tb(Columns, []) :-
    debug_format('intracc_tb fails with Columns = ~p<br>', [Columns]).

intracc_jigsaw1(Columns, NextColumns, ICPs) :-
/* Jigsaw 1 spawns 2 weeks:
   1a) Studying, Individual learners, Selected study materials
   1b) empty
   2a) Preparing a presentation, Small groups, Presentation software +
                                               (No Techn. | Forum)
   2b) Giving a presentation, Plenary, Projector | Videoconf.
*/
    Columns = [column(ColNumber1, _HasStar1, _Technique1, _Phase1,
                      TaskABA1, TeamABA1, TechnologyABA11, TechnologyABA21,
                      TaskABB1, TeamABB1, TechnologyABB11, TechnologyABB21),
               column(ColNumber2, _HasStar2, _Technique2, _Phase2,
                      TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22,
                      TaskABB2, TeamABB2, TechnologyABB12, TechnologyABB22)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or STUDYING
    interacc_helper(TaskABA1, ['102'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA1, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA11, ['306'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA21, ['306'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB1 must be empty
    interacc_helper(TaskABB1, [], 'C~d-ABB-CSS-TASK', ColNumber1),
    % TeamABB1 must be empty
    interacc_helper(TeamABB1, [], 'C~d-ABB-CSS-TEAM', ColNumber1),
    % TechnologyABB11 must be empty
    interacc_helper(TechnologyABB11, [], 'C~d-ABB-CSS-TEC1', ColNumber1),
    % TechnologyABB21 must be empty
    interacc_helper(TechnologyABB21, [], 'C~d-ABB-CSS-TEC2', ColNumber1),
    % TaskABA2 must be either empty or PREPARING A PRESENTATION
    interacc_helper(TaskABA2, ['106'], 'C~d-ABA-CSS-TASK', ColNumber2),
    % TeamABA2 must be either empty or SMALL GROUPS
    interacc_helper(TeamABA2, ['203'], 'C~d-ABA-CSS-TEAM', ColNumber2),
    % TechnologyABA12 must be either empty or FORUM
    %                             or PRESENTATION SOFTWARE or NO TECHNOLOGY
    interacc_helper(TechnologyABA12, ['301', '302', '310'], 'C~d-ABA-CSS-TEC1',
                    ColNumber2),
    % TechnologyABA22 must be either empty or FORUM
    %                             or PRESENTATION SOFTWARE or NO TECHNOLOGY
    interacc_helper(TechnologyABA22, ['301', '302', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber2),
    % TaskABB2 must be either empty or GIVING A PRESENTATION
    interacc_helper(TaskABB2, ['108'], 'C~d-ABB-CSS-TASK', ColNumber2),
    % TeamABB2 must be either empty or PLENARY
    interacc_helper(TeamABB2, ['206'], 'C~d-ABB-CSS-TEAM', ColNumber2),
    % TechnologyABB12 must be either empty or PROJECTOR or VIDEOCONF.
    interacc_helper(TechnologyABB12, ['305', '309'], 'C~d-ABB-CSS-TEC1',
                    ColNumber2),
    % TechnologyABB22 must be either empty or PROJECTOR or VIDEOCONF.
    interacc_helper(TechnologyABB22, ['305', '309'], 'C~d-ABB-CSS-TEC2',
                    ColNumber2),
    debug_format('jigsaw 1 in cols ~d and ~d<br/>~n',
                 [ColNumber1, ColNumber2]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_jigsaw2(Columns, NextColumns, ICPs) :-
/* Jigsaw 1 spawns 1 week:
   1a) Writing a report, Small groups, Text editor + (No Techn. | Forum)
   1b) Giving a presentation, Plenary, Projector ! Videoconfer.
*/
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or WRITING A REPORT
    interacc_helper(TaskABA, ['101'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or SMALL GROUPS
    interacc_helper(TeamABA, ['203'], 'C~d-ABA-CSS-TEAM', ColNumber),
    % TechnologyABA1 must be either empty or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['308'], 'C~d-ABA-CSS-TEC1', ColNumber),
    % TechnologyABA2 must be either empty or NO TECHNOLOGY or FORUM
    interacc_helper(TechnologyABA2, ['301', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be either empty or GIVING A PRESENTATION
    interacc_helper(TaskABB, ['108'], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB2 must be either empty or PLENARY
    interacc_helper(TeamABB, ['206'], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB12 must be either empty or PROJECTOR or VIDEOCONF.
    interacc_helper(TechnologyABB1, ['305', '309'], 'C~d-ABB-CSS-TEC1',
                    ColNumber),
    % TechnologyABB22 must be either empty or PROJECTOR or VIDEOCONF.
    interacc_helper(TechnologyABB2, ['305', '309'], 'C~d-ABB-CSS-TEC2',
                    ColNumber),
    debug_format('jigsaw2 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).


intracc_peer1(Columns, NextColumns, ICPs) :-
/* Peer 1 spans 2 weeks:
 * 1a) Studying, Individual learners, Selected study materials
 * 1b) empty
 * 2a) Producing an artefact,
 *     Individual learners or Pairs or Small groups,
 *     Materials and tools for practice + (No Techn. or Forum)
 * 2b) empty
 */
    Columns = [column(ColNumber1, _HasStar1, _Technique1, _Phase1,
                      TaskABA1, TeamABA1, TechnologyABA11, TechnologyABA21,
                      TaskABB1, TeamABB1, TechnologyABB11, TechnologyABB21),
               column(ColNumber2, _HasStar2, _Technique2, _Phase2,
                      TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22,
                      TaskABB2, TeamABB2, TechnologyABB12, TechnologyABB22)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or STUDYING
    interacc_helper(TaskABA1, ['102'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA1, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA11, ['306'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA21, ['306'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB1 must be empty
    interacc_helper(TaskABB1, [], 'C~d-ABB-CSS-TASK', ColNumber1),
    % TeamABB1 must be empty
    interacc_helper(TeamABB1, [], 'C~d-ABB-CSS-TEAM', ColNumber1),
    % TechnologyABB11 must be empty
    interacc_helper(TechnologyABB11, [], 'C~d-ABB-CSS-TEC1', ColNumber1),
    % TechnologyABB21 must be empty
    interacc_helper(TechnologyABB21, [], 'C~d-ABB-CSS-TEC2', ColNumber1),

    % TaskABA2 must be either empty or PRODUCING AN ARTEFACT
    interacc_helper(TaskABA2, ['112'], 'C~d-ABA-CSS-TASK', ColNumber2),
    % TeamABA2 must be either empty or INDIVIDUAL LEARNERS
    %                               or PAIRS or SMALL GROUPS
    interacc_helper(TeamABA2, ['201', '202', '203'], 'C~d-ABA-CSS-TEAM',
                    ColNumber2),
    % TechnologyABA12 must be either empty or MATERIALS AND TOOLS FOR PRACTICE
    interacc_helper(TechnologyABA12, ['311'], 'C~d-ABA-CSS-TEC1', ColNumber2),
    % TechnologyABA22 must be either empty or NO TECHN. or FORUM
    interacc_helper(TechnologyABA22, ['301', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber2),
    % TaskABB2 must be empty
    interacc_helper(TaskABB2, [], 'C~d-ABB-CSS-TASK', ColNumber2),
    % TeamABB1 must be empty
    interacc_helper(TeamABB2, [], 'C~d-ABB-CSS-TEAM', ColNumber2),
    % TechnologyABB11 must be empty
    interacc_helper(TechnologyABB12, [], 'C~d-ABB-CSS-TEC1', ColNumber2),
    % TechnologyABB21 must be empty
    interacc_helper(TechnologyABB22, [], 'C~d-ABB-CSS-TEC2', ColNumber2),
    debug_format('peer review 1 in cols ~d and ~d<br/>~n',
                 [ColNumber1, ColNumber2]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_peer2(Columns, NextColumns, ICPs) :-
/* Peer 2 spans 1 week:
 * 1a) Commenting on someone else's work,
 *     Individual learners or Pairs or Small groups,
 *     Forum or Text editor
 * 1b) empty
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or COMMENTING ON SOMEONE ELSE'S WORK
    interacc_helper(TaskABA, ['105'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or INDIVIDUAL LEARNERS or PAIRS
    %                              or SMALL GROUPS
    interacc_helper(TeamABA, ['201', '202', '203'], 'C~d-ABA-CSS-TEAM',
                    ColNumber),
    % TechnologyABA1 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['301', '308'], 'C~d-ABA-CSS-TEC1',
                    ColNumber),
    % TechnologyABA2 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA2, ['301', '308'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('peer review 2 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_peer3(Columns, NextColumns, ICPs) :-
/* Peer 3 spans 1 week:
 * 1a) Producing an artefact,
 *     Individual learners or Pairs or Small groups,
 *     Materials and tools for practice + (No Techn. or Forum)
 * 1b) Giving a presentation, Plenary, Projector or Videoconfer.
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or PRODUCING AN ARTEFACT
    interacc_helper(TaskABA, ['112'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or INDIVIDUAL LEARNERS or PAIRS
    %                              or SMALL GROUPS
    interacc_helper(TeamABA, ['201', '202', '203'], 'C~d-ABA-CSS-TEAM',
                    ColNumber),
    % TechnologyABA1 must be either empty or MATERIALS AND TOOLS FOR PRACTICE
    interacc_helper(TechnologyABA1, ['311'], 'C~d-ABA-CSS-TEC1', ColNumber),
    % TechnologyABA2 must be either empty or FORUM or NO TECHN.
    interacc_helper(TechnologyABA2, ['301', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be either empty or GIVING A PRESENTATION
    interacc_helper(TaskABB, ['108'], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB2 must be either empty or PLENARY
    interacc_helper(TeamABB, ['206'], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB12 must be either empty or PROJECTOR or VIDEOCONF.
    interacc_helper(TechnologyABB1, ['305', '309'], 'C~d-ABB-CSS-TEC1',
                    ColNumber),
    % TechnologyABB22 must be either empty or PROJECTOR or VIDEOCONF.
    interacc_helper(TechnologyABB2, ['305', '309'], 'C~d-ABB-CSS-TEC2',
                    ColNumber),
    debug_format('peer review 3 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).


intracc_pyramidL1(Columns, NextColumns, ICPs) :-
/* Pyramid (for list preparation) 1 spans 2 weeks:
 *  1a) Studying, Individual learners, Selected study materials
 *  1b) empty
 *  2a) Preparing a list of questions,
 *      Individual learner or Pairs,
 *      Text editor or Forum or (Forum + Text editor)
 *  2b) empty
 */
    Columns = [column(ColNumber1, _HasStar1, _Technique1, _Phase1,
                      TaskABA1, TeamABA1, TechnologyABA11, TechnologyABA21,
                      TaskABB1, TeamABB1, TechnologyABB11, TechnologyABB21),
               column(ColNumber2, _HasStar2, _Technique2, _Phase2,
                      TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22,
                      TaskABB2, TeamABB2, TechnologyABB12, TechnologyABB22)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or STUDYING
    interacc_helper(TaskABA1, ['102'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA1, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA11, ['306'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA21, ['306'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB1 must be empty
    interacc_helper(TaskABB1, [], 'C~d-ABB-CSS-TASK', ColNumber1),
    % TeamABB1 must be empty
    interacc_helper(TeamABB1, [], 'C~d-ABB-CSS-TEAM', ColNumber1),
    % TechnologyABB11 must be empty
    interacc_helper(TechnologyABB11, [], 'C~d-ABB-CSS-TEC1', ColNumber1),
    % TechnologyABB21 must be empty
    interacc_helper(TechnologyABB21, [], 'C~d-ABB-CSS-TEC2', ColNumber1),
    % TaskABA2 must be either empty or PREPARING A LIST OF QUESTIONS
    interacc_helper(TaskABA2, ['104'], 'C~d-ABA-CSS-TASK', ColNumber2),
    % TeamABA2 must be either empty or INDIVIDUAL LEARNERS or PAIRS
    interacc_helper(TeamABA2, ['201', '202'], 'C~d-ABA-CSS-TEAM',
                    ColNumber2),
    % TechnologyABA12 must be either empty or TEXT EDITOR or FORUM
    interacc_helper(TechnologyABA12, ['301', '308'], 'C~d-ABA-CSS-TEC1',
                    ColNumber2),
    % TechnologyABA22 must be either empty or TEXT EDITOR or FORUM
    interacc_helper(TechnologyABA22, ['301', '308'], 'C~d-ABA-CSS-TEC2',
                    ColNumber2),
    % TaskABB2 must be empty
    interacc_helper(TaskABB2, [], 'C~d-ABB-CSS-TASK', ColNumber2),
    % TeamABB2 must be empty
    interacc_helper(TeamABB2, [], 'C~d-ABB-CSS-TEAM', ColNumber2),
    % TechnologyABB12 must be empty
    interacc_helper(TechnologyABB12, [], 'C~d-ABB-CSS-TEC1', ColNumber2),
    % TechnologyABB22 must be empty
    interacc_helper(TechnologyABB22, [], 'C~d-ABB-CSS-TEC2', ColNumber2),
    debug_format('Pyramid (for list preparation) 1 in cols ~d and ~d<br/>~n',
                 [ColNumber1, ColNumber2]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_pyramidL2(Columns, NextColumns, ICPs) :-
/* Pyramid (for list preparation) 2 spans 1 week:
 * 1a) Preparing a list of questions,
 *     Pairs or Small groups,
 *     Forum or Text editor
 * 1b) empty
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or PREPARING A LIST OF QUESTIONS
    interacc_helper(TaskABA, ['104'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or PAIRS or SMALL GROUPS
    interacc_helper(TeamABA, ['202', '203'], 'C~d-ABA-CSS-TEAM',
                    ColNumber),
    % TechnologyABA1 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['301', '308'], 'C~d-ABA-CSS-TEC1',
                    ColNumber),
    % TechnologyABA2 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA2, ['301', '308'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Pyramid (for list preparation) 2 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_pyramidL3(Columns, NextColumns, ICPs) :-
/* Pyramid (for list preparation) 2 spans 1 week:
 * 1a) Preparing a list of questions,
 *     Plenary,
 *     Forum or Text editor
 * 1b) empty
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or PREPARING A LIST OF QUESTIONS
    interacc_helper(TaskABA, ['104'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or PLENARY
    interacc_helper(TeamABA, ['206'], 'C~d-ABA-CSS-TEAM', ColNumber),
    % TechnologyABA1 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['301', '308'], 'C~d-ABA-CSS-TEC1',
                    ColNumber),
    % TechnologyABA2 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA2, ['301', '308'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Pyramid (for list preparation) 3 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).


intracc_pyramidS1(Columns, NextColumns, ICPs) :-
/* Pyramid (for problem solving) 1 spans 2 weeks:
 *  1a) Studying, Individual learners, Selected study materials
 *  1b) empty
 *  2a) Solving a problem,
 *      Individual learner or Pairs,
 *      Text editor or Forum or (Forum + Text editor)
 *  2b) empty
 */
    Columns = [column(ColNumber1, _HasStar1, _Technique1, _Phase1,
                      TaskABA1, TeamABA1, TechnologyABA11, TechnologyABA21,
                      TaskABB1, TeamABB1, TechnologyABB11, TechnologyABB21),
               column(ColNumber2, _HasStar2, _Technique2, _Phase2,
                      TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22,
                      TaskABB2, TeamABB2, TechnologyABB12, TechnologyABB22)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or STUDYING
    interacc_helper(TaskABA1, ['102'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA1, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA11, ['306'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA21, ['306'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB1 must be empty
    interacc_helper(TaskABB1, [], 'C~d-ABB-CSS-TASK', ColNumber1),
    % TeamABB1 must be empty
    interacc_helper(TeamABB1, [], 'C~d-ABB-CSS-TEAM', ColNumber1),
    % TechnologyABB11 must be empty
    interacc_helper(TechnologyABB11, [], 'C~d-ABB-CSS-TEC1', ColNumber1),
    % TechnologyABB21 must be empty
    interacc_helper(TechnologyABB21, [], 'C~d-ABB-CSS-TEC2', ColNumber1),
    % TaskABA2 must be either empty or SOLVING A PROBLEM
    interacc_helper(TaskABA2, ['109'], 'C~d-ABA-CSS-TASK', ColNumber2),
    % TeamABA2 must be either empty or INDIVIDUAL LEARNERS or PAIRS
    interacc_helper(TeamABA2, ['201', '202'], 'C~d-ABA-CSS-TEAM',
                    ColNumber2),
    % TechnologyABA12 must be either empty or TEXT EDITOR or FORUM
    interacc_helper(TechnologyABA12, ['301', '308'], 'C~d-ABA-CSS-TEC1',
                    ColNumber2),
    % TechnologyABA22 must be either empty or TEXT EDITOR or FORUM
    interacc_helper(TechnologyABA22, ['301', '308'], 'C~d-ABA-CSS-TEC2',
                    ColNumber2),
    % TaskABB2 must be empty
    interacc_helper(TaskABB2, [], 'C~d-ABB-CSS-TASK', ColNumber2),
    % TeamABB2 must be empty
    interacc_helper(TeamABB2, [], 'C~d-ABB-CSS-TEAM', ColNumber2),
    % TechnologyABB12 must be empty
    interacc_helper(TechnologyABB12, [], 'C~d-ABB-CSS-TEC1', ColNumber2),
    % TechnologyABB22 must be empty
    interacc_helper(TechnologyABB22, [], 'C~d-ABB-CSS-TEC2', ColNumber2),
    debug_format('Pyramid (for problem solving) 1 in cols ~d and ~d<br/>~n',
                 [ColNumber1, ColNumber2]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_pyramidS2(Columns, NextColumns, ICPs) :-
/* Pyramid (for problem solving) 2 spans 1 week:
 * 1a) Solving a problem,
 *     Pairs or Small groups,
 *     Forum or Text editor
 * 1b) empty
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or SOLVING A PROBLEM
    interacc_helper(TaskABA, ['109'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or PAIRS or SMALL GROUPS
    interacc_helper(TeamABA, ['202', '203'], 'C~d-ABA-CSS-TEAM', ColNumber),
    % TechnologyABA1 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['301', '308'], 'C~d-ABA-CSS-TEC1',
                    ColNumber),
    % TechnologyABA2 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA2, ['301', '308'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Pyramid (for problem solving) 2 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_pyramidS3(Columns, NextColumns, ICPs) :-
/* Pyramid (for problem solving) 3 spans 1 week:
 * 1a) Solving a problem,
 *     Plenary,
 *     Forum or Text editor
 * 1b) empty
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or SOLVING A PROBLEM
    interacc_helper(TaskABA, ['109'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or PLENARY
    interacc_helper(TeamABA, ['206'], 'C~d-ABA-CSS-TEAM', ColNumber),
    % TechnologyABA1 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['301', '308'], 'C~d-ABA-CSS-TEC1',
                    ColNumber),
    % TechnologyABA2 must be either empty or FORUM or TEXT EDITOR
    interacc_helper(TechnologyABA2, ['301', '308'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Pyramid (for problem solving) 3 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).


/*
 * Discussion 1 may span 1 or 2 weeks: if the DEBATING activity is
 * carried out synchronously the whole duration is 1 week, otherwise 2
 * weeks.
 *
 * SYNCHRONOUS VERSION (1 week):
 * 1a) Finding materials, Individual learners,
 *     Source of materials for learning
 * 1b) Debating, Plenary, No Techn.
 *
 * ASYNCHRONOUS VERSION (2 weeks):
 * 1a) Finding materials, Individual learners,
 *     Source of materials for learning
 * 1b) empty
 * 2a) Debating, Plenary, Videoconf. or Forum (asynchronous)
 * 2b) empty
 *
 * C'è un problema di decidibilità: finché l'attività di debating
 * non viene esplicitamente indicata, non possiamo sapere se sarà
 * sincrona o asincrona, e non possiamo quindi conoscere se la tecnica
 * occupa 1 o 2 colonne. L'ipotesi di lavoro è che solo se la seconda
 * colonna contiene una delle carte del debating, allora si può assumere
 * una durata di 2 settimane; in carenza di
 * informazioni, conviene assumere una durata di 1 settimana.
*/
intracc_disc1(Columns, NextColumns, ICPs) :- % asynchronous, 2 weeks
    Columns = [column(ColNumber1, _HasStar1, _Technique1, _Phase1,
                      TaskABA1, TeamABA1, TechnologyABA11, TechnologyABA21,
                      TaskABB1, TeamABB1, TechnologyABB11, TechnologyABB21),
               column(ColNumber2, _HasStar2, _Technique2, _Phase2,
                      TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22,
                      TaskABB2, TeamABB2, TechnologyABB12, TechnologyABB22)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or FINDING MATERIALS
    interacc_helper(TaskABA1, ['103'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA1, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SOURCE OF MATERIALS FOR LEARNING
    interacc_helper(TechnologyABA11, ['307'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SOURCE OF MATERIALS FOR LEARNING
    interacc_helper(TechnologyABA21, ['307'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB1 must be empty
    interacc_helper(TaskABB1, [], 'C~d-ABB-CSS-TASK', ColNumber1),
    % TeamABB1 must be empty
    interacc_helper(TeamABB1, [], 'C~d-ABB-CSS-TEAM', ColNumber1),
    % TechnologyABB11 must be empty
    interacc_helper(TechnologyABB11, [], 'C~d-ABB-CSS-TEC1', ColNumber1),
    % TechnologyABB21 must be empty
    interacc_helper(TechnologyABB21, [], 'C~d-ABB-CSS-TEC2', ColNumber1),
    % TaskABA2 must be either empty or DEBATING
    interacc_helper(TaskABA2, ['113'], 'C~d-ABA-CSS-TASK', ColNumber2),
    % TeamABA2 must be either empty or PLENARY
    interacc_helper(TeamABA2, ['206'], 'C~d-ABA-CSS-TEAM', ColNumber2),
    % TechnologyABA12 must be either empty or VIDEOCONF. or FORUM
    interacc_helper(TechnologyABA12, ['301', '305'], 'C~d-ABA-CSS-TEC1',
                    ColNumber2),
    % TechnologyABA22 must be either empty or VIDEOCONF. or FORUM
    interacc_helper(TechnologyABA22, ['301', '305'], 'C~d-ABA-CSS-TEC2',
                    ColNumber2),
    % TaskABB2 must be empty
    interacc_helper(TaskABB2, [], 'C~d-ABB-CSS-TASK', ColNumber2),
    % TeamABB2 must be empty
    interacc_helper(TeamABB2, [], 'C~d-ABB-CSS-TEAM', ColNumber2),
    % TechnologyABB12 must be empty
    interacc_helper(TechnologyABB12, [], 'C~d-ABB-CSS-TEC1', ColNumber2),
    % TechnologyABB22 must be empty
    interacc_helper(TechnologyABB22, [], 'C~d-ABB-CSS-TEC2', ColNumber2),
    /*** at least one of
         [TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22]
         must be non empty ***/
    \+ (is_empty(TaskABA2),
        is_empty(TeamABA2),
        is_empty(TechnologyABA12),
        is_empty(TechnologyABA22) ),
    !,
    debug_format('Discussion (all cases) 1 in cols ~d and ~d<br/>~n',
                 [ColNumber1, ColNumber2]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).
intracc_disc1(Columns, NextColumns, ICPs) :- % synchronous, 1 week
/* SYNCHRONOUS VERSION (1 week):
 * 1a) Finding materials, Individual learners,
 *     Source of materials for learning
 * 1b) Debating, Plenary, No Techn.
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or FINDING MATERIALS
    interacc_helper(TaskABA, ['103'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SOURCE OF MATERIALS FOR LEARNING
    interacc_helper(TechnologyABA1, ['307'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SOURCE OF MATERIALS FOR LEARNING
    interacc_helper(TechnologyABA2, ['307'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB must be empty or DEBATING
    interacc_helper(TaskABB, ['113'], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty or PLENARY
    interacc_helper(TeamABB, ['206'], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty or NO TECHNOLOGY
    interacc_helper(TechnologyABB1, ['310'], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty or NO TECHNOLOGY
    interacc_helper(TechnologyABB2, ['310'], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Discussion (all cases) 1 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_disc2ass(Columns, NextColumns, ICPs) :-
/* DISCUSSION (TOWARDS ASSIGNMENT) 2 spans 1 week:
 * 1a) Carrying out an assignment,
 *     Individual learners or Pairs or Small groups
 *     Materials and tools for practice + (Forum or No Technology)
 * 1b) empty
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or CARRYING OUT AN ASSIGNMENT
    interacc_helper(TaskABA, ['107'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or INDIVIDUAL LEARNERS or PAIRS
    %                              or SMALL GROUPS
    interacc_helper(TeamABA, ['201', '202', '203'], 'C~d-ABA-CSS-TEAM',
                    ColNumber),
    % TechnologyABA1 must be either empty or MATERIALS AND TOOLS FOR PRACTICE
    interacc_helper(TechnologyABA1, ['311'], 'C~d-ABA-CSS-TEC1', ColNumber),
    % TechnologyABA2 must be either empty or FORUM or NO TECHNOLOGY
    interacc_helper(TechnologyABA2, ['301', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Discussion (assignment) 2 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_disc2art(Columns, NextColumns, ICPs) :-
/* DISCUSSION (TOWARDS ARTEFACT) 2 spans 1 week:
 * 1a) Producing an artefact,
 *     Individual learners or Pairs or Small groups
 *     Materials and tools for practice + (Forum or No Technology)
 * 1b) empty
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or PRODUCING AN ARTEFACT
    interacc_helper(TaskABA, ['112'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or INDIVIDUAL LEARNERS or PAIRS
    %                              or SMALL GROUPS
    interacc_helper(TeamABA, ['201', '202', '203'], 'C~d-ABA-CSS-TEAM',
                    ColNumber),
    % TechnologyABA1 must be either empty or MATERIALS AND TOOLS FOR PRACTICE
    interacc_helper(TechnologyABA1, ['311'], 'C~d-ABA-CSS-TEC1', ColNumber),
    % TechnologyABA2 must be either empty or FORUM or NO TECHNOLOGY
    interacc_helper(TechnologyABA2, ['301', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Discussion (artefact) 2 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_disc2rep(Columns, NextColumns, ICPs) :-
/* DISCUSSION (TOWARDS REPORT) 2 spans 1 week:
 * 1a) Writing a report,
 *     Individual learners or Pairs or Small groups
 *     Text editor + (Forum or No Technology)
 * 1b) empty
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or WRITING A REPORT
    interacc_helper(TaskABA, ['101'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or INDIVIDUAL LEARNERS or PAIRS
    %                              or SMALL GROUPS
    interacc_helper(TeamABA, ['201', '202', '203'], 'C~d-ABA-CSS-TEAM',
                    ColNumber),
    % TechnologyABA1 must be either empty or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['308'], 'C~d-ABA-CSS-TEC1', ColNumber),
    % TechnologyABA2 must be either empty or FORUM or NO TECHNOLOGY
    interacc_helper(TechnologyABA2, ['301', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Discussion (report) 2 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).


intracc_role1(Columns, NextColumns, ICPs) :-
/* ROLE PLAY 1 spans 1 week
 * 1a) Assuming roles, Small groups, No Techn. or Videoconfer.
 * 1b) Studying, Individual learners, Selected study materials
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or WRITING A REPORT
    interacc_helper(TaskABA, ['101'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or INDIVIDUAL LEARNERS or PAIRS
    %                              or SMALL GROUPS
    interacc_helper(TeamABA, ['201', '202', '203'], 'C~d-ABA-CSS-TEAM',
                    ColNumber),
    % TechnologyABA1 must be either empty or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['308'], 'C~d-ABA-CSS-TEC1', ColNumber),
    % TechnologyABA2 must be either empty or FORUM or NO TECHNOLOGY
    interacc_helper(TechnologyABA2, ['301', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty
    interacc_helper(TaskABB, [], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty
    interacc_helper(TeamABB, [], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty
    interacc_helper(TechnologyABB1, [], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty
    interacc_helper(TechnologyABB2, [], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Role play 1 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

intracc_role2(Columns, NextColumns, ICPs) :-
/* ROLE PLAY 2 spans 1 week
 * 1a) Writing a report, Small groups,
 *     Text editor + (No Techn. or Forum)
 * 1b) Giving a presentation, Plenary, Projector or Videoconfer.
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA must be either empty or WRITING A REPORT
    interacc_helper(TaskABA, ['101'], 'C~d-ABA-CSS-TASK', ColNumber),
    % TeamABA must be either empty or SMALL GROUPS
    interacc_helper(TeamABA, ['203'], 'C~d-ABA-CSS-TEAM', ColNumber),
    % TechnologyABA1 must be either empty or TEXT EDITOR
    interacc_helper(TechnologyABA1, ['308'], 'C~d-ABA-CSS-TEC1', ColNumber),
    % TechnologyABA2 must be either empty or FORUM or NO TECHNOLOGY
    interacc_helper(TechnologyABA2, ['301', '310'], 'C~d-ABA-CSS-TEC2',
                    ColNumber),
    % TaskABB must be empty or GIVING A PRESENTATION
    interacc_helper(TaskABB, ['108'], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty or PLENARY
    interacc_helper(TeamABB, ['206'], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty or PROJECTOR or VIDEOCONF.
    interacc_helper(TechnologyABB1, ['305', '309'], 'C~d-ABB-CSS-TEC1',
                    ColNumber),
    % TechnologyABB2 must be empty or PROJECTOR or VIDEOCONF.
    interacc_helper(TechnologyABB2, ['305', '309'], 'C~d-ABB-CSS-TEC2',
                    ColNumber),
    debug_format('Role play 1 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).


/*
 * Case Study 1 may span 1 or 2 weeks: if the SOLVING A PROBLEM activity
 * is carried out synchronously the whole duration is 1 week, otherwise
 * 2 weeks.
 *
 * SYNCHRONOUS VERSION (1 week):
 * 1a) Studying, Individual learners, Selected study materials
 * 1b) Solving a problem, Pairs or Small groups, No Techn.
 *
 * ASYNCHRONOUS VERSION (2 weeks):
 * 1a) Studying, Individual learners, Selected study materials
 * 1b) empty
 * 2a) Solving a problem, Pairs or Small groups, Forum
 * 2b) empty
 *
 * C'è un problema di decidibilità: finché l'attività di SOLVING A
 * PROBLEM non viene esplicitamente indicata, non possiamo sapere se è
 * sincrona o asincrona, e non possiamo quindi conoscere se la tecnica
 * occupa 1 o 2 colonne. L'ipotesi di lavoro è che solo se la seconda
 * colonna contiene una delle carte di SOLVING A PROBLEM, allora si può
 * assumere una durata di 2 settimane; in carenza di
 * informazioni, conviene assumere una durata di 1 settimana.
*/
intracc_case1(Columns, NextColumns, ICPs) :- % asynchronous, 2 weeks
    Columns = [column(ColNumber1, _HasStar1, _Technique1, _Phase1,
                      TaskABA1, TeamABA1, TechnologyABA11, TechnologyABA21,
                      TaskABB1, TeamABB1, TechnologyABB11, TechnologyABB21),
               column(ColNumber2, _HasStar2, _Technique2, _Phase2,
                      TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22,
                      TaskABB2, TeamABB2, TechnologyABB12, TechnologyABB22)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or STUDYING
    interacc_helper(TaskABA1, ['102'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA1, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA11, ['306'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA21, ['306'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB1 must be empty
    interacc_helper(TaskABB1, [], 'C~d-ABB-CSS-TASK', ColNumber1),
    % TeamABB1 must be empty
    interacc_helper(TeamABB1, [], 'C~d-ABB-CSS-TEAM', ColNumber1),
    % TechnologyABB11 must be empty
    interacc_helper(TechnologyABB11, [], 'C~d-ABB-CSS-TEC1', ColNumber1),
    % TechnologyABB21 must be empty
    interacc_helper(TechnologyABB21, [], 'C~d-ABB-CSS-TEC2', ColNumber1),
    % TaskABA2 must be either empty or SOLVING A PROBLEM
    interacc_helper(TaskABA2, ['109'], 'C~d-ABA-CSS-TASK', ColNumber2),
    % TeamABA2 must be either empty or PAIRS OR SMALL GROUPS
    interacc_helper(TeamABA2, ['202', '203'], 'C~d-ABA-CSS-TEAM', ColNumber2),
    % TechnologyABA12 must be either empty or FORUM
    interacc_helper(TechnologyABA12, ['301'], 'C~d-ABA-CSS-TEC1', ColNumber2),
    % TechnologyABA22 must be either empty or FORUM
    interacc_helper(TechnologyABA22, ['301'], 'C~d-ABA-CSS-TEC2', ColNumber2),
    % TaskABB2 must be empty
    interacc_helper(TaskABB2, [], 'C~d-ABB-CSS-TASK', ColNumber2),
    % TeamABB2 must be empty
    interacc_helper(TeamABB2, [], 'C~d-ABB-CSS-TEAM', ColNumber2),
    % TechnologyABB12 must be empty
    interacc_helper(TechnologyABB12, [], 'C~d-ABB-CSS-TEC1', ColNumber2),
    % TechnologyABB22 must be empty
    interacc_helper(TechnologyABB22, [], 'C~d-ABB-CSS-TEC2', ColNumber2),
    /*** at least one of
         [TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22]
         must be non empty ***/
    \+ (is_empty(TaskABA2),
        is_empty(TeamABA2),
        is_empty(TechnologyABA12),
        is_empty(TechnologyABA22) ),
    !,
    debug_format('Case Study 1 in cols ~d and ~d<br/>~n',
                 [ColNumber1, ColNumber2]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).
intracc_case1(Columns, NextColumns, ICPs) :-
/* SYNCHRONOUS VERSION (1 week):
 * 1a) Studying, Individual learners, Selected study materials
 * 1b) Solving a problem, Pairs or Small groups, No Techn.
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or STUDYING
    interacc_helper(TaskABA, ['102'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA1, ['306'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA2, ['306'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB must be empty or SOLVING A PROBLEM
    interacc_helper(TaskABB, ['109'], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty or PAIRS OR SMALL GROUPS
    interacc_helper(TeamABB, ['202', '203'], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty or NO TECHNOLOGY
    interacc_helper(TechnologyABB1, ['310'], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty or NO TECHNOLOGY
    interacc_helper(TechnologyABB2, ['310'], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Case Study 1 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

/*
 * Case Study 2 may span 1 or 2 weeks: if the DEBATING activity
 * is carried out synchronously the whole duration is 1 week, otherwise
 * 2 weeks.
 *
 * SYNCHRONOUS VERSION (1 week):
 * 1a) Studying, Individual learners, Selected study materials
 * 1b) Debating, Small groups or Plenary, No Techn.
 *
 * ASYNCHRONOUS VERSION (2 weeks):
 * 1a) Studying, Individual learners, Selected study materials
 * 1b) empty
 * 2a) Debating, Small groups or Plenary, Forum
 * 2b) empty
 *
 * C'è un problema di decidibilità: finché l'attività di DEBATING
 * non viene esplicitamente indicata, non possiamo sapere se sarà
 * sincrona o asincrona, e non possiamo quindi conoscere se la tecnica
 * occupa 1 o 2 colonne. L'ipotesi di lavoro è che solo se la seconda
 * colonna contiene una delle carte del debating, allora si può assumere
 * una durata di 2 settimane; in carenza di
 * informazioni, conviene assumere una durata di 1 settimana.
 */
intracc_case2(Columns, NextColumns, ICPs) :- % asynchronous 2 weeks
    Columns = [column(ColNumber1, _HasStar1, _Technique1, _Phase1,
                      TaskABA1, TeamABA1, TechnologyABA11, TechnologyABA21,
                      TaskABB1, TeamABB1, TechnologyABB11, TechnologyABB21),
               column(ColNumber2, _HasStar2, _Technique2, _Phase2,
                      TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22,
                      TaskABB2, TeamABB2, TechnologyABB12, TechnologyABB22)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or STUDYING
    interacc_helper(TaskABA1, ['102'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA1, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA11, ['306'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA21, ['306'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB1 must be empty
    interacc_helper(TaskABB1, [], 'C~d-ABB-CSS-TASK', ColNumber1),
    % TeamABB1 must be empty
    interacc_helper(TeamABB1, [], 'C~d-ABB-CSS-TEAM', ColNumber1),
    % TechnologyABB11 must be empty
    interacc_helper(TechnologyABB11, [], 'C~d-ABB-CSS-TEC1', ColNumber1),
    % TechnologyABB21 must be empty
    interacc_helper(TechnologyABB21, [], 'C~d-ABB-CSS-TEC2', ColNumber1),
    % TaskABA2 must be either empty or DEBATING
    interacc_helper(TaskABA2, ['113'], 'C~d-ABA-CSS-TASK', ColNumber2),
    % TeamABA2 must be either empty or SMALL GROUPS or PLENARY
    interacc_helper(TeamABA2, ['203', '206'], 'C~d-ABA-CSS-TEAM', ColNumber2),
    % TechnologyABA12 must be either empty or FORUM
    interacc_helper(TechnologyABA12, ['301'], 'C~d-ABA-CSS-TEC1', ColNumber2),
    % TechnologyABA22 must be either empty or FORUM
    interacc_helper(TechnologyABA22, ['301'], 'C~d-ABA-CSS-TEC2', ColNumber2),
    % TaskABB2 must be empty
    interacc_helper(TaskABB2, [], 'C~d-ABB-CSS-TASK', ColNumber2),
    % TeamABB2 must be empty
    interacc_helper(TeamABB2, [], 'C~d-ABB-CSS-TEAM', ColNumber2),
    % TechnologyABB12 must be empty
    interacc_helper(TechnologyABB12, [], 'C~d-ABB-CSS-TEC1', ColNumber2),
    % TechnologyABB22 must be empty
    interacc_helper(TechnologyABB22, [], 'C~d-ABB-CSS-TEC2', ColNumber2),
    /*** at least one of
         [TaskABA2, TeamABA2, TechnologyABA12, TechnologyABA22]
         must be non empty ***/
    \+ (is_empty(TaskABA2),
        is_empty(TeamABA2),
        is_empty(TechnologyABA12),
        is_empty(TechnologyABA22) ),
    !,
    debug_format('Case Study 2 in cols ~d and ~d<br/>~n',
                 [ColNumber1, ColNumber2]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).
intracc_case2(Columns, NextColumns, ICPs) :-
/* SYNCHRONOUS VERSION (1 week):
 * 1a) Studying, Individual learners, Selected study materials
 * 1b) Debating, Small groups or Plenary, No Techn.
 */
    Columns = [column(ColNumber, _HasStar, _Technique, _Phase,
                      TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                      TaskABB, TeamABB, TechnologyABB1, TechnologyABB2)
              | NextColumns],
    retractall(correctness:wrongSlot(_)),
    % TaskABA1 must be either empty or STUDYING
    interacc_helper(TaskABA, ['102'], 'C~d-ABA-CSS-TASK', ColNumber1),
    % TeamABA1 must be either empty or INDIVIDUAL LEARNERS
    interacc_helper(TeamABA, ['201'], 'C~d-ABA-CSS-TEAM', ColNumber1),
    % TechnologyABA11 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA1, ['306'], 'C~d-ABA-CSS-TEC1', ColNumber1),
    % TechnologyABA21 must be either empty or SELECTED STUDY MATERIALS
    interacc_helper(TechnologyABA2, ['306'], 'C~d-ABA-CSS-TEC2', ColNumber1),
    % TaskABB must be empty or DEBATING
    interacc_helper(TaskABB, ['113'], 'C~d-ABB-CSS-TASK', ColNumber),
    % TeamABB must be empty or SMALL GROUPS or PLENARY
    interacc_helper(TeamABB, ['203', '206'], 'C~d-ABB-CSS-TEAM', ColNumber),
    % TechnologyABB1 must be empty or NO TECHNOLOGY
    interacc_helper(TechnologyABB1, ['310'], 'C~d-ABB-CSS-TEC1', ColNumber),
    % TechnologyABB2 must be empty or NO TECHNOLOGY
    interacc_helper(TechnologyABB2, ['310'], 'C~d-ABB-CSS-TEC2', ColNumber),
    debug_format('Case Study 2 in col ~d<br/>~n', [ColNumber]),
    ( setof(X, wrongSlot(X), ICPs) ; ICPs = []),
    retractall(correctness:wrongSlot(_)).

interacc_helper(CardInSlot, ExpectedCards, SlotNameFmt, ColNumber) :-
    ( is_not_empty(CardInSlot),
      \+ member(CardInSlot, ExpectedCards)
    ) ->
    ( format(string(SlotName), SlotNameFmt, [ColNumber]),
      assertz(wrongSlot(SlotName))
    ) ;
    true.
interacc_helper(CardInSlot, ExpectedCards, SlotNameFmt, ColNumber, Row) :-
    ( is_not_empty(CardInSlot),
      \+ member(CardInSlot, ExpectedCards)
    ) ->
    ( format(string(SlotName), SlotNameFmt, [ColNumber, Row]),
      assertz(wrongSlot(SlotName))
    ) ;
    true.


intracc_3t(Column, ICPs) :-
/*
 * intracc_3t
 * for each 3T row:
 *   if task card is present, calls check_task/7
 *   if task card is not present, calls check_team_technology/6
 *   in both cases, at end calls checkNoTechnologiesReplicated/2
 *
 */
    Column = column(ColNumber, _HasStar, _Technique, _Phase,
                    TaskABA, TeamABA, TechnologyABA1, TechnologyABA2,
                    TaskABB, TeamABB, TechnologyABB1, TechnologyABB2),
    retractall(correctness:wrongSlot(_)),
    ( is_empty(TaskABA) ->
      check_team_technology(ColNumber, 'A', TeamABA,
                 TechnologyABA1, TechnologyABA2)
    ;
      check_task(ColNumber, 'A', TaskABA, TeamABA,
                 TechnologyABA1, TechnologyABA2)
    ),
    ( is_empty(TaskABB) ->
      check_team_technology(ColNumber, 'B', TeamABB,
                 TechnologyABB1, TechnologyABB2)
    ;
      check_task(ColNumber, 'B', TaskABB, TeamABB,
                 TechnologyABB1, TechnologyABB2)
    ),
    checkNoTechnologiesReplicated(Column, ICP2s),
    ( setof(X, wrongSlot(X), ICP1s) ; ICP1s = []),
    append(ICP1s, ICP2s, ICPs),
    retractall(correctness:wrongSlot(_)).

check_task(ColNumber, Row, '101', Team, Technology1, Technology2) :-
/* Task: WRITING A REPORT
 * Team: INDIVIDUAL LEARNERS or PAIRS or SMALL GROUPS
 * Technology: TEXT EDITOR or (TEXT EDITOR & FORUM) or WIKI SOFTWARE
 */
    debug_format('WRITING A REPORT col ~d row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['201', '202', '203'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['308', '304'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['301'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '102', Team, Technology1, Technology2) :-
/* Task: STUDYING
 * Team: INDIVIDUAL LEARNERS or PAIRS or SMALL GROUPS
 * Technology: SELECTED STUDY MATERIALS
 */
    debug_format('STUDYING col=~d, row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['201', '202', '203'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['306'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['306'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '103', Team, Technology1, Technology2) :-
/* Task: FINDING MATERIALS
 * Team: INDIVIDUAL LEARNERS or PAIRS or SMALL GROUPS
 * Technology: SOURCE OF MATERIALS FOR LEARNING
 */
    debug_format('FINDING MATERIALS col=~d, row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['201', '202', '203'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['307'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['307'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '104', Team, Technology1, Technology2) :-
/* Task: PREPARING A LIST OF QUESTIONS
 * Team: individually or in a group of any size
 * Technology: Text editor or (text editor + forum) or (text editor + videoconf.)
 */
    debug_format('PREPARING A LIST OF QUESTIONS col=~d, row=~w<br/>~n',
                 [ColNumber, Row]),
    interacc_helper(Team, ['201', '202', '203', '204', '205', '206'],
                    'C~d-AB~w-CSS-TEAM', ColNumber, Row),
    interacc_helper(Technology1, ['308'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['301', '305'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '105', Team, Technology1, Technology2) :-
/* Task: COMMENTING ON SOMEONE ELSE'S WORK
 * Team: INDIVIDUAL LEARNERS or PAIRS or SMALL GROUPS
 * Technology: Text editor or (text editor + forum)
 */
    debug_format('COMMENTING ON SOMEONE ELSE\'S WORK col=~d, row=~w<br/>~n',
                 [ColNumber, Row]),
    interacc_helper(Team, ['201', '202', '203'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['308'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['301'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '106', Team, Technology1, Technology2) :-
/* Task: PREPARING A PRESENTATION
 * Team: INDIVIDUAL LEARNERS or PAIRS or SMALL GROUPS or MEDIUM-SIZED GROUPS
 * Technology: Presentation software or
 *            (presentation software + forum) or
 *            (presentation software + IWB)
 */
    debug_format('PREPARING A PRESENTATION col=~d, row=~w<br/>~n',
                 [ColNumber, Row]),
    interacc_helper(Team, ['201', '202', '203', '204'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['302'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['301', '303'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '107', Team, Technology1, Technology2) :-
/* Task: CARRYING OUT AN ASSIGNMENT
 * Team: INDIVIDUAL LEARNERS or PAIRS or SMALL GROUPS
 * Technology: MATERIALS AND TOOLS FOR PRACTICE or
 *             (MATERIALS AND TOOLS FOR PRACTICE + IWB) or
 *             (MATERIALS AND TOOLS FOR PRACTICE + forum)
 */
    debug_format('CARRYING OUT AN ASSIGNMENT col=~d, row=~w<br/>~n',
                 [ColNumber, Row]),
    interacc_helper(Team, ['201', '202', '203'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['311'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['303', '301'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '108', Team, Technology1, Technology2) :-
/* Task: GIVING A PRESENTATION
 * Team: PLENARY
 * Technology: projector or IWB or videoconference
 */
    debug_format('GIVING A PRESENTATION col=~d, row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['206'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['309', '303', '305'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['309', '303', '305'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '109', Team, Technology1, Technology2) :-
/* Task: SOLVING A PROBLEM
 * Team: PAIRS or SMALL GROUPS
 * Technology: no-technology or videoconference or forum
 */
    debug_format('SOLVING A PROBLEM col=~d, row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['202', '203'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['310', '305', '301'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['310', '305', '301'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '110', Team, Technology1, Technology2) :-
/* Task: INTERVIEWING AN EXPERT
 * Team: MEDIUM-SIZED GROUPS or LARGE GROUPS or PLENARY
 * Technology: no-technology or videoconference or forum
 */
    debug_format('INTERVIEWING AN EXPERT col=~d, row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['204', '205', '206'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['310', '305', '301'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['310', '305', '301'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '111', Team, Technology1, Technology2) :-
/* Task: ASSUMING ROLES
 * Team: SMALL GROUPS
 * Technology: no-technology or videoconference or forum
 */
    debug_format('ASSUMING ROLES col=~d, row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['203'], 'C~d-AB~w-CSS-TEAM',
                    ColNumber, Row),
    interacc_helper(Technology1, ['310', '305', '301'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['310', '305', '301'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '112', Team, Technology1, Technology2) :-
/* Task: PRODUCING AN ARTEFACT
 * Team: individually or in groups of any size
 * Technology: MATERIALS AND TOOLS FOR PRACTICE or
 *            (MATERIALS AND TOOLS FOR PRACTICE + IWB) or
 *            (MATERIALS AND TOOLS FOR PRACTICE + forum)
 */
    debug_format('PRODUCING AN ARTEFACT col=~d, row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['201', '202', '203', '204', '205', '206'],
                    'C~d-AB~w-CSS-TEAM', ColNumber, Row),
    interacc_helper(Technology1, ['311'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['303', '301'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, '113', Team, Technology1, Technology2) :-
/* Task: DEBATING
 * Team: groups of any size
 * Technology: FORUM or NO TECHNOLOGY or VIDEOCONF.
 */
    debug_format('DEBATING col=~d, row=~w<br/>~n', [ColNumber, Row]),
    interacc_helper(Team, ['202', '203', '204', '205', '206'],
                    'C~d-AB~w-CSS-TEAM', ColNumber, Row),
    interacc_helper(Technology1, ['301', '310', '305'], 'C~d-AB~w-CSS-TEC1',
                    ColNumber, Row),
    interacc_helper(Technology2, ['301', '310', '305'], 'C~d-AB~w-CSS-TEC2',
                    ColNumber, Row).
check_task(ColNumber, Row, Task, _Team, _Technology1, _Technology2) :-
    debug_format('check_task catchall col=~d, row=~w, task=~w<br/>~n',
                 [ColNumber, Row, Task]).

check_team_technology(ColNumber, Row, '201', Technology1, Technology2) :-
    /* Team: INDIVIDUAL LEARNER
     * Technology: PRESENTATION SOFTWARE or
     *             WIKI SOFTWARE or
     *             SELECTED STUDY MATERIALS or
     *             SOURCE OF MATERIALS FOR LEARNING or
     *             TEXT EDITOR or
     *             NO TECHNOLOGY or
     *             MATERIALS AND TOOLS FOR PRACTICE
     */
    interacc_helper(Technology1,
                    ['302', '304', '306', '307', '308', '310', '311'],
                    'C~d-AB~w-CSS-TEC1', ColNumber, Row),
    interacc_helper(Technology2,
                    ['302', '304', '306', '307', '308', '310', '311'],
                    'C~d-AB~w-CSS-TEC2', ColNumber, Row).
check_team_technology(ColNumber, Row, '202', Technology1, Technology2) :-
    /* Team: PAIRS
     * Technology: FORUM or
     *             PRESENTATION SOFTWARE or
     *             INTERACTIVE WHITEBOARD (IWB) or
     *             WIKI SOFTWARE or
     *             VIDEOCONFERENCING SYSTEM or
     *             SELECTED STUDY MATERIALS or
     *             SOURCE OF MATERIALS FOR LEARNING or
     *             TEXT EDITOR or
     *             PROJECTOR or
     *             NO TECHNOLOGY or
     *             MATERIALS AND TOOLS FOR PRACTICE
     */
    interacc_helper(Technology1,
                    ['301', '302', '303', '304', '305',
                     '306', '307', '308', '309', '310', '311'],
                    'C~d-AB~w-CSS-TEC1', ColNumber, Row),
    interacc_helper(Technology2,
                    ['301', '302', '303', '304', '305',
                     '306', '307', '308', '309', '310', '311'],
                    'C~d-AB~w-CSS-TEC2', ColNumber, Row).
check_team_technology(ColNumber, Row, '203', Technology1, Technology2) :-
    /* Team: SMALL GROUPS
     * Technology: FORUM or
     *             PRESENTATION SOFTWARE or
     *             INTERACTIVE WHITEBOARD (IWB) or
     *             WIKI SOFTWARE or
     *             VIDEOCONFERENCING SYSTEM or
     *             SELECTED STUDY MATERIALS or
     *             SOURCE OF MATERIALS FOR LEARNING or
     *             TEXT EDITOR or
     *             PROJECTOR or
     *             NO TECHNOLOGY or
     *             MATERIALS AND TOOLS FOR PRACTICE
     */
    interacc_helper(Technology1,
                    ['301', '302', '303', '304', '305',
                     '306', '307', '308', '309', '310', '311'],
                    'C~d-AB~w-CSS-TEC1', ColNumber, Row),
    interacc_helper(Technology2,
                    ['301', '302', '303', '304', '305',
                     '306', '307', '308', '309', '310', '311'],
                    'C~d-AB~w-CSS-TEC2', ColNumber, Row).
check_team_technology(ColNumber, Row, '204', Technology1, Technology2) :-
    /* Team: MEDIUM-SIZED GROUPS
     * Technology: FORUM or
     *             PRESENTATION SOFTWARE or
     *             INTERACTIVE WHITEBOARD (IWB) or
     *             WIKI SOFTWARE or
     *             VIDEOCONFERENCING SYSTEM or
     *             SELECTED STUDY MATERIALS or
     *             SOURCE OF MATERIALS FOR LEARNING or
     *             TEXT EDITOR or
     *             PROJECTOR or
     *             NO TECHNOLOGY or
     *             MATERIALS AND TOOLS FOR PRACTICE
     */
    interacc_helper(Technology1,
                    ['301', '302', '303', '304', '305',
                     '306', '307', '308', '309', '310', '311'],
                    'C~d-AB~w-CSS-TEC1', ColNumber, Row),
    interacc_helper(Technology2,
                    ['301', '302', '303', '304', '305',
                     '306', '307', '308', '309', '310', '311'],
                    'C~d-AB~w-CSS-TEC2', ColNumber, Row).
check_team_technology(ColNumber, Row, '205', Technology1, Technology2) :-
    /* Team: LARGE GROUPS
     * Technology: FORUM or
     *             PRESENTATION SOFTWARE or
     *             INTERACTIVE WHITEBOARD (IWB) or
     *             WIKI SOFTWARE or
     *             VIDEOCONFERENCING SYSTEM or
     *             SELECTED STUDY MATERIALS or
     *             SOURCE OF MATERIALS FOR LEARNING or
     *             TEXT EDITOR or
     *             PROJECTOR or
     *             NO TECHNOLOGY or
     *             MATERIALS AND TOOLS FOR PRACTICE
     */
    interacc_helper(Technology1,
                    ['301', '302', '303', '304', '305',
                     '306', '307', '308', '309', '310', '311'],
                    'C~d-AB~w-CSS-TEC1', ColNumber, Row),
    interacc_helper(Technology2,
                    ['301', '302', '303', '304', '305',
                     '306', '307', '308', '309', '310', '311'],
                    'C~d-AB~w-CSS-TEC2', ColNumber, Row).
check_team_technology(ColNumber, Row, '206', Technology1, Technology2) :-
    /* Team: PLENARY
     * Technology: FORUM or
     *             PRESENTATION SOFTWARE or
     *             INTERACTIVE WHITEBOARD (IWB) or
     *             WIKI SOFTWARE or
     *             VIDEOCONFERENCING SYSTEM or
     *             PROJECTOR or
     *             NO TECHNOLOGY
     */
    interacc_helper(Technology1,
                    ['301', '302', '303', '304', '305', '309', '310'],
                    'C~d-AB~w-CSS-TEC1', ColNumber, Row),
    interacc_helper(Technology2,
                    ['301', '302', '303', '304', '305', '309', '310'],
                    'C~d-AB~w-CSS-TEC2', ColNumber, Row).
check_team_technology(ColNumber, Row, Team, _Technology1, _Technology2) :-
    ( is_not_empty(Team) ->
      debug_format('check_team_technology catchall col=~d, row=~w, team=~w<br/>~n',
                   [ColNumber, Row, Team])
    ) ; true.


checkNoTechnologiesReplicated(
    column(ColNumber, _HasStar, _Technique, _Phase,
           _TaskABA, _TeamABA, TechnologyABA1, TechnologyABA2,
           _TaskABB, _TeamABB, TechnologyABB1, TechnologyABB2), ICPs) :-
    ( ( TechnologyABA1 = TechnologyABA2, TechnologyABA1 \= '' ) ->
      ( format(string(SlotName1), 'C~d-ABA-CSS-TEC2', [ColNumber]),
        ICP1s = [SlotName1] )
      ;
      ( ICP1s = [] )
    ),
    ( ( TechnologyABB1 = TechnologyABB2, TechnologyABB1 \= '' ) ->
      ( format(string(SlotName2), 'C~d-ABB-CSS-TEC2', [ColNumber]),
        ICP2s = [SlotName2] )
      ;
      ( ICP2s = [] )
    ),
    append(ICP1s, ICP2s, ICPs).

