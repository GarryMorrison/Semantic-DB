pick-class |*> #=> spick-elt class |_self>
merge-class (*) #=> smerge[" "] sdrop pick-class |_self>

class |A> => |the>
class |B> => |young> . |>
class |C> => |girl> . |boy>
class |D> => |old> . |other> . |>
class |E> => |man> . |woman> . |lady>
class |F> => |saw>
class |G> => |through the>
class |H> => |telescope> . |binoculars> . |night vision goggles>

class |K> #=> merge-class (|B> . |C>) . merge-class (|D> . |E>)
class |M> #=> merge-class (|A> . |K>) . |>
class |N> #=> merge-class (|A> . |K> . |F> . |M> . |G> . |H>)

sentence |*> #=> to-upper[1] class |_self> _ |.>


