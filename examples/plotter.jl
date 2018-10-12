using MatrixGenerator

function matmul(n::Int)
  A = rand(n, n);
  B = rand(n, n);
  return A*B;
end

plotter = Benchmarker.Plot("julia_data.txt", ["N"; "N^2"])
for i=50:10:100
  Benchmarker.add_data(plotter, [i; i^2], @Benchmarker.time(matmul(i)))
end
Benchmarker.finish(plotter);

plotter2 = Benchmarker.Plot("julia_data2.txt")
for i=50:10:100
  Benchmarker.add_data(plotter2, @Benchmarker.time(matmul(i)))
end
Benchmarker.finish(plotter2)
