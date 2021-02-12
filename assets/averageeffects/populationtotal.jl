# This file was generated, do not modify it. # hide
N_sum = Dict(
   r[1] => r[2] 
   for r in eachrow(
              combine(groupby(poda, :jahr), 
                      :N=>sum)))

# grouped sum of raw population table for each Stichtag
tmp = combine(groupby(p, :Stichtag), 
              :Insgesamt=>sum)
tmp[:, :N_lookup] = [ get(N_sum, year(d)+1, missing) 
                      for d in tmp[:,1] ]
tmp |> println