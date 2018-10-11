module Properties

  #export Random, Constant, Positive, Negative, Symmetric, SPD, Orthogonal

  struct Random
    lower_bound::Float64
    upper_bound::Float64

    function Random(lower_bound, upper_bound)
      if lower_bound > upper_bound
        throw(ErrorException("Incorrect random boundaries: lower bound
                             $lower_bound greater than upper bound $upper_bound"))
      end
      return new(lower_bound, upper_bound)
    end
  end

  struct Constant
    value::Float64

    #TODO examine if default to 0 is a good idea
    function Constant(value::Float64 = 0.0)
      return new(value)
    end
  end

  struct Positive end

  struct Negative end

  struct Symmetric end

  struct SPD end

  struct Orthogonal end

end
