 |context> => |context: half siblings>

daughter |tom> => |emma> + |erica> + |sally>

daughter |trude> => |erica> + |sally>
son |trude> => |robert>

daughter |liz> => |emma>

son |richard> => |robert>

mother |emma> => |liz>
father |emma> => |tom>

mother |erica> => |trude>
father |erica> => |tom>

mother |sally> => |trude>
father |sally> => |tom>

father |robert> => |richard>
mother |robert> => |trude>

half-brother |*> #=> drop son (mother - father) |_self> + drop son (father - mother) |_self>
half-sister |*> #=> drop daughter (mother - father) |_self> + drop daughter (father - mother) |_self>

|null> => table[child, half-brother, half-sister] split |emma erica sally robert>

