from graph_tool.all import *

def read_edgelist(fname):
    g = Graph()
    max_vnum = -1
    with open(fname, "r") as edge_file:
        for line in edge_file:
            first, second = map(int, line.split())
            if first > max_vnum:
                max_vnum = first
            if second > max_vnum:
                max_vnum = second
    g.add_vertex(max_vnum+1)
    with open(fname, "r") as edge_file:
        idx = 0
        for line in edge_file:
            idx += 1
            if idx % 100000 == 0:
                print("idx: " + str(idx))
            first, second = map(int, line.split())
            g.add_edge(g.vertex(first), g.vertex(second))
    print("loaded " + fname)
    return g

if __name__ == "__main__":
    fname = "turb.edgelist"
    g = read_edgelist(fname)
