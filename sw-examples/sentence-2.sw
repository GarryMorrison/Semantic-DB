merge-class (*) #=> smerge[" "] sdrop pick-elt class |_self>

class |A> => |the>
class |B> => 0|null> + |young> . |girl> + |boy>
class |D> => 0|null> + |old> + |other> . |man> + |woman> + |lady>
class |F> => |saw>
class |G> => |through the>
class |H> => |telescope> + |binoculars> + |night vision goggles>

class |K> #=> merge-class |B> + merge-class |D>
class |M> #=> 0|null> + merge-class (|A> . |K>)
class |N> #=> merge-class (|A> . |K> . |F> . |M> . |G> . |H>)

sentence |*> #=> to-upper[1] class |_self> _ |.>


