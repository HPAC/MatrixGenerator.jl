using Test
using Nullables
using MatrixGenerator

include("helpers.jl")
include("band_types.jl")
tests = ["constants", "random", "spd", "orthogonal", "typematcher"]

for f in tests
  include("$(f).jl")
end
