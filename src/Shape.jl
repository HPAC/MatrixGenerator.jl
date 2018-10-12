module Shape

  export ShapeType, ==

  import Base.==

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

  function ==(a::Shape.Band, b::Shape.Band)
     return a.lower_bandwidth == b.lower_bandwidth && a.upper_bandwidth == b.upper_bandwidth
   end
end
