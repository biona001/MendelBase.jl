using MendelBase, Base.Test, Distributions

info("Unit tests for genetic_utilities")

srand(123)
n = 1000

@testset "map_function" begin
    # input x = genetic distance, i.e. must be greater than 1
    # output = recombination fraction, which will always be < 0.5 
    x = rand() 
    h = map_function(x, "Haldane")
    k = map_function(x, "Kosambi")

    @test typeof(h) == Float64
    @test typeof(k) == Float64
    @test_throws(ArgumentError, map_function(x, "RandomString"))
    @test_throws(DomainError, map_function(-x, "Haldane"))
    @test_throws(DomainError, map_function(-Inf, "Haldane"))
    @test map_function(Inf, "Kosambi") == 0.5
    @test map_function(0.0, "Kosambi") == 0.0
    @test map_function(Inf, "Haldane") == 0.5
    @test map_function(0.0, "Haldane") == 0.0
    @test isnan(map_function(NaN, "Haldane")) 
    @test isnan(map_function(NaN, "Kosambi")) 

    for i in 1:10
        x = rand()
        h = map_function(x, "Haldane")
        k = map_function(x, "Kosambi")
        @test h ≈ 0.5 * (1.0 - exp(-2*x))
        @test k ≈ 0.5 * tanh(2*x)
    end
end

@testset "inverse_map_function" begin
    # input = recombination fraction (i.e. some probability) which must be 
    # greater than 0, and output should be infinite if input >= 0.5
    @test inverse_map_function(0.0, "Kosambi") == 0.0
    @test inverse_map_function(0.5, "Haldane") == Inf
    @test inverse_map_function(0.5, "Kosambi") == Inf
    @test_throws(DomainError, inverse_map_function(1.1, "Haldane"))
    @test_throws(DomainError, inverse_map_function(-rand(), "Kosambi"))
    @test_throws(DomainError, inverse_map_function(-Inf, "Kosambi"))
    @test isnan(inverse_map_function(NaN, "Kosambi"))
    @test isnan(inverse_map_function(NaN, "Haldane"))

    for i in 1:10
        x = rand(Uniform(0, 0.5))
        h = inverse_map_function(x, "Haldane")
        k = inverse_map_function(x, "Kosambi")
        @test h ≈ -0.5 * log(1.0 - 2.0 * x)
        @test k ≈ 0.25 * log((1.0 + 2.0 * x) / (1.0 - 2.0 * x))
    end
end

@testset "hardy_weinberg_test" begin
    x = fill(NaN, n)
    @test hardy_weinberg_test(x) == 1.0
    y = rand(n)
    @test typeof(hardy_weinberg_test(y)) == Float64

    # flower example http://www.radford.edu/rsheehy/Gen_flash/Tutorials/Chi-Square_tutorial/x2-tut.htm
    for i in 1:200 x[i] = 0.0 end
    for i in 201:600 x[i] = 1.0 end
    for i in 601:1000 x[i] = 2.0 end
    result = hardy_weinberg_test(x)
    ans = ccdf(Chisq(1), 27.77777777)
    @test round(result * 10e5, 6) == round(ans * 10e5, 6) #julia still lacks a significant digit rounding funciton... lol
end

@testset "xlinked_hardy_weinberg_test" begin
    # nothing yet.
end