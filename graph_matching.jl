#from the kaggle winning graph matching folks:
#http://arxiv.org/pdf/1102.4374v1.pdf
#pseudocode copied from here, some of it:
#http://randomwalker.info/social-networks/De_anonymization.html

using Graphs
using Base.Collections
using Base.Test

const theta = 0.5

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
  
function sa_neighbor(state)
  ds = copy(state)
  skeys = collect(keys(ds))
  idx1 = rand(1:length(skeys))
  idx2 = rand(1:length(skeys))
  while idx1 == idx2
    idx2 = rand(1:length(skeys))
  end
  temp = ds[skeys[idx1]]
  ds[skeys[idx1]] = ds[skeys[idx2]]
  ds[skeys[idx2]] = temp
  return ds
end

function sa_neighbor_test()
  nodes1 = [1,2,3,4,5,6,7]
  nodes2 = ["a","b","c","d","e","f","g"]
  mapping = Dict(nodes1, nodes2)
  println(mapping)
  neighbor = sa_neighbor(mapping)
  println(neighbor)
end

function pair_dist(x, y)
  r = x > y ? (x / y) : (y / x)
  sqrt(r - 1)
end

function pair_dist_test()
  println("0.5, 10: ")
  println(pair_dist(0.5, 10))
  println("5, 0.1: ")
  println(pair_dist(5, 0.1))
end

function sa_cost(state) #this has more than this
  g1_weights = []
  g2_weights = []
  for (node1, node2) in state
    nothing
    #weight = get that cosine distance
  end
  g1_mean = mean(g1_weights)
  g2_mean = mean(g2_weights)
  ((g1_mean * g2_mean) ^ 0.25) * sum([0])
  #### not sum([0]), but sum(something)
end

function sa_cost_test() #make the graphs here...
  graph1 = something
  graph2 = something
  nodes1 = something #with dummy node included I think
  nodes2 = something #with dummy node included I think
  state = Dict(1:8, 2:9)
  cost = sa_cost(state)
  println(cost)
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

function sa(g1, g2, iterations=10000, num_nodes=50, keep_best=true)
  #this should be symmetric
  temp_fn = t -> (1 / t)
  nodes1 = highdeg_nodes(g1)
  nodes2 = highdeg_nodes(g2)
  c = length(g1) * 20
  s = Dict(nodes1, nodes2)
  score = sa_cost(s)
  best_s = s
  best_score = score
  for i in 1:iterations
    if i % 1000 == 0
      println(i)
    end
    t = temp_fn(i)
    s_n = sa_neighbor(s)
    y = cost(s)
    y_n = cost(s_n)
    if y_n <= y
      s = s_n
      y = y_n
    else
      p = exp(-((y_n - y) / t))
      if rand() <= p
        s = s_n
        y = y_n
      else
        nothing
      end
    end
    if y < best_cost
      best_s = s
      best_cost = y
    end
    keep_best ? best_s : s
  end
end
  
#=
function propagation_step(lgraph, rgraph, mapping)
  scores = [][]
  for lnode in vertices(lgraph)
    scores[lnode] = matchScores(lgraph, rgraph, mapping, lnode)
    if eccentricity(scores[lnode]) < theta
      continue
    end
    rnode = indmax(scores[lnode])

    scores[rnode] = matchScores(rgraph, lgraph, invert(mapping), rnode)
    if eccentricity(scores[rnode]) < theta
      continue
    end
    reverse_match = indmax(scores[rnode])
    if reverse_match != lnode
      continue
    end

    mapping[lnode] = rnode
  end
  mapping
end

function matchScores(lgraph, rgraph, mapping, lnode)
  scores = [0 for rnode in rgraph.nodes]
  for (lnbr, lnode) in edges(lgraph)
    if lnbr not in mapping
      continue
    end
    rnbr = mapping[lnbr]
    for (rnbr, rnode) in edges(rgraph)
      if rnode in mapping.image
        continue
      end
      #the histogram is the same, but not the distribution
      scores[rnode] += 1 / (rnode.in_degree ^ 0.5)
      scores[rnode] += 1 / (rnode.out_degree ^ 0.5)
    end
  end
  scores
end

function eccentricity(items)
  #use select!
  return (max(items) - max2(items)) / std(items)
end

function propagation(tgt_g, aux_g, seed_map, num_iters=10000)
  for i in 1:num_iters
    propagation_step(tgt_g, aux_g, seed_map) #must mutate seed_map
  end
  seed_map
end
=#

function test()
  #weight_matrix_test()
  #sa_neighbor_test()
  #pair_distance_test()
  sa_cost_test()
end

test()

#turb_g = read_edgelist("turb.edgelist")
#word_g = read_edgelist("words.edgelist")
#sa(turb_g, word_g)
