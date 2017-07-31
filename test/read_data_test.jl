using MendelBase, Base.Test, SnpArrays, DataFrames, DataStructures

info("Unit tests for read_data")

srand(123)

# gamete example from gamete package
keyword = set_keyword_defaults!(Dict{AbstractString, Any}())
process_keywords!(keyword, "control.txt", []) 
computed = read_external_data_files(keyword)
reference = readtable("gamete competition PedigreeFrame.txt")
num = length(unique(reference[1]))
tot_num = length(reference[1])

@testset "some basics" begin
    @test typeof(computed) == Tuple{MendelBase.Pedigree,MendelBase.Person,MendelBase.NuclearFamily,MendelBase.Locus,SnpArrays.SnpData,DataFrames.DataFrame,DataFrames.DataFrame,DataFrames.DataFrame,DataFrames.DataFrame}
end

@testset "pedigree constructor" begin
    computed_ped = computed[1]
    @test computed_ped.pedigrees == num
    x = zeros(num)
    for i in 1:length(unique(reference[1])) 
        x[i] = parse(Int64, computed_ped.name[i]) 
    end # puts unique pedigrees to vector x
    @test all(x .== unique(reference[1]))
    # from now on, will only test if the last entry is correct, since theres no point 
    # to write code to reproduce another code
    @test computed_ped.start[num] == 549
    @test computed_ped.twin_finish[num] == 553 # no twins in gametes example
    @test computed_ped.finish[num] == 553
    @test computed_ped.individuals[num] == 5
    @test computed_ped.founders[num] == 2 #in a pedigree, count # of people who don't know their father
    @test computed_ped.females[num] == 4 #in a pedigree, count # of females
    @test computed_ped.males[num] == 1
    @test all(computed_ped.twins .== 0) # since no twins
    @test computed_ped.families[num] == 1 # number of differernt pairs of parents
    @test all(computed_ped.loglikelihood .== 0.0) #loglikelihood never computed...?
end

@testset "person constructor" begin
    computed_person = computed[2]
    @test computed_person.people == 553
    @test computed_person.populations == 1 #population is a set with length 1
    @test computed_person.name[tot_num] == "5" # person's name is a string of a number
    @test computed_person.pedigree[tot_num] == 69 # 69th unique pedigree
    #@test computed_person.mother[tot_num] ==  # this is probably a bug?
    #@test computed_person.father[tot_num] ==  
    @test computed_person.male[tot_num] == false # person's name in each pedigree is sorted first
    @test all(computed_person.next_twin .== 0) 
    @test all(computed_person.primary_twin .== 0) 
    @test size(computed_person.admixture) == (tot_num, computed_person.populations)
    @test all(computed_person.admixture .== 1.0)
    @test computed_person.children[tot_num - 3] == IntSet([551, 552, 553])
    @test computed_person.spouse[tot_num - 3] == IntSet([549])
    @test size(computed_person.genotype) == (553, 10) # cant figure out what genotype does
    @test size(computed_person.homozygotes) == (553, 10)
    @test computed_person.homozygotes[tot_num,:] == [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    @test computed_person.disease_status[16] == "1" # first instance when ACE = 1
    @test size(computed_person.variable) == (553,0) #nothing has non-admixture variables
    @test computed_person.variable_name == [] # no variables
end

# nuclear family is defined as a family of only the spouse and their children, 
# so in this set of 69 pedigrees we have 115 nuclear families because people
# can be a part of more than 1 nuclear family.
@testset "NuclearFamily constructor" begin 
    computed_nuclear = computed[3]
    num = sum(computed[1].families)
    @test computed_nuclear.families == num 
    @test computed_nuclear.pedigree[num] == 69
    
    #first move all NA up, then sort everybody in the same pedigree based on "person" number
    #@test computed_nuclear.mother == ...not sure...
    #@test computed_nuclear.father ==
    @test computed_nuclear.sib[num] == IntSet([551, 552, 553]) 
end

@testset "Locus constructor" begin
    computed_locus = computed[4]
    @test computed_locus.loci == 10
    @test computed_locus.model_loci == 10
    @test computed_locus.trait == 0
    @test computed_locus.free_recombination == false #since all on the same chromosome
    @test length(computed_locus.name) == 10
    @test all(computed_locus.chromosome .== "AUTOSOME")
    @test all(computed_locus.base_pairs .== 0)
    @test size(computed_locus.morgans) == (2, computed_locus.loci)
    @test size(computed_locus.theta) == (2, computed_locus.loci - 1)
    @test all(computed_locus.theta .== map_function(1.0, "Haldane")) # d = 1.0 since 1.0 morgans...?
    @test all(computed_locus.xlinked .== false)
    @test all(computed_locus.alleles .== 2)
    @test typeof(computed_locus.allele_name) == Array{Array{AbstractString,1},1}
    @test eltype(computed_locus.frequency) == Array{Float64,2}
    @test eltype(computed_locus.lumped_frequency) == Float64
    @test length(computed_locus.model_locus) == 10
    @test length(computed_locus.locus_field_in_pedigree_frame) == 10
end

@testset "count_homozygotes! function" begin
    
end

@testset "are errors being thrown" begin
    
end



