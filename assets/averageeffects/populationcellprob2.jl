# This file was generated, do not modify it. # hide
# hideall
tmp = [ ( A=k[1].start, G=k[2], p = 100*v/(k[1].stop-k[1].start)) 
	    for (k,v) in PAG_mean ] |> DataFrame


@df tmp[sortperm(tmp.A),:] plot(:A,:p, group=:G, lw=3, legend=:bottomright,
    xlabel="Alter",
    ylabel="% Bevölkerung",
    title="Bevölkerungsanteil (mittel 2016-2020) in Deutschland",
)

savefig(joinpath(@OUTPUT, "Pmean.svg")) # hide