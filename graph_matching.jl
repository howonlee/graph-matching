using Graphs
using Base.Collections

function read_edgelist(fname)
  max_vnum = -1
  function cmp_vnum(str)
    num = parseint(str)
    num > max_vnum ? max_vnum = num : nothing
    nothing
  end
  edges = Edge{Int}[]
  i = 0
  open(fname) do file
    for line in eachline(file)
      i += 1
      first, second = split(line)
      cmp_vnum(first)
      cmp_vnum(second)
      edges = push!(edges, Edge{Int}(i, parseint(first), parseint(second)))
    end
  end
  g = simple_graph(max_vnum, is_directed=false)
  for edge in edges
    add_edge!(g, edge)
  end
  g
end

function highdeg_nodes(graph, num_vertices=50)
  res = PriorityQueue{Int64, Int64}(Base.Order.Reverse)
  for vertex in vertices(graph)
    deg = in_degree(vertex, graph)
    enqueue!(res, vertex, deg)
  end
  [dequeue!(res) for i=1:num_vertices]
end

function eo()
  nothing
  #funky version of the extremal optimization algorithm
end

function propagation(graph, eo_matching)
  prop = [] #do the propagation step
end

turb_g = read_edgelist("turb.edgelist")
word_g = read_edgelist("words.edgelist")
show(highdeg_nodes(turb_g))
println()
println()
show(highdeg_nodes(word_g))
