-- encode our states using simple random encoder:
full |range> => range(|1>, |65535>)
encode |A> => pick[10] full |range>
encode |B> => pick[10] full |range>
encode |C> => pick[10] full |range>
encode |D> => pick[10] full |range>
encode |E> => pick[10] full |range>
encode |F> => pick[10] full |range>
encode |G> => pick[10] full |range>
encode |H> => pick[10] full |range>
encode |I> => pick[10] full |range>
encode |J> => pick[10] full |range>
encode |K1> => pick[10] full |range>
encode |K2> => pick[10] full |range>
encode |K3> => pick[10] full |range>
encode |K> => pick[10] full |range>


-- if (A and B) then C
pattern |node: 1: 1> => encode (|A> + |B>)
then |node: 1: *> => |C>

-- if (A or B) then D
pattern |node: 2: 1> => encode |A>
pattern |node: 2: 2> => encode |B>
then |node: 2: *> => |D>

-- if (C and D) then E
pattern |node: 7: 1> => encode (|C> + |D>)
then |node: 7: *> => |E>

if-then |*> #=> then similar-input[pattern] encode words-to-list |_self>
-- if-then-2 |*> #=> then similar-input[pattern] encode then similar-input[pattern] encode words-to-list |_self>
if-then-2 |*> #=> (then similar-input[pattern] encode)^2 words-to-list |_self>

|null> => table[input, if-then, if-then-2] (|A> + |B> + |A and B>)


-- if ((E and F) or (G and H and I) or J) then K
pattern |node: 3: 1> => encode (|E> + |F>)
then |node: 3: *> => |K1>

pattern |node: 4: 1> => encode (|G> + |H> + |I>)
then |node: 4: *> => |K2>

pattern |node: 5: 1> => encode |J>
then |node: 5: *> => |K3>

pattern |node: 6: 1> => encode |K1>
pattern |node: 6: 2> => encode |K2>
pattern |node: 6: 3> => encode |K3>
then |node: 6: *> => |K>

|null> => table[input, if-then, if-then-2] (|E> + |F> + |G> + |H> + |I> + |J> + |G and H> + |G and I> + |H and I> + |E and F> + |G, H and I>)


