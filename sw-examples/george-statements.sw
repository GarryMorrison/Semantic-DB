-- learn some facts:
statement |1> => |George is 29 years old.>
statement |2> => |George's date of birth is 1984-05-23.>
statement |3> => |George has brown hair.>
statement |4> => |George has blue eyes.>
statement |5> => |George is male.>
statement |6> => |George is 176 centimeters tall.>
statement |7> => |George is married to Beth.>
statement |8> => |George works as a car salesman.>
statement |9> => |George's friends are Fred, Jane, Liz and Andrew.>
statement |10> => |George's mother is Sarah.>
statement |11> => |George's father is David.>
statement |12> => |George's sister is Emily.>
statement |13> => |George's brothers are Frank, Tim and Sam.>
statement |14> => |George's siblings are Frank, Tim, Sam and Emily.>
statement |15> => |George's parents are Sarah and David.>
statement |16> => |George's family are Sarah, David, Frank, Tim, Sam and Emily.>
statement |17> => |George's family and friends are Sarah, David, Frank, Tim, Sam, Emily, Fred, Jane, Liz and Andrew.>
statement |18> => |George's email address is george.douglas@gmail.com.>
statement |19> => |George's education level is high-school.>

-- process those facts, and extract triples:
process-single-rule |*> #=> process[rule] |_self>
|null> => process-single-rule statement rel-kets[statement] |>
