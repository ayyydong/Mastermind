% the gameboard 
:- use_module(library(random)).

% store value of game solution as key(List).  Will randomize for each new instance of swipl.
:- table key/1. 
key(List) :- randseq(4,6,List).

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
	show(X,10).
displayBoard(gameBoard(X), N, List):- 
	write('   ? ? ? ?'), 
	nl,
	show(X,10).

% show(X,N) shows lines [N .. 1] of board X
show(_,0).
show(X,N):- 
	showLine(X,N,X2),
	Ns is N-1,
    show(X2,Ns).

%showLine(X,N,X2) writes N and shows first line of board X (first element of every column). X2 is X without the shown line.
showLine(X,N,X2):- N >= 10, write(N), write(' '), 
		showLineHelper(X,X2), nl.
showLine(X,N,X2):- write(N), write('  '),
		showLineHelper(X,X2), nl.

%showLineHelper(X,X2) writes first element of every column. X2 is X without the shown line.
showLineHelper([],_).
showLineHelper([[X|X2]|XS],[X2|XS2]):- write(X), write(' '),
			          showLineHelper(XS,XS2).

uncoverAnswer(X,[H|T]):-
	displayBoard(X, 0).

mastermind:- 
	makeGreeting, 
	initialize(X),
	displayBoard(X,10,List), !.
     
makeGreeting :- 
    writeln('\e[H\e[2J'),
    writeln("			   █░█░█ █▀▀ █░░ █▀▀ █▀█ █▀▄▀█ █▀▀								"),
    writeln("			   ▀▄▀▄▀ ██▄ █▄▄ █▄▄ █▄█ █░▀░█ ██▄								"),
	nl,
    writeln("				       ▀█▀ █▀█           								"),
    writeln("				       ░█░ █▄█										"),
    nl,
    writeln("███╗░░░███╗░█████╗░░██████╗████████╗███████╗██████╗░███╗░░░███╗██╗███╗░░██╗██████╗░"),
    writeln("████╗░████║██╔══██╗██╔════╝╚══██╔══╝██╔════╝██╔══██╗████╗░████║██║████╗░██║██╔══██╗"),
    writeln("██╔████╔██║███████║╚█████╗░░░░██║░░░█████╗░░██████╔╝██╔████╔██║██║██╔██╗██║██║░░██║"),
    writeln("██║╚██╔╝██║██╔══██║░╚═══██╗░░░██║░░░██╔══╝░░██╔══██╗██║╚██╔╝██║██║██║╚████║██║░░██║"),
    writeln("██║░╚═╝░██║██║░░██║██████╔╝░░░██║░░░███████╗██║░░██║██║░╚═╝░██║██║██║░╚███║██████╔╝"),
    writeln("╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░░░░╚═╝░░░╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝╚═════╝░"),
    nl, 
    writeln("Instructions [ Enter 1 ]"),
    nl,
    writeln("Settings [ Enter 2 ]"),
    nl,
    writeln("Load Game [ Enter 3 ]"),
    nl,
    readChoice(C).

readChoice(C) :-
	get_char(C),
	C == '1',
	writeln('\e[H\e[2J'),
	nl,
	writeln('Guess the 4-digit key by typing: guess(N1,N2,N3,N4) where each N is a unique number from 1 to 6.'), 
	writeln('Duplicates are not allowed. The computer will return clues based on your guesses.'),
	writeln('You will have 10 guesses before the answer is revealed and the bot wins...'), 
    nl, !.

% nextMove(X, 10), !.

guess(A,B,C,D):- countcolor([A,B,C,D],0),nl,countcorrect([A,B,C,D],0,1).

nextMove(X, 0):- triesleft(X),
		updateBoard(X),
		write('Bot wins!').
nextMove(X, Tries):- 
		guess(A,B,C,D), 
		nextMove(X, Num),
		write('You win!'),
		Num is Tries-1.

countcolor([],Count1):-
	write(Count1),
	write(' of your guessed colors are in the answer').

countcolor([H|T],Count1):-
    key(List),
    member(H, List),
    Count is Count1 + 1,
    countcolor(T,Count).

countcolor([_|T],Count1):-
    countcolor(T,Count1).

countcorrect([],Count1,_):-
    write(Count1),
    write(' of your guessed colors are in the right place').

countcorrect([H|T],Count1,Pos1):-
    key(List),
    nth1(Pos1,List,H),
    Pos is Pos1 + 1,
    Count is Count1 + 1,
    countcorrect(T,Count,Pos).

countcorrect([_|T],Count1,Pos1):-
    Pos is Pos1 + 1,
    countcorrect(T,Count1,Pos).
