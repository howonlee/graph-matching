using Graphs

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

function highdeg_nodes(graph)
  res = Int64[]
  for vertex in vertices(graph)
    deg = in_degree(vertex, graph)
    if deg > 250
      push!(res, vertex)
    end
  end
  res
end

function eo()
  nothing
  #funky version of the extremal optimization algorithm
end

function propagation_step(graph, eo_matching)
  prop = [] #do the propagation step
end

g = read_edgelist("turb.edgelist")
#show(highdeg_nodes(g))
println(length(highdeg_nodes(g)))
