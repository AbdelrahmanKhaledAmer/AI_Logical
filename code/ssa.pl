% Dragon-Glass constant.
dragonglass(2).

% Maximum dimenions constants.
rows(3).
cols(3).

% Obstacle predicates. Will not change regardless of the situation.
obstacle(0, 2).

% Dragonstone predicate. Will not change regardless of the situation.
dragonstone(2, 0).


% White-Walker predicates. Some will be removed as the situation differs.
whitewalker(0, 0, s0).
whitewalker(R, C, result(A, S)):-
    whitewalker(R, C, S),(not(nearby(R, C, S));\+A = kill).

% Nearby predicate. Shorthand for when jon is near a White-Walker.
nearby(R, C, S):-
    jon(R2, C2, _, S),
    abs(R - R2) + abs(C - C2) =:= 1.

% Empty predicates (Shorthand). More predicates will be added as the situation changes.
empty(0, 1, _).
empty(1, 0, _).
empty(1, 1, _).
empty(1, 2, _).
empty(2, 1, _).
empty(2, 2, _).
empty(R, C, S):-
    not(whitewalker(R, C, S)),
    not(obstacle(R, C)).

% Jon predicates. This is the agent that will play the game.
jon(2, 2, 0, s0).
jon(R, C, D, result(A, S)):-
    (
        jon(R2, C2, D2, S),
        (
            (A = north, R is R2 - 1, not(R < 0), C is C2, empty(R2, C, S), D is D2);
            (A = south, R is R2 + 1, rows(RMAX), not(R >= RMAX), C is C2, empty(R2, C, S), D is D2);
            (A = west, C is C2 - 1, not(C < 0), R is R2, empty(R2, C, S), D is D2);
            (A = east, C is C2 + 1, cols(CMAX), not(C >= CMAX), R is R2, empty(R2, C, S), D is D2);
            (A = kill, whitewalker(WR,WC, S), D2 > 0, D is D2 - 1, R = R2,C = C2,  abs(WR - R2) + abs(WC - C2) =:= 1);
            (A = pick, dragonstone(R, C), D2 = 0, dragonglass(D),R = R2,C = C2)
        )
    ).

% Win State.
win(S):-
    S = result(kill, S2),
    jon(_, _, _, result(kill, S2)),
    not(whitewalker(_, _, S)).