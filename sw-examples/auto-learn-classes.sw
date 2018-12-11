-- seed classes:
class |PERSON> => |Mary>
class |MOVEMENT> => |moved>
class |PLACE> => |bathroom>

-- our seed statements:
seed-statement |0> => |Mary moved back to the bathroom>
seed-statement |1> => |Mary moved to the bathroom>

-- classes to if-then machines:
|null> => class-to-if-then-machine[class, pattern, then] |>

-- process our statements:
process-a-statement |*> #=> smerge[" "] then explain[pattern] ssplit[" "] seed-statement |_self>

-- now apply it:
|null> => map[process-a-statement, processed-statement] rel-kets[seed-statement] |>



-- the rest of our statements, that we auto learn from:
statement |2> => |John went to the hallway>
statement |3> => |Daniel went back to the hallway>
statement |4> => |Sandra moved to the garden>
statement |5> => |John moved to the office>
statement |6> => |Sandra journeyed to the bathroom>
statement |7> => |Mary moved to the hallway>
statement |8> => |Daniel travelled to the office>
statement |9> => |John went back to the garden>
statement |10> => |John moved to the bedroom>

-- now auto learn classes:
|null> => process[processed-statement] statement rel-kets[statement] |>

