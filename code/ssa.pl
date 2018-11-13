rows(3).
cols(3).
dragonglass(2).
whitewalker(0, 0, s0).
whitewalker(0, 1, s0).
obstacle(0, 2).
obstacle(1, 0).
empty(1, 1, _).
dragonstone(1, 2).
empty(2, 0, _).
obstacle(2, 1).
empty(2, 2, _).
jon(2,2,0, s0).


whitewalker(R, C, result(A, S)):-
    whitewalker(R, C, S),
    (
        not(A = kill);
        not((jon(R2, C2, _, S), abs(R - R2) + abs(C - C2) =:= 1))
    ).

empty(R, C, S):-
    not((whitewalker(R, C, S));
    (obstacle(R, C))).

jon(R, C, D, result(A, S)):-
    (
        jon(R2, C2, D2, S),
        (
            (
                (
                    (A = north, R is R2 - 1, not(R < 0), C = C2);
                    (A = south, R is R2 + 1, rows(RMAX), not(R >= RMAX), C = C2);
                    (A = west, C is C2 - 1, not(C < 0), R = R2);
                    (A = east, C is C2 + 1, cols(CMAX), not(C >= CMAX), R = R2)
                ), (D = D2, empty(R, C, S))
            );
            (
                (R = R2, C = C2), (
                    (A = kill, whitewalker(WR, WC, S), D2 > 0, D is D2 - 1,  abs(WR - R2) + abs(WC - C2) =:= 1);
                    (A = pick, dragonstone(R, C), D2 = 0, dragonglass(D))
                )
            )
        )
    ).

win(S):-
    S = result(kill, S2),
    jon(_, _, _, result(kill, S2)),
    not(whitewalker(_, _, S)).
