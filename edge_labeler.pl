permute([], []).
permute([X|Rest], L) :-
    permute(Rest, L1),
    select(X, L, L1).

% get numbers from 1 to N
getnums(N,Lis) :-
    getnumsinner(N,Revlis),
    reverse(Revlis,Lis).
getnumsinner(1,[1]).
getnumsinner(N,[N|Lis]) :-
    N > 1,
    M is N-1,
    getnumsinner(M,Lis).



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
    nth1(Head,Labels,Num1),
    nth1(Tail,Labels,Num2),
    Le1 is Le + 1,
    between(1,Le1,Num1),
    between(1,Le1,Num2),
    Diff is abs(Num1-Num2).

satisfies_alternate(E,Ew,L,Le) :-
    satisfies_alternate_inner(E,Ew,L,Le).

satisfies_alternate_inner([],[],_,_).

satisfies_alternate_inner([Head|Tail],[Ewhead|Ewtail],L,Le) :-
    Vnum is Le + 1,
    length(L,Vnum),
    difference_alternate(Head,L,Ewhead,Le),
    satisfies_alternate_inner(Tail,Ewtail,L,Le),
    is_set(L).

graceful_alternate(E,L) :-
length(E,Le),
getnums(Le,Weights),
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