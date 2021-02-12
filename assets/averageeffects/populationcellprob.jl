# This file was generated, do not modify it. # hide
using Statistics
using StatsPlots
using StatsPlots.PlotMeasures
poda[:,:P] = poda.N ./ [ N_sum[j] for j in poda.jahr ]
poda[:,:cell] = collect(zip(poda.alter,poda.geschlecht))
tmp = combine(groupby(poda, :cell), 
              :P=>mean)
PAG_mean = Dict([ r[1] => r[2] 
                for r in eachrow(tmp)
			  ])