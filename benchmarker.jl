#include("../../julia/Benchmarker.jl/src/Benchmarker.jl")
#push!(LOAD_PATH, pwd() * "")
workspace()
reload("Benchmarker")
using Benchmarker;


function f(x::Int, y::Int)
  y::Float64 = y;
  for i=1:x
    y = y + rand()
  end
end

println(Benchmarker.run(100, f, 100000, 1))
