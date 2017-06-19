
using .Shape;
using .Properties;

function define_orthogonal(functions, generic_functions)

  functions[ Set([Properties.Orthogonal]) ] =
    (shape, props) -> orthogonal(shape, props, none);

  functions[ Set([Properties.Orthogonal, Properties.Positive]) ] =
    (shape, props) -> orthogonal(shape, props, positive);

  functions[ Set([Properties.Orthogonal, Properties.Negative]) ] =
    (shape, props) -> orthogonal(shape, props, negative);

  generic_functions[Properties.Orthogonal] =
    (shape, val_types, props) -> orthogonal(shape, val_types, props)
end

function orthogonal(shape::Shape.Band, properties, valTypes)

  # verify if we can use one of easy generators
  special_shape = cast_band(shape)
  if (special_shape == Shape.General || special_shape == Shape.Symmetric) &&
    (shape.upper_bandwidth + 1 != shape.cols || shape.lower_bandwidth + 1 != shape.rows)
    throw(ErrorException("Banded orthogonal not supported!"))
  end  
  mat = orthogonal(special_shape, properties, valTypes)
  # apply band to remove unnecessary elems
  return apply_band(special_shape, shape, mat)
end

"""
  Generate an orthogonal matrix by a QR factorization.
  Only diagonal orthogonal matrices can be positive/negative,
  a general positive/negative matrix would not have orthogonal columns.
"""
function orthogonal(shape::Shape.General, properties, type_::ValuesType)

  if type_ != none
    throw(ErrorException("Only diagonal orthogonal matrix can be positive/negative!"))
  end

  if shape.rows != shape.cols
    throw(ErrorException("A non-square matrix cannot be orthogonal!"))
  else
    q, = qr( rand(shape.rows, shape.rows) )
    return q
  end

end

"""
  Some orthogonal matrices are symmetric - all diagonal matrices,
"""
function orthogonal(shape::Shape.Symmetric, properties, type_::ValuesType)
  throw(ErrorException("Symmetric orthogonal matrices are not supported!"))
end

function orthogonal(shape::Shape.Triangular, properties, type_::ValuesType)
  throw(ErrorException("Triangular matrix cannot be orthogonal!"))
end

"""
  A diagonal matrix is orthogonal iff columns are basis vectors of Euclidean space,
  with possible negative values.
  FIXME: move the implementation to permutation matrix
"""
function orthogonal(shape::Shape.Diagonal, properties, type_::ValuesType)

  # mix negative and positive values
  if type_ == none
    vals = [rand() >= 0.5 ? 1.0 : -1.0 for n in 1:shape.rows]
  elseif type_ == negative
    vals = ones(shape.rows) * -1
  else
    vals = ones(shape.rows)
  end

  return Diagonal(vals)
end
