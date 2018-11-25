-- statements from here:
-- The Dialog-based Language Learning dataset:
-- https://research.fb.com/downloads/babi/


split-a-statement |*> #=> ssplit[" "] to-lower remove-suffix["."] statement |_self>
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

|null> => map[split-a-statement, split-statement] rel-kets[statement] |>
list-of |places> => split |bathroom hallway garden office bedroom>
list-of |movement types> => split |moved went journeyed travelled>
list-of |people> => split |Mary John Daniel Sandra>

-- currently buggy:
-- is-a-place |*> #=> is-mbr(|_self>, list-of |places>)

is-a-place |*> #=> do-you-know mbr(|_self>, list-of |places>)
is-a-movement |*> #=> do-you-know mbr(|_self>, list-of |movement types>)

first-where-is |*> #=> such-that[is-a-place] split-statement select[1,1] reverse extract-category predict[split-statement] to-lower |_self>

pattern |node: 1: 1> => |moved>
pattern |node: 1: 2> => |went>
pattern |node: 1: 3> => |journeyed>
pattern |node: 1: 4> => |travelled>
then |node: 1: *> => |MOVEMENT>
then |*> #=> |_self>

make-movement-statement |*> #=> then explain[pattern] split-statement |_self>
|null> => map[make-movement-statement, movement-statement] rel-kets[split-statement] |>

second-where-is |*> #=> such-that[is-a-place] split-statement select[1,1] reverse extract-category predict[movement-statement] ( to-lower |_self> . |MOVEMENT> . |to> )
third-where-is |*> #=> extract-value select[1,1] reverse predict[movement-statement] ( to-lower |_self> . |MOVEMENT> . |to> )

where-is |*> #=> third-where-is |_self>

|null> => table[person, where-is] list-of |people>

