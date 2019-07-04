# Benchmarker resources
#
# http://docs.julialang.org/en/stable/manual/performance-tips/#measure-performance-with-time-and-pay-attention-to-memory-allocation
#
# Wallclock time vs CPU time
# https://groups.google.com/forum/#!topic/julia-dev/w3NW9JzeV9I
# https://groups.google.com/forum/#!topic/julia-users/2zB4hajQJuc/discussion
#
# Other benchmarkers
# https://github.com/johnmyleswhite/Benchmarks.jl/blob/master/src/benchmarkable.jl
# https://github.com/schmrlng/CPUTime.jl/blob/master/src/CPUTime.jl

# Trigger several successive GC sweeps. This is more comprehensive than running just a
# single sweep, since freeable objects may need more than one sweep to be appropriately
# marked and freed.


module Benchmarker

using Statistics
using DelimitedFiles

include("Results.jl")
export show

include("Plot.jl")

gcscrub() = (GC.gc(); GC.gc(); GC.gc(); GC.gc())

A = rand(7500000)
cachescrub() = (A .+= rand())

function ci(data)
  n = length(data)
  # z = 1.96 # 95%
  z = 2.576 # 99%
  # z = 3.291 # 99.9%
  lower_pos = floor(Integer, (n - z*sqrt(n))/2)
  upper_pos = ceil(Integer, 1 + (n + z*sqrt(n))/2)
  return (lower_pos, upper_pos)
end

function citest(data)
  n = length(data)
  if n < 11 # careful: this number depends on z in the ci function
    return false
  else 
    data_sorted = sort(data)
    (lower_pos, upper_pos) = ci(data_sorted) 
    m = median(data_sorted)
    lower_val = data_sorted[lower_pos]
    upper_val = data_sorted[upper_pos]
    t = 1.05
    return m/t < lower_val && upper_val < m*t
  end
end

function measure(iters, f, args...)
  timings = Array{Float64}(undef, 0)

  # JIT optimization run removed. Postprocessing will handle JIT-ed runs
  local elapsed_time::Float64 = 0.0

  while !citest(timings)
    copy_args = map(copy, args)
    cachescrub()
    gcscrub()
    result, elapsed_time = f(copy_args...)
    push!(timings, elapsed_time)
  end
  return Results(length(timings), timings)
end
end
