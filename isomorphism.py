import networkx as nx
import operator

def degrees(net):
    degree_dict = {}
    for node in net.nodes_iter():
        degree_dict[node] = net.degree(node)
    return degree_dict

def degree_neighborhoods(net, degree_dict):
    neighbor_dict = {}
    for node in net.nodes_iter():
        neighbor_dict[node] = []
        for neigh in net.neighbors_iter(node):
            neighbor_dict[node].append(degree_dict[neigh])
        neighbor_dict[node].sort() #mutating sort
        #neighbor_dict[node] = ",".join(map(str, neighbor_dict[node]))
    return neighbor_dict

def lexicographical_form(neighbor_list):
    #specific goal exists for this one.
    #we want that if two nodes are in the same position in the listing
    #they should be a close match
    #and then a distance measure should be put forth
    #we considered carefully a cosine distance or something
    pass

if __name__ == "__main__":
    net1 = nx.read_edgelist("./gen_graph1")
    net2 = nx.read_edgelist("./gen_graph2")
    deg1 = degrees(net1)
    deg2 = degrees(net2)
    deg_neigh1 = sorted(degree_neighborhoods(net1, deg1).items(), key=operator.itemgetter(1))
    deg_neigh2 = sorted(degree_neighborhoods(net2, deg2).items(), key=operator.itemgetter(1))
    print deg_neigh1
