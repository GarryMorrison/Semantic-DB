-- tweak to handle '1 years' old:
to-english |op: age> #=> to-upper[1] extract-value current |person> __ |is> __ extract-value age current |person> __ |years old.>
to-english |op: dob> #=> to-upper[1] extract-value current |person> _ |'s> __ |date of birth is> __ extract-value dob current |person> _ |.>
to-english |op: hair-colour> #=> to-upper[1] extract-value current |person> __ |has> __ extract-value hair-colour current |person> __ |hair.>
to-english |op: eye-colour> #=> to-upper[1] extract-value current |person> __ |has> __ extract-value eye-colour current |person> __ |eyes.>
to-english |op: gender> #=> to-upper[1] extract-value current |person> __ |is> __ extract-value gender current |person> _ |.>

-- tweak to check height units:
to-english |op: height> #=> to-upper[1] extract-value current |person> __ |is> __ extract-value height current |person> __ |centimeters tall.>
to-english |op: wife> #=> to-upper[1] extract-value current |person> __ |is married to> __ extract-value wife current |person> _ |.>
to-english |op: occupation> #=> to-upper[1] extract-value current |person> __ |works as a> __ extract-value occupation current |person> _ |.>

-- what if they only have 1 friend?
to-english |op: friends> #=> to-upper[1] extract-value current |person> _ |'s friends are> __ list-to-words extract-value friends current |person> _ |.>
to-english |op: mother> #=> to-upper[1] extract-value current |person> _ |'s mother is> __ extract-value mother current |person> _ |.>
to-english |op: father> #=> to-upper[1] extract-value current |person> _ |'s father is> __ extract-value father current |person> _ |.>

-- tweak to handle 1 sister vs more than 1 sister
-- eg: 'George's sister is Emily.' vs 'George's sisters are Emily, Liz and Sally.'
to-english |op: sisters> #=> process-if if( is-equal[1] how-many sisters current |person>, |1 sister>, |more than 1 sister>)
process-if |1 sister> #=> to-upper[1] extract-value current |person> _ |'s sister is> __ extract-value sisters current |person> _ |.>
process-if |more than 1 sister> #=> to-upper[1] extract-value current |person> _ |'s sisters are> __ list-to-words extract-value sisters current |person> _ |.>

to-english |op: brothers> #=> process-if if( is-equal[1] how-many brothers current |person>, |1 brother>, |more than 1 brother>)
process-if |1 brother> #=> to-upper[1] extract-value current |person> _ |'s brother is> __ extract-value brothers current |person> _ |.>
process-if |more than 1 brother> #=> to-upper[1] extract-value current |person> _ |'s brothers are> __ list-to-words extract-value brothers current |person> _ |.>

to-english |op: siblings> #=> process-if if( is-equal[1] how-many siblings current |person>, |1 sibling>, |more than 1 sibling>)
process-if |1 sibling> #=> to-upper[1] extract-value current |person> _ |'s sibling is> __ extract-value siblings current |person> _ |.>
process-if |more than 1 sibling> #=> to-upper[1] extract-value current |person> _ |'s siblings are> __ list-to-words extract-value siblings current |person> _ |.>

to-english |op: parents> #=> process-if if( is-equal[1] how-many parents current |person>, |1 parent>, |more than 1 parent>)
process-if |1 parent> #=> to-upper[1] extract-value current |person> _ |'s parent is> __ extract-value parents current |person> _ |.>
process-if |more than 1 parent> #=> to-upper[1] extract-value current |person> _ |'s parents are> __ list-to-words extract-value parents current |person> _ |.>

to-english |op: email> #=> to-upper[1] extract-value current |person> _ |'s email address is> __ extract-value email current |person> _ |.>
to-english |op: education> #=> to-upper[1] extract-value current |person> _ |'s education level is> __ extract-value education current |person> _ |.>

print-english |*> #=> drop 0 print to-english supported-ops current |person>
current |person> => |person: George>
|null> => print-english |>

