%  CS463 Prolog Project 2
%  John Reeves
%  11/20/15

%  value/4 returns Val as the character in the X,Y location in the list
value(X,Y,Maze,Val) :- nth0(Y, Maze, Elem),
		nth0(X, Elem, Val).

%  floor/3 returns true if the X,Y coordinate is a floor
floor(X,Y,Maze) :- value(X,Y,Maze,Value),
                  Value == f.

%  door/3 returns true if the X,Y coordinate is a door
door(X,Y,Maze) :- value(X,Y,Maze,Value),
                  Value == d.

%  key/3 returns true if the X,Y coordinate is a key
key(X,Y,Maze) :- value(X,Y,Maze,Value),
                  Value == k.

%  sword/3 returns true if the X,Y coordinate is a sword
sword(X,Y,Maze) :- value(X,Y,Maze,Value),
                  Value == s.

%  darklord/3 returns true if the X,Y coordinate is a dark lord
darklord(X,Y,Maze) :- value(X,Y,Maze,Value),
                  Value == darklord.

%  nextStep/4 is going up, down, left, and right from the last position

nextStep(X1,Y1,X1,Y) :- Y is Y1+1.
nextStep(X1,Y1,X,Y1) :- X is X1+1.
nextStep(X1,Y1,X1,Y) :- Y is Y1-1.
nextStep(X1,Y1,X,Y1) :- X is X1-1.

%  findkey/5 finds the path from X1,Y1 to the key and returns the path as keyPath.

findkey(X1,Y1,Maze,currentPath,keyPath) :-
		nextStep(X1, Y1, X2, Y2),
		key(X2,Y2,Maze) ,
		keyPath = [[X2,Y2]|currentPath].

findkey(X1,Y1,Maze,currentPath,keyPath) :-
		nextStep(X1, Y1, X2, Y2),
		floor(X2,Y2,Maze),
		\+ memberchk([X2,Y2],currentPath),
		findkey(X2,Y2,Maze,[[X2,Y2]|currentPath],keyPath).

%  findsword/5 finds the path from X1,Y1 to the sword walking through both floors and doors and returns the path as swordPath.

findsword(X1,Y1,Maze,currentPath,swordPath) :-
		nextStep(X1, Y1, X2, Y2),
		sword(X2,Y2,Maze) ,
		swordPath = [[X2,Y2]|currentPath].

findsword(X1,Y1,Maze,currentPath,swordPath) :-
		nextStep(X1, Y1, X2, Y2),
		(floor(X2,Y2,Maze);door(X2,Y2,Maze)),
		\+ memberchk([X2,Y2],currentPath),
		findsword(X2,Y2,Maze,[[X2,Y2]|currentPath],swordPath).

%  findsword_noKey/5 finds the path from X1,Y1 to the sword walking only on floors because we didn't aquire a key and returns the path as swordPath.

findsword_noKey(X1,Y1,Maze,currentPath,swordPath) :-
		nextStep(X1, Y1, X2, Y2),
		sword(X2,Y2,Maze) ,
		swordPath = [[X2,Y2]|currentPath].

findsword_noKey(X1,Y1,Maze,currentPath,swordPath) :-
		nextStep(X1, Y1, X2, Y2),
	        floor(X2,Y2,Maze),
		\+ memberchk([X2,Y2],currentPath),
		findsword_noKey(X2,Y2,Maze,[[X2,Y2]|currentPath],swordPath).

%  finddarklord/5 finds the path from X1,Y1 to the dark lord and returns the path as darkLordPath.

finddarklord(X1,Y1,Maze,currentPath,darkLordPath) :-
		nextStep(X1, Y1, X2, Y2),
		darklord(X2,Y2,Maze) ,
		darkLordPath = [[X2,Y2]|currentPath].

finddarklord(X1,Y1,Maze,currentPath,darkLordPath) :-
		nextStep(X1, Y1, X2, Y2),
		(floor(X2,Y2,Maze);door(X2,Y2,Maze)),
		\+ memberchk([X2,Y2],currentPath),
		finddarklord(X2,Y2,Maze,[[X2,Y2]|currentPath],darkLordPath).

%  finddarklord_noKey/5 finds the path from X1,Y1 to the dark lord without passing though doors because we never obtained a key and it returns the path as darkLordPath.

finddarklord_noKey(X1,Y1,Maze,currentPath,darkLordPath) :-
		nextStep(X1, Y1, X2, Y2),
		darklord(X2,Y2,Maze) ,
		darkLordPath = [[X2,Y2]|currentPath].

finddarklord_noKey(X1,Y1,Maze,currentPath,darkLordPath) :-
		nextStep(X1, Y1, X2, Y2),
		floor(X2,Y2,Maze),
		\+ memberchk([X2,Y2],currentPath),
		finddarklord_noKey(X2,Y2,Maze,[[X2,Y2]|currentPath],darkLordPath).

%  This is the predicate called by the user that starts finding the path by finding the key path. If there is a key it then looks for the sword then the dark lord. If no key is found then it looks for the sword without passing through doors and then the dark lord

mazepath(X,Y,Maze,Path) :- findkey(X,Y,Maze,[[X,Y]],keyPath)->
		([[X2,Y2]|_] = keyPath,
		findsword(X2,Y2,Maze,[],swordPath) ->
		([[Xd,Yd]|_] = swordPath,
		finddarklord(Xd,Yd,Maze,[],darkLordPath)),
		append(swordPath,keyPath,T_Path),
		append(darkLordPath,T_Path,F_Path),
		reverse(F_Path,Path));
		(findsword_noKey(X,Y,Maze,[[X,Y]],swordPath) ->
		([[Xd,Yd]|_] = swordPath,
		finddarklord_noKey(Xd,Yd,Maze,[],darkLordPath)),
		append(darkLordPath,swordPath,F_Path),
		reverse(F_Path,Path)).




