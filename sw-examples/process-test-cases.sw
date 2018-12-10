-- define our classes:
class |female name> => |Beth> + |Jane> + |Liz> + |Sarah> + |Emily> + |Emma> + |Bella> + |Madison> + |Mia> + |Judy>
class |male name> => |Fred> + |Andrew> + |David> + |Frank> + |Tim> + |Sam> + |Ian> + |William> + |Nathan>
class |name> => clean class (|female name> + |male name>)
class |gender> => |male> + |female>
class |birth sign> => |aries> + |taurus> + |gemini> + |cancer> + |leo> + |virgo> + |libra> + |scorpio> + |sagittarius> + |capricorn> + |aquarius> + |pisces>
class |digit> => |0> + |1> + |2> + |3> + |4> + |5> + |6> + |7> + |8> + |9>

-- verify an object has the right properties before we learn it:
-- if not defined for an operator, then accept anything
is-valid-gender |*> #=> is-mbr(|_self>, class |gender>)
is-valid-mother |*> #=> is-mbr(|_self>, class |female name>)
is-valid-father |*> #=> is-mbr(|_self>, class |male name>)
is-valid-sister |*> #=> is-mbr(|_self>, class |female name>)
is-valid-brother |*> #=> is-mbr(|_self>, class |male name>)
is-valid-brothers |*> #=> is-subset(clean words-to-list |_self>, class |male name>)
is-valid-birth-sign |*> #=> is-mbr(to-lower |_self>, class |birth sign>)
is-valid-number |*> #=> is-subset(clean split[""] |_self>, class |digit>)
is-valid-season |*> #=> is-subset(clean split[""] |_self>, class |digit>)
is-valid-episode |*> #=> is-subset(clean split[""] |_self>, class |digit>)


rule |1> => |## is a friend of #friend-of#>
rule |2> => |## S#season#E#episode#>
rule |3> => |The ## sat on the #sat-on#>
rule |4> => |The ## sat on the #sat-on# and then #action#>
rule |5> => |The ## is #first#, #second#, #third#, #fourth# and #fifth#>
rule |6> => |#friend-of# is a friend of ##.>
rule |7> => |##'s email address is #email#.>

statement |1> => |Sam is a friend of George>
statement |2> => |SOME SHOW S03E05 SOME MORE TEXT>
statement |3> => |The hungry dog sat on the scruffy mat>
statement |4> => |The sleepy dog sat on the dirty mat and then slept soundly>
statement |5> => |The shopping list is milk, bread, cream, jam and steak>
statement |6> => |The weird shopping list is milk, bread and steak>
statement |7> => |The numbers list is one, two, three, four, five, six and seven>
statement |8> => |SOME SHOW S03E05>
statement |9> => |Liz is a friend of Mary.>
statement |10> => |George's email address is george.douglas@gmail.com.>

|null> => process[rule] statement rel-kets[statement] |>

p |*> #=> process[rule] |_self>
