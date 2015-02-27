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
    print "word mapping dumped to : ", name

def word_net(words, mapping):
    bigs = get_bigrams(words)
    edge_list = map(lambda x: (mapping[x[0]], mapping[x[1]]), bigs)
    net = nx.Graph()
    for edge in edge_list:
        net.add_edge(*edge)
    return net

def save_word_net(net, name):
    nx.write_edgelist(net, name, data=False)
    print "word graph saved to : ", name

if __name__ == "__main__":
    brown_words = brown.words()
    brown_length = len(brown_words) // 2
    first, second = brown_words[brown_length:], brown_words[:brown_length]
    first_dict = word_mapping(first)
    first_net = word_net(first, first_dict)
    second_dict = word_mapping(second)
    second_net = word_net(second, second_dict)
    print "generated. saving...."

    save_word_mapping(first_dict, "first_dict.pickle")
    save_word_net(first_net, "first_net.edgelist")

    save_word_mapping(second_dict, "second_dict.pickle")
    save_word_net(second_net, "second_net.edgelist")
