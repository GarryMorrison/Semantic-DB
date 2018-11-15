-- first, before you load this file, you need to load:
-- child-book-intersection-classes.sw or similar

class |*> #=> |_self>
pick-from-class |*> #=> pick-elt class |_self>
merge-class (*) #=> smerge pick-from-class |_self>

sentence |1> #=> to-upper[1] merge-class (|THE> . | > . |DOG> . | > . |SAT> . | > . |ON> . | > . |THE> . | > . |STONE> . |.>)
sentence |2> #=> to-upper[1] merge-class (|IT> . | > . |WAS> . | > . |THE> . | > . |START> . | > . |OF> . | > . |A> . | > . |GRAND> . | > . |DAY> . |.>)

