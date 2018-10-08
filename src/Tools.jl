module Tools

  import Base.==

  export unwrap, ==

  using LinearAlgebra

  include("Shape.jl")
  using .Shape: Band

  function unwrap(input::LinearAlgebra.LowerTriangular)
      return input.data
  end

  function unwrap(input::LinearAlgebra.UpperTriangular)
      return input.data
  end

  function unwrap(input::LinearAlgebra.Diagonal)
      return diagm(input.diag)
  end

  function unwrap(input::LinearAlgebra.Symmetric)
      return input.data
  end

  function unwrap(input::Array)
      return input
  end

  function unwrap(input::Float64)
      return input
  end

  
  function ==(a::Shape.Band, b::Shape.Band)
    return a.lower_bandwidth == b.lower_bandwidth &&
      a.upper_bandwidth == b.upper_bandwidth
  end

end
