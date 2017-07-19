using MendelBase, Base.Test

info("Unit tests for genetic_utilities")

srand(123)
n = 1000

@testset "genetic_utilities constructors" begin
    @test_throws(ErrorException, blanks(-1))
    @test_throws(MethodError, blanks(rand()))
    @test_throws(MethodError, blanks(NaN))
    @test_throws(MethodError, blanks(Inf))
    blank0 = blanks(0)
    @test length(blank0) == 0
    x = rand(1:n)
    blankx = blanks(x)
    @test typeof(blankx) <: Array{AbstractString}
    @test eltype(blankx) == AbstractString
    @test length(blankx) == x

    @test_throws(ErrorException, empties(-1))
    @test_throws(MethodError, empties(rand()))
    @test_throws(MethodError, empties(NaN))
    @test_throws(MethodError, empties(Inf))
    empty0 = empties(0)
    @test length(empty0) == 0
    emptyx = empties(x)
    @test typeof(emptyx) <: Array{IntSet}
    @test eltype(emptyx) == IntSet
    @test length(emptyx) == x
end

@testset "general_utilities" begin
    a = repeated_string(["hi", "ho", "ha", "he"])
    @test a == (false, "")
    b = repeated_string(["a", "b", "c", "d", "d"])
    @test b == (true, "d")
    c = repeated_string(["*&^%#", "*&^%#", "f32<", "*jf*ijioej2"])
    @test c == (true, "*&^%#")
end

@testset "select_set_element" begin
    firstset = IntSet([1, 4, 555, 3, 23, 40, 23456])
    secondset = IntSet([2, 2, 2, 2, 2])
    @test select_set_element(firstset, 5) == 40
    @test select_set_element(secondset, 1) == 2
    @test typeof(select_set_element(secondset, 2)) == Void
    @test typeof(select_set_element(secondset, 20)) == Void
end