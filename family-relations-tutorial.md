Representing family relations using the Semantic DB
===================================================

## Introduction
In this tutorial we will go through the steps of building up a knowledge base about a family in particular, and family relations in general. We will be using the Semantic DB which uses an experimental language that borrows some notation from quantum mechanics and converts it into a knowledge representation language. The goal of the project is to reduce everything down to either kets or operators. Kets are then used to represent the state of a system, and operators act to change the state of that system. In simplest terms, a ket is just a string label with an associated real valued coefficient (usually positive).


## The Semantic DB console
Before we start, we need to introduce the Semantic DB console. This is where we enter knowledge, either by typing it in, or loading from a file, and then ask questions. Once you have it installed, simply run:
```
$ ./sdb-console.py
Welcome to version 2.0 of the Semantic DB!
Last updated 22 May, 2019

To load remote sw files, run:

  web-files http://semantic-db.org/sw/

To see usage docs, visit:

  http://semantic-db.org/docs/usage/


sa:
```
Here are some of the features of the console to get you started:  
To get help in the console:  
`sa: help`

To get usage information for the operator "op":  
`sa: usage op`  

To change file directory:  
`sa: cd sw-examples`

To load files:  
`sa: load family.sw`  
`sa: load family-relations.sw`

To save files:  
`sa: save my-results.sw`

To see what is currently known:  
`sa: dump`

To load files at run time, and then enter "interactive" mode:  
`$ ./sdb-console.py -i sw-examples/family.sw sw-examples/family-relations.sw`

To exit the console:  
`sa: exit`



## Simple Networks
Today we are going to be building some knowledge about a multi-generational family.
We will start by considering "Sally", which we represent in our notation as the ket `|Sally>`.
More generally, ket's can contain almost arbitrary strings, excluding the `'<'` `'|'` and `'>'` characters. 
If we consider some abstract network, `|Sally>` is simply a node in that network.
To start filling out that network, let's next consider Sally's mother Trude, and introduce the `|Trude>` node.
The question becomes how do we notate network structure, such as Trude is the mother of Sally?
For that we need to introduce the second component of our notation, operators. 
In this case we want to define the "mother" operator applied to the `|Sally>` node to result in the `|Trude>` node.
This is done using the following "learn rule":  
`mother |Sally> => |Trude>`  
Or in the console (note the "sa:" prompt indicates we are working in the console):  
`sa: mother |Sally> => |Trude>`  
This is of course the familiar predicate-subject-object triple:  
`"mother" "Sally" "Trude"`  
Though it should be noted, our notation goes well beyond simple triples, as we will see below.
Given this learn rule entered into the console, we can ask the console the simple question: "Who is the mother of Sally?":  
`sa: mother |Sally>`  
`|Trude>`  
At this point it is important to recognise we are actually talking about a network here. A very simple one, but a network nonetheless. We have an abstract network with only one node active, the `|Sally>` node, and we change the state of the network by applying the "mother" operator, and we now have a network with only the `|Trude>` node active. Later we will have more general network states with more than one node active at a time, and those nodes having degrees of activation (the coefficients of kets). We call these states "superpositions". More on them later.



## Semantic Triples
Now we have our notation for semantic triples,
 we can quickly learn some more knowledge about this family:
```
Sally's father is Tom
Sally is 16
Erica's mother is (also) Trude
Erica's father is (also) Tom
Erica is 12
Trude's mother is Sara
Trude's father is Sam
Trude's husband is Tom
Trude's daughters are Sally and Erica
Trude is 38
Tom's mother is Ruth
Tom's father is Mike
Tom's wife is Trude
Tom's daughter are Sally and Erica
Tom is 40
```
in our notation becomes:
```
father |Sally> => |Tom>
age |Sally> => |16>

mother |Erica> => |Trude>
father |Erica> => |Tom>
age |Erica> => |12>

mother |Trude> => |Sara>
father |Trude> => |Sam>
husband |Trude> => |Tom>
daughter |Trude> => |Sally> + |Erica>
age |Trude> => |38>

mother |Tom> => |Ruth>
father |Tom> => |Mike>
wife |Tom> => |Trude>
daughter |Tom> => |Sally> + |Erica>
age |Tom> => |40>
```
Note that I snuck in there our first example of a superposition. When the daughter operator is applied to either `|Trude>` or `|Tom>` the resultant network state is both `|Sally>` and `|Erica>` active at the same time. In our notation this is represented as a sum of the kets: 
`|Sally> + |Erica>`.


