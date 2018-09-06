-- data from here: http://mnemstudio.org/path-finding-q-learning-tutorial.htm

step |0> => |4>
step |1> => |3> + |5> 
step |2> => |3> 
step |3> => |1> + |2> + |4> 
step |4> => |0> + |3> + |5>
step |5> => |1> + |4> + |5>

reward |0> => |0>
reward |1> => |0>
reward |2> => |0>
reward |3> => |0>
reward |4> => |0>
reward |5> => |100>

-- q-learn[alpha, gamma, op] set-of-terminal-states:
|null> => q-learn[1000, 1, 0.8, step] |5>


-- now display the results in a table:

-- tables chomp the leading category, which we don't want, so we apply one:
-- yeah, a bit of a hack.
apply-prefix |*> #=> |prefix:> __ |_self>

-- define our tidy results operator:
tidy-Q |*> #=> round[3] norm-Q remove-prefix["prefix: "] |_self>

-- show the table:
|null> => table[transition, tidy-Q] apply-prefix ket-sort rel-kets[norm-Q] |>

