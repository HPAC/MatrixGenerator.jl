using MatrixGenerator

println(generate((2, 2), [Properties.Random(0, 3), Shape.General]))
println(generate((2, 2), [Properties.Negative, Properties.Random(-2, -1), Shape.Diagonal]))
println(generate((2, 2), [Properties.Random, Properties.Positive, Shape.UpperTriangular]))
