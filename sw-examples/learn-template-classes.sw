-- first load some text:
-- the |text> => |Just some text for processing ...>

--- split the text into sentence fragments:
the |split text> => split[", "] split[". "] the |text>

-- learn some word ngrams:
|null> => print |creating 3 grams ...>
the |3 grams> => coeff-sort word-ngrams[3] the |split text>

|null> => print |creating 4 grams ...>
the |4 grams> => coeff-sort word-ngrams[4] the |split text>

|null> => print |creating 5 grams ...>
the |5 grams> => coeff-sort word-ngrams[5] the |split text>

|null> => print |creating 6 grams ...>
the |6 grams> => coeff-sort word-ngrams[6] the |split text>

-- define the ngram-to-template operator:
ngram-to-template |*> #=> sselect[1,1] ssplit[" "] |_self> . |*> . sselect[1,1] sreverse ssplit[" "] |_self>

-- define the learn-template operator:
learn-template |*> #=> learn(|op: template>, smerge[" "] ngram-to-template |_self>, ngram-to-template |_self>)

-- define our learn-class operator:
learn-class |*> #=> add-learn(|op: class>, smerge[" "] ngram-to-template |_self>, smerge[" "] subseqn-extract(ngram-to-template |_self>, ssplit[" "] |_self>))

-- learn our 3-gram classes:
|null> => print |starting work on 3 grams ...>
|null> => drop tidy learn-class the |3 grams>

-- learn our 4-gram classes:
|null> => print |starting work on 4 grams ...>
|null> => drop tidy learn-class the |4 grams>

-- learn our 5-gram classes:
|null> => print |starting work on 5 grams ...>
|null> => drop tidy learn-class the |5 grams>

-- learn our 6-gram classes:
|null> => print |starting work on 6 grams ...>
|null> => drop tidy learn-class the |6 grams>


-- define an interesting class to be one with more than k kets in the class:
is-interesting-class-1 |*> #=> is-greater-than[1] how-many class |_self>
is-interesting-class-2 |*> #=> is-greater-than[2] how-many class |_self>
is-interesting-class-3 |*> #=> is-greater-than[3] how-many class |_self>
is-interesting-class-4 |*> #=> is-greater-than[4] how-many class |_self>
is-interesting-class-5 |*> #=> is-greater-than[5] how-many class |_self>