## The Parent Operator
OK, so we have notation for triples, but everyone has triples. We need to compose some more interesting operators. How about we consider the definition of parents? Parents are simply our mother plus our father. We can do that in the console:  
`sa: mother |Sally> + father |Sally>`  
`|Trude> + |Tom>`  
OK, but we can do a little better than this, in a more compact and visually cleaner way:  
`sa: (mother + father) |Sally>`  
`|Trude> + |Tom>`  
Nice, but we can go one step further and promote this to a general rule: a parent is always a mother + father independent of who we apply it to (and if needed, we can later over-write general rules with specific exceptions, but that is outside the scope of this tutorial). In our notation this is:  
`parent |*> #=> (mother + father) |_self>`  
We have a bit to unpack here!  
`|*>` means the "parent" operator is defined with respect to all kets  
`#=>` means calculate the answer at invoke time not definition time, and is appropriately called a "stored rule". For comparison `=>` means calculate at defintion time. If that doesn't make sense, don't worry about it for now, just know we need it.
`|_self>` is the location where we substitute in who the operator is being applied to. For example, "Who is the parent of Erica?" is:  
`parent |Erica>`  
which expands to (since we have replaced `|_self>` with `|Erica>`):  
`(mother + father) |Erica>`  
which expands to:  
`|Trude> + |Tom>`

Since we have the "parent" operator defined with respect to `|*>`, it will work when applied to everyone. We can now ask, for example, who are the parents of Sally, Erica, Trude or Tom:  
`sa: parent |Sally>`  
`|Trude> + |Tom>`

`sa: parent |Erica>`  
`|Trude> + |Tom>`

`sa: parent |Trude>`  
`|Sara> + |Sam>`

`sa: parent |Tom>`  
`|Ruth> + |Mike>`


In an identical fashion we can next define the "child" operator as "son" + "daughter":  
`child |*> #=> (son + daughter) |_self>`



## The Sibling Operator
How would we go about defining the "sibling" operator? This is a little bit more involved, but the outline is we find your parents children, and then exclude or subtract yourself. Let's start by considering Sally, and then generalize later. We already know her parents:  
`sa: parent |Sally>`  
`|Trude> + |Tom>`

And in turn, we know Trude's and Tom's children (NB: they are only the same because there are no step-kids in this example):  
`sa: child |Trude>`  
`|Sally> + |Erica>`

`sa: child |Tom>`  
`|Sally> + |Erica>`

One of the properties of operators is we can chain them in sequences by separating them by the space character. In this example, consider the operator sequence "child parent" applied to `|Sally>`:  
`sa: child parent |Sally>`  
`2|Sally> + 2|Erica>`

Let's explain what is going on, and why there are those coefficients of 2 in there! (short version is because Sally has two parents).  
`child parent |Sally>`  
expands to (we evaluate operator sequences right to left):  
`child (|Trude> + |Tom>)`  
expands to, due to operator linearity:  
`child |Trude> + child |Tom>`  
expands to:  
`(|Sally> + |Erica>) + (|Sally> + |Erica>)`  
expands to, using the addition property of kets:  
`2|Sally> + 2|Erica>`

We don't want those 2's in there as they complicate subtracting out `|Sally>` in our "sibling" operator. To solve this we have a collection of built-in "sigmoids" that only modify ket coefficients, not ket labels. In network terms, sigmoids modify how active nodes are, but not which nodes are active. In this case we need the "clean" sigmoid which has the property that if the coefficient is less than or equal to zero the new coefficient is zero, otherwise the new coefficient is set to 1. It produces what we call "clean" superpositions, where all coefficients are either 0 or 1. Which now gives us:  
`sa: clean child parent |Sally>`  
`|Sally> + |Erica>`

But Sally is not a sibling of herself, so let's subtract her:  
`sa: clean child parent |Sally> - |Sally>`  
`0|Sally> + |Erica>`

Then finaly to remove her from the superposition, we use the built-in "drop" operator, which removes all kets from a superposition with coefficients less than or equal to zero:  
`sa: drop (clean child parent |Sally> - |Sally>)`  
`|Erica>`

Finally, tidy this a little:  
`sa: drop (clean child parent - 1) |Sally>`  
`|Erica>`

We are now ready to promote this to a general rule:  
`sibling |*> #=> drop (clean child parent - 1) |_self>`

