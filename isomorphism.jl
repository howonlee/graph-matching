using Graphs
using Base.Collections
using Base.Test

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
  g = simple_graph(max_vnum) #work with directed graph
  for edge in edges
    add_edge!(g, edge)
  end
  g
end

function comp_degs(graph)
  #1: compute vertex degrees
end

function comp_dns(graph, degrees)
  #2: compute degree neighborhoods
end

function sort_dns()
  #3: sort vertices by degree neighborhoods in lexicographical order
end

function label_graphs()
  #4: number the vertices in sorted order
  #use a distance measure instead of automagically failing
end

