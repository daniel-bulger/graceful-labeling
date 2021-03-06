% this will deal with graceful labelings for a tree

permute([], []).
permute([X|Rest], L) :-
    permute(Rest, L1),
    select(X, L, L1).

% get numbers from 0 to N - 1
getnums(N,Lis) :-
    M is N - 1,
    getnumsinner(M,Revlis),
    reverse(Revlis,Lis).
getnumsinner(0,[0]).
getnumsinner(N,[N|Lis]) :-
    N > 0,
    M is N-1,
    getnumsinner(M,Lis).

difference([Head,Tail],Labels,Diff) :-
    nth0(Head,Labels,Num1),
    nth0(Tail,Labels,Num2),
    Diff is abs(Num1-Num2).

% does L satisfy E
satisfies(E,L) :-
    satisfies_inner(E,L,_).

satisfies_inner([],_,[]).
satisfies_inner([Head|Tail],L,[Usedhead|Usedtail]) :-
    difference(Head,L,Usedhead),
    satisfies_inner(Tail,L,Usedtail),
    is_set([Usedhead|Usedtail]).

% args: list of edges (0-indexed), labeling
graceful(E,L) :-
length(E,Le),
V is Le+1,
getnums(V,Nums),
permute(Nums,L),
satisfies(E,L).
