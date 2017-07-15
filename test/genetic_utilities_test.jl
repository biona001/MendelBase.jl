using MendelBase, Base.Test

info("Unit tests for genetic_utilities")

srand(123)
n, p = 100, 1000

@testset "map_function" begin
  x = rand()
  h = map_function(x, "Haldane")
  k = map_function(x, "Kosambi")

  @test typeof(h) == Float64
  @test typeof(k) == Float64
  @test_throws(ArgumentError, map_function(x, "RandomString"))
  @test_throws(BoundsError, map_function(-x, "Haldane"))

  for i in 1:10
    x = rand()
    h = map_function(x, "Haldane")
    k = map_function(x, "Kosambi")
    @test h ≈ 0.5 * (1.0 - exp(-2*x))
    @test k ≈ 0.5 * tanh(2*x)
  end
end

