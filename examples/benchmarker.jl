using MatrixGenerator

function f(x::Int, y::Int)
  y::Float64 = y;
  for i=1:x
    y = y + rand()
  end
end

println(Benchmarker.measure(100, f, 100000, 1))
println(@Benchmarker.time(f(100000, 1)))
