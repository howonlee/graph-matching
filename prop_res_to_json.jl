using JSON

dict_file = open("prop_result.jld", "r")
prop_res = deserialize(dict_file)
println(JSON.json(prop_res))
