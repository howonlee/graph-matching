import networkx as nx
import numpy as np
import matplotlib.pyplot as plt

if __name__ == "__main__":
    net1 = nx.read_edgelist("./gen_graph1")
    net2 = nx.read_edgelist("./gen_graph2")
    plt.matshow(nx.to_numpy_matrix(net1))
    plt.title("1")
    plt.matshow(nx.to_numpy_matrix(net2))
    plt.title("2")
    plt.show()
