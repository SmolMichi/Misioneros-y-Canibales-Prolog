% Misioneros y Canibales
% Hay 3 misioneros y 3 canibales que deben de pasar por medio de un bote, donde solo 
% entran máximo 2 personas y no puede ir vacio, al otro lado.
% Sin embargo, no pueden haber más canibales que misioneros o acaba los canibales se
% comen a los misioneros.

% MI = Misioneros izquierda
% MD = Misioneros derecha
% CI = Canibales izquierda
% CD = Canibales derecha
% NI = Número en la izquierda (Para los misioneros)
% ND = Número en la derecha (Para los misioneros)
% DI = Número en la izquierda (Para los canibales)
% DD = Número en la derecha (Para los canibales)
% Izquierda/Derecha = De que lado está el bote

% Para la solución debe tener un estado inicial, un estado final y la solución del problema
% Donde la inicial serán los misioneros y canibales a la izquierda
% Y el estado final serán los misioneros y canibales a la derecha
% La solución serían los pasos para lograr del estado inicial al estado final
solucion(Solucion) :-
    inicial(Inicial),
    final(Final),
    camino(Inicial, Solucion, Final).

% Declaramos el estado inicial y el estado final
inicial(miscan(3,3,0,0,izquierda)).
final(miscan(0,0,3,3,derecha)).

% Lo que queremos es encontrar los pasos (camino) para pasar del estado inicial al
% estado final, por lo que buscamos evitar que el programa repita una situación 
% dos veces y se cicle. Poniendole asi una condición de que use solo cruces válidos

camino(Inicial, Camino, Final) :-
    camino(Inicial, Camino, Final, []).
% Los [] es la lista de acciones previas

camino(Inicial, [Cruce], Final, _) :-
    valido(Cruce, Inicial, Final).

% Por lo tanto, hay que marcar la situación actual para que no vuelva a pasar por ahi
camino(Inicial, [Cruce | Resto], Final, Visitadas) :-
    valido(Cruce, Inicial, Intermedia),
    noEn(Intermedia, Visitadas),
    camino(Intermedia, Resto, Final, [Inicial | Visitadas]).

% Para determinar si algo ya está dentro de la lista, se crea la función noEn. Aunque
% la lista en un principio está vacia, se tiene busca "cualquier cosa"
% Una vez que la lista ya no está vacia, buscará si eso no está al principio o en el resto
% de la lista

noEn(_, []).

noEn(X, [Y | Resto]) :-
    X \= Y,
    noEn(X,Resto).

% Para que el programa haga solo movimientos válidos, hay que hacerle saber cuales
% son esos movimientos válidos.

% Siempre se tiene que cumplir la condición de que no haya más canibales que misioneros
% en cualquiera de los dos lados

% Una persona cruza en el bote (Misionero)
valido(bote(1,0,izquierda),
       miscan(MI,CI,MD,CD,derecha),
       miscan(NI,CI,ND,CD,izquierda)) :-
    ND is MD - 1,
    NI is MI + 1,
    ND >= 0,
    NI =< 3,
    (NI = 0; NI >= CI),
    (ND = 0; ND >= CD).

valido(bote(1,0,derecha),
       miscan(MI,CI,MD,CD,izquierda),
       miscan(NI,CI,ND,CD,derecha)) :-
    NI is MI - 1,
    ND is MD + 1,
    NI >= 0,
    ND =< 3,
    (NI = 0; NI >= CI),
    (ND = 0; ND >= CD).

% Una persona cruza en el bote (Canibal)
valido(bote(0,1,izquierda),
       miscan(MI,CI,MD,CD,derecha),
       miscan(MI,DI,MD,DD,izquierda)) :-
    DD is CD - 1,
    DI is CI + 1,
    DD >= 0,
    DI =< 3,
    (MI = 0; MI >= DI),
    (MD = 0; MD >= DD).

valido(bote(0,1,derecha),
       miscan(MI,CI,MD,CD,izquierda),
       miscan(MI,DI,MD,DD,derecha)) :-
    DI is CI - 1,
    DD is CD + 1,
    DI >= 0,
    DD =< 3,
    (MI = 0; MI >= DI),
    (MD = 0; MD >= DD).

% Dos personas del mismo tipo (2 canibales / 2 misioneros) cruzan
valido(bote(2,0,izquierda),
       miscan(MI,CI,MD,CD,derecha),
       miscan(NI,CI,ND,CD,izquierda)) :-
    ND is MD - 2,
    NI is MI + 2,
    ND >= 0,
    NI =< 3,
    (NI = 0; NI >= CI),
    (ND = 0; ND >= CD).

valido(bote(2,0,derecha),
       miscan(MI,CI,MD,CD,izquierda),
       miscan(NI,CI,ND,CD,derecha)) :-
    NI is MI - 2,
    ND is MD + 2,
    NI >= 0,
    ND =< 3,
    (NI = 0; NI >= CI),
    (ND = 0; ND >= CD).

valido(bote(0,2,izquierda),
       miscan(MI,CI,MD,CD,derecha),
       miscan(MI,DI,MD,DD,izquierda)) :-
    DD is CD - 2,
    DI is CI + 2,
    DD >= 0,
    DI =< 3,
    (MI = 0; MI >= DI),
    (MD = 0; MD >= DD).

valido(bote(0,2,derecha),
       miscan(MI,CI,MD,CD, izquierda),
       miscan(MI,DI,MD,DD, derecha)) :-
    DI is CI - 2,
    DD is CD + 2,
    DI >= 0,
    DD =< 3,
    (MI = 0; MI >= DI),
    (MD = 0; MD >= DD).

% Uno y uno (1 Canibal y 1 Misionero) cruzan
valido((1,1,izquierda),
       miscan(MI,CI,MD,CD,derecha),
       miscan(NI,DI,ND,DD,izquierda)) :-
    ND is MD - 1,
    DD is CD - 1,
    NI is MI + 1,
    DI is CI + 1,
    ND >= 0,
    DD >= 0,
    NI =< 3,
    DI =< 3,
    (NI = 0; NI >= DI),
    (ND = 0; ND >= DD).

valido(bote(1,1,derecha),
       miscan(MI,CI,MD,CD,izquierda),
       miscan(NI,DI,ND,DD,derecha)) :-
    NI is MI - 1,
    DI is CI - 1,
    ND is MD + 1,
    DD is CD + 1,
    NI >= 0,
    DI >= 0,
    ND =< 3,
    DD =< 3,
    (NI = 0; NI >= DI),
    (ND = 0; ND >= DD).
