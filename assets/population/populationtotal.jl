# This file was generated, do not modify it. # hide
# grouped sum of raw population table for each Stichtag
tmp = combine(groupby(p, :Stichtag), 
              :Insgesamt=>sum)
tmp[:, :N_lookup] = [ get(N_sum, year(d)+1, missing) 
                      for d in tmp[:,1] ]
tmp |> println