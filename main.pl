% main entry point of the game

guess(A,B,C,D):-countcolor([A,B,C,D],0),nl,countcorrect([A,B,C,D],0,1).

countcolor([],Count1):-
write(Count1),
write(' of your guessed color is in the answer').

countcolor([H|T],Count1):-
    exist(H),
    Count is Count1 + 1,
    countcolor(T,Count).
countcolor([_|T],Count1):-
    countcolor(T,Count1).

countcorrect([],Count1,_):-
    write(Count1),
    write(' of your guessed color is at the right place').
countcorrect([H|T],Count1,Pos1):-
    ans(Pos1,H),
    Pos is Pos1 + 1,
    Count is Count1 + 1,
    countcorrect(T,Count,Pos).
countcorrect([_|T],Count1,Pos1):-
    Pos is Pos1 + 1,
    countcorrect(T,Count1,Pos).

ans(1,1).
ans(2,2).
ans(3,3).
ans(4,4).
exist(1).
exist(2).
exist(3).
exist(4).