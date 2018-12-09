class |female name> => |Beth> + |Jane> + |Liz> + |Sarah> + |Emily> + |Emma> + |Bella> + |Madison> + |Mia>
class |male name> => |Fred> + |Andrew> + |David> + |Frank> + |Tim> + |Sam> + |Ian> + |William> + |Nathan>
class |name> => clean class (|female name> + |male name>)
class |gender> => |male> + |female>
class |birth sign> => |aries> + |taurus> + |gemini> + |cancer> + |leo> + |virgo> + |libra> + |scorpio> + |sagittarius> + |capricorn> + |aquarius> + |pisces>

is-valid-gender |*> #=> is-mbr(|_self>, class |gender>)
is-valid-mother |*> #=> is-mbr(|_self>, class |female name>)
is-valid-father |*> #=> is-mbr(|_self>, class |male name>)
is-valid-sister |*> #=> is-mbr(|_self>, class |female name>)
is-valid-brother |*> #=> is-mbr(|_self>, class |male name>)
is-valid-brothers |*> #=> is-subset(words-to-list |_self>, class |male name>)
is-valid-birth-sign |*> #=> is-mbr(to-lower |_self>, class |birth sign>)


-- our simple parser rules:
rule |1> => |## is #gender#.>
rule |2> => |## is #age# years old.>
rule |3> => |##'s date of birth is #dob#.>
rule |4> => |## has #hair-colour# hair.>
rule |5> => |## has #eye-colour# eyes.>
rule |6> => |## is #height# centimeters tall.>
rule |7> => |## is married to #wife#.>
rule |8> => |## works as a #occupation_1#.>
rule |9> => |## works as an #occupation_2#.>
rule |10> => |##'s friend is #friend#.>
rule |11> => |##'s friends are #friends#.>
rule |12> => |##'s mother is #mother#.>
rule |13> => |##'s father is #father#.>
rule |14> => |##'s sister is #sister#.>
rule |15> => |##'s sisters are #sisters#.>
rule |16> => |##'s brother is #brother#.>
rule |17> => |##'s brothers are #brothers#.>
rule |18> => |##'s sibling is #sibling#.>
rule |19> => |##'s siblings are #siblings#.>
rule |20> => |##'s parent is #parent#.>
rule |21> => |##'s parents are #parents#.>
rule |22> => |##'s family is #family_1#.>
rule |23> => |##'s family are #family_2#.>
rule |24> => |##'s family and friends are #family-and-friends#.>
rule |25> => |##'s email address is #email#.>
rule |26> => |##'s education level is #education#.>
rule |27> => |##'s birth sign is #birth-sign#.>
rule |28> => |## has #number-sibling# sibling.>
rule |29> => |## has #number-siblings# siblings.>
rule |30> => |##'s preferred wine is #wine-preference#.>
rule |31> => |##'s favourite fruit is #favourite-fruit#.>
rule |32> => |##'s favourite music is #favourite-music#.>
rule |33> => |##'s favourite play is #favourite-play#.>
rule |34> => |## lives in #where-live#.>
rule |35> => |##'s favourite holiday spot is #favourite-holiday-spot#.>
rule |36> => |## drives a #make-of-car#.>
rule |37> => |##'s religion is #religion#.>
rule |38> => |##'s personality type is #personality-type#.>
rule |39> => |##'s current emotion is #current-emotion#.>
rule |40> => |##'s bed time is #bed-time#.>

rule |41> => |## name is #name#.>
rule |42> => |## age is #age#.>
rule |43> => |## mother is #mother#.>

rule |44> => |The ## ate the #ate#.>
rule |45> => |The ## ate the #ate# and then #action#.>

rule |46> => |## is a #is-a#.>
rule |47> => |##'s are #property#.>

rule |48> => |#friend-of# is a friend of ##.>

-- the ' and ' in these rules break statements like: 'Sam is a friend of Liz and Mary.'
-- this is the same bug that is causing issues with counting '.' as a match string.
-- eg: george.douglas@gmail.com
-- these rules also break statements like: 'George's brothers are Frank, Tim and Sam.'
-- and they make statements like 'the shopping list is chocolate, cream, milk, apples and steak' very slow!
-- Hrmm.... how fix??? I think it is in the explain[cause] branch of the code.

-- rule |49> => |## is #first#, #second# and #third#.>
-- rule |50> => |## is #first#, #second#, #third# and #fourth#.>
-- rule |51> => |## is #first#, #second#, #third#, #fourth# and #fifth#.>


p |*> #=> process[rule] |_self>
