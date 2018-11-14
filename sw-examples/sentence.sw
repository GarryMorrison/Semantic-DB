class |A> => |the>
class |B> => |young> . |>
class |C> => |girl> . |boy>
class |D> => |old> . |other> . |>
class |E> => |man> . |woman> . |lady>
class |F> => |saw>
class |G> => |through the>
class |H> => |telescope> . |binoculars> . |night vision goggles>

pick-class |*> #=> spick-elt class |_self>

merged-class |I> #=> smerge[" "] sdrop pick-class (|B> . |C>)
merged-class |J> #=> smerge[" "] sdrop pick-class (|D> . |E>)

class |K> #=> merged-class (|I> . |J>)

merged-class |L> #=> smerge[" "] sdrop pick-class (|A> . |K>)

class |M> #=> merged-class |L> . |>

merged-class |N> #=> smerge[" "] sdrop pick-class (|A> . |K> . |F> . |M> . |G> . |H>)

sentence |*> #=> to-upper[1] merged-class |_self> _ |.>


