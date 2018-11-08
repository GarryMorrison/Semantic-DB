sounds |node: 1: 1> => |purring> + |miaowing> + |scratching at the door>
sound |node: 1: 1> => |purring>
sound |node: 1: 2> => |miaowing>
sound |node: 1: 3> => |scratching at the door>
animal |node: 1: *> => |cat>

sounds |node: 2: 1> => |panting> + |sniffing> + |scratching at the door>
sound |node: 2: 1> => |panting>
sound |node: 2: 2> => |sniffing>
sound |node: 2: 3> => |scratching at the door>
animal |node: 2: *> => |dog>

sound |node: 3: 1> => |tweeting>
sound |node: 3: 2> => |singing>
animal |node: 3: *> => |bird>

sound |node: 4: 1> => |croaking>
animal |node: 4: *> => |frog>

sound |node: 5: 1> => |howling>
sound |node: 5: 2> => |growling>
animal |node: 5: *> => |wolf>

sound |node: 6: 1> => |roaring>
animal |node: 6: *> => |lion>


inhibitory-animal |*> #=> 2 animal clean |_self> - animal rel-kets[animal] |>
-- inhibitory-animal |*> #=> animal (2 clean |_self> - rel-kets[animal] |> )


predict-from |*> #=> similar-input[sounds] words-to-list |_self>
predict |*> #=> similar-input[sound] words-to-list |_self>
predict-animal-from |*> #=> top[1] animal similar-input[sound] words-to-list |_self>
predict-inhibitory |*> #=> inhibitory-animal similar-input[sound] words-to-list |_self>
predict-inhibitory-from |*> #=> drop-below[0] inhibitory-animal similar-input[sound] words-to-list |_self>
predict-clean |*> #=> clean drop-below[0] inhibitory-animal similar-input[sound] words-to-list |_self>

-- this one works the best:
-- the inhibitory idea using rel-kets doesn't work as well as hoped,
-- at least for this toy example
-- though top[k] is a form of inhibition too.
predict-animal-from |*> #=> top[1] animal similar-input[sound] words-to-list |_self>

