-- learn some facts:
statement |1> => |Bella's mother is Mia.>
statement |2> => |Bella's father is William.>
statement |3> => |Bella's birth sign is Cancer.>
statement |4> => |Bella has 1 sibling.>
statement |5> => |Bella's preferred wine is merlot.>
statement |6> => |Bella's favourite fruit is pineapples.>
statement |7> => |Bella's favourite music is punk.>
statement |8> => |Bella's favourite play is Endgame.>
statement |9> => |Bella has gray hair.>
statement |10> => |Bella has hazel eyes.>
statement |11> => |Bella lives in Sydney.>
statement |12> => |Bella's favourite holiday spot is Paris.>
statement |13> => |Bella drives a Porsche.>
statement |14> => |Bella's religion is Christianity.>
statement |15> => |Bella's personality type is the guardian.>
statement |16> => |Bella's current emotion is fear.>
statement |17> => |Bella's bed time is 8pm.>
statement |18> => |Bella is 31 years old.>

statement |19> => |Emma's mother is Madison.>
statement |20> => |Emma's father is Nathan.>
statement |21> => |Emma's birth sign is Capricorn.>
statement |22> => |Emma has 4 siblings.>
statement |23> => |Emma's preferred wine is pinot noir.>
statement |24> => |Emma's favourite fruit is oranges.>
statement |25> => |Emma's favourite music is hip hop.>
statement |26> => |Emma's favourite play is No Exit.>
statement |27> => |Emma has red hair.>
statement |28> => |Emma has gray eyes.>
statement |29> => |Emma lives in New York.>
statement |30> => |Emma's favourite holiday spot is the Taj Mahal.>
statement |31> => |Emma drives a BMW.>
statement |32> => |Emma's religion is Taoism.>
statement |33> => |Emma's personality type is the visionary.>
statement |34> => |Emma's current emotion is kindness.>
statement |35> => |Emma's bed time is 2am.>
statement |36> => |Emma is 29 years old.>

statement |37> => |Madison's mother is Mia.>
statement |38> => |Madison's father is Ian.>
statement |39> => |Madison's birth sign is Cancer.>
statement |40> => |Madison has 6 siblings.>
statement |41> => |Madison's preferred wine is pinot noir.>
statement |42> => |Madison's favourite fruit is pineapples.>
statement |43> => |Madison's favourite music is blues.>
statement |44> => |Madison's favourite play is Death of a Salesman.>
statement |45> => |Madison has red hair.>
statement |46> => |Madison has amber eyes.>
statement |47> => |Madison lives in Vancouver.>
statement |48> => |Madison's favourite holiday spot is Uluru.>
statement |49> => |Madison drives a Bugatti.>
statement |50> => |Madison's religion is Islam.>
statement |51> => |Madison's personality type is the performer.>
statement |52> => |Madison's current emotion is indignation.>
statement |53> => |Madison's bed time is 10:30pm.>
statement |54> => |Madison is 23 years old.>
-- for some reason the space causes it to not match the age rule:
-- can we fix it, or is it due to the way regex's work?
-- statement |54> => |Madison is twenty three years old.>
statement |55> => |Madison's friends are Emma and Bella.>


-- process those facts, and extract triples:
|null> => process[rule] statement rel-kets[statement] |>
