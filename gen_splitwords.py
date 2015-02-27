from nltk.corpus import brown
first = brown.words()[580596:]
second = brown.words()[:580596]

def bigrams(ls):
    return zip(ls, ls[1:])

first_bi = bigrams(first)
print first_bi[:1000]
