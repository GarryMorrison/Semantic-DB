-- first load some text:
-- the |text> => |Just some text for processing ...>

-- learn some word ngrams:
the |3 grams> => coeff-sort word-ngrams[3] the |text>
the |4 grams> => coeff-sort word-ngrams[4] the |text>
the |5 grams> => coeff-sort word-ngrams[5] the |text>

-- define the 3-gram version of the ngram-to-template operator:
ngram-to-template |*> #=> sselect[1,1] ssplit[" "] |_self> . |*> . sselect[3,3] ssplit[" "] |_self>

-- define the learn-template operator:
learn-template |*> #=> learn(|op: template>, smerge[" "] ngram-to-template |_self>, ngram-to-template |_self>)

-- define our learn-class operator:
learn-class |*> #=> add-learn(|op: class>, smerge[" "] ngram-to-template |_self>, smerge[" "] subseqn-extract(ngram-to-template |_self>, ssplit[" "] |_self>))

-- learn our 3-gram classes:
|null> => drop tidy learn-class the |3 grams>


-- define the 4-gram version of our ngram-to-template operator:
ngram-to-template |*> #=> sselect[1,1] ssplit[" "] |_self> . |*> . sselect[4,4] ssplit[" "] |_self>

-- learn our 4-gram classes:
|null> => drop tidy learn-class the |4 grams>


-- define the 5-gram version of our ngram-to-template operator:
ngram-to-template |*> #=> sselect[1,1] ssplit[" "] |_self> . |*> . sselect[5,5] ssplit[" "] |_self>

-- learn our 5-gram classes:
|null> => drop tidy learn-class the |5 grams>

