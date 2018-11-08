full |range> => range(|1>, |65535>)

encode |purring> => pick[10] full |range>
encode |miaowing> => pick[10] full |range>
encode |scratching at the door> => pick[10] full |range>
encode |panting> => pick[10] full |range>
encode |sniffing> => pick[10] full |range>
encode |tweeting> => pick[10] full |range>
encode |singing> => pick[10] full |range>
encode |croaking> => pick[10] full |range>
encode |howling> => pick[10] full |range>
encode |roaring> => pick[10] full |range>


sound |node: 1: 1> => encode |purring>
sound |node: 1: 2> => encode |miaowing>
sound |node: 1: 3> => encode |scratching at the door>
animal |node: 1: *> => |cat>

sound |node: 2: 1> => encode |panting>
sound |node: 2: 2> => encode |sniffing>
sound |node: 2: 3> => encode |scratching at the door>
animal |node: 2: *> => |dog>

sound |node: 3: 1> => encode |tweeting>
sound |node: 3: 2> => encode |singing>
animal |node: 3: *> => |bird>

sound |node: 4: 1> => encode |croaking>
animal |node: 4: *> => |frog>

sound |node: 5: 1> => encode |howling>
animal |node: 5: *> => |wolf>

sound |node: 6: 1> => encode |roaring>
animal |node: 6: *> => |lion>


predict-animal-from |*> #=> top[1] animal similar-input[sound] encode words-to-list |_self>

