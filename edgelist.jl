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
  g = simple_edgelist(max_vnum,edges)
end

function list_eo_cands(graph)
  cands = []
  cands
end

function eo()
  nothing
  #funky version of the extremal optimization algorithm
end

function propagation_step(graph, eo_matching)
  prop = [] #do the propagation step
end

g = read_edgelist("turb.edgelist")
show(g)
