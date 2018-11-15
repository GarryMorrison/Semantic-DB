pick-from-class |*> #=> pick-elt class |_self>
merge-class (*) #=> smerge[" "] pick-from-class |_self>

class |*> #=> |_self>
class |THE> => |the> + |his> + |their> + |my> + |our> + |this> + |her> + |its> + |your> + |a>
class |DOG> => |dog> + |cat> + |child>
class |ON> => |on> + |in> + |upon> + |by> + |over> + |from> + |under>
class |SAT> => |sat> + |stood>
class |STONE> => |stone> + |rock>

class |1> #=> merge-class (|THE> . |DOG> . |SAT> . |ON> . |THE> . |STONE> )

sentence |*> #=> to-upper[1] class |_self> _ |.>


