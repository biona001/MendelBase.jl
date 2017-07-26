using MendelBase, Base.Test

info("Unit tests for read_data")

srand(123)

# The following private functions are used in read_external_data_files,
# and hence will not be tested separately, unless they depend on 
# other (private or public) functions in read_data. This function, btw, 
# requires the keywords function to be working.

# read_plink_fam_file, 
# locus_information
# pedigree_information
# person_information,
# pedigree_counts!
# construct_nuclear_families
# check_data_structures!
# snp_information

@testset "read_external_data_files" begin
    dict = Dict{AbstractString,Any}()
    dict["pedigree_file"] = "example_pedigree.txt"
    dict["locus_file"] = "example_locus.txt" #there's an extra column? deleted it.
    dict["phenotype_file"] = "example_phenotype.txt"
    dict["field_separator"] = ','
    dict["populations"] = ""
    read_external_data_files(dict)
end
