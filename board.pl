% the gameboard 
:- use_module(library(random)).

% Initialize empty board
initialize(gameBoard([
	['_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_']])).


displayBoard(gameBoard(X), 0, List):- 
	atomic_list_concat(List, ' ', FinalAtom),
	atom_concat('   ',FinalAtom,A),
	write(A), 
	nl,
	iShow(X,10).
displayBoard(gameBoard(X), N, List):- 
	write('   ? ? ? ?'), 
	nl,
	iShow(X,10).

% iShow(X,N) shows lines [N .. 1] of board X
iShow(_,0).
iShow(X,N):- 
	showLine(X,N,X2),
	Ns is N-1,
    iShow(X2,Ns).

%showLine(X,N,X2) writes N and shows first line of board X (first element of every column). X2 is X without the shown line.
showLine(X,N,X2):- N >= 10, write(N), write(' '), 
		iShowLine(X,X2), nl.
showLine(X,N,X2):- write(N), write('  '),
		iShowLine(X,X2), nl.

%iShowLine(X,X2) writes first element of every column. X2 is X without the shown line.
iShowLine([],_).
iShowLine([[X|X2]|XS],[X2|XS2]):- write(X), write(' '),
			          iShowLine(XS,XS2).

uncoverAnswer(X,[H|T]):-
	displayBoard(X, 0).

mastermind:- initialize(X),
	   randseq(4,6,List), 
	   displayBoard(X,10,List).

% nextMove(X, 10), !.

guess(A,B,C,D):- countcolor([A,B,C,D],0),nl,countcorrect([A,B,C,D],0,1).

nextMove(X, 0):- triesleft(X),
		updateBoard(X),
		write('Machine wins!').
nextMove(X, Tries):- 
		guess(A,B,C,D), 
		nextMove(X, Num),
		write('You win!'),
		Num is Tries-1.

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