# MatrixGenerator.jl
[![Build Status](https://travis-ci.org/mcopik/MatrixGenerator.jl.svg?branch=master)](https://travis-ci.org/mcopik/MatrixGenerator.jl)

Julia package supporting benchmarking of functions with automatic export of measurement data to a CSV file and generation of matrices with desired shapes and properties. Requires Julia in version 0.6 or newer. 

**Supported matrix shapes:** full, symmetric, upper/lower triangular (non-square as well), diagonal, banded (partial support)

When multiple shape properties are provided, the generator tries to find the largest matrix shape satisfying all requirements. For all example, merging ```General``` matrix type with ```LowerTriangular``` creates a lower triangular matrix.

**Support matrix properties:** random, constant, symmetric positive-definite, orthogonal

Short example of using the library
```julia
using MatrixGenerator
# creates 3x3 random matrix with entries in range [0, 1)
generate([3, 3], [Shape.General, Properties.Random])
# creates 3x3 random symmetric matrix with entries in range [-5, 5)
generate([3, 3], [Shape.Symmetric, Properties.Random(-5, 5)])
# creates 5x2 upper triangular constant matrix
generate([5, 2], [Shape.UpperTriangular, Properties.Constant(3.0)])
# 4x4 diagonal and symmetric positive-definite matrix
generate([4,4], [Shape.UpperTriangular, Shape.General, Shape.Diagonal, Properties.SPD])

```
