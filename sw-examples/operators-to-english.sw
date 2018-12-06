-- operators that tidy our to-english rules:
the |person> #=> to-upper[1] extract-value current |person>
op |op: *> #=> list-to-words extract-value apply(|_self>, current |person>) |>
raw-op |op: *> #=> apply(|_self>, current |person>) |>

-- we need to tweak to handle '1 year' old:
to-english |op: age> #=> the |person> __ |is> __ op |_self> __ |years old.>
to-english |op: dob> #=> the |person> _ |'s> __ |date of birth is> __ op |_self> _ |.>
to-english |op: hair-colour> #=> the |person> __ |has> __ op |_self> __ |hair.>
to-english |op: eye-colour> #=> the |person> __ |has> __ op |_self> __ |eyes.>
to-english |op: gender> #=> the |person> __ |is> __ op |_self> _ |.>

-- tweak to process height units:
to-english |cm: *> #=> extract-value |_self> __ |centimeters tall>
to-english |height: cm: *> #=> extract-value |_self> __ |centimeters tall>
to-english |height: feet: *> #=> extract-value |_self> __ |feet tall>

-- to-english |op: height> #=> the |person> __ |is> __ op |_self> __ |centimeters tall.>
to-english |op: height> #=> the |person> __ |is> __ to-english raw-op |_self> _ |.>
to-english |op: wife> #=> the |person> __ |is married to> __ op |_self> _ |.>
to-english |op: occupation> #=> the |person> __ |works as a> __ op |_self> _ |.>

to-english |op: friends> #=> process-if if( is-equal[1] how-many friends current |person>, |1 friend>, |more than 1 friend>)
process-if |1 friend> #=> the |person> _ |'s friend is> __ op |op: friends> _ |.>
process-if |more than 1 friend> #=> the |person> _ |'s friends are> __ op |op: friends> _ |.>

to-english |op: mother> #=> the |person> _ |'s mother is> __ op |_self> _ |.>
to-english |op: father> #=> the |person> _ |'s father is> __ op |_self> _ |.>

-- tweak to handle 1 sister vs more than 1 sister
-- eg: 'George's sister is Emily.' vs 'George's sisters are Emily, Liz and Sally.'
to-english |op: sisters> #=> process-if if( is-equal[1] how-many sisters current |person>, |1 sister>, |more than 1 sister>)
process-if |1 sister> #=> the |person> _ |'s sister is> __ op |op: sisters> _ |.>
process-if |more than 1 sister> #=> the |person> _ |'s sisters are> __ op |op: sisters> _ |.>

to-english |op: brothers> #=> process-if if( is-equal[1] how-many brothers current |person>, |1 brother>, |more than 1 brother>)
process-if |1 brother> #=> the |person> _ |'s brother is> __ op |op: brothers> _ |.>
process-if |more than 1 brother> #=> the |person> _ |'s brothers are> __ op |op: brothers> _ |.>

to-english |op: siblings> #=> process-if if( is-equal[1] how-many siblings current |person>, |1 sibling>, |more than 1 sibling>)
process-if |1 sibling> #=> the |person> _ |'s sibling is> __ op |op: siblings> _ |.>
process-if |more than 1 sibling> #=> the |person> _ |'s siblings are> __ op |op: siblings> _ |.>

to-english |op: parents> #=> process-if if( is-equal[1] how-many parents current |person>, |1 parent>, |more than 1 parent>)
process-if |1 parent> #=> the |person> _ |'s parent is> __ op |op: parents> _ |.>
process-if |more than 1 parent> #=> the |person> _ |'s parents are> __ op |op: parents> _ |.>

to-english |op: family> #=> process-if if( is-equal[1] how-many family current |person>, |1 family>, |more than 1 family>)
process-if |1 family> #=> the |person> _ |'s family is> __ op |op: family> _ |.>
process-if |more than 1 family> #=> the |person> _ |'s family are> __ op |op: family> _ |.>

to-english |op: family-and-friends> #=> process-if if( is-equal[1] how-many family-and-friends current |person>, |1 family-and-friends>, |more than 1 family-and-friends>)
process-if |1 family-and-friends> #=> the |person> _ |'s family and friend is> __ op |op: family-and-friends> _ |.>
process-if |more than 1 family-and-friends> #=> the |person> _ |'s family and friends are> __ op |op: family-and-friends> _ |.>

to-english |op: email> #=> the |person> _ |'s email address is> __ op |_self> _ |.>
to-english |op: education> #=> the |person> _ |'s education level is> __ op |_self> _ |.>
to-english |op: birth-sign> #=> the |person> _ |'s birth sign is> __ op |_self> _ |.>

-- maybe we could do this without using an if statement?
to-english |op: number-siblings> #=> process-if if( is-equal[1] number-siblings current |person>, |1 number-siblings>, |more than 1 number-siblings>)
process-if |1 number-siblings> #=> the |person> __ |has> __ op |op: number-siblings> __ |sibling.>
process-if |more than 1 number-siblings> #=> the |person> __ |has> __ op |op: number-siblings> __ |siblings.>

to-english |op: wine-preference> #=> the |person> _ |'s preferred wine is> __ to-lower op |_self> _ |.>
to-english |op: favourite-fruit> #=> the |person> _ |'s favourite fruit is> __ op |_self> _ |.>
to-english |op: favourite-music> #=> the |person> _ |'s favourite music is> __ op |_self> _ |.>
to-english |op: favourite-play> #=> the |person> _ |'s favourite play is> __ op |_self> _ |.>
to-english |op: where-live> #=> the |person> __ |lives in> __ op |_self> _ |.>
to-english |op: favourite-holiday-spot> #=> the |person> _ |'s favourite holiday spot is> __ op |_self> _ |.>
to-english |op: make-of-car> #=> the |person> __ |drives a> __ op |_self> _ |.>
to-english |op: religion> #=> the |person> _ |'s religion is> __ op |_self> _ |.>
to-english |op: personality-type> #=> the |person> _ |'s personality type is> __ op |_self> _ |.>
to-english |op: current-emotion> #=> the |person> _ |'s current emotion is> __ op |_self> _ |.>
to-english |op: bed-time> #=> the |person> _ |'s bed time is> __ op |_self> _ |.>



-- set the current person:
-- see: sw-examples/george.sw
-- current |person> => |person: George>

-- see: sw-examples/bots.sw
-- current |person> => |bot: Bella>
-- current |person> => |bot: Emma>
-- current |person> => |bot: Madison>

-- convert knowledge of current person into simple English:
print-english |*> #=> drop 0 print to-english supported-ops current |person>
-- |null> => print-english |>


-- print English for nodes with a known mother or father:
-- so we don't have to set the current person manually
choose-person |*> #=>
    current |person> => |__self>
    print-english |>
    print |>

|null> => choose-person (rel-kets[mother] + rel-kets[father]) |>
