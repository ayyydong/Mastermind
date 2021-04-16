% the gameboard 
:- use_module(library(random)).

% Initialize empty board
initialize(10, gameBoard([
	['_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_']])).

initialize(8, gameBoard([
	['_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_'],
    ['_', '_', '_', '_', '_', '_', '_', '_']])).

displayBoard(gameBoard(X), 0, List):- 
	writeln("end"),
	atomic_list_concat(List, ' ', FinalAtom),
	atom_concat('   ',FinalAtom,A),
	write(A), 
	nl,
	show(X,10).
displayBoard(gameBoard(X), N, List):- 
	atomic_list_concat(List, ' ', FinalAtom),
	atom_concat('   ',FinalAtom,A),
	write(A), 
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

uncoverAnswer(X,[H|T], List):-
	displayBoard(X, 0, List).

mastermind:- 
	makeGreeting(2,1),
	!.
     
makeGreeting(D, M) :- 
	repeat,
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
    writeln("How to play/ Information about the game [ Enter 1 ]"),
    nl,
    writeln("Settings [ Enter 2 ]"),
    nl,
    writeln("Load Game [ Enter 3 ]"),
    nl,
    readChoice(C, D, M, Hints, Guesses, AIs).

readChoice(C, D, M, Hints, Guesses, AIs) :-
	writeln(D),
	writeln(M),
	get_char(C),
	(C == '1' -> 
		writeln('\e[H\e[2J'),
		writeln("User single player: "),
		nl,
		writeln('Guess the 4-digit key by typing: guess(N1,N2,N3,N4) where each N is a unique number from 1 to 6.'), 
		writeln('Duplicates are not allowed. The bot will return clues based on your guesses.'),
		writeln('You will have 10 guesses before the answer is revealed and the bot wins...'),
		nl,
		nl,
		nl,
		writeln("User vs Bot: "),
		nl,
		writeln("A number generator will randomly generate a 4-digit key. The user and the bot will compete to guess the 4-digit key first."),
		writeln('Each player will take turns guessing. A draw will be when the board is full'),
		nl,
    	nl,
		writeln('Enter anything to return to home page.'),
		get_char(K),
		(K == '1' ->
			fail
		; fail
		)
	; C == '2' ->
		repeat,
		writeln('\e[H\e[2J'),
		% writeln(D), writeln(M), 
		nl,
		writeln("Choose difficulty level (Default: Medium) [ Enter 1 ]"),
		nl,
		writeln("Choose gamemode (Default: User single player) [ Enter 2 ]"),
		nl,
    	nl,
		writeln('Enter anything else to return to home page.'),
	    readInnerChoice(K, D, M, Hints, Guesses, AIs)
	; C == '3' -> 
		writeln('\e[2J'),
		initialize(Guesses, X), 
		randseq(4,6,List),
		displayBoard(X,Guesses,List),
		!
	; 	writeln("Not a valid input!"),
		sleep(0.2),
		fail
	).

readInnerChoice(K, D, M, Hints, Guesses, AIs) :-
	get_char(K),
	(K == '1' ->
		writeln('\e[H\e[2J'),
		writeln(D), writeln(M), 
		writeln("Difficulties: "),
		nl,
		nl,
		writeln("Easy [ Enter 1 ]"),
		nl,
		writeln("Medium [ Enter 2 ]"),
		nl,
		writeln("Hard [ Enter 3 ]"),
		nl,
		nl,
		writeln('Enter anything else to go back.'),
		get_char(S),
		(S == '1' -> 
			(M == '1' -> chosenSetting(S, M, Hints, Guesses, AIs), fail
			; M == '2' -> chosenSetting(S, M, Hints, Guesses, AIs), fail
			; writeln("c")
			)
		; S == '2' ->
		 	(M == '1' -> chosenSetting(S, M, Hints, Guesses, AIs), fail
		 	; M == '2' -> chosenSetting(S, M, Hints, Guesses, AIs), fail
		 	; writeln("b")
		 	)
		; S == '3' -> 
			(M == '1' -> chosenSetting(S, M, Hints, Guesses, AIs), fail
			; M == '2' -> chosenSetting(S, M, Hints, Guesses, AIs), fail
			; writeln("a")
			)
		; writeln("A")
		)
	; K == '2' ->
		writeln('\e[H\e[2J'),
		writeln(D), writeln(M), 
		writeln("Gamemodes: "),
		nl,
		nl,
		writeln("User single player [ Enter 1 ]"),
		nl,
		writeln("User vs Bot [ Enter 2 ]"),
		nl,
		nl,
		writeln('Enter anything else to go back.'),
		get_char(M),
		(M == '1' ->
			(D == '1' -> chosenSetting(D, M, Hints, Guesses, AIs), fail
			; D == '2' -> chosenSetting(D, M, Hints, Guesses, AIs), fail
			; D == '3' -> chosenSetting(D, M, Hints, Guesses, AIs), fail
			; fail
			)
		; M == '2' ->
			(D == '1' -> chosenSetting(D, M, Hints, Guesses, AIs), fail
			; D == '2' -> chosenSetting(D, M, Hints, Guesses, AIs), fail
			; D == '3' -> chosenSetting(D, M, Hints, Guesses, AIs), fail
			; fail
			)
		; fail
		)
	; makeGreeting(D,M)
	).

% chosenSetting(D, M, Hints, Guesses, AIs).
% user gets hints, 10 guesses
chosenSetting(1, 1, 2, 10, NAI).

% user gets hints, 10 guesses
chosenSetting(1, 2, 2, 10, NAI).

% no hints, 10 guesses
chosenSetting(2, 1, 0, 10, NAI).

% no hints, no AI, 10 guesses
chosenSetting(2, 2, 0, 10, NAI).

% no hints, 8 guesses
chosenSetting(3, 1, 0, 8, NAI).

% no hints, with AI, 10 guesses total (5 each)
chosenSetting(3, 2, 0, 10, AI).

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
