#from the kaggle winning graph matching folks:
#http://arxiv.org/pdf/1102.4374v1.pdf
#pseudocode copied from here, some of it:
#http://randomwalker.info/social-networks/De_anonymization.html

using Graphs
using Base.Collections
using Base.Test

const theta = 0.1

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

function in_out_deg_comparison(graph)
  ins = [in_degree(vertex, graph) for vertex in vertices(graph)]
  outs = [out_degree(vertex, graph) for vertex in vertices(graph)]
  println(hist(ins))
  println(hist(outs))
end

function cosine_sim(first, second)
  length(intersect(first, second)) / sqrt(length(first) * length(second))
end

function cosine_sim_test()
  cos_test_1 = [1,2,3,4,5,6,7,8,9]
  cos_test_2 = [4,5,6,7,8,9,10,11,12]
  #this should come out 2/3
  println(cos_test_1)
  println(cos_test_2)
  println(cosine_sim(cos_test_1, cos_test_2))
end

function weight_matrix(graph)
  #caveat: requires ergodic mat
  mat = zeros(num_vertices(graph), num_vertices(graph))
  for node1 in vertices(graph)
    for node2 in vertices(graph)
      mat[node1, node2] = cosine_sim(in_neighbors(node1, graph), in_neighbors(node2, graph))
    end
  end
  mat
end

function weight_matrix_test()
  test_graph = simple_graph(4)
  #seems pretty much the case that this requires ergodic mat
  add_edge!(test_graph, Edge{Int}(0,1,2))
  add_edge!(test_graph, Edge{Int}(0,2,3))
  add_edge!(test_graph, Edge{Int}(0,3,4))
  add_edge!(test_graph, Edge{Int}(0,1,4))
  add_edge!(test_graph, Edge{Int}(0,1,3))
  add_edge!(test_graph, Edge{Int}(0,4,1))
  cos_mat = weight_matrix(test_graph)
  true_mat = [
    [1,0,0,0],
    [0,1,0.7071067811865475,0.7071067811865475],
    [0,0.7071067811865475,1,0.5],
    [0,0.7071067811865475,0.5,1]
    ]
  println(cos_mat)
  @test_approx_eq cos_mat true_mat
end

function inverse_mapping(mapping)
  inverted = Dict()
  for (key, val) in mapping
    inverted[val] = key
  end
  inverted
end

function propagation_step(lgraph, rgraph, mapping)
  scores = (Int => Array{Float64})[]
  #is all of this computation necessary?
  for lnode in vertices(lgraph)
    scores[lnode] = match_scores(lgraph, rgraph, mapping, lnode)
    #if eccentricity(scores[lnode]) < theta
    #  continue
    #end
    rnode = indmax(scores[lnode])
    inv_map = inverse_mapping(mapping)
    scores[rnode] = match_scores(rgraph, lgraph, inv_map, rnode)
    #if eccentricity(scores[rnode]) < theta
    #  continue
    #end
    reverse_match = indmax(scores[rnode])
    if reverse_match != lnode
      continue
    end
    mapping[lnode] = rnode
  end
  mapping
end

function get_seed_map(rgraph, lgraph)
  mapping = {highdeg_nodes(rgraph, 1)[1] => highdeg_nodes(lgraph, 1)[1]}
end

function propagation_step_test()
  lgraph = make_lgraph()
  rgraph = make_rgraph()
  mapping = get_seed_map(rgraph, lgraph)
  for _ in 1:100
    mapping = propagation_step(lgraph, rgraph, mapping)
  end
  println(mapping)
end

function match_scores(lgraph, rgraph, mapping, lnode)
  #caching the scores??
  scores = zeros(num_vertices(rgraph))
  inv_map = inverse_mapping(mapping)
  for ledge in edges(lgraph)
    lnbr = source(ledge, lgraph)
    lnode = target(ledge, lgraph)
    if !haskey(mapping, lnbr)
      continue
    end
    rnbr = mapping[lnbr]
    for redge in edges(rgraph)
      rnbr = source(redge, rgraph)
      rnode = target(redge, rgraph)
      if haskey(inv_map, rnode)
        continue
      end
      scores[rnode] += 1.0 / ((in_degree(rnode, rgraph) ^ 0.5) + 0.01)
      #scores[rnode] += 1.0 / ((out_degree(rnode, rgraph) ^ 0.5) + 0.01)
    end
  end
  scores
end

function make_lgraph()
  lgraph = simple_graph(5, is_directed=true)
  add_edge!(lgraph, 1, 2)
  add_edge!(lgraph, 1, 3)
  add_edge!(lgraph, 1, 4)
  add_edge!(lgraph, 1, 5)
  add_edge!(lgraph, 2, 3)
  add_edge!(lgraph, 2, 4)
  add_edge!(lgraph, 2, 5)
  add_edge!(lgraph, 3, 4)
  add_edge!(lgraph, 3, 5)
  add_edge!(lgraph, 4, 5)
  lgraph
end

function make_rgraph()
  rgraph = simple_graph(5, is_directed=true)
  add_edge!(rgraph, 5, 1)
  add_edge!(rgraph, 5, 2)
  add_edge!(rgraph, 5, 3)
  add_edge!(rgraph, 5, 4)
  add_edge!(rgraph, 4, 1)
  add_edge!(rgraph, 4, 2)
  add_edge!(rgraph, 4, 3)
  add_edge!(rgraph, 3, 1)
  add_edge!(rgraph, 3, 2)
  add_edge!(rgraph, 2, 1)
  rgraph
end

function match_scores_test()
  #mapping should be 1=>5, 2=>4, etc
  lgraph = make_lgraph()
  rgraph = make_rgraph()
  mapping = get_seed_map(rgraph, lgraph)
  scores = match_scores(lgraph, rgraph, mapping, 1)
  println(scores)
  #@assert match_scores == something_else
end

function eccentricity(items)
  curr_max = 0
  curr_max2 = 0
  for item in items
    if item > curr_max
      curr_max2 = curr_max
      curr_max = item
    elseif item > curr_max2 && item < curr_max - 0.001
      curr_max2 = item
    end
  end
  #use select!
  return (curr_max - curr_max2) / std(items)
end

function propagation(tgt_g, aux_g, seed_map, num_iters=100)
  println("propagation beginning...")
  curr_map = seed_map
  for i in 1:num_iters
    curr_map = propagation_step(tgt_g, aux_g, curr_map) #must mutate seed_map
    println(i)
  end
  curr_map
end

function test()
  #match_scores_test()
  propagation_step_test()
end

#test()

turb_g = read_edgelist("turb.edgelist")
word_g = read_edgelist("words.edgelist")
#need different graphs I think
#g_1 = read_edgelist("gen_graph1")
#g_2 = read_edgelist("gen_graph2")
println(propagation(turb_g, word_g, get_seed_map(turb_g, word_g)))
