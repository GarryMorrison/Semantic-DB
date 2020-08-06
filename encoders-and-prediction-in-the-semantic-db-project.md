# Encoders and Prediction in the Semantic DB Project

## Introduction

The Semantic DB is at its core an associative memory system, that was orignally motivated by the idea of a semantic web. That is, an internet wide network of servers transfering packets of semantic information, and processing that information into some useful form. But as it currently stands, the SDB is still trying to find its niche, and remains a toy, experimental language. The founding idea behind the SDB is to reduce everything to what we call kets and operators, with the idea that they provide a notation to describe neuronal circuits. Simply enough, kets perhaps correspond to synapses, and operators to changes in state of a neural system. Note however that we are more motivated by mathematical ideas than biological ones, so we are not fussed if this mapping is not biologically exact. Biologically approximate is sufficent.

### Kets

What then is a ket? There are a few explanations. One is that it is a string, float pair, with a weird notation. If we take the synapse idea seriously, then the string is some label for that synapse (in the broader scheme of things the exact string label doesn't really matter, but it is helpful to be human readable), and the float is some measure of how active that synapse is. If instead we look at them mathematically, the string component of kets are basis elements in some almost infinite vector space (limited by the finite nature of strings on computers), and the floats are the co-ordinates of some vector in that space. Another interpretation of a ket is that they are nodes in a graph, and the float is measure of the strength of the link between nodes. Since we desire to reduce everything to kets and operators, we consequently require our kets to be general enough to represent almost everything of interest. The result is that the exact interpretation of a ket depends on the context. So, how do we represent our string, float pairs? We use `c|s>`, where c is some float, usually positive, and s is some string. The notation is actually borrowed from Dirac's bra-ket notation in quantum mechanics, where c would be a complex number, but that connection is not terribly important to what we are doing here. A couple of simple examples are, 70% hungry would be the ket `0.7|hungry>`, meanwhile nine apples would be `9|apple>`. 

### Superpositions

Given kets, we can now build superpositions. Again, the name is borrowed from quantum mechanics, but that is not important either. Mathematically a superposition is linear combination of kets, or a vector in a vector space. More simply, a superposition is just the addition of a bunch of kets, or perhaps considered as the set of kets active at the same time, with their coefficients a measure of how active they are. Zero means they are not active at all, and negative coefficients can be thought of as a type of inhibbition (especially when combined with the `drop` operator). If all the coefficients are either 0 or 1 then we call the superposition a "clean superposition". In this case a clean superposition has more specialized meanings. For example, if the ket has a zero coefficient we say it is not in a set, and if it is 1, then it is in a set. So the set `{ball, bat, glove}` can be represented by the superposition `|ball> + |bat> + |glove>` (note that if the coefficient is exactly 1 we don't specify it). Or the set `{orange, apple, pear, peach}` by the superposition `|orange> + |apple> + |pear> + |peach>`. Indeed, we can even take unions and intersections of superpositions, where a union is ket-wise maximums of the coefficients, and intersections are ket-wise minimums of the coefficients. Which generalizes straightforwardly to fuzzy set membership, where the coefficients are not exactly 0 or 1. Further, SDR's ([sparse distributed representations](https://numenta.com/neuroscience-research/sparse-distributed-representations/)) can also be represented by clean superpositions, where SDR's are relevant to [Numenta's HTM work](https://numenta.org/). So a SDR is just a specific type of superposition. Indeed, we see no reason why HTM encoders could not be used with the SDB.

A couple of examples of superpositions. First a shopping list would be represented as:
```
  2|apple> + 5|orange> + |banana> + |milk> + |steak> + |coffee>
```
with the meaning, 2 apples, 5 oranges, 1 banana, 1 milk, 1 steak and 1 coffee. While:
```
  0.3|A> + 0.22|B> + 0.05|C> + 0.43|D>
```
has one interpretation as 30% chance of A, 22% chance of B, 5% chance of C, and 43% chance of D. It should be noted that superpositions are implemented in python as OrderedDict's, where the string is the key, and the float is the value. Mathematically it doesn't make a lot of sense for superpositions to be ordered, but in practice this is very useful indeed. For example, sorting by the coefficient using [coeff-sort](http://semantic-db.org/docs/usage/built-in/coeff-sort.html), sorting by the ket string using [ket-sort](http://semantic-db.org/docs/usage/built-in/ket-sort.html) or some more involved sorting process using [sort-by[]](http://semantic-db.org/docs/usage/function-operators/sort-by.html).

### Sequences

Given superpositions, we can now build sequences. So while a superposition is a collection of kets active at one time, a sequence represents a change in activation over some period of time. Though the speed with which a sequence changes from one superposition to the next is not specified. Notationaly we represent a sequence by separating the superpositions with the dot character " . ". Unfortunately, in general a sequence of superpositions is notationaly quite ugly to read, though we have operators such as [long-display](http://semantic-db.org/docs/usage/function-operators/long-display.html) that helps with this. But for simple superpositions they are not so bad. The simplest sequences are sequences of clean kets (ie, kets with coefficient 1). Indeed, we can represent a lot just with these "clean" sequences. Some examples:

The spelling of the word happy:
```
  |h> . |a> . |p> . |p> . |y>
```
A simple sentence:
```
  |The> . |frog> . |sat> . |on> . |the> . |stone> . |and> . |rested.>
```
The first few digits of Pi:
```
  |3> . |.> . |1> . |4> . |1> . |5> . |9> . |2> . |6> . |5>
```
The first few digits of e:
```
  |2> . |.> . |7> . |1> . |8> . |2> . |8> . |1> . |8> . |2> . |8> . |4> . |5> . |9>
```
Again, it should be noted that sequences are implemented as python lists of superposition objects.


## Associative Memory

At the core of the SDB is an associative memory system (implemented using hash tables). This system associates an operator and a ket with a pattern. That pattern can be almost anything, either a ket, a superposition, a sequence, or even more complex objects that we haven't described. We call this triple `(operator, ket, pattern)` a learn rule. Triples of course being the foundation behind so called [triple-stores](https://en.wikipedia.org/wiki/Triplestore), though in the SDB, the pattern component is rather general, and not restricted to just kets. 

In the simplest case, the pattern is a ket. For example, we could start to represent some knowledge about Fred Smith using the following learn rules:
```
  mother |Fred Smith> => |Eve Smith>
  father |Fred Smith> => |John Smith>
  sister |Fred Smith> => |Erica Smith>
  age |Fred Smith> => |37>
  height |Fred Smith> => |cm: 180>
```
where `mother`, `father`, `sister`, `age`, and `height` are so called literal operators - the simplest class of operators. More on operators later. 

So even though the string "Fred Smith" is in a sense arbitrary, and could for example be replaced by some non human-readable integer, it is the association of this ket with other kets through learn rules (triples), that provides an "understanding" of "Fred Smith". Similar to a mind-map, the more links between kets, the better we "understand" those kets. It is now straightforward to learn a little more about Fred's family:
```
  mother |Eve Smith> => |Joan Roberts>
  father |Eve Smith> => |Harold Roberts>
  age |Eve Smith> => |65>
  height |Eve Smith> => |cm: 165>

  mother |John Smith> => |Emma Smith>
  father |John Smith> => |Philip Smith>
  age |John Smith> => |69>
  height |John Smith> => |cm: 182>

  mother |Erica Smith> => |Eve Smith>
  father |Erica Smith> => |John Smith>
  age |Erica Smith> => |33>
  height |Erica Smith> => |cm: 167>
```
If we enter this knowledge into our SDB "console", which has the prompt `sa:`, we can ask the system simple questions:

How old is Fred?
```
  sa: age |Fred Smith>
    |37>
```
Who is Fred's sister?
```
  sa: sister |Fred Smith>
    |Erica Smith>
```
Or by composing operators in a so called "operator sequence", we can ask indirect questions:

Who is Fred's grandfather on his father's side?
```
  sa: father father |Fred Smith>
    |Philip Smith>
```
How tall is Fred's mother?
```
  sa: height mother |Fred Smith>
    |cm: 165>
```

### Operator sequences

One powerful feature of operators is that they can be chained in sequences (separated by the space character), rather like pipes on the commandline (where the | symbol is used). At each step in the operator sequence, the object being processed is a ket, superposition or sequence. Once an operator is finished processing the input sequence, it passes it on to the next operator. Because ket's, superpositions and sequences are rather general in what they can represent, this makes operator sequences a compact and powerful way to manipulate states. Just above we have the two operator sequence examples of `father father` and `height mother`, but as will be seen below, they are frequently used in the semantic db. 


### The table operator

Asking questions one at a time is a little limited, so we can display our knowledge in a neatly formatted [table](http://semantic-db.org/docs/usage/function-operators/table.html). For example, if we define a list of people of interest:
```
  the |people> => |Eve Smith> + |John Smith> + |Fred Smith> + |Erica Smith>
```
We can display our knowledge using:
```
  sa: table[person, mother, father, sister, age, height] the |people>
  +-------------+--------------+----------------+-------------+-----+--------+
  | person      | mother       | father         | sister      | age | height |
  +-------------+--------------+----------------+-------------+-----+--------+
  | Eve Smith   | Joan Roberts | Harold Roberts |             | 65  | 165    |
  | John Smith  | Emma Smith   | Philip Smith   |             | 69  | 182    |
  | Fred Smith  | Eve Smith    | John Smith     | Erica Smith | 37  | 180    |
  | Erica Smith | Eve Smith    | John Smith     |             | 33  | 167    |
  +-------------+--------------+----------------+-------------+-----+--------+
```
where the table column headings are the operators applied to the objects in the first column (the first column header is actually arbitrary). If the operator is undefined with respect to an object, then it returns `|>` the so called empty ket, or in table form, just a blank space. In this case when we ask about the sister of Eve, John and Erica.


### The empty ket

An aside about the empty ket `|>`. Anytime the system does not know the answer, it returns `|>`. Mathematically, `|>` is the identity element for superpositions, in that if you add it to any superposition that superpostion is unchanged. Just like 0 is the identity element for addition, and 1 is the identity element for multiplication. Also, any triple with `|>` as the pattern on the right hand side is ignored, ie, nothing is learned in that case. Sometimes you don't want this behaviour, so there are work-arounds, but mostly you do. There is also a related operator called [do-you-know](http://semantic-db.org/docs/usage/built-in/do-you-know.html) that tells you if the result is the empty ket or not. So for example:
```
  sa: do-you-know sister |Fred Smith>
    |yes>
	
  sa: do-you-know sister |Eve Smith>
    |no>
```

### Similarity measure

Above we briefly mentioned you can take the union or intersection of superpositions, even superpositions that are not "clean". Well, we also have a [similarity measure](http://semantic-db.org/docs/usage/sequence-functions/simm.html). This returns a value in the range 0 to 1 based on the "similarity" of two given superpositions. The similarity of any superposition with itself is always 1. The similarity of any superposition with another that has no kets in common is always 0. If the two superpositions share some kets in common, then the similarity is somewhere between 0 and 1. This measure allows us to compare superpositions in a useful way. If the superpositions are encoded in just the right way, then the similarity measure measures the semantic similarity of two objects. In theory this is very powerful, in practice it is hard work to find good encoders. It is for example easy to find encoders that encode the spelling similarity of words, or the similarity of a sequence of digits of say pi or e, or the similarity of integer sequences such as Fibonacci and factorial. It is much harder to find encoders that encode the semantic similarity of two words (see for example [Cortical IO's work](https://www.cortical.io/)), or that can be used for [MNIST digit recognition](http://yann.lecun.com/exdb/mnist/), or the even harder problem of face or object recognition. So finding good [encoders](https://arxiv.org/abs/1602.05925), in the general case, remains an open but important problem.


### If-Then machines

Now we have the basics out of the way, we can move on to a more advanced topic, so called if-then machines. The motivation is that we have a collection of patterns that when matched return an output pattern. Ie, if any of the patterns are true (or at least fuzzily true), then the output is triggered. Hence the (boring) name. But more interestingly, if-then machines can be considered a simplified model of a neuron. The patterns correspond to different "input branches" of the given neuron, and the output pattern is the result when the neuron "fires". The idea is you feed in an input pattern, then it is compared (by way of the [similar-input[]](http://semantic-db.org/docs/usage/function-operators/similar-input.html) operator) using the similarity measure against all the patterns defined with respect to a literal operator (most frequently that operator is simply called `pattern`). We then filter the results using the [drop-below[]](http://semantic-db.org/docs/usage/built-in/drop-below.html) operator. So, for a 75% similarity before firing, we would use [drop-below[0.75]](http://semantic-db.org/docs/usage/built-in/drop-below.html). It is important to note that the SDB while being "mathematical" in structure, is unlike [Prolog](https://en.wikipedia.org/wiki/Prolog) and similar, by not being based on [first order logic](https://en.wikipedia.org/wiki/First-order_logic).

Here is a very simple example, used to read a correspondingly simple sentence (which we will get to in a moment):
```
  pattern |node: 1: 1> => |Hello>
  then |node: 1: *> => |greeting: hello>

  pattern |node: 2: 1> => |Fred> . |Smith>
  then |node: 2: *> => |person: Fred Smith>

  pattern |node: 3: 1> => |how> . |are> . |you?>
  then |node: 3: *> => |phrase question: how are you>
```

### Smap

Before we can proceed, we need to explain the [smap](http://semantic-db.org/docs/usage/sequence-functions/smap.html) operator (ie, the sequence-map operator). The general idea is you break a sequence into ngrams of the specified sizes, and then apply operators to those pieces. The motivation is to replicate a little what happens when a person reads a sentence, and indeed, that is the example we will get to shortly. First a sentence is split into a sequence, and at each step, you populate a small set of buffers which are ngrams of the last n words, and apply operators to those buffers. Let's work through a trivial example, the sequence `|a> . |b> . |c> . |d> . |e>`, and buffers of length 1, 2 and 3. 

At step 1 the three buffers are:
```
  |a> and |> and |>
```
At step 2 the buffers are:
```
  |b> and |a> . |b> and |>
```
At step 3 the buffers are:
```
  |c> and |b> . |c> and |a> . |b> . |c>
```
At step 4 the buffers are:
```
  |d> and |c> . |d> and |b> . |c> . |d>
```
At step 5 the buffers are:
```
  |e> and |d> . |e> and |c> . |d> . |e>
```
At step 6 the processing stops, so the output sequence of smap is always the same length as the input sequence. Along with operator sequences, this allows one to build up hierarchical processing of an input sequence. 

If we define a wrapper around the [smerge](http://semantic-db.org/docs/usage/function-operators/smerge.html) function, that merges a sequence into a ket (though we won't go into details here):
```
  merge-seq (*) #=> smerge[" . "] |_self>
```
And note that [smap](http://semantic-db.org/docs/usage/sequence-functions/smap.html) has form:
```
  smap(min_size, max_size, operators) input-seq
```
where "min_size" is the minimum ngram size, "max_size" is the maximum ngram size, "operators" is the set of operators to apply to the buffers, and "input-seq" is the input sequence we apply this all to. 

Then finally, we can get a hint of what smap is doing using the following code:
```
  sa: long-display smap(|1>, |3>, |op: merge-seq>) (|a> . |b> . |c> . |d> . |e>)
    seq |0> => |a>
    seq |1> => |b> + |a . b>
    seq |2> => |c> + |b . c> + |a . b . c>
    seq |3> => |d> + |c . d> + |b . c . d>
    seq |4> => |e> + |d . e> + |c . d . e>
    |a> . |b> + |a . b> . |c> + |b . c> + |a . b . c> . |d> + |c . d> + |b . c . d> . |e> + |d . e> + |c . d . e>
```
As I said above, the final sequence is hard to read, but the [long-display](http://semantic-db.org/docs/usage/function-operators/long-display.html) operator shows the superpositions at each step in the sequence. If this section on smap doesn't make a terrible lot of sense, it is safe to mostly ignore it!


### Read-sentence

The smap section was just a motivation for this section, using if-then machines and smap to read simple sentences. Then it becomes only a matter of defining more if-then machines if we wish to have a deeper understanding of a sentence. All we have to do is define a couple of operators:
```
  sim-pattern (*) #=> then drop-below[0.7] similar-input[pattern] |_self>
  read-sentence |*> #=> smap(|1>, |3>, |op: sim-pattern>) ssplit[" "] |_self>
```
And now we can do:
```
  sa: read-sentence |Hello Fred Smith how are you?>
    |greeting: hello> . |> . |person: Fred Smith> . |> . |> . |phrase question: how are you>
```
where `sim-pattern` operator invokes our if-then machines, and `read-sentence` applies `sim-pattern` to the ngrams generated by smap. We used "max_size" of `|3>`, but in practice `|4>` or `|5>` might be more appropriate if we want to consider longer ngrams. Likewise, we used [drop-below[0.7]](http://semantic-db.org/docs/usage/built-in/drop-below.html), in other cases you might want it stricter than this, eg, [drop-below[0.98]](http://semantic-db.org/docs/usage/built-in/drop-below.html) or less strict such as [drop-below[0.5]](http://semantic-db.org/docs/usage/built-in/drop-below.html), for 98% and 50% similarity respectively.

### A larger if-then machine example

A slightly more complex if-then machine read-sentence example. This time our machines/neurons have more than one pattern available to match, which can be interpretated as a kind of "or" statement. That is, if the pattern matches pattern1 or pattern2 or pattern3 or ... patternn then output the `then` pattern.

First, define the relevant if-then machines, related to my home town:
```
  pattern |node: 4: 1> => |university> . |of> . |Adelaide>
  pattern |node: 4: 2> => |University> . |of> . |Adelaide>
  pattern |node: 4: 3> => |Adelaide> . |uni>
  then |node: 4: *> => |university: Adelaide>

  pattern |node: 5: 1> => |Adelaide>
  then |node: 5: *> => |Australia: city: Adelaide> + |UK: queen: Adelaide>

  pattern |node: 6: 1> => |river> . |Torrens>
  pattern |node: 6: 2> => |the> . |Torrens>
  pattern |node: 6: 3> => |Torrens> . |river>
  then |node: 6: *> => |South Australia: river: Torrens>

  pattern |node: 7: 1> => |South> . |Australia>
  pattern |node: 7: 2> => |SA>
  then |node: 7: *> => |Australia: state: South Australia>

  pattern |node: 8: 1> => |university>
  pattern |node: 8: 2> => |Univeristy>
  pattern |node: 8: 3> => |uni>
  then |node: 8: *> => |place of study: university>
```

Now we can read a couple of sentences:
```
  sa: long-display read-sentence |The university of Adelaide is located next to the beautiful river Torrens in Adelaide South Australia>
    seq |0> => |>
    seq |1> => |place of study: university>
    seq |2> => |>
    seq |3> => |Australia: city: Adelaide> + |UK: queen: Adelaide> + |university: Adelaide>
    seq |4> => |>
    seq |5> => |>
    seq |6> => |>
    seq |7> => |>
    seq |8> => |>
    seq |9> => |>
    seq |10> => |>
    seq |11> => |South Australia: river: Torrens>
    seq |12> => |>
    seq |13> => |Australia: city: Adelaide> + |UK: queen: Adelaide>
    seq |14> => |>
    seq |15> => |Australia: state: South Australia>
    |> . |place of study: university> . |> . |Australia: city: Adelaide> + |UK: queen: Adelaide> + |university: Adelaide> . |> . |> . |> . |> . |> . |> . |> . |South Australia: river: Torrens> . |> . |Australia: city: Adelaide> + |UK: queen: Adelaide> . |> . |Australia: state: South Australia>


  sa: long-display read-sentence |Adelaide uni is next to the Torrens in SA>
    seq |0> => |Australia: city: Adelaide> + |UK: queen: Adelaide>
    seq |1> => |place of study: university> + |university: Adelaide>
    seq |2> => |>
    seq |3> => |>
    seq |4> => |>
    seq |5> => |>
    seq |6> => |South Australia: river: Torrens>
    seq |7> => |>
    seq |8> => |Australia: state: South Australia>
    |Australia: city: Adelaide> + |UK: queen: Adelaide> . |place of study: university> + |university: Adelaide> . |> . |> . |> . |> . |South Australia: river: Torrens> . |> . |Australia: state: South Australia>
```
To start to "understand" more complex sentences is then an exercise in specifying more detailed if-then machines. If we had a semantic web, we could just download such knowledge from the relevant server, and then proceed. Though care would be require so that the if-then machine node labels don't over-write each other. But that would not be difficult.

### Spelling encoder

We now have enough background to describe our spelling encoder. It is quite compact, but perhaps a bit slow and not as good as a standard spell-check algorithm. I guess it is more of a proof of concept. At a later stage, someone might design a better spelling encoder. Again, our encoder makes use of smap, and an additional operator called [seq2sp](http://semantic-db.org/docs/usage/function-operators/seq2sp.html). Seq2sp converts a sequence into a single superposition by adding all the superpositions in the sequence together. Here is our proposed encoder:
```
  seq2sp-op (*) #=> seq2sp |_self>
  spelling-encoder |*> #=> smap(|1>, |3>, |op: seq2sp-op>) ssplit |_self>
```
It is useful to see a couple of examples of spelling-encoder in action:
```
  sa: long-display spelling-encoder |happy>
    seq |0> => |h>
    seq |1> => 2|a> + |h>
    seq |2> => 3|p> + 2|a> + |h>
    seq |3> => 5|p> + |a>
    seq |4> => 3|y> + 3|p>
    |h> . 2|a> + |h> . 3|p> + 2|a> + |h> . 5|p> + |a> . 3|y> + 3|p>

  sa: long-display spelling-encoder |friend>
    seq |0> => |f>
    seq |1> => 2|r> + |f>
    seq |2> => 3|i> + 2|r> + |f>
    seq |3> => 3|e> + 2|i> + |r>
    seq |4> => 3|n> + 2|e> + |i>
    seq |5> => 3|d> + 2|n> + |e>
    |f> . 2|r> + |f> . 3|i> + 2|r> + |f> . 3|e> + 2|i> + |r> . 3|n> + 2|e> + |i> . 3|d> + 2|n> + |e>
```
Noting that the parameters in smap of min ngram 1, and max ngram size of 3 seem to be optimal. Given we have an encoder we are a small step away from having a full spell-check operator. Since we don't have a local copy of a dictionary we need to load one from [remote](http://semantic-db.org/sw-examples/small-english-dictionary.sw):
```
  sa: web-load http://semantic-db.org/sw-examples/small-english-dictionary.sw
```
Then we need to apply the spelling encoder to every word in that dictionary using:
```
  sa: map[spelling-encoder, encoded-spelling] rel-kets[spelling]
```
where [rel-kets[spelling]](http://semantic-db.org/docs/usage/function-operators/rel-kets.html) returns a superposition with all the "relevant" kets that have the literal operator `spelling` defined. In our case that is all the words in the dictionary we just loaded. The [map](http://semantic-db.org/docs/usage/function-operators/map.html) operator then applies our spelling encoder to each of the kets in the superposition returned by rel-kets, and stores the result using the literal operator `encoded-spelling`. With those pieces in place, our spell-check operator becomes:
```
  spell-check |*> #=> select[1,10] similar-input[encoded-spelling] spelling-encoder |_self>
```
This encodes the input word, compares it to all the stored encoded-spellings (which can be quite slow unfortunately, as there are a lot of comparisons going on in the background), and then selects the top 10 results. Noting that the superposition returned by [similar-input[]](http://semantic-db.org/docs/usage/function-operators/similar-input.html) is sorted by coefficient size, largest first, otherwise [select[]](http://semantic-db.org/docs/usage/built-in/select.html) would not work as desired. The resulting superposition is somewhat difficult to read, so we display it using the [bar-chart[]](http://semantic-db.org/docs/usage/function-operators/bar-chart.html) operator. The length of the bars correspond to the coefficients of the kets. Here are some examples of common typos:
```
sa: bar-chart[10] spell-check |heirarchy>
----------
hierarchy    : ||||||||||
hierarchical : |||||||
oligarchy    : ||||||
heirloom     : |||||
hesitancy    : |||||
headache     : |||||
heirs        : |||||
research     : |||||
overarching  : |||||
oligarch     : |||||
----------

sa: bar-chart[10] spell-check |recieve>
----------
relieve  : ||||||||||
receive  : |||||||||
recipe   : ||||||||
recite   : ||||||||
recover  : ||||||||
recital  : |||||||
recline  : |||||||
receipt  : |||||||
reviewer : |||||||
believe  : |||||||
----------

sa: bar-chart[10] spell-check |teh>
----------
tea  : ||||||||||
ten  : ||||||||||
the  : ||||||||
team : |||||||
tear : |||||||
teem : |||||||
teen : |||||||
tell : |||||||
tend : |||||||
tens : |||||||
----------

sa: bar-chart[10] spell-check |shwo>
----------
show  : ||||||||||
shod  : |||||||||
shoe  : |||||||||
shop  : |||||||||
shot  : |||||||||
sham  : ||||||||
shed  : ||||||||
ship  : ||||||||
shown : ||||||||
shows : ||||||||
----------
```

### Digit encoder

The next encoder we are going to consider is the digit encoder. Just like the spelling encoder it is quite compact. The idea is that given a digit we will return a Gaussian around that digit. So nearby digits will be similar, but distant digits will have zero similarity. The only difficulty we face is how wide do we want the Gaussian to be? Too large and say 1 and 9 would be quite similar. Too small and neighbouring digits won't be considered similar at all. For now it seems 0.6 is close to the right choice. Here is [Gaussian[0.6]](http://semantic-db.org/docs/usage/function-operators/Gaussian.html) applied to 5, again visualizing the coefficients using the bar-chart operator:
```
sa: bar-chart[10] Gaussian[0.6] |5>
----------
2 :
3 :
4 : ||
5 : ||||||||||
6 : ||
7 :
8 :
----------
```
Before we define our full digit encoder we first need to learn what a digit is. So simply enough:
```
  list-of |digits> => |0> + |1> + |2> + |3> + |4> + |5> + |6> + |7> + |8> + |9>
```
Then we require the `is-digit` operator, which returns `|yes>` or `|no>` depending on whether the input ket is a member ([is-mbr](http://semantic-db.org/docs/usage/sequence-functions/is-mbr.html)) of the list of digits or not:
```
  is-digit |*> #=> is-mbr(|_self>, list-of |digits>)
```
So finally we can write down our digit encoder:
```
  digit-encoder |*> #=> if(is-digit |_self>, Gaussian[0.6] |_self>, |_self>)
```
In words, if the input object is a digit return the [Gaussian[0.6]](http://semantic-db.org/docs/usage/function-operators/Gaussian.html) of that object, otherwise return the object itself. All in all, very simple. Unlike our next section.


### Predicting and fuzzy predicting digits

Given a digit encoder we can in theory now predict the next few digits of a given digit sequence (eg, Pi or e), but the code to do so is very technical and beyond the scope of this document. To do so we need smap, if-then machines, our digit encoder and more. Instead of giving the details we will instead only provide examples of it in action. Let's consider the first few digits of Pi and e, but there is nothing special about these, they could be any sequence of digits:
```
  string |pi> => |3.141592653589>
  digits |pi> => ssplit string |pi>

  string |e> => |2.71828182845904523>
  digits |e> => ssplit string |e>
```
Once the [relevant code](http://semantic-db.org/docs/usage/sw-examples/identify-and-predict-sequence-fragments.swc "identify-and-predict-sequence-fragments.swc") is loaded into the console, we can ask:
```
  sa: predict-next |3.141>
  100 %      number: pi      pattern:     3 . 1 4 1      next-1:     5
  100 %      number: pi      pattern:     3 . 1 4 1      next-2:     5 9
  100 %      number: pi      pattern:     3 . 1 4 1      next-3:     5 9 2
  3|results>

  sa: predict-next |2.7>
  100 %      number: e      pattern:     2 . 7      next-1:     1
  100 %      number: e      pattern:     2 . 7      next-2:     1 8
  100 %      number: e      pattern:     2 . 7      next-3:     1 8 2
  3|results>

  sa: predict-next |999>
  |Anomaly, no sequence detected ... >
```
where the first column is the percent similarity with the inputted sequence (always 100% if using the `predict-next` operator), the next column is the name of that sequence, the next is the pattern that matched the input, and the final column is the prediction for the next 1, 2 and 3 digits. As you can see it correctly identifies the digits of Pi and e, but complains that it knows nothing about the sequence 999. 

The fuzzy-predict-next operator works similarly, but this time fuzzy matches digit sequences. Let's say we didn't quite get Pi or e right:
```
  sa: fuzzy-predict-next |3.142>
  87.9 %      number: pi      pattern:     3 . 1 4 1      next-1:     5
  87.9 %      number: pi      pattern:     3 . 1 4 1      next-2:     5 9
  87.9 %      number: pi      pattern:     3 . 1 4 1      next-3:     5 9 2
  80 %      number: pi      pattern:     3 . 1 4      next-1:     1
  80 %      number: pi      pattern:     3 . 1 4      next-2:     1 5
  80 %      number: pi      pattern:     3 . 1 4      next-3:     1 5 9
  73.3 %      number: pi      pattern:     3 . 1 4 1 5      next-1:     9
  73.3 %      number: pi      pattern:     3 . 1 4 1 5      next-2:     9 2
  62.8 %      number: pi      pattern:     3 . 1 4 1 5 9      next-1:     2
  60 %      number: pi      pattern:     3 . 1      next-1:     4
  60 %      number: pi      pattern:     3 . 1      next-2:     4 1
  60 %      number: pi      pattern:     3 . 1      next-3:     4 1 5
  12|results>

  sa: fuzzy-predict-next |2.8>
  79.8 %      number: e      pattern:     2 . 7      next-1:     1
  79.8 %      number: e      pattern:     2 . 7      next-2:     1 8
  79.8 %      number: e      pattern:     2 . 7      next-3:     1 8 2
  66.7 %      number: e      pattern:     2 .      next-1:     7
  66.7 %      number: e      pattern:     2 .      next-2:     7 1
  66.7 %      number: e      pattern:     2 .      next-3:     7 1 8
  59.9 %      number: e      pattern:     2 . 7 1      next-1:     8
  59.9 %      number: e      pattern:     2 . 7 1      next-2:     8 2
  59.9 %      number: e      pattern:     2 . 7 1      next-3:     8 2 8
  9|results>
```

### Integer encoder

Our final encoder is an integer encoder. Again, we use a Gaussian, but this time a little wider than for the digit encoder. [Gaussian[1]](http://semantic-db.org/docs/usage/function-operators/Gaussian.html) seems to work well enough. The code is only a little more involved than the digit encoder, but still rather similar. The only difficulty is to define the `is-integer` operator.
```
  list-of |digits> => |0> + |1> + |2> + |3> + |4> + |5> + |6> + |7> + |8> + |9>
  is-integer |*> #=> is-subset(clean split[""] replace[", ", ""] |_self>, list-of |digits>)
  integer-encoder |*> #=> if(is-integer |_self>, Gaussian[1] |_self>, |_self>)
```
In words, if the input ket is an integer apply [Gaussian[1]](http://semantic-db.org/docs/usage/function-operators/Gaussian.html) to it, otherwise return the input ket. This is what [Gaussian[1]](http://semantic-db.org/docs/usage/function-operators/Gaussian.html) applied to 5 looks like, ie, quite a bit wider than for the digit encoder, which is exactly what we want:
```
sa: bar-chart[10] Gaussian[1] |5>
----------
-4 :
-3 :
-2 :
-1 :
0  :
1  : |
2  : ||
3  : |||
4  : ||||||
5  : ||||||||||
6  : ||||||
7  : |||
8  : ||
9  : |
10 :
11 :
12 :
13 :
14 :
----------
```

### Predicting and fuzzy predicting integer sequences

In this final section we learn some integer sequences, then apply rather similar code to the digit predict code. Unlike digit sequences, there are many, many sequences of integers that are interesting. For our demonstration we have chosen the counting numbers, Fibonacci, factorial and primes. But again, there is nothing paritcularly special about these sequences, other than they are easy to generate. Here is the code that generates our desired sequences:
```
  fib |0> => |0>
  fib |1> => |1>
  fib |*> !=> arithmetic( fib minus[1] |_self>, |+>, fib minus[2] |_self>)

  fact |0> => |1>
  fact |*> !=> arithmetic(|_self>, |*>, fact minus[1] |_self>)

  is-prime |*> #=> is-prime |_self>

  int-seq |count> => sp2seq range(|1>, |100>)
  int-seq |fib> => fib sp2seq range(|1>, |30>)
  int-seq |fact> => fact sp2seq range(|1>, |15>)
  int-seq |primes> => such-that[is-prime] sp2seq range(|1>, |200>)
```
Once the [relevant code](http://semantic-db.org/docs/usage/sw-examples/identify-and-predict-integer-sequence-fragments.swc "identify-and-predict-integer-sequence-fragments.swc") is loaded into the console, we can start making predictions.
```
  sa: predict-next |1 2 3 4 5>
  100 %      integer sequence: counting      pattern:     1 2 3 4 5      next-1:     6
  100 %      integer sequence: counting      pattern:     1 2 3 4 5      next-2:     6 7
  100 %      integer sequence: counting      pattern:     1 2 3 4 5      next-3:     6 7 8
  100 %      integer sequence: counting      pattern:     1 2 3 4 5      next-4:     6 7 8 9
  4|results>

  sa: predict-next |2 3 5 8>
  100 %      integer sequence: fibonacci      pattern:     2 3 5 8      next-1:     13
  100 %      integer sequence: fibonacci      pattern:     2 3 5 8      next-2:     13 21
  100 %      integer sequence: fibonacci      pattern:     2 3 5 8      next-3:     13 21 34
  100 %      integer sequence: fibonacci      pattern:     2 3 5 8      next-4:     13 21 34 55
  4|results>

  sa: predict-next |2 6 24>
  100 %      integer sequence: factorial      pattern:     2 6 24      next-1:     120
  100 %      integer sequence: factorial      pattern:     2 6 24      next-2:     120 720
  100 %      integer sequence: factorial      pattern:     2 6 24      next-3:     120 720 5040
  100 %      integer sequence: factorial      pattern:     2 6 24      next-4:     120 720 5040 40320
  4|results>

  sa: predict-next |2 3 5 7>
  100 %      integer sequence: primes      pattern:     2 3 5 7      next-1:     11
  100 %      integer sequence: primes      pattern:     2 3 5 7      next-2:     11 13
  100 %      integer sequence: primes      pattern:     2 3 5 7      next-3:     11 13 17
  100 %      integer sequence: primes      pattern:     2 3 5 7      next-4:     11 13 17 19
  4|results>
```
Alternatively, we can make fuzzy predictions (which due to the fuzzy matching produces many more results):
```
sa: fuzzy-predict-next |2 3 5 7 11>
100 %      integer sequence: primes      pattern:     2 3 5 7 11      next-1:     13
100 %      integer sequence: primes      pattern:     2 3 5 7 11      next-2:     13 17
100 %      integer sequence: primes      pattern:     2 3 5 7 11      next-3:     13 17 19
100 %      integer sequence: primes      pattern:     2 3 5 7 11      next-4:     13 17 19 23
87.1 %      integer sequence: fibonacci      pattern:     2 3 5 8 13      next-1:     21
87.1 %      integer sequence: fibonacci      pattern:     2 3 5 8 13      next-2:     21 34
87.1 %      integer sequence: fibonacci      pattern:     2 3 5 8 13      next-3:     21 34 55
87.1 %      integer sequence: fibonacci      pattern:     2 3 5 8 13      next-4:     21 34 55 89
83.3 %      integer sequence: primes      pattern:     2 3 5 7 11 13      next-1:     17
83.3 %      integer sequence: primes      pattern:     2 3 5 7 11 13      next-2:     17 19
83.3 %      integer sequence: primes      pattern:     2 3 5 7 11 13      next-3:     17 19 23
80 %      integer sequence: primes      pattern:     2 3 5 7      next-1:     11
80 %      integer sequence: primes      pattern:     2 3 5 7      next-2:     11 13
80 %      integer sequence: primes      pattern:     2 3 5 7      next-3:     11 13 17
80 %      integer sequence: primes      pattern:     2 3 5 7      next-4:     11 13 17 19
75.1 %      integer sequence: fibonacci      pattern:     2 3 5 8      next-1:     13
75.1 %      integer sequence: fibonacci      pattern:     2 3 5 8      next-2:     13 21
75.1 %      integer sequence: fibonacci      pattern:     2 3 5 8      next-3:     13 21 34
75.1 %      integer sequence: fibonacci      pattern:     2 3 5 8      next-4:     13 21 34 55
72.6 %      integer sequence: fibonacci      pattern:     2 3 5 8 13 21      next-1:     34
72.6 %      integer sequence: fibonacci      pattern:     2 3 5 8 13 21      next-2:     34 55
72.6 %      integer sequence: fibonacci      pattern:     2 3 5 8 13 21      next-3:     34 55 89
72.6 %      integer sequence: counting      pattern:     2 3 4 5 6      next-1:     7
72.6 %      integer sequence: counting      pattern:     2 3 4 5 6      next-2:     7 8
72.6 %      integer sequence: counting      pattern:     2 3 4 5 6      next-3:     7 8 9
72.6 %      integer sequence: counting      pattern:     2 3 4 5 6      next-4:     7 8 9 10
72.4 %      integer sequence: counting      pattern:     3 4 5 6 7      next-1:     8
72.4 %      integer sequence: counting      pattern:     3 4 5 6 7      next-2:     8 9
72.4 %      integer sequence: counting      pattern:     3 4 5 6 7      next-3:     8 9 10
72.4 %      integer sequence: counting      pattern:     3 4 5 6 7      next-4:     8 9 10 11
71.4 %      integer sequence: primes      pattern:     2 3 5 7 11 13 17      next-1:     19
71.4 %      integer sequence: primes      pattern:     2 3 5 7 11 13 17      next-2:     19 23
68.3 %      integer sequence: counting      pattern:     4 5 6 7 8      next-1:     9
68.3 %      integer sequence: counting      pattern:     4 5 6 7 8      next-2:     9 10
68.3 %      integer sequence: counting      pattern:     4 5 6 7 8      next-3:     9 10 11
68.3 %      integer sequence: counting      pattern:     4 5 6 7 8      next-4:     9 10 11 12
67.1 %      integer sequence: counting      pattern:     2 3 4 5      next-1:     6
67.1 %      integer sequence: counting      pattern:     2 3 4 5      next-2:     6 7
67.1 %      integer sequence: counting      pattern:     2 3 4 5      next-3:     6 7 8
67.1 %      integer sequence: counting      pattern:     2 3 4 5      next-4:     6 7 8 9
65.2 %      integer sequence: counting      pattern:     3 4 5 6      next-1:     7
65.2 %      integer sequence: counting      pattern:     3 4 5 6      next-2:     7 8
65.2 %      integer sequence: counting      pattern:     3 4 5 6      next-3:     7 8 9
65.2 %      integer sequence: counting      pattern:     3 4 5 6      next-4:     7 8 9 10
63.3 %      integer sequence: fibonacci      pattern:     1 2 3 5 8      next-1:     13
63.3 %      integer sequence: fibonacci      pattern:     1 2 3 5 8      next-2:     13 21
63.3 %      integer sequence: fibonacci      pattern:     1 2 3 5 8      next-3:     13 21 34
63.3 %      integer sequence: fibonacci      pattern:     1 2 3 5 8      next-4:     13 21 34 55
62.5 %      integer sequence: primes      pattern:     2 3 5 7 11 13 17 19      next-1:     23
62.2 %      integer sequence: fibonacci      pattern:     2 3 5 8 13 21 34      next-1:     55
62.2 %      integer sequence: fibonacci      pattern:     2 3 5 8 13 21 34      next-2:     55 89
60.5 %      integer sequence: counting      pattern:     2 3 4 5 6 7      next-1:     8
60.5 %      integer sequence: counting      pattern:     2 3 4 5 6 7      next-2:     8 9
60.5 %      integer sequence: counting      pattern:     2 3 4 5 6 7      next-3:     8 9 10
60.4 %      integer sequence: counting      pattern:     3 4 5 6 7 8      next-1:     9
60.4 %      integer sequence: counting      pattern:     3 4 5 6 7 8      next-2:     9 10
60.4 %      integer sequence: counting      pattern:     3 4 5 6 7 8      next-3:     9 10 11
60 %      integer sequence: fibonacci      pattern:     2 3 5      next-1:     8
60 %      integer sequence: fibonacci      pattern:     2 3 5      next-2:     8 13
60 %      integer sequence: fibonacci      pattern:     2 3 5      next-3:     8 13 21
60 %      integer sequence: fibonacci      pattern:     2 3 5      next-4:     8 13 21 34
60 %      integer sequence: primes      pattern:     2 3 5      next-1:     7
60 %      integer sequence: primes      pattern:     2 3 5      next-2:     7 11
60 %      integer sequence: primes      pattern:     2 3 5      next-3:     7 11 13
60 %      integer sequence: primes      pattern:     2 3 5      next-4:     7 11 13 17
59.2 %      integer sequence: counting      pattern:     4 5 6 7      next-1:     8
59.2 %      integer sequence: counting      pattern:     4 5 6 7      next-2:     8 9
59.2 %      integer sequence: counting      pattern:     4 5 6 7      next-3:     8 9 10
59.2 %      integer sequence: counting      pattern:     4 5 6 7      next-4:     8 9 10 11
58.5 %      integer sequence: primes      pattern:     3 5 7 11 13      next-1:     17
58.5 %      integer sequence: primes      pattern:     3 5 7 11 13      next-2:     17 19
58.5 %      integer sequence: primes      pattern:     3 5 7 11 13      next-3:     17 19 23
58.5 %      integer sequence: primes      pattern:     3 5 7 11 13      next-4:     17 19 23 29
57.3 %      integer sequence: counting      pattern:     5 6 7 8 9      next-1:     10
57.3 %      integer sequence: counting      pattern:     5 6 7 8 9      next-2:     10 11
57.3 %      integer sequence: counting      pattern:     5 6 7 8 9      next-3:     10 11 12
57.3 %      integer sequence: counting      pattern:     5 6 7 8 9      next-4:     10 11 12 13
56.9 %      integer sequence: counting      pattern:     4 5 6 7 8 9      next-1:     10
56.9 %      integer sequence: counting      pattern:     4 5 6 7 8 9      next-2:     10 11
56.9 %      integer sequence: counting      pattern:     4 5 6 7 8 9      next-3:     10 11 12
55.6 %      integer sequence: counting      pattern:     1 2 3 4 5      next-1:     6
55.6 %      integer sequence: counting      pattern:     1 2 3 4 5      next-2:     6 7
55.6 %      integer sequence: counting      pattern:     1 2 3 4 5      next-3:     6 7 8
55.6 %      integer sequence: counting      pattern:     1 2 3 4 5      next-4:     6 7 8 9
55.1 %      integer sequence: counting      pattern:     2 3 4      next-1:     5
55.1 %      integer sequence: counting      pattern:     2 3 4      next-2:     5 6
55.1 %      integer sequence: counting      pattern:     2 3 4      next-3:     5 6 7
55.1 %      integer sequence: counting      pattern:     2 3 4      next-4:     5 6 7 8
54.5 %      integer sequence: fibonacci      pattern:     2 3 5 8 13 21 34 55      next-1:     89
54.2 %      integer sequence: fibonacci      pattern:     1 2 3 5      next-1:     8
54.2 %      integer sequence: fibonacci      pattern:     1 2 3 5      next-2:     8 13
54.2 %      integer sequence: fibonacci      pattern:     1 2 3 5      next-3:     8 13 21
54.2 %      integer sequence: fibonacci      pattern:     1 2 3 5      next-4:     8 13 21 34
52.8 %      integer sequence: fibonacci      pattern:     1 2 3 5 8 13      next-1:     21
52.8 %      integer sequence: fibonacci      pattern:     1 2 3 5 8 13      next-2:     21 34
52.8 %      integer sequence: fibonacci      pattern:     1 2 3 5 8 13      next-3:     21 34 55
51.8 %      integer sequence: counting      pattern:     2 3 4 5 6 7 8      next-1:     9
51.8 %      integer sequence: counting      pattern:     2 3 4 5 6 7 8      next-2:     9 10
51.7 %      integer sequence: counting      pattern:     3 4 5 6 7 8 9      next-1:     10
51.7 %      integer sequence: counting      pattern:     3 4 5 6 7 8 9      next-2:     10 11
51.3 %      integer sequence: counting      pattern:     1 2 3 4      next-1:     5
51.3 %      integer sequence: counting      pattern:     1 2 3 4      next-2:     5 6
51.3 %      integer sequence: counting      pattern:     1 2 3 4      next-3:     5 6 7
51.3 %      integer sequence: counting      pattern:     1 2 3 4      next-4:     5 6 7 8
50.7 %      integer sequence: counting      pattern:     6 7 8 9 10      next-1:     11
50.7 %      integer sequence: counting      pattern:     6 7 8 9 10      next-2:     11 12
50.7 %      integer sequence: counting      pattern:     6 7 8 9 10      next-3:     11 12 13
50.7 %      integer sequence: counting      pattern:     6 7 8 9 10      next-4:     11 12 13 14
50.1 %      integer sequence: counting      pattern:     3 4 5      next-1:     6
50.1 %      integer sequence: counting      pattern:     3 4 5      next-2:     6 7
50.1 %      integer sequence: counting      pattern:     3 4 5      next-3:     6 7 8
50.1 %      integer sequence: counting      pattern:     3 4 5      next-4:     6 7 8 9
112|results>


sa: fuzzy-predict-next |9 9 9>
83.5 %      integer sequence: counting      pattern:     8 9 10      next-1:     11
83.5 %      integer sequence: counting      pattern:     8 9 10      next-2:     11 12
83.5 %      integer sequence: counting      pattern:     8 9 10      next-3:     11 12 13
83.5 %      integer sequence: counting      pattern:     8 9 10      next-4:     11 12 13 14
78.5 %      integer sequence: counting      pattern:     7 8 9      next-1:     10
78.5 %      integer sequence: counting      pattern:     9 10 11      next-1:     12
78.5 %      integer sequence: counting      pattern:     7 8 9      next-2:     10 11
78.5 %      integer sequence: counting      pattern:     9 10 11      next-2:     12 13
78.5 %      integer sequence: counting      pattern:     7 8 9      next-3:     10 11 12
78.5 %      integer sequence: counting      pattern:     9 10 11      next-3:     12 13 14
78.5 %      integer sequence: counting      pattern:     7 8 9      next-4:     10 11 12 13
78.5 %      integer sequence: counting      pattern:     9 10 11      next-4:     12 13 14 15
62.7 %      integer sequence: counting      pattern:     8 9 10 11      next-1:     12
62.7 %      integer sequence: counting      pattern:     8 9 10 11      next-2:     12 13
62.7 %      integer sequence: counting      pattern:     8 9 10 11      next-3:     12 13 14
62.7 %      integer sequence: counting      pattern:     8 9 10 11      next-4:     12 13 14 15
60.3 %      integer sequence: counting      pattern:     6 7 8      next-1:     9
60.3 %      integer sequence: counting      pattern:     10 11 12      next-1:     13
60.3 %      integer sequence: counting      pattern:     6 7 8      next-2:     9 10
60.3 %      integer sequence: counting      pattern:     10 11 12      next-2:     13 14
60.3 %      integer sequence: counting      pattern:     6 7 8      next-3:     9 10 11
60.3 %      integer sequence: counting      pattern:     10 11 12      next-3:     13 14 15
60.3 %      integer sequence: counting      pattern:     6 7 8      next-4:     9 10 11 12
60.3 %      integer sequence: counting      pattern:     10 11 12      next-4:     13 14 15 16
58.9 %      integer sequence: counting      pattern:     7 8 9 10      next-1:     11
58.9 %      integer sequence: counting      pattern:     9 10 11 12      next-1:     13
58.9 %      integer sequence: counting      pattern:     7 8 9 10      next-2:     11 12
58.9 %      integer sequence: counting      pattern:     9 10 11 12      next-2:     13 14
58.9 %      integer sequence: counting      pattern:     7 8 9 10      next-3:     11 12 13
58.9 %      integer sequence: counting      pattern:     9 10 11 12      next-3:     13 14 15
58.9 %      integer sequence: counting      pattern:     7 8 9 10      next-4:     11 12 13 14
58.9 %      integer sequence: counting      pattern:     9 10 11 12      next-4:     13 14 15 16
58.4 %      integer sequence: counting      pattern:     8 9      next-1:     10
58.4 %      integer sequence: counting      pattern:     8 9      next-4:     10
58.4 %      integer sequence: counting      pattern:     9 10      next-1:     11
58.4 %      integer sequence: counting      pattern:     9 10      next-4:     11
58.4 %      integer sequence: counting      pattern:     8 9      next-2:     10 11
58.4 %      integer sequence: counting      pattern:     9 10      next-2:     11 12
58.4 %      integer sequence: counting      pattern:     8 9      next-3:     10 11 12
58.4 %      integer sequence: counting      pattern:     9 10      next-3:     11 12 13
58.4 %      integer sequence: counting      pattern:     8 9      next-4:     10 11 12 13
58.4 %      integer sequence: counting      pattern:     9 10      next-4:     11 12 13 14
52.3 %      integer sequence: primes      pattern:     5 7 11      next-1:     13
52.3 %      integer sequence: primes      pattern:     7 11 13      next-1:     17
52.3 %      integer sequence: primes      pattern:     5 7 11      next-2:     13 17
52.3 %      integer sequence: primes      pattern:     7 11 13      next-2:     17 19
52.3 %      integer sequence: primes      pattern:     5 7 11      next-3:     13 17 19
52.3 %      integer sequence: primes      pattern:     7 11 13      next-3:     17 19 23
52.3 %      integer sequence: primes      pattern:     5 7 11      next-4:     13 17 19 23
52.3 %      integer sequence: primes      pattern:     7 11 13      next-4:     17 19 23 29
50.1 %      integer sequence: counting      pattern:     8 9 10 11 12      next-1:     13
50.1 %      integer sequence: counting      pattern:     8 9 10 11 12      next-2:     13 14
50.1 %      integer sequence: counting      pattern:     8 9 10 11 12      next-3:     13 14 15
50.1 %      integer sequence: counting      pattern:     8 9 10 11 12      next-4:     13 14 15 16
54|results>
```

## Conclusion

The Semantic DB is an experimental language based on the idea of reducing everything to kets and operators with the hope of being a mathematical notation to describe neural circuits, or a component of the semantic web. The eventual goal of the project is to have a fast implementation (the current one is based on python 3 and the parsley parser), and numerous servers around the internet serving [semantic db files](http://semantic-db.org/sw/) (`.sw` and `.swc`) and interacting with each other adding some "understanding" to the data passed around the internet. The short term goal is to find collaboraters that are interested in the work, or help improve the project. It should be noted the above is only a summary, and there is much more of the project left undescribed.


* The code is [available under a GPLv3 license](https://github.com/GarryMorrison/Semantic-DB) at github
* [Operator usage information](http://semantic-db.org/docs/usage/)
* Feel free to contact me at: garry -at- semantic-db.org


