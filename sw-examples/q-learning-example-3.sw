-- data from here: https://medium.freecodecamp.org/diving-deeper-into-reinforcement-learning-with-q-learning-c18d0db58efe
-- the cheese/mouse section

step |start> => |1 small cheese> + |2 small cheese>
step |1 small cheese> => |start> + |death> + |empty cell>
step |empty cell> => |1 small cheese> + |big cheese>
step |2 small cheese> => |start> + |death>
step |death> => |death>
step |big cheese> => |death> + |empty cell> + |big cheese>

reward |start> => |0>
reward |1 small cheese> => |1>
reward |empty cell> => |0>
reward |2 small cheese> => |2>
reward |death> => |-10>
reward |big cheese> => |10>


-- q-learn[iterations, alpha, gamma, op] set-of-terminal-states:
|null> => q-learn[1000, 1, 0.8, step] (|death> + |big cheese>)


-- now display the results in a table:
|null> => table[transition, norm-Q] ket-sort rel-kets[norm-Q] |>


-- show the walk sequences:
walk |*> #=> q-walk |_self>
|null> => table[start, walk] rel-kets[step] |>
