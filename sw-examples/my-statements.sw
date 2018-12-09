-- learn some facts:
statement |1> => |My name is Alice.>
statement |2> => |His name is George.>
statement |3> => |My age is 37.>
statement |4> => |Her age is 29.>
statement |5> => |Their mother is Sarah.>

-- process those facts, and extract triples:
|null> => drop 0 process[rule] statement rel-kets[statement] |>

