% esAnimal(Animal).
esAnimal(cerdo).
esAnimal(vaca).

% provieneDe(Alimento, MateriaPrima).
provieneDe(pan, trigo).
provieneDe(jamon, cerdo).
provieneDe(leche, vaca).
provieneDe(queso, leche).

% esLacteo(Alimento)
esLacteo(Alimento) :-
    provieneDe(Alimento,leche).

% tieneGluten(Alimento)
tieneGluten(Alimento) :-
    provieneDe(Alimento, trigo).

% derivadoDeAnimal(Alimento)
derivadoDeAnimal(Alimento) :-
    provieneDe(Alimento, Animal),
    esAnimal(Animal).

derivadoDeAnimal(Alimento) :-
    provieneDe(Alimento, UnDerivado),
    derivadoDeAnimal(UnDerivado).

% vegano(Alimento)
vegano(Alimento) :-
    not(derivadoDeAnimal(Alimento)).

% celiaco(Alimento)
celiaco(Alimento) :-
    not(tieneGluten(Alimento)).

omnivoro(_).

% dieta(Persona, Dieta).
dieta(analia, vegano).
dieta(benito, celiaco).
dieta(claudia, omnivoro).

plato(sandwichJamonYQueso).
plato(wokVegetales).

% ingrediente(Plato, Ingrediente).
ingrediente(sandwichJamonYQueso, pan).
ingrediente(sandwichJamonYQueso, jamon).
ingrediente(sandwichJamonYQueso, queso).
ingrediente(wokVegetales, pan).
ingrediente(wokVegetales, arroz).
ingrediente(wokVegetales, zanahoria).
ingrediente(wokVegetales, cebolla).
ingrediente(wokVegetales, morron).

% quiereComer(Persona, Plato)
quiereComer(Persona, Plato) :-
    dieta(Persona, Dieta),
    platoSegunCriterio(Dieta, Plato).

% respetaDieta(Dieta, Ingrediente)
respetaDieta(vegano,Ingrediente) :-
    vegano(Ingrediente).

respetaDieta(celiaco,Ingrediente) :-
    celiaco(Ingrediente).

respetaDieta(omnivoro,Ingrediente) :-
    omnivoro(Ingrediente).

% dietaRecomendada(Enfermedad, Dieta).
dietaRecomendada(hipertension, vegano).
dietaRecomendada(colesterolAlto, vegano).
dietaRecomendada(intoleranteAlGluten, celiaco).
dietaRecomendada(obesidad, celiaco).

% diagnostico(Persona, Tipo(Enfermedad, NivelPeligro)).
diagnostico(analia, prevencion(obesidad, 5)).
diagnostico(benito, prevencion(hipertension, 4)).
diagnostico(claudia, critico(colesterolAlto, 3)).

% enfermedad(Diagnostico).
enfermedad(prevencion(Enfermedad, _), Enfermedad).
enfermedad(critico(Enfermedad, _), Enfermedad).

% nivelPeligro(Diagnostico).
nivelPeligro(prevencion(_, NivelPeligro), NivelPeligro) :-
    NivelPeligro * 2 >= 10.
nivelPeligro(critico(_, NivelPeligro), NivelPeligro) :-
    NivelPeligro * 5 >= 10.

% platoRecomendadoPara(Persona, Plato)
platoRecomendadoPara(Persona, Plato) :-
    diagnosticoPeligroso(Persona, Diagnostico),
    comidaSegunDiagnostico(Diagnostico, Plato).

platoRecomendadoPara(Persona, Plato) :-
    not(diagnosticoPeligroso(Persona, Diagnostico)),
    comidaSegunDiagnostico(Diagnostico, Plato).

platoRecomendadoPara(Persona, Plato) :-
    not(diagnosticoPeligroso(Persona, _)),
    comidaPreferida(Persona, Plato).

% diagnosticoPeligroso(Persona, Diagnostico)
diagnosticoPeligroso(Persona, Diagnostico) :-
    diagnostico(Persona, Diagnostico),
    nivelPeligro(Diagnostico, _).

% comidaSegunDiagnostico(Diagnostico, Plato)
comidaSegunDiagnostico(Diagnostico, Plato) :-
    enfermedad(Diagnostico, Enfermedad),
    dietaRecomendada(Enfermedad, Dieta),
    platoSegunCriterio(Dieta, Plato).

% comidaPreferida(Persona, Plato)
comidaPreferida(Persona, Plato) :-
    dieta(Persona, Dieta),
    platoSegunCriterio(Dieta, Plato).

% platoSegunCriterio(Dieta, Plato)
platoSegunCriterio(Dieta, Plato) :-
    plato(Plato),
    forall(ingrediente(Plato, Ingrediente), respetaDieta(Dieta, Ingrediente)).