# This file was generated, do not modify it. # hide
D_2016_2021_Tage = Dict( j => d 
	for (j,d) in zip((2020,2019,2018, 2017, 2016), 
	                 (982489,  939520,  954874,  932263,  910899)))
expected_deaths[:,:totalxls] = 
	[ D_2016_2021_Tage[j] for j in expected_deaths.Jahr ]
expected_deaths[:,:Population] = 
	[ N_sum[j] for j in expected_deaths.Jahr ]
expected_deaths[:,:D_pop_adj] = 
	round.(EN_sum * expected_deaths.D_sum_sum ./ expected_deaths.Population )
expected_deaths[:,:difference] = 
	expected_deaths.Dadj_sum_sum .- expected_deaths.D_sum_sum
expected_deaths[:,:difference_adj] = 
	round.(expected_deaths.Dadj_sum_sum .- expected_deaths.D_pop_adj)
 
println(expected_deaths)