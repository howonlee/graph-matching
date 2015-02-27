import numpy as np
import numpy.random as npr
import numpy.linalg as npl
import scipy.sparse as sci_sp
import scipy.stats as sci_st
import matplotlib.pyplot as plt
import matplotlib.cm as cm
import networkx as nx
from nltk.corpus import brown
import collections
import operator
import cPickle
import random

def word_mapping(words):
    curr_count = 0
    state_map = {}
    for word in words:
        if word not in state_map:
            state_map[word] = curr_count
            curr_count += 1
    return state_map

def get_bigrams(ls):
    return zip(ls, ls[1:])

def save_word_mapping(mapping, name):
    with open(name, "w") as map_file:
        cPickle.dump(mapping, map_file)
    print "dumped to : ", name

def word_graph(words, mapping, name):
    #store the word graph
    pass

def store_word_graph(net):
    pass

if __name__ == "__main__":
    brown_words = brown.words()
    print len(brown_words), " words"
    bigrams = get_bigrams(brown_words)
    word_dict = word_mapping(brown_words)
    #print sorted(word_dict.items(), key=operator.itemgetter(1))[:1000]
