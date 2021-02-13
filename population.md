+++
title = "Population tables"
hascode = true
hasplotly = true
rss = ""
+++
@def tags = ["syntax", "code"]

# Population in Germany 2016-2020

## Collecting values in a table
The lookup functions `population` are used in 
a multi-dimensional julia comprehension `[f(...) for ...]` and 
converted to a `DataFrame` `poda` (abbrev. population data).


```julia:./deathdf
# Julia sets of values in the condition variables:  # hide
include("./_assets/scripts/groups.jl") # hide
# load functions:  # hide
altersgruppen = altersgruppen_months

include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide


poda[1:10,:] |> println # hide
```

The data is comprised of rows like for the `0:30` age group:
\show{./deathdf}

```julia:./agegroups
# hideall
println(join([ "[$(x.start),$(x.stop)[" for x in  altersgruppen ], ", "))
```


#### Total population
As data sanity check it is tested whether `poda` groups sum to same value as original data in CSV file.
```julia:./populationtotal

# grouped sum of raw population table for each Stichtag
tmp = combine(groupby(p, :Stichtag), 
              :Insgesamt=>sum)
tmp[:, :N_lookup] = [ get(N_sum, year(d)+1, missing) 
                      for d in tmp[:,1] ]
tmp |> println
```
Total population computed from two tables (lookup `poda` and raw data `p`) must match:
\output{./populationtotal}





### Average joint age, gender distribution `PAG_mean=` $P(A, G)$
This plot is only for checking errors:
```julia:./populationcellprob2
# hideall
tmp = [ ( A=k[1].start, G=k[2], p = 100*v/(k[1].stop-k[1].start)) 
	    for (k,v) in PAG_mean ] |> DataFrame


@df tmp[sortperm(tmp.A),:] plot(:A,:p, group=:G, lw=3, legend=:bottomright,
    xlabel="Alter",
    ylabel="% Bevölkerung",
    title="Bevölkerungsanteil (mittel 2016-2020) in Deutschland",
)

savefig(joinpath(@OUTPUT, "Pmean.svg")) # hide
```

\fig{./Pmean}
