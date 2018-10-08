module Shape

  export ShapeType, LowerTriangular

  abstract type ShapeType end

  struct General <: ShapeType end

  struct Symmetric <: ShapeType end

  struct LowerTriangular <: ShapeType end

  struct UpperTriangular <: ShapeType end

  struct Diagonal <: ShapeType end

  struct Band <: ShapeType
    lower_bandwidth::Int
    upper_bandwidth::Int
  end

end

