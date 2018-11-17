:-include('SampleGrid2').

whitewalker(R, C, result(A, S)):-
    whitewalker(R, C, S),
    (
        not(A = kill);
        not((jon(R2, C2, D2, S), abs(R - R2) + abs(C - C2) =:= 1, D2 > 0))
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
