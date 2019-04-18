-- first load female-male-names.sw
-- now pick 50 female and 50 male names for our full list of friends:
the-full-list-of |friends> => clean (pick[50] names |female name> + pick[50] names |male name>)

-- now pick 10 of those to be our example people:
the-list-of |people> => pick[10] the-full-list-of |friends>

-- define an operator that assigns random friends to the given person:
learn-friends |*> #=> learn(|op: friends>, |_self>, pick[10] the-full-list-of |friends>)

-- apply that operator and learn random friends:
|null> => drop tidy learn-friends the-list-of |people>

-- pick 1 random person, and find a table of similar friends:
|null> => table[person, coeff] 100 similar-input[friends] friends pick[1] the-list-of |people>