When we ask "Who is the sibling of Sally?" and "Who is the sibling of Erica?" we get the expected answers:  
`sa: sibling |Sally>`  
`|Erica>`

`sa: sibling |Erica>`  
`|Sally>`

In a similar fashion we can also define the "brother" and "sister" operators:  
`brother |*> #=> drop (clean son parent - 1) |_self>`  
`sister |*> #=> drop (clean daughter parent - 1) |_self>`

And the "brother-and-sister" operator can be defined either as brother + sister, or more simply as an alias for the sibling operator:  
`brother-and-sister |*> #=> sibling |_self>`  
Indeed, this is the general pattern for defining "op2" as an alias for "op1":  
`op2 |*> #=> op1 |_self>`

Finally in this section, we can even define half-brother and half-sister operators, but the explanation for how they work is beyond the scope of this tutorial:  
`half-brother |*> #=> drop son (mother - father) |_self> + drop son (father - mother) |_self>`  
`half-sister |*> #=> drop daughter (mother - father) |_self> + drop daughter (father - mother) |_self>`



## Operator Composition and Operator Sequences
One of the powers of the operator notation over other triple notation is the ease with which we can compose operators. For example your grand-parent's are the parent's of your parent's. Your grand-mother is your parent's mother. Your grand-son is your child's son. And so on. This is demonstrated in the following general rules:
```
grand-parent |*> #=> parent parent |_self>
grand-mother |*> #=> mother parent |_self>
grand-father |*> #=> father parent |_self>
grand-child |*> #=> child child |_self>
grand-son |*> #=> son child |_self>
grand-daughter |*> #=> daughter child |_self>
great-grand-child |*> #=> child child child |_self>
great-grand-son |*> #=> son child child |_self>
great-grand-daughter |*> #=> daughter child child |_self>
great-grand-parent |*> #=> parent parent parent |_self>
great-grand-mother |*> #=> mother parent parent |_self>
great-grand-father |*> #=> father parent parent |_self>
```
So we can now ask:
"Who are Sally's grand-parents, grand-mothers and grand-fathers?"  
`sa: grand-parent |Sally>`  
`|Sara> + |Sam> + |Ruth> + |Mike>`

`sa: grand-mother |Sally>`  
`|Sara> + |Ruth>`

`sa: grand-father |Sally>`  
`|Sam> + |Mike>`

Similarly we can define the following general rules:
```
uncle |*> #=> brother parent |_self> 
aunt |*> #=> sister parent |_self>
aunt-and-uncle |*> #=> (aunt + uncle) |_self>
great-uncle |*> #=> brother grand-parent |_self>
great-aunt |*> #=> sister grand-parent |_self>
great-aunt-and-uncle |*> #=> (great-aunt + great-uncle) |_self>

cousin |*> #=> clean child aunt-and-uncle |_self>
niece |*> #=> daughter brother-and-sister |_self>
nephew |*> #=> son brother-and-sister |_self>

brother-in-law |*> #=> (brother wife + brother husband + husband sister) |_self>
sister-in-law |*> #=> (sister wife + sister husband + wife brother) |_self>
mother-in-law |*> #=> mother (wife + husband) |_self>
father-in-law |*> #=> father (wife + husband) |_self>
spouse |*> #=> (wife + husband) |_self>
```

## The don't know ket, and the do-you-know operator
Let's take a side-step. What happens if you ask a question but we don't know the answer?
For example, consider the spouse operator, we just defined:  
`spouse |*> #=> (wife + husband) |_self>`  
And then ask the spouse of Sally, Erica, Trude and Tom:  
`sa: spouse |Sally>`  
`|>`

`sa: spouse |Erica>`  
`|>`

`sa: spouse |Trude>`  
`|Tom>`

`sa: spouse |Tom>`  
`|Trude>`

So, what is this `|>`? It is the empty ket, otherwise known as the "I don't know" ket. Anytime the system doesn't know the answer, it returns `|>`. Mathematically, the empty ket is the identity element for superposition addition, but that is outside the scope of this tutorial. Usefully however, we have a built-in operator called "do-you-know" that returns `|no>` when applied to `|>`, and `|yes>` otherwise.
Some examples:  
`sa: do-you-know |>`  
`|no>`

`sa: do-you-know spouse |Sally>`  
`|no>`

`sa: do-you-know spouse |Erica>`  
`|no>`

`sa: do-you-know spouse |Trude>`  
`|yes>`

