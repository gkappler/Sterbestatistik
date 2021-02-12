# This file was generated, do not modify it. # hide
expected_deaths[:,:Population] = 
	[ N_sum[j] for j in expected_deaths.Jahr ]
expected_deaths[:,:D_pop_adj] = 
	round.(EN_sum * expected_deaths.D_sum_sum ./ expected_deaths.Population )
expected_deaths[:,:difference] = 
	expected_deaths.Dadj_sum_sum .- expected_deaths.D_sum_sum
expected_deaths[:,:difference_adj] = 
	round.(expected_deaths.Dadj_sum_sum .- expected_deaths.D_pop_adj)
println(expected_deaths)