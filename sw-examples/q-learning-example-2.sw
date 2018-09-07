-- data from here: https://medium.freecodecamp.org/diving-deeper-into-reinforcement-learning-with-q-learning-c18d0db58efe

-- can take diagonals:
step |A> => |B> + |E> + |D>
step |B> => |A> + |D> + |E> + |F> + |C>
step |C> => |B> + |E> + |F>
step |D> => |A> + |B> + |E>
step |E> => |E>
step |F> => |E> + |B> + |C> + |F>

-- can not take diagonals:
step |A> => |B> + |D>
step |B> => |A> + |E> + |C>
step |C> => |B> + |F>
step |D> => |A> + |E>
step |E> => |E>
step |F> => |E> + |C> + |F>

reward |A> => |0>
reward |B> => |1>
reward |C> => |0>
reward |D> => |2>
reward |E> => |-10>
reward |F> => |10>


-- q-learn[iterations, alpha, gamma, op] set-of-terminal-states:
|null> => q-learn[1000, 1, 0.8, step] (|E> + |F>)


-- now display the results in a table:
|null> => table[transition, norm-Q] ket-sort rel-kets[norm-Q] |>


-- show the walk sequences:
walk |*> #=> q-walk |_self>
|null> => table[start, walk] rel-kets[step] |>
