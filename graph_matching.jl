#from the kaggle winning graph matching folks
#http://arxiv.org/pdf/1102.4374v1.pdf
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
  g = simple_graph(max_vnum) #work with directed graph
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

function cosine_sim(first, second)
  #works on set, array, intset
  length(intersect(first, second)) / sqrt(length(first) * length(second))
end

function sa(iterations=10000, keep_best=true)
  #SA just for the graph matching problem
  function log_temp(i)
    1 / log(i)
  end

  function neighbor(state)
    nothing
  end

  function cost(state)
    nothing
  end

  s0 = 0 #something
end
  
function propagation_step(lgraph, rgraph, map)
  for lnode in lgraph.nodes
    scores[lnode] = matchScores(lgraph, rgraph, mapping, lnode)
    if eccentricity(scores[lnode]) < theta
      continue
    end
    rnode = (pick node from rgraph.nodes where 
    scores[lnode][node] = max(scores[lnode]))

    scores[rnode] = matchScores(rgraph, lgraph, invert(mapping), rnode)
    if eccentricity(scores[rnode]) < theta
      continue
    end
    reverse_match = (pick node from lgraph.nodes where 
    scores[rnode][node] = max(scores[rnode]))
    if reverse_match != lnode
      continue
    end

    mapping[lnode] = rnode
  end
end

function matchScores(lgraph, rgraph, mapping, lnode)
  initialize scores = [0 for rnode in rgraph.nodes]
  for (lnbr, lnode) in lgraph.edges
    if lnbr not in mapping
      continue
    end
    rnbr = mapping[lnbr]
    for (rnbr, rnode) in rgraph.edges
      if rnode in mapping.image
        continue
      end
      scores[rnode] += 1 / rnode.in_degree ^ 0.5
    end
  end

  for (lnode, lnbr) in lgraph.edges
    if lnbr not in mapping
      continue
    end
    rnbr = mapping[lnbr]
    for (rnode, rnbr) in rgraph.edges
      if rnode in mapping.image
        continue
      end
      scores[rnode] += 1 / rnode.out_degree ^ 0.5
    end
  end

  scores
end
  
function eccentricity(items)
  ((max(items) - max2(items)) / std_dev(items))
end

function propagation(tgt_g, aux_g, seed_map, num_iters=10000)
  for i in 1:num_iters
    propagation_step(tgt_g, aux_g, seed_map) #must mutate seed_map
  end
  seed_map
end

turb_g = read_edgelist("turb.edgelist")
word_g = read_edgelist("words.edgelist")
show(highdeg_nodes(turb_g))
println()
println()
show(highdeg_nodes(word_g))