`sa: do-you-know spouse |Tom>`  
`|yes>`

Which allows us to define the is-married operator:  
`is-married |*> #=> do-you-know spouse |_self>`

And if we define the meaning of the "not" operator:  
`not |yes> => |no>`  
`not |no> => |yes>`  
`not |don't know> => |don't know>`

We can then define the is-not-married operator:  
`is-not-married |*> #=> not do-you-know spouse |_self>`

Which returns the expected results:  
`sa: is-not-married |Sally>`  
`|yes>`

`sa: is-not-married |Erica>`  
`|yes>`

`sa: is-not-married |Trude>`  
`|no>`

`sa: is-not-married |Tom>`  
`|no>`  
And as a bonus our operator sequences are reading like simple English sentences.



## is-mbr and the is-a-x operators
It is now time to look at the is-a-x operators, but first we need to introduce the `is-mbr(ket, sp)` function. This function returns `|yes>` if `ket` is a member of the superposition `sp`, otherwise `|no>`.  
This is how we ask: `is "b" in the set {"a", "b", "c"}`:  
`sa: is-mbr(|b>, |a> + |b> + |c>)`  
`|yes>`

Likewise: `is "x" in the set {"a", "b", "c"}`:  
`sa: is-mbr(|x>, |a> + |b> + |c>)`  
`|no>`

We can then use this to construct a collection of operators. Let's try to build the "is-a-daughter" operator first. Once again, consider Sally. Who are Sally's parents?  
`sa: parent |Sally>`  
`|Trude> + |Tom>`

Who are their daughter's?  
`sa: daughter parent |Sally>`  
`2|Sally> + 2|Erica>`

Who are their daughter's, cleaned:  
`sa: clean daughter parent |Sally>`  
`|Sally> + |Erica>`

Now finally we want to ask is "Sally" in the set {"Sally", "Erica"}? Ie, we want to use the is-mbr() function:  
`sa: is-mbr(|Sally>, |Sally> + |Erica>)`  
`|yes>`

Then putting it all together, we define the general rule:  
`is-a-daughter |*> #=> is-mbr(|_self>, clean daughter parent |_self>)`

Using an identical structure we can similarly define:  
`is-a-father |*> #=> is-mbr(|_self>, clean father child |_self>)`  
`is-a-mother |*> #=> is-mbr(|_self>, clean mother child |_self>)`  
`is-a-son |*> #=> is-mbr(|_self>, clean son parent |_self>)`



## The table operator
It often happens to be useful to display the answers to questions in table form, instead of asking them one at a time.
So we introduce the table operator. It has the form:  
`table[label, op1, op2, ..., opn] sp`  
where `label` is the label for the first column  
`op1, op2, ..., opn` are operators that are applied to the objects in the first column (NB: it is often useful to use aliases here).  
`sp` is a superposition/list of objects that we want to apply the operators to.

For example, using the operators defined in the above section, we can display the answers to 16 questions at once:  
```
sa: table[person, is-a-son, is-a-daughter, is-a-mother, is-a-father] (|Sally> + |Erica> + |Trude> + |Tom>)
+--------+----------+---------------+-------------+-------------+
| person | is-a-son | is-a-daughter | is-a-mother | is-a-father |
+--------+----------+---------------+-------------+-------------+
| Sally  | no       | yes           | no          | no          |
| Erica  | no       | yes           | no          | no          |
| Trude  | no       | no            | yes         | no          |
| Tom    | no       | no            | no          | yes         |
+--------+----------+---------------+-------------+-------------+
```

## Exponentiating Operators
Applying operators is kind of like a form of multiplication. Indeed sometimes operators are matrices, and sometimes operators are literally numbers, where it is clear they are acting as multiplication. In this spirit, we can exponentiate operators. So `op^n` expands to the operator sequence `op op ... op`, where `op` is repeated `n` times. In particular, `child^2` is a short-cut for the operator sequence `child child`. `child^3` is short-cut for `child child child`, and so on. Hence, with minimal explanation we introduce these operators:
```
is-a-parent |*> #=> do-you-know child |_self>

is-a-grand-mother |*> #=> is-mbr(|_self>, clean mother parent child^2 |_self>)
is-a-grand-father |*> #=> is-mbr(|_self>, clean father parent child^2 |_self>)
is-a-grand-parent |*> #=> do-you-know child^2 |_self>

is-a-great-grand-mother |*> #=> is-mbr(|_self>, clean mother parent^2 child^3 |_self>)
is-a-great-grand-father |*> #=> is-mbr(|_self>, clean father parent^2 child^3 |_self>)
is-a-great-grand-parent |*> #=> do-you-know child^3 |_self>
```


