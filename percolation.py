import networkx as nx
import operator

if __name__ == "__main__":
    net = nx.read_edgelist("words.edgelist")
    print type(net)
    print "number nodes in total wordlist: "
    print net.number_of_nodes()
    print "finished reading edge list"
    top_node = sorted(net.degree_iter(), key=operator.itemgetter(1), reverse=True)[0]
    node_set = set()
    for edge in nx.bfs_edges(net, top_node[0]):
        if edge[0] not in node_set:
            node_set.add(edge[0])
        if edge[1] not in node_set:
            node_set.add(edge[1])
    print "number nodes in percolation: "
    print len(node_set)
