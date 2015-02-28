import igraph as ig

if __name__ == "__main__":
    g = ig.Graph()
    g.add_vertices(65)
    with open("./gen_graph1", "r") as g1_file:
        for line in g1_file:
            first, second = map(int, line.split())
            g.add_edges([(first, second)])
    print "start..."
    ig.plot(g, "g1_plot.pdf", layout=g.layout_lgl())
    print "end..."
