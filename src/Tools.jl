function unwrap(input::LinearAlgebra.LowerTriangular)
  return input.data
end

function unwrap(input::LinearAlgebra.UpperTriangular)
  return input.data
end

function unwrap(input::LinearAlgebra.Diagonal)
  return Matrix(Diagonal(input.diag))
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
