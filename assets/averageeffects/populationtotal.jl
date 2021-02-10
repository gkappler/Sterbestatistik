# This file was generated, do not modify it. # hide
gsrd = groupby(srd, :jahr)
N_sum = Dict(r[1] => r[2] for r in eachrow(combine(gsrd, :N=>sum)))

# grouped sum of population table for each Stichtag
gsrd = groupby(p, :Stichtag)
tmp = combine(gsrd, :Insgesamt=>sum)
tmp[:, :N_lookup] = [ get(N_sum, year(d)+1, missing) 
                      for d in tmp[:,1] ]
tmp |> println