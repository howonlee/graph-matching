import networkx as nx
import operator
import cPickle

def degrees(net):
    degree_dict = {}
    for node in net.nodes_iter():
        degree_dict[node] = net.degree(node)
    return degree_dict

def degree_neighborhoods(net, degree_dict):
    neighbor_dict = {}
    #really need a better sort of distance, I think
    #not distance measures actually
    for node in net.nodes_iter():
        neighbor_dict[node] = []
        for neigh in net.neighbors_iter(node):
            neighbor_dict[node].append(degree_dict[neigh])
        neighbor_dict[node].sort() #mutating sort
        #neighbor_dict[node] = sum(neighbor_dict[node])
    return neighbor_dict

def load_word_mapping(name, rev=True):
    mapping = {}
    with open(name, "rb") as pickle_file:
        mapping = cPickle.load(pickle_file)
    if rev:
        mapping = {v: k for k, v in mapping.iteritems()}
    return mapping

if __name__ == "__main__":
    #just different ordering problems....
    net1 = nx.read_edgelist("./first_net.edgelist")
    net2 = nx.read_edgelist("./second_net.edgelist")
    deg1 = degrees(net1)
    deg2 = degrees(net2)
    deg_neigh1 = sorted(degree_neighborhoods(net1, deg1).items(), key=operator.itemgetter(1))
    deg_neigh2 = sorted(degree_neighborhoods(net2, deg2).items(), key=operator.itemgetter(1))
    mapping_1 = load_word_mapping("first_dict.pickle")
    mapping_2 = load_word_mapping("second_dict.pickle")
    sample_1 = map(lambda x: mapping_1[int(x[0])], deg_neigh1)
    sample_2 = map(lambda x: mapping_2[int(x[0])], deg_neigh2)
    samples = zip(sample_1, sample_2)
    print samples[:100]
    #filtered_samples = filter(lambda x: x[0] == x[1], samples)
    #print filtered_samples
    #print len(filtered_samples)

