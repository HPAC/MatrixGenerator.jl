
module Benchmarker

	export measure

	include("Results.jl")
	include("Plotter.jl")

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

	function measure(iters, f, args...)

		timings = Array{Float64}(undef, iters);

		# Compile f and time functions
		@elapsed f(map(copy, args)...);

		local elapsed_time::Float64 = 0.0;
		for i=1:iters
            copy_args = map(copy, args);
			elapsed_time = @elapsed f(copy_args...);
			timings[i] = elapsed_time;
		end
		return Results(iters, timings);

	end

	macro time(ex)

		quote
			timings = Array{Float64}(undef, 100);

			# Compile f and time functions
			@elapsed $(esc(ex));

			local elapsed_time::Float64 = 0.0;
			for i=1:100
				elapsed_time = @elapsed $(esc(ex));
				timings[i] = elapsed_time;
			end
			Results(100, timings);
		end

	end

end
