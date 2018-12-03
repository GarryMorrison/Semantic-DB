-- the following code implements this grammar:
-- dot = '.'
-- comma = ','
-- digit = '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
-- non-zero-digit = '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
-- hundreds = non-zero-digit | non-zero-digit . digit | non-zero-digit . digit . digit
-- tail = tail | comma . digit . digit . digit | ''
-- int = 0 | hundreds . tail
-- decimal = non-zero-digit | digit . decimal
-- number = int | int . dot . decimal


-- define our chomp space operator:
chomp |*> #=> |_self>
chomp | > #=> |>

-- define our merge class operator:
merge (*) #=> smerge sdrop chomp clean weighted-pick-elt class |_self>

-- define our classes:
class |dot> => |.>
class |comma> => |,>
class |digit> => range(|0>, |9>)
class |non zero digit> => range(|1>, |9>)
class |hundreds> #=> merge |non zero digit> + merge (|non zero digit> . |digit>) + merge (|non zero digit> . |digit> . |digit>)

-- our ideal class |tail> operator, but is broken due to recursion limits:
-- class |tail> #=> merge |tail> + merge (|comma> . |digit> . |digit> . |digit>) + | >

-- a working class |tail> operator:
class |tail 0> #=> merge (|comma> . |digit> . |digit> . |digit>) + | >
class |tail> #=> process-if if(pick-elt split |yes no>, |unfinished>, |finished> )
process-if |finished> #=> merge |tail 0>
process-if |unfinished> #=> merge (|tail 0> . |tail>)

class |decimal> #=> process-if if(pick-elt split |yes no>, |unfinished decimal>, |finished decimal> )
process-if |finished decimal> #=> merge |non zero digit>
process-if |unfinished decimal> #=> merge (|digit> . |decimal>)

-- most of the time return |hundreds> . |tail>, occasionally return |0>:
class |int> #=> |0> + 100 merge (|hundreds> . |tail>)

-- our final number class:
class |number> #=> merge |int> + merge (|int> . |dot> . |decimal>)

-- find and print number operators:
find |number> #=> merge |number>
print-number |*> #=> print find |number>

-- print a whole bunch of examples:
|null> => drop 0 print-number range(|1>, |100>)

