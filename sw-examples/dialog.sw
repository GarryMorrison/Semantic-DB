-- statements from here:
-- The Dialog-based Language Learning dataset:
-- https://research.fb.com/downloads/babi/


-- our statements:
statement |1> => |Mary moved to the bathroom.>
statement |2> => |John went to the hallway.>
statement |3> => |Daniel went back to the hallway.>
statement |4> => |Sandra moved to the garden.>
statement |5> => |John moved to the office.>
statement |6> => |Sandra journeyed to the bathroom.>
statement |7> => |Mary moved to the hallway.>
statement |8> => |Daniel travelled to the office.>
statement |9> => |John went back to the garden.>
statement |10> => |John moved to the bedroom.>


-- relevant lists:
list-of |places> => split |bathroom hallway garden office bedroom>
list-of |movement types> => split |moved went journeyed travelled>
list-of |people> => split |Mary John Daniel Sandra>


-- movement if-then machine:
pattern |node: 1: 1> => |moved>
pattern |node: 1: 2> => |went>
pattern |node: 1: 3> => |journeyed>
pattern |node: 1: 4> => |travelled>
then |node: 1: *> => |MOVEMENT>
then |*> #=> |_self>


-- is-a rules:
is-a-place |*> #=> is-mbr(|_self>, list-of |places>)
is-a-movement |*> #=> is-mbr(|_self>, list-of |movement types>)


-- processing rules:
split-a-statement |*> #=> ssplit[" "] to-lower remove-suffix["."] statement |_self>
make-movement-statement |*> #=> then explain[pattern] split-statement |_self>

-- now apply them:
|null> => map[split-a-statement, split-statement] rel-kets[statement] |>
|null> => map[make-movement-statement, movement-statement] rel-kets[split-statement] |>


-- our where-is operators:
first-where-is |*> #=> such-that[is-a-place] split-statement select[1,1] reverse extract-category predict[split-statement] to-lower |_self>
second-where-is |*> #=> such-that[is-a-place] split-statement select[1,1] reverse extract-category predict[movement-statement] ( to-lower |_self> . |MOVEMENT> . |to> )
third-where-is |*> #=> extract-value select[1,1] reverse predict[movement-statement] ( to-lower |_self> . |MOVEMENT> . |to> )
where-is |*> #=> third-where-is |_self>


-- now display a table of results:
|null> => table[person, where-is] list-of |people>

