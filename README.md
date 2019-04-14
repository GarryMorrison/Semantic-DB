The Semantic DB
===============

The Semantic DB is an experimental language that borrows the idea of [kets, superpositions and operators](https://en.wikipedia.org/wiki/Bra%E2%80%93ket_notation) from quantum mechanics and makes something of a programming language out of it. In its current form it is not a general purpose programming language, but may have relevance in the domain of the [semantic web](https://en.wikipedia.org/wiki/Semantic_Web). Our [sw files](http://semantic-db.org/sw/) make great little packages of [knowledge](https://en.wikipedia.org/wiki/Knowledge_representation_and_reasoning) that are easy to pass around the internet.

The central idea of our language, which we call mumble-lang, is to reduce everything down to kets and operators. Don't be afraid though, no knowledge of quantum mechanics is required to understand mumble! Ket's may initially look strange, but they are really just float, string pairs combined with a few mathematical properties. The advantage of kets is their ability to represent nodes, sets, lists, vectors, superpositions, sequences all with the same notation.

## Kets
A string, or object, or node in a graph such as "Fred" is simply the ket `|Fred>`. Likewise, "Sam Roberts" is the ket `|Sam Roberts>`. Indeed, the so called ket label can be any string that does not contain the `| < >` characters. But a ket is slightly more general than a string label, it also has an associated coefficient. For example the tuple `(3, "apple")` in our notation is the ket `3|apple>`, which in the context of a shopping list corresponds to 3 apples, naturally enough. While the tuple `(0.2, "hungry")`, has the corresponding ket `0.2|hungry>`, which can be interpreted as 20% hungry, or "a little bit hungry". That is all a ket is, a notation to represent a float, string pair, that looks a little bit like quantum mechanics.

## Superpositions
They get more interesting when we build "superpositions" of them, where a superposition is a linear combination of kets. That is, our kets add in a natural way. It is not immediately clear what addition means for tuples of float, string pairs, using kets it is more obvious. For example `(3, "apple") + (2, "apple")` is not as intuitive as `3|apple> + 2|apple>` equals `5|apple>`. And `(1, "Sam") + (1, "Mary") + (1, "Matt") + (1, "Sarah")` is not as concise as `|Sam> + |Mary> + |Matt> + |Sarah>`.

The power of our superpositions is that they can flexibly represent a variety of things such as:  
 * "a 50/50 chance of yes or no" as `0.5|yes> + 0.5|no>`
 * The list ["Sam", "Mary", "Matt", "Sarah"] as `|Sam> + |Mary> + |Matt> + |Sarah>`.
 * The set {a,b,c,d,e} as `|a> + |b> + |c> + |d> + |e>`.
 * The vector [0.2, 0.5, 1.7, 9, 3.5] as `0.2|x: 1> + 0.5|x: 2> + 1.7|x: 3> + 9|x: 4> + 3.5|x: 5>`
 * A shopping list such as `3|apple> + |steak> + 5|orange> + |coffee> + |bread> + |milk> + 2|cheese>`
 * A simple equation 3x^2 + 5x + 7 as `3|x*x> + 5|x> + 7| >`
 * "a little bit hungry, very tired, and somewhat upset" as `0.2|hungry> + 0.9|tired> + 0.5|upset>`
 * Or something more abstract such as the superposition: `|a> + 0.5|b> + 2.2|c> + |d>`

## Sequences
Briefly we will mention sequences. They are a time ordered sequence of superpositions. For example, "sp1 . sp2 . sp3" represents the time evolution of superpositon sp1, followed by superposition sp2, followed by superposition sp3. For example, the spelling of the name "Fred" or `|Fred>` is `|F> . |r> . |e> . |d>`. The first few digits of Pi are `|3> . |.> . |1> . |4> . |1> . |5>`. And so on. We can represent many things using only superpositions, but sometimes we need a notion of time, or order, and that is when we use sequences. Again though, the fundamental element in a sequence is the ket.

## Operators
The next component in mumble is the operator. The simplest type of operator is linear, and maps one ket to another ket. If we consider a graph with nodes and directed labelled links between those nodes, then in our notation nodes are kets, and directed links are operators. For example if we have the node `|Fred>` and the node `|47>` in a graph, with a directed arrow labelled "age" linking them, then we call "age" an operator. We define an operator using the notation:  
`age |Fred> => |47>`  
If that didn't make sense, visually this is: 
![Fred age 47](https://raw.githubusercontent.com/GarryMorrison/Semantic-DB/master/graph-examples/fred.png)

Further, the right hand side can also be a superposition, in this case a list of Fred's friends:  
`friends |Fred> => |Sam> + |Mary> + |Matt> + |Sarah>`  
Which visually is this:
![Fred's friends](https://raw.githubusercontent.com/GarryMorrison/Semantic-DB/master/graph-examples/fred-friends.png)

Indeed, this notation is sufficient to represent a simple graph. Consider this knowledge, or collection of "learn rules":
```
|context> => |context: global context>
mother |sally> => |trude>
father |sally> => |tom>
mother |erica> => |trude>
father |erica> => |tom>
mother |trude> => |sarah>
father |trude> => |sam>
mother |tom> => |ruth>
father |tom> => |mike>
mother |ruth> => |gina>
mother |mike> => |mary>
father |mike> => |mark>
```
Which directly maps to this graph:
![mother father graph](https://raw.githubusercontent.com/GarryMorrison/Semantic-DB/master/graph-examples/mother-father.dot.png)

## The SDB Console

Now we have a little bit of knowledge, what can we do with it? Well, we have a console where we can type in or load .sw files, and then enter queries:
```
$ ./sdb-console.py
Welcome to version 2.0 of the Semantic DB!
Last updated 8 December, 2018

To load remote sw files, run:

  web-files http://semantic-db.org/sw/

To see usage docs, visit:

  http://semantic-db.org/docs/usage/


sa:
```

Let's type in the above learn rules:
```
sa: mother |sally> => |trude>
sa: father |sally> => |tom>
sa: mother |erica> => |trude>
sa: father |erica> => |tom>
sa: mother |trude> => |sarah>
sa: father |trude> => |sam>
sa: mother |tom> => |ruth>
sa: father |tom> => |mike>
sa: mother |ruth> => |gina>
sa: mother |mike> => |mary>
sa: father |mike> => |mark>
```

Now "dump" the current context as a check to see what we currently know:
```
sa: dump

----------------------------------------
 |context> => |context: global context>

mother |sally> => |trude>
father |sally> => |tom>

mother |erica> => |trude>
father |erica> => |tom>

mother |trude> => |sarah>
father |trude> => |sam>

mother |tom> => |ruth>
father |tom> => |mike>

mother |ruth> => |gina>

mother |mike> => |mary>
father |mike> => |mark>
----------------------------------------
```

Now ask who is the father of Erica, and then the mother of Ruth?
```
sa: father |erica>
|tom>

sa: mother |ruth>
|gina>
```
Or who is the mother of Sally's father:
```
sa: mother father |sally>
|ruth>
```

Or this knowledge all at once in a neatly formatted table:
```
sa: the-list-of |people> => |sally> + |erica> + |trude> + |tom> + |ruth> + |mike> 
sa: table[person, mother, father] the-list-of |people> 
+--------+--------+--------+
| person | mother | father |
+--------+--------+--------+
| sally  | trude  | tom    |
| erica  | trude  | tom    |
| trude  | sarah  | sam    |
| tom    | ruth   | mike   |
| ruth   | gina   |        |
| mike   | mary   | mark   |
+--------+--------+--------+
```

## Context
Now we have a couple of comments to make on this. First is the idea of context. It often happens that knowledge changes depending on context, so we needed some way to handle that. And hence the special context learn rule:  
`|context> => |context: some context>`  
This defines the context for the learn rules that follow it. And all rules in one context are fully independent of learn rules in all other contexts. Anyway, just a neat way to partition knowledge into domains.

## Operator sequences
Next comment is that, if you missed it, operators can be composed into operator sequences. For example we just gave the example of the mother of Sally's father is:  
`mother father |sally>`  
Another example might be the question "Who are the friends of the friends of Fred?", in the console would simply be:  
`sa: friend friend |Fred>`   
Or "What are the ages of the friends of Fred?", in the console would be:  
`sa: age friend |Fred>`

# Plurals
While still in the console, let's demonstrate loading a .sw file. Consider our [sw file of plurals](https://github.com/GarryMorrison/Semantic-DB/blob/master/sw-examples/plural.sw).
First reset the console back to an empty state:
```
sa: reset

  Warning! This will erase all unsaved work! Are you sure? (y/n): y

  Gone ...
```
Set the sw directory:  
`sa: cd sw-examples`

Now load our knowledge of plurals:
```
sa: load plural.sw
loading sw file: sw-examples/plural.sw
```
Now we can ask some questions. "What is the plural of radius?":
```
sa: plural |radius>
|radii>
```

"What is the plural of apple?":
```
sa: plural |apple>
|apples>
```
"What is the plural of dog?":
```
sa: plural |dog>
|dogs>
```
"What is the inverse-plural of mice?":
```
sa: inverse-plural |mice>
|mouse>
```
And so on.

## Inherit operator
The final idea I want to demonstrate is the inherit operator. The idea is that you can define an object to inherit properties from a parent object.
Let's work through a simple example. Consider our favourite cat Trudy, who is so old she lost her teeth, but otherwise is a standard cat. Let's define our context as "Trudy the cat":  
`sa: |context> => |context: Trudy the cat>`

Let's say Trudy is a type of cat:  
`sa: inherit |trudy> => |cat>`

Let's say a cat is a type of feline:  
`sa: inherit |cat> => |feline>`

Further, a feline is a mammal, and a mammal is an animal:  
`sa: inherit |feline> => |mammal>`  
`sa: inherit |mammal> => |animal>`

Now learn some facts about animals, such as they have fur, teeth, 2 eyes and 4 legs:  
`sa: has-fur |animal> => |yes>`  
`sa: has-teeth |animal> => |yes>`  
`sa: has-2-eyes |animal> => |yes>`  
`sa: has-4-legs |animal> => |yes>`

Now learn that feline's have pointy ears:  
`sa: has-pointy-ears |feline> => |yes>`

Finally, learn that Trudy has no teeth:  
`sa: has-teeth |trudy> => |no>`

Now we have entered this, let's dump our current context and see what we now know:
```
sa: dump

----------------------------------------
 |context> => |context: Trudy the cat>
previous |context> => |context: sw console>

inherit |trudy> => |cat>
has-teeth |trudy> => |no>

inherit |cat> => |feline>

inherit |feline> => |mammal>
has-pointy-ears |feline> => |yes>

inherit |mammal> => |animal>

has-fur |animal> => |yes>
has-teeth |animal> => |yes>
has-2-eyes |animal> => |yes>
has-4-legs |animal> => |yes>
----------------------------------------
```

Now we use the inherit operator to ask a bunch of questions:  
Does Trudy have teeth?  
Has pointy ears?  
Has fur?  
Has 2 eyes?  
Has 4 legs?

```
sa: inherit[has-teeth] |trudy>
|no>

sa: inherit[has-pointy-ears] |trudy>
|yes>

sa: inherit[has-fur] |trudy>
|yes>

sa: inherit[has-2-eyes] |trudy>
|yes>

sa: inherit[has-4-legs] |trudy>
|yes>
```
Which returns the expected answers.

## Conclusion
There is much, much more to mumble, but this will serve as an introduction. The goal of mumble is to be a concise language that contributes towards creating a [Giant Global Graph](https://en.wikipedia.org/wiki/Giant_Global_Graph), with nodes passing around, and processing [sw files](https://github.com/GarryMorrison/Semantic-DB/tree/master/sw-examples), in a distributed semantic computation. Or more speculatively, a mathematical notation for describing (simple) neural circuits, where the ket label is a label for a neuron or synapse, the coefficient corresponds to the activity of that neuron or synapse over some small time window, superpositions represent the currently active neurons/synapses, and operators change the state of the neural circuit.

## Further reading
 * [A collection of rules that define plurals and their inverse](http://semantic-db.org/docs/usage/sw-examples/plural.sw).
 * [A collection of rules that define a family tree](http://semantic-db.org/docs/usage/sw-examples/family.sw).
 * [A collection of rules that can conclude family structures using that family tree](http://semantic-db.org/docs/usage/sw-examples/family-relations.sw).
 * [Our usage info for the similar-input operator](http://semantic-db.org/docs/usage/function-operators/similar-input.html).
 * [Our usage info for the find-topic operator](http://semantic-db.org/docs/usage/function-operators/find-topic.html).
 * [Our usage info for the predict operator](http://semantic-db.org/docs/usage/function-operators/predict.html).
 * [Our worked example for the if-then machine, a simple model of a neuron](http://semantic-db.org/docs/usage/worked-examples/if-then-machines.html).
 * [Our worked example 'active logic' using if-then machines](http://semantic-db.org/docs/usage/worked-examples/active-logic.html).
 * [Our worked example 'walking ant'](http://semantic-db.org/docs/usage/worked-examples/walking-ant.html).
 * [Our current collection of documentation for operators, sw examples, and worked examples](http://semantic-db.org/docs/usage/).

## Some mathematical properties of superpositions
1) they have `|>`, the empty ket, or the don't know ket, as the identity element, so that `|> + sp == sp + |> == sp`, for any superposition sp.
2) they add.  
eg: `(3|a> + 0.2|b> + |c>) + (|a> + 0.5|b> + 2.2|c> + |d>) == 4|a> + 0.7|b> + 3.2|c> + |d>`
3) ket's commute, ie the addition is Abelian.  
So `|a> + |b> + |c> == |b> + |c> + |a>`
4) they can be multiplied by a scalar.  
eg: `7 (3|a> + 0.2|b> + |c>) == 21|a> + 1.4|b> + 7|c>`
5) you can add a ket with coefficient 0 without changing the "meaning" of a superposition.  
eg: `meaning(sp1) == meaning(sp1 + 0 sp2)`  
eg: `meaning(3|a> + 2|b> + |c> + 0|x> + 0|y> + 0|z>) == meaning(3|a> + 2|b> + |c>)`
6) we can take the union of them.  
eg: `union(|a> + 2|b> + 3|c>, 3|a> + 2|b>, |c>) == 3|a> + 2|b> + 3|c>`
7) we can find the intersection.  
eg: `intersection(|a> + 2|b> + 3|c>, 3|a> + 2|b>, |c>) == |a> + 2|b> + |c>`  
where union is term by term max of coefficients, and intersection is term by term min of coefficients.
8) we can find the similarity of them. 1 for identical, 0 for completely different, values in between otherwise.  
eg: `simm(8|a> + 2.2|b>, 8|a> + 2.2|b>) == |simm>`  
eg: `simm(|b>, |a> + |b> + |c>) == 0.3333|simm>`  
eg: `simm(|a> + |b> + |c>, |x> + |y> + |z>) == 0|simm>`

