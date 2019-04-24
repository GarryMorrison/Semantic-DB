-- first define your text body:
-- the |text> => |Some big collection of text ....>

-- create a list of word frequencies, 2-grams and the top 2000 words:
the |words> => coeff-sort word-ngrams[1] the |text>
the |2 grams> => coeff-sort word-ngrams[2] the |text>
the-top-2000 |words> => select[1,2000] the |words>

-- define our learn-pre and learn-post operators:
learn-pre |*> #=> add-learn(|op: pre>, sselect[2,2] ssplit[" "] |_self>, sselect[1,1] ssplit[" "] |_self>)
learn-post |*> #=> add-learn(|op: post>, sselect[1,1] ssplit[" "] |_self>, sselect[2,2] ssplit[" "] |_self>)

-- now learn them with respect to our 2-grams:
|null> => drop tidy learn-pre the |2 grams>
|null> => drop tidy learn-post the |2 grams>

-- next define our pre, post and intn class operators:
pre-class-op |*> #=> clean select[1,10] similar-input[pre] pre |_self>
post-class-op |*> #=> clean select[1,10] similar-input[post] post |_self>
intn-class-op |*> #=> intersection(pre-class |_self>, post-class |_self>)

-- now learn them with respect to our top 2000 words:
|null> => map[pre-class-op, pre-class] the-top-2000 |words>
|null> => map[post-class-op, post-class] the-top-2000 |words>
|null> => map[intn-class-op, intn-class] the-top-2000 |words>

-- next, define our distinctive pre, post operators:
distinctive-pre-op |*> #=> normalize drop (normalize pre - normalize pre intn-class) |_self>
distinctive-post-op |*> #=> normalize drop (normalize post - normalize post intn-class) |_self>

-- now learn them:
|null> => map[distinctive-pre-op, distinctive-pre] the-top-2000 |words>
|null> => map[distinctive-post-op, distinctive-post] the-top-2000 |words>