## The or() and the and() functions
These work in the obvious way, really. Simply enough we have:  
`sa: or(|no>, |no>)`  
`|no>`

`sa: or(|no>, |yes>)`  
`|yes>`

`sa: or(|yes>, |no>)`  
`|yes>`

`sa: or(|yes>, |yes>)`  
`|yes>`


`sa: and(|no>, |no>)`  
`|no>`

`sa: and(|no>, |yes>)`  
`|no>`

`sa: and(|yes>, |no>)`  
`|no>`

`sa: and(|yes>, |yes>)`  
`|yes>`


Allowing us to define the following set of is-a-x operators:
```
is-a-male |*> #=> or(is-a-son |_self>, is-a-father |_self>)
is-a-female |*> #=> or(is-a-daughter |_self>, is-a-mother |_self>)

is-an-uncle |*> #=> and(is-a-male |_self>, do-you-know child sibling |_self>)
is-an-aunt |*> #=> and(is-a-female |_self>, do-you-know child sibling |_self>)

is-a-husband |*> #=> and(is-a-male |_self>, do-you-know wife |_self>)
is-a-wife |*> #=> and(is-a-female |_self>, do-you-know husband |_self>)

is-a-brother |*> #=> and(is-a-male |_self>, do-you-know sibling |_self>)
is-a-sister |*> #=> and(is-a-female |_self>, do-you-know sibling |_self>)
```

## The is-in-range[] operator
We have come a long way! All of the above operators have been derived from knowing this initial set of operators:
`{mother, father, son, daughter, wife, husband}`. If we include the age operator we can define yet more. But first, we need to introduce the `is-in-range[a, b]` operator. Consider the statement:  
`is-in-range[x, y] |z>`  
which has the property that if "z" can't be cast to a float, then return the don't know ket `|>`  
If `x <= z <= y` then return `|yes>`  
Otherwise, return `|no>`

Now we can apply this to the age of our subject in these general rules:
```
is-a-child |*> #=> is-in-range[0,17] age |_self>
is-a-teenager |*> #=> is-in-range[13,19] age |_self>
is-an-adult |*> #=> not is-in-range[0,17] age |_self>
```
Using our table operator we can see the result:
```
sa: table[person, age, is-a-child, is-a-teenager, is-an-adult] (|Sally> + |Erica> + |Trude> + |Tom>)
+--------+-----+------------+---------------+-------------+
| person | age | is-a-child | is-a-teenager | is-an-adult |
+--------+-----+------------+---------------+-------------+
| Sally  | 16  | yes        | yes           | no          |
| Erica  | 12  | yes        | no            | no          |
| Trude  | 38  | no         | no            | yes         |
| Tom    | 40  | no         | no            | yes         |
+--------+-----+------------+---------------+-------------+
```
Finally, we can derive a couple more operators:
```
is-a-man |*> #=> and(is-a-male |_self>, is-an-adult |_self>)
is-a-boy |*> #=> and(is-a-male |_self>, is-a-child |_self>)

is-a-woman |*> #=> and(is-a-female |_self>, is-an-adult |_self>)
is-a-girl |*> #=> and(is-a-female |_self>, is-a-child |_self>)
```


## The have-a-x operators
Recall from above the don't know ket |> and the "do-you-know" operator. Which has the property that "do-you-know" applied to |> returns |no>, and for everything else, "do-you-know" returns |yes>. Hence we can ask if an operator is defined for an object. 
In particular, this collection of have-a-x operators:
have-a-child |*> #=> do-you-know child |_self>
have-a-brother |*> #=> do-you-know brother |_self>
have-a-sister |*> #=> do-you-know sister |_self>
have-a-wife |*> #=> do-you-know wife |_self>
have-a-husband |*> #=> do-you-know husband |_self>
have-an-uncle |*> #=> do-you-know uncle |_self>
have-an-aunt |*> #=> do-you-know aunt |_self>
have-a-cousin |*> #=> do-you-know cousin |_self>
have-a-niece |*> #=> do-you-know niece |_self>
have-a-nephew |*> #=> do-you-know nephew |_self>

