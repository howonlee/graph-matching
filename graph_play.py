### use python3
### the reason: f-- impossible to install graph-tool on anaconda
from graph_tool.all import *

if __name__ == "__main__":
    #what is the smallest step that you could take?
    g = Graph()
    v1 = g.add_vertex()
    g2 = Graph(g)
    v2 = g.add_vertex()
    e = g.add_edge(v1, v2)
    print(v1.out_degree())
    #graph_draw(g, vertex_text=g.vertex_index)
