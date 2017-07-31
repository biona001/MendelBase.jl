module PkgTest

using MendelBase
using Base.Test

# write your own tests here

include("genetic_utilities_test.jl")
include("general_utilities_test.jl")
include("keywords_test.jl")
include("read_data_test.jl")
end # PkgTest module