More concretly, here are some of them in action in table form:
sa: table[person, have-a-brother, have-a-sister, have-a-wife, have-a-husband] (|Sally> + |Erica> + |Trude> + |Tom>)
+--------+----------------+---------------+-------------+----------------+
| person | have-a-brother | have-a-sister | have-a-wife | have-a-husband |
+--------+----------------+---------------+-------------+----------------+
| Sally  | no             | yes           | no          | no             |
| Erica  | no             | yes           | no          | no             |
| Trude  | no             | no            | no          | yes            |
| Tom    | no             | no            | yes         | no             |
+--------+----------------+---------------+-------------+----------------+



## The how-many operator
The how-many operator counts how many kets are in a superposition. Some examples:
sa: how-many |>
|number: 0>

sa: how-many (|a> + |b>)
|number: 2>

sa: how-many (|a> + |b> + |c> + |d> + |e>)
|number: 5>

This allows us to create another collection of operators. Eg, we can ask: "How many children does Trude have?":
sa: how-many child |Trude>
|number: 2>

In a similar manner we can now define:
how-many-children |*> #=> how-many child |_self>
how-many-grand-children |*> #=> how-many child^2 |_self>
how-many-great-grand-children |*> #=> how-many child^3 |_self>
how-many-brothers |*> #=> how-many brother |_self>
how-many-sisters |*> #=> how-many sister |_self>
how-many-uncles |*> #=> how-many uncle |_self>
how-many-aunts |*> #=> how-many aunt |_self>
how-many-cousins |*> #=> how-many cousin |_self>
how-many-nieces |*> #=> how-many niece |_self>
how-many-nephews |*> #=> how-many nephew |_self>



## Asking and replying in short sentences
Now we have some knowledge, we can define simple question and answer pairs. We already have most of the required pieces, we just need to know how to merge ket labels. '_' merges ket labels with no space, and '__' merges ket labels with a separating space. So for example: |fish> _ |soup> becomes |fishsoup> and |fish> __ |soup> becomes |fish soup>. Now let's define some operators:
sa: Who-is-the-mother-of |*> #=> |The mother of> __ |_self> __ |is> __ mother |_self> _ |.>
sa: Who-is-the-father-of |*> #=> |_self> _ |'s> __ |father is> __ father |_self> _ |.>
sa: How-old-is |*> #=> |_self> __ |is> __ age |_self> __ |years old.>

And now we can ask:
sa: Who-is-the-mother-of |Sally>
|The mother of Sally is Trude.>

sa: Who-is-the-father-of |Trude>
|Trude's father is Sam.>

sa: How-old-is |Erica>
|Erica is 12 years old.>

sa: How-old-is |Trude>
|Trude is 38 years old.>

But to be honest, these simple question/answer pairs are quite restricted in what they can do. With a little work it is possible to reply to questions by selecting a reply template from a list of templates, similar to what we have in the greetings worked example (http://semantic-db.org/docs/usage/worked-examples/greetings.html). With a lot more work we could possibly handle sentences with more than one subject of interest, but that is well beyond the scope of this tutorial. And of course, answering questions with any degree of intelligence is unfortunately a long way off.



## Conclusion
Whew! I hope you made it this far! The above tutorial serves as something of an introduction to the ket/operator model. The goal was to start with an initial set of operators {mother, father, son, daughter, wife, husband, age} and go on to compose consequences of that knowledge, and build a set of operators that apply to all family tree's, not just Sally's. And that the ket/operator model is a more powerful model than a typical triple store. A side observation is that operator sequences often read like simple English sentences. Indeed, we might even go on to claim that the ket/operator model is a good notation to represent brains, where ket's correspond to synapses, and operators to neural circuits. The question then becomes what is the set of interesting and useful operators?


## Further reading
Sally's full family tree: http://semantic-db.org/docs/usage/sw-examples/family.sw
The full family-relations sw file: http://semantic-db.org/docs/usage/sw-examples/family-relations.sw
The Semantic DB readme file: https://github.com/GarryMorrison/Semantic-DB/blob/master/README.md
Minimalistic usage for our operators: http://semantic-db.org/docs/usage/
The Semantic DB: https://github.com/GarryMorrison/Semantic-DB

Where we borrowed the notation from (NB: borrowed. Ie, there are many differences!):
https://en.wikipedia.org/wiki/Bra%E2%80%93ket_notation
https://en.wikipedia.org/wiki/Operator_(physics)

