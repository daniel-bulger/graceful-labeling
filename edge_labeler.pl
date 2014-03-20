permute([], []).
permute([X|Rest], L) :-
    permute(Rest, L1),
    select(X, L, L1).

% get numbers from 1 to N
getnums1(N,Lis) :-
    getnumsinner(N,Revlis),
    reverse(Revlis,Lis).
getnumsinner(1,[1]).
getnumsinner(N,[N|Lis]) :-
    N > 1,
    M is N-1,
    getnumsinner(M,Lis).

indexof([Element|_], Element, 0). % We found the element
indexof([_|Tail], Element, Index):-
  indexof(Tail, Element, Index1), % Check in the tail of the list
  Index is Index1+1.  % and increment the resulting index

% Case 1: Index not specified
nth1(Index, In, Element, Rest) :-
    var(Index), !,
    generate_nth(1, Index, In, Element, Rest).
% Case 2: Index is specified
nth1(Index, In, Element, Rest) :-
    integer(Index), Index > 0,
    find_nth1(Index, In, Element, Rest).

generate_nth(I, I, [Head|Rest], Head, Rest).
generate_nth(I, IN, [H|List], El, [H|Rest]) :-
    I1 is I+1,
    generate_nth(I1, IN, List, El, Rest).

find_nth1(1, [Head|Rest], Head, Rest) :- !.
find_nth1(N, [Head|Rest0], Elem, [Head|Rest]) :-
    M is N-1,
    find_nth1(M, Rest0, Elem, Rest).

% my code

num_occurrences([Item],Item,Num) :-
    Num is 1.
num_occurrences([Elem],Item,Num) :-
    Elem \== Item,
    Num is 0.
num_occurrences([Item|Tail],Item,Num) :-
    num_occurrences(Tail,Item,Oldnum),
    Num is Oldnum + 1. 
num_occurrences([Head|Tail],Item,Num) :-
    Head \== Item,
    num_occurrences(Tail,Item,Num).

difference_alternate([Head,Tail],Labels,Diff,Le) :-
    nth0(Head,Labels,Num1),
    nth0(Tail,Labels,Num2),
    between(0,Le,Num1),
    between(0,Le,Num2),
    Diff is abs(Num1-Num2).

satisfies_alternate(E,Ew,L,Le) :-
    satisfies_alternate_inner(E,Ew,L,Le).

satisfies_alternate_inner([],[],_,_).

satisfies_alternate_inner(E,Ew,L,Le) :-
    Vnum is Le + 1,
    length(L,Vnum),
    length(Ew,Ewnum),
    indexof(Ew,Ewnum,NextIndex0),
    NextIndex is NextIndex0 + 1,
    nth1(NextIndex,E,NextEdge,RestEdges),
    nth1(NextIndex,Ew,NextEdgeWeight,RestEdgeWeights),
    difference_alternate(NextEdge,L,NextEdgeWeight,Le),
    satisfies_alternate_inner(RestEdges,RestEdgeWeights,L,Le),
    is_set(L).

graceful_alternate(E,L) :-
length(E,Le),
getnums1(Le,Weights),
permute(Weights,Ew),
satisfies_alternate(E,Ew,L,Le).

no_dups([]).
no_dups([I]) :-
    number(I).
no_dups([I]) :-
    not(integer(I)).
no_dups([Head,Tail]) :-
    number(Tail),
    not(integer(Head)).
no_dups([Head,Tail]) :-
    number(Head),
    not(integer(Tail)).
no_dups([Head,Tail]) :-
    integer(Head),
    integer(Tail),
    Head =\= Tail.
no_dups([Head1,Head2|Tail]) :-
    no_dups([Head1|Tail]),
    no_dups([Head2|Tail]).