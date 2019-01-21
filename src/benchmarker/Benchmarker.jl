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
	cachescrub() = rand(5000, 5000) + rand(5000, 5000)

	function measure(iters, f, args...)
		timings = Array{Float64}(undef, iters)

    # JIT optimization run removed. Postprocessing will handle JIT-ed runs
		local elapsed_time::Float64 = 0.0
		for i=1:iters
      copy_args = map(copy, args)
			cachescrub()
			gcscrub()
			elapsed_time = @elapsed f(copy_args...)
			timings[i] = elapsed_time
		end
		return Results(iters, timings)
	end
end
