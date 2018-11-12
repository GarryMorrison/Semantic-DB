-- if (A and B) then C
pattern |node: 1: 1> => |A> + |B>
then |node: 1: *> => |C>

-- if (A or B) then D
pattern |node: 2: 1> => |A>
pattern |node: 2: 2> => |B>
then |node: 2: *> => |D>

-- if (C and D) then E
pattern |node: 7: 1> => |C> + |D>
then |node: 7: *> => |E>

if-then |*> #=> then similar-input[pattern] words-to-list |_self>
-- if-then-2 |*> #=> then similar-input[pattern] then similar-input[pattern] words-to-list |_self>
if-then-2 |*> #=> (then similar-input[pattern])^2 words-to-list |_self>

|null> => print |>
|null> => print |if (A and B) then C>
|null> => print |if (A or B) then D>
|null> => print |if (C and D) then E>
|null> => table[input, if-then, if-then-2] (|A> + |B> + |A and B>)


-- if ((E and F) or (G and H and I) or J) then K
pattern |node: 3: 1> => |E> + |F>
then |node: 3: *> => |K1>

pattern |node: 4: 1> => |G> + |H> + |I>
then |node: 4: *> => |K2>

pattern |node: 5: 1> => |J>
then |node: 5: *> => |K3>

pattern |node: 6: 1> => |K1>
pattern |node: 6: 2> => |K2>
pattern |node: 6: 3> => |K3>
then |node: 6: *> => |K>

|null> => print |if ((E and F) or (G and H and I) or J) then K>
|null> => table[input, if-then, if-then-2] (|E> + |F> + |G> + |H> + |I> + |J> + |G and H> + |G and I> + |H and I> + |E and F> + |G, H and I>)


