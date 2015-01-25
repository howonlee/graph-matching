# test out sa optimization just in julia
# taken from JM White
# http://www.johnmyleswhite.com/notebook/2012/04/04/simulated-annealing-in-julia/
using Distributions

function sa(cost, #cost fn
  s0, #initial state
  neighbor, #function from states to states
  temperature, #temperature function, param'd by time
  iterations, #only termination is num iterations
  keep_best #should keep best?
  )
  s = s0
  best_s = s0
  best_cost = cost(s0)
  for i in 1:iterations
    if i % 100 == 0
      println(i)
    end
    t = temperature(i)
    s_n = neighbor(s)
    y = cost(s)
    y_n = cost(s_n)
    if y_n <= y
      s = s_n
      y = y_n #to make sense with the best cost
    else
      p = exp(-((y_n-y) / t))
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
  end

  keep_best ? best_s : s
end

function rosenbrock(x, y)
  (1 - x)^2 + 100(y - x^2)^2
end

function neighbors(z)
  [rand(Uniform(z[1] - 1, z[1] + 1)), rand(Uniform(z[2] - 1, z[2] + 1))]
end

function log_temperature(i)
  1 / log(i)
end

solution = sa(z->rosenbrock(z[1], z[2]), [0,0], neighbors, log_temperature, 10000, true)
show(solution)
