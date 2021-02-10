# This file was generated, do not modify it. # hide
using Statistics
using StatsPlots
srd[:,:P] = srd.N ./ [ N_sum[j] for j in srd.jahr ]
srd[:,:cell] = collect(zip(srd.alter,srd.geschlecht))
gsrd = groupby(srd, :cell)
P_mean = Dict([ r[1] => r[2] 
                for r in eachrow(combine(gsrd, :P=>mean))
			  ])
		
		
tmp = [ ( A=k[1].start, G=k[2], p = 100*v/(k[1].stop-k[1].start)) 
	    for (k,v) in P_mean ] |> DataFrame


@df tmp[sortperm(tmp.A),:] plot(:A,:p, group=:G, lw=3, legend=:bottomright,
    xlabel="Alter",
    ylabel="% Bevölkerung",
    title="Bevölkerungsanteil (mittel 2016-2020) in Deutschland",
)

savefig(joinpath(@OUTPUT, "Pmean.svg")) # hide