The Semantic DB is an experimental language that borrows the idea of [kets, superpositions and operators](https://en.wikipedia.org/wiki/Bra%E2%80%93ket_notation) from quantum mechanics and makes something of 
a programming language out of it. In its current form it is not a general purpose programming language, but may have relevance in the domain of the 
[semantic web](https://en.wikipedia.org/wiki/Semantic_Web). Our [sw files](http://semantic-db.org/sw/) make great little packages of [knowledge](https://en.wikipedia.org/wiki/Knowledge_representation_and_reasoning) that are easy to pass around the internet. 

Some simple examples:
Here we define the age operator with respect to Fred and Sam, which are essentially [semantic web triples](https://en.wikipedia.org/wiki/Semantic_triple):  
`age |Fred> => |47>`  
`age |Sam> => |33>`

Here we define the friends operator with respect to Emma and Liz, where the right hand side is a "superposition":  
`friends |Emma> => |Fred> + |Robert> + |Bella>`  
`friends |Liz> => |Sam> + |Mary> + |Sam> + |Matt> + |Sarah>`

More generally a superposition can have coefficients. If none is given, then it has value 1.
Note that in contrast with quantum mechanics where ket coefficients are complex numbers, here they are real valued floats.
For example, a shopping list can be represented simply as:  
`the |shopping list> => 3|apple> + |steak> + 5|orange> + |coffee> + |bread> + |milk> + 2|cheese>`

Superpositions have a number of properties, for example:
1) they have `|>`, the empty ket, or the don't know ket, as the identity element, so that `|> + sp == sp + |> == sp`, for any superposition sp.
2) they add. eg: `(3|a> + 0.2|b> + |c>) + (|a> + 0.5|b> + 2.2|c> + |d>) == 4|a> + 0.7|b> + 3.2|c> + |d>`
3) ket's commute, ie the addition is Abelian. So `|a> + |b> + |c> == |b> + |c> + |a>`
4) they can be multiplied by a scalar. eg: `7 (3|a> + 0.2|b> + |c>) == 21|a> + 1.4|b> + 7|c>`
5) you can add a ket with coefficient 0 without changing the "meaning" of a superposition.  
eg: `meaning(sp1) == meaning(sp1 + 0 sp2)`  
eg: `meaning(3|a> + 2|b> + |c> + 0|x> + 0|y> + 0|z>) == meaning(3|a> + 2|b> + |c>)`
6) we can take the union of them. eg: `union(|a> + 2|b> + 3|c>, 3|a> + 2|b>, |c>) == 3|a> + 2|b> + 3|c>`
7) we can find the intersection. eg: `intersection(|a> + 2|b> + 3|c>, 3|a> + 2|b>, |c>) == |a> + 2|b> + |c>`
where union is term by term max of coefficients, and intersection is term by term min of coefficients.
8) we can find the similarity of them. 1 for identical, 0 for completely different, values in between otherwise.  
eg: `simm(8|a> + 2.2|b>, 8|a> + 2.2|b>) == |simm>`  
eg: `simm(|b>, |a> + |b> + |c>) == 0.3333|simm>`  
eg: `simm(|a> + |b> + |c>, |x> + |y> + |z>) == 0|simm>`


In the context of networks, a superposition could be considered a collection of active nodes, with the coefficient a measure of how active that node is.
For example, the phrase "a little bit hungry, very tired, and somewhat upset" could be represented by this superposition:  
`0.2|hungry> + 0.9|tired> + 0.5|upset>`

Superpositions represent the state of a network or knowledge at a single point in time, but we can also represent a sequence of superpositions using dots.
For example, the spelling of Fred is this sequence of letters/kets:  
`spelling |Fred> => |F> . |r> . |e> . |d>`

Or the first few digits of Pi:  
`the-digits-of |Pi> => |3> . |.> . |1> . |4> . |1> . |5> . |9> . |2>`


There is much more to this experimental language, which we call mumble lang. Some for examples:
 * [A collection of rules that define plurals and their inverse](http://semantic-db.org/docs/usage/sw-examples/plural.sw).
 * [A collection of rules that define a family tree](http://semantic-db.org/docs/usage/sw-examples/family.sw).
 * [A collection of rules that can conclude family structures using that family tree](http://semantic-db.org/docs/usage/sw-examples/family-relations.sw).
 * [Our usage info for the similar-input operator](http://semantic-db.org/docs/usage/function-operators/similar-input.html).
 * [Our usage info for the find-topic operator](http://semantic-db.org/docs/usage/function-operators/find-topic.html).
 * [Our worked example for the if-then machine, a simple model of a neuron](http://semantic-db.org/docs/usage/worked-examples/if-then-machines.html).
 * [Our worked example 'active logic' using if-then machines](http://semantic-db.org/docs/usage/worked-examples/active-logic.html).
 * [Our current collection of documentation for operators, sw examples, and worked examples](http://semantic-db.org/docs/usage/).

To run the code, simply:  
`$ ./sdb-console.py`

For help in the console:
```
sa: help

  q, quit, exit                         quit the agent.
  h, help                               print this message
  context                               print list of context's
  context string                        set current context to string
  icontext                              interactive context
  reset                                 reset back to completely empty console
                                        Warning! you will lose all unsaved work!
  dump                                  print current context
  dump exact                            print current context in exact mode
  dump multi                            print context list
  dump self                             print what we know about the default ket/sp
  dump ket/sp                           print what we know about the given ket/sp
  display                               (relatively) readable display of current context
  display ket/sp                        (relatively) readable display about what we know for the ket/sp
  freq                                  convert current context to frequency list
  mfreq                                 convert context list to frequency list
  load file.sw                          load file.sw
  line-load file.sw                     load file.sw one line at a time, useful for large files, breaks for swc files.
  save file.sw                          save current context to file.sw
  save multi file.sw                    save context list to file.sw
  save-as-dot file.dot                  save current context in dot format to file.dot
  files                                 show the available .sw files
  web-files http://semantic-db.org/sw/  show the available .sw files on remote site
  web-load http://file.sw               load a sw file from the web
  cd                                    change and create if necessary the .sw directory
  ls, dir, dirs                         show the available directories
  create inverse                        create inverse for current context
  create multi inverse                  create inverse for all context in context list
  x = foo: bah                          set x (the default ket) to |foo: bah>
  id                                    display the default ket/superposition
  s, store                              set x to the result of the last computation
  .                                     repeat last computation
  i                                     interactive history
  history                               show last 30 commands
  history n                             show last n commands
  save history                          save console history to file
  debug on                              switch verbose debug messages on
  debug off                             switch debug messages off
  info on                               switch info messages on
  info off                              switch info messages off
  quiet on                              switch time-taken messages off
  quiet off                             switch time-taken messages on
  -- comment                            ignore, this is just a comment line.
  usage                                 show list of usage information
  usage op1, op2, op3                   show usage of listed operators
  if none of the above                  process_input_line(context, line, x)
```
