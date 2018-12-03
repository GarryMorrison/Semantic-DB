-- our statements:
statement |1> => |Mary moved to the bathroom.>
statement |2> => |The dog sat on the rug.>
statement |3> => |John went to the hallway.>
statement |4> => |The cat ran through the hallway.>
statement |5> => |Daniel went back to the hallway.>
statement |6> => |Sandra moved to the garden.>
statement |7> => |John moved to the office.>
statement |8> => |John slept in the office.>
statement |9> => |Sandra journeyed to the bathroom.>
statement |10> => |Mary moved to the hallway.>
statement |11> => |Daniel travelled to the office.>
statement |12> => |Daniel used the phone in the office.>
statement |13> => |John went back to the garden.>
statement |14> => |John moved to the bedroom.>


-- movement if-then machine:
pattern |node: 1: 1> => |moved>
pattern |node: 1: 2> => |went>
pattern |node: 1: 3> => |journeyed>
pattern |node: 1: 4> => |travelled>
then |node: 1: *> => |MOVEMENT>
then |*> #=> |_self>

-- person if-then machine:
pattern |node: 2: 1> => |john>
pattern |node: 2: 2> => |mary>
pattern |node: 2: 3> => |daniel>
pattern |node: 2: 4> => |sandra>
then |node: 2: *> => |PERSON>

-- place if-then machine:
pattern |node: 3: 1> => |bathroom>
pattern |node: 3: 2> => |hallway>
pattern |node: 3: 3> => |garden>
pattern |node: 3: 4> => |office>
pattern |node: 3: 5> => |bedroom>
then |node: 3: *> => |PLACE>

-- pmp if-then machine:
pattern |node: 4: 1> => |PERSON> . |MOVEMENT> . |to> . |the> . |PLACE>
then |node: 4: *> => |PMP statement>


-- processing rules:
split-a-statement |*> #=> ssplit[" "] to-lower remove-suffix["."] statement |_self>
make-person-movement-place-statement |*> #=> then explain[pattern] split-statement |_self>
-- make-person-movement-place-statement |*> #=> (then explain[pattern])^2 split-statement |_self>


-- now apply them:
|null> => map[split-a-statement, split-statement] rel-kets[statement] |>
|null> => map[make-person-movement-place-statement, person-movement-place-statement] rel-kets[split-statement] |>


-- construct list of person-movement-statements:
list-of |person movement place statements> => extract-category predict[person-movement-place-statement] (|PERSON> . |MOVEMENT> . |to> . |PLACE>)


-- define not:
not |yes> => |no>
not |no> => |yes>
not |don't know> => |don't know>


-- is-a rules:
is-a-pmp-statement |*> #=> is-mbr(|_self>, list-of |person movement place statements>)
is-not-a-pmp-statement |*> #=> not is-a-pmp-statement |_self>


-- display a table:
|null> => table[index, statement, person-movement-place-statement, is-a-pmp-statement, is-not-a-pmp-statement] rel-kets[statement] |>

