
import Base.==

module Shape

  export unwrap, ShapeType

  abstract type ShapeType end

  immutable General <: ShapeType
  end

  immutable Symmetric <: ShapeType
  end

  immutable LowerTriangular <: ShapeType
  end

  immutable UpperTriangular <: ShapeType
  end

  immutable Diagonal <: ShapeType
  end

  type Band <: ShapeType
    lower_bandwidth::Int
    upper_bandwidth::Int
  end

  function unwrap(input::Base.LinAlg.LowerTriangular)
      return input.data
  end

  function unwrap(input::Base.LinAlg.UpperTriangular)
      return input.data
  end

  function unwrap(input::Base.LinAlg.Diagonal)
      return diagm(input.diag)
  end

  function unwrap(input::Base.LinAlg.Symmetric)
      return input.data
  end

  function unwrap(input::Array)
      return input
  end
  
  function unwrap(input::Float64)
      return input
  end

end

function ==(a::Shape.Band, b::Shape.Band)
  return a.lower_bandwidth == b.lower_bandwidth &&
    a.upper_bandwidth == b.upper_bandwidth
end
