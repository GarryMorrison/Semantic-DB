-- first load a dictionary, eg:
-- web-load http://semantic-db.org/sw-examples/small-english-dictionary.sw
-- web-load http://semantic-db.org/sw-examples/moby-dictionary.sw

-- first version:
-- now make letter ngrams of our words:
-- make-letter-ngrams |*> #=> letter-ngrams[1,2,3] |_self>
-- |null> => map[make-letter-ngrams, ngrams] rel-kets[spelling] |>
--
-- now define our spell-check operator:
-- spell-check |*> #=> select[1,10] similar-input[ngrams] make-letter-ngrams |_self>


-- improved version:
-- define the required operators:
seq2sp-op (*) #=> seq2sp |_self>
spelling-encoder |*> #=> smap(|op: seq2sp-op>, |1>, |3>) ssplit |_self>
spell-check |*> #=> select[1,10] similar-input[encoded-spelling] spelling-encoder |_self>

-- learn the encoded spelling patterns:
|null> => print
|null> => print |Learning how to spell ... >
|null> => print (|Processing> __ extract-value to-comma-number how-many rel-kets[spelling] |> __ |words>)
|null> => map[spelling-encoder, encoded-spelling] rel-kets[spelling] |>
|null> => print |Finished.>
|null> => print


print-usage |*> #=>
    print
    print |Usage:>
    print |  The spell check operator:>
    print |    bar-chart[10] spell-check ket(hierarchy)>
    print |    bar-chart[10] spell-check ket(recieve)>
    print
    print |  Make sure you have a dictionary loaded in memory before you load this file.>
    print |  eg:>
    print |    web-load http://semantic-db.org/sw-examples/small-english-dictionary.sw>
    print |    web-load http://semantic-db.org/sw-examples/moby-dictionary.sw>
    print

|null> => print-usage |>
