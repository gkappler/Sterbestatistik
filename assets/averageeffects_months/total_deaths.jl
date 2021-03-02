# This file was generated, do not modify it. # hide
# hideall
D_2016_2021_Tage = Dict( j => d 
	for (j,d) in zip((2020,2019,2018, 2017, 2016), 
	                 (982489,  939520,  954874,  932263,  910899)))
expected_deaths[:,:totalxls] = 
	[ D_2016_2021_Tage[j] for j in expected_deaths.Jahr ]
println(select(expected_deaths, "totalxls"=>"Total", "D_sum_sum"=>"Total sum", "D_sum_sum_EN" => "N adjusted", "Dadj_sum_sum" => "age-gender adjusted"))