import networkx as nx
import matplotlib.pyplot as plt

if __name__ == "__main__":
    net1 = nx.read_edgelist("./gen_graph1")
    net2 = nx.read_edgelist("./gen_graph2")
    plt.figure()
    plt.subplot(211)
    nx.draw(net1)
    plt.subplot(212)
    nx.draw(net2)
    plt.show()
