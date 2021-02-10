# This file was generated, do not modify it. # hide
using Statistics
using StatsPlots
using StatsPlots.PlotMeasures
srd[:,:P] = srd.N ./ [ N_sum[j] for j in srd.jahr ]
srd[:,:cell] = collect(zip(srd.alter,srd.geschlecht))
gsrd = groupby(srd, :cell)
P_mean = Dict([ r[1] => r[2] 
                for r in eachrow(combine(gsrd, :P=>mean))
			  ])