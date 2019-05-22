-- the |text> => |split on something eg. sentence, paragraph, wikipedia page.>
process-punctuation |*> #=> replace[".", " #DOT#"] replace[",", " #COMMA#"] replace["(", " #LB# "] replace[")", " #RB# "] to-lower |_self>
the |processed text> => process-punctuation the |text>
the |word frequency list> => coeff-sort split[" "] the |processed text>

freq |*> !=> mbr(|_self>, the |word frequency list>)
invert-freq |*> #=> invert freq |_self>

nfc |*> !=> apply-normed-frequency-class(|_self>, the |word frequency list>)
invert-nfc |*> #=> subtraction-invert[1.01] nfc |_self>

learn-pre (*) #=> add-learn(|op: pre>, sselect[1,1] |_self>, sselect[2,2] |_self> + 0.666 sselect[3,3] |_self> + 0.333 sselect[4,4] |_self>)
learn-post (*) #=> add-learn(|op: post>, sselect[1,1] |_self>, sselect[2,2] |_self> + 0.666 sselect[3,3] |_self> + 0.333 sselect[4,4] |_self>)

-- |null> => smap-window[learn-pre, 4] sreverse invert-freq ssplit[" "] the |processed text>
-- |null> => smap-window[learn-post, 4] invert-freq ssplit[" "] the |processed text>

-- learn-nghbr-4 (*) #=> add-learn(|op: nghbr>, sselect[1,1] |_self>, sselect[2,2] |_self> + 0.666 sselect[3,3] |_self> + 0.333 sselect[4,4] |_self>)
-- |null> => smap-window[learn-nghbr-4, 4] sreverse invert-freq ssplit[" "] the |processed text>
-- |null> => smap-window[learn-nghbr-4, 4] invert-freq ssplit[" "] the |processed text>

-- learn-nghbr-5 (*) #=> add-learn(|op: nghbr>, sselect[1,1] |_self>, sselect[2,2] |_self> + 0.75 sselect[3,3] |_self> + 0.5 sselect[4,4] |_self> + 0.25 sselect[5,5] |_self>)
-- |null> => smap-window[learn-nghbr-5, 5] sreverse invert-freq ssplit[" "] the |processed text>
-- |null> => smap-window[learn-nghbr-5, 5] invert-freq ssplit[" "] the |processed text>

learn-nghbr-4 (*) #=> add-learn(|op: nghbr>, sselect[1,1] |_self>, sselect[2,2] |_self> + 0.666 sselect[3,3] |_self> + 0.333 sselect[4,4] |_self>)
|null> => smap-window[learn-nghbr-4, 4] sreverse invert-nfc ssplit[" "] the |processed text>
|null> => smap-window[learn-nghbr-4, 4] invert-nfc ssplit[" "] the |processed text>

s |*> #=> similar-input[nghbr] nghbr |_self>
t |*> #=> table[object, coeff] select[1,30] similar-input[nghbr] nghbr |_self>

