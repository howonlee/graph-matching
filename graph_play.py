### use python3
### the reason: f-- impossible to install graph-tool on anaconda
from graph_tool.all import *

if __name__ == "__main__":
    g = Graph()
    v1 = g.add_vertex()
    g2 = Graph(g)
    v2 = g.add_vertex()
    graph_draw(g2)
