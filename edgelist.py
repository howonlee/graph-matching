from graph_tool.all import *

def read_edgelist(fname):
    g = Graph()
    with open(fname, "r") as edge_file:
        max_vnum = -1
        edges = edge_file.readlines()
        for line in edges:
            first, second = map(int, line.split())
            if first > max_vnum:
                max_vnum = first
            if second > max_vnum:
                max_vnum = second
        g.add_vertex(max_vnum+1)
        for line in edges:
            first, second = map(int, line.split())
            g.add_edge(g.vertex(first), g.vertex(second))
    return g

if __name__ == "__main__":
    fname = "turb.edgelist"
    g = read_edgelist(fname)
    graph_draw(g, output_size=(1000,1000), output=fname+".png")
