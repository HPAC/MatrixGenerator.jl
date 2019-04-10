using .Shape
using .Properties
# import to extend with a set support
#import Base.findfirst

function define_random(functions, generic_functions)

  functions[ [Properties.Random] ] =
    (size, shape, props) -> random(size..., shape, props, none)
  functions[ [Properties.Random, Properties.Positive] ] =
    (size, shape, props) -> random(size..., shape, props, positive)
  functions[ [Properties.Random, Properties.Negative] ] =
    (size, shape, props) -> random(size..., shape, props, negative)
  functions[ [Properties.Positive, Properties.Random] ] =
    (size, shape, props) -> random(size..., shape, props, positive)
  functions[ [Properties.Negative, Properties.Random] ] =
    (size, shape, props) -> random(size..., shape, props, negative)


  generic_functions[Properties.Random] =
    (shape, val_types, props) -> random(shape, val_types, props)

end

function findfirst(f::Function, set::Set)
  for element in set
    if f(element)
      return element
    end
  end
  return nothing
end

function findfirst(f::Function, set::Array)
  for element in set
    if f(element)
      return element
    end
  end
  return nothing
end

function get_bounds(properties, valTypes)
  rand_prop = findfirst(x -> x == Properties.Random || isa(x, Properties.Random), properties)
  if rand_prop == Properties.Random
    return valTypes == negative ? (-1, 0) : (0, 1)
  else
    return rand_prop.lower_bound, rand_prop.upper_bound
  end
end

function random(packed_shape::Tuple{T, Shape.Band, Bool, Int, Int}, properties, valTypes::U) where T where U <: ValuesType
  special_shape, shape, symmetric, rows, cols = packed_shape
  mat = random(rows, cols, special_shape, properties, valTypes)
  # apply band to remove unnecessary elems
  return apply_band(special_shape, shape, rows, cols, mat)
end

function random(rows, cols, shape::Shape.General, properties, valTypes::T) where T <: ValuesType
  low, high = get_bounds(properties, valTypes)
  if valTypes == none
    return rand(rows, cols) * (high - low) .+ low
  elseif valTypes == positive
    if low < 0
      throw(ErrorException("Clash between lower bound $low of Random and Positive!"))
    end
    return rand(rows, cols) * (high - low) .+ low
  else
    if high > 0
      throw(ErrorException("Clash between upper bound $high of Random and Negative!"))
    end
    return rand(rows, cols) * (high - low) .+ low
  end
end

function random(rows, cols, shape::Shape.Symmetric, properties, valTypes::T) where T <: ValuesType

  if rows != cols
    throw(ErrorException("Non-square matrix passed to a symmetric generator!"))
  end
  mat = random(rows, rows, Shape.General(), properties, valTypes)
  # overwrite values to ensure that matrix is symmetric after using unwrap
  for i = 1:rows
    for j = 1:(rows - 1)
      mat[i, j] = mat[j, i]
    end
  end
  return Symmetric(mat)
end

function random(rows, cols, shape::Shape.UpperTriangular, properties, valTypes::T) where T <: ValuesType

  # fill whole matrix, one part will be ignored
  mat = random(rows, cols, Shape.General(), properties, valTypes)
  return apply_upper_triangular(rows, cols, mat)
end

function random(rows, cols, shape::Shape.LowerTriangular, properties, valTypes::T) where T <: ValuesType

  # fill whole matrix, one part will be ignored
  mat = random(rows, cols, Shape.General(), properties, valTypes)
  return apply_lower_triangular(rows, cols, mat)
end

function random(rows, cols, shape::Shape.Diagonal, properties, valTypes::T) where T <: ValuesType

  # fill one row
  n = min(rows, cols)
  mat = sign.(rand(1, n) .- 0.5)*10 + (rand(1, n) .- 0.5)
  return apply_diagonal(rows, cols, mat)
end
