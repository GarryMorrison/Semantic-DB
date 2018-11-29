-- first load a dictionary, eg:
-- http://semantic-db.org/sw-examples/small-english-dictionary.sw
-- http://semantic-db.org/sw-examples/moby-dictionary.sw

-- now make letter ngrams of our words:
make-letter-ngrams |*> #=> letter-ngrams[1,2,3] |_self>
|null> => map[make-letter-ngrams, ngrams] rel-kets[spelling] |>

-- now define our spell-check operator:
spell-check |*> #=> select[1,10] similar-input[ngrams] make-letter-ngrams |_self>

