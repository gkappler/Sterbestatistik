+++
title = "Population"
hascode = true
hasplotly = true
rss = ""
+++
@def tags = ["syntax", "code"]

# Population in Germany 2016-2020

```julia:./deathdf
# hideall
# Julia sets of values in the condition variables:  # hide
include("./_assets/scripts/groups.jl") # hide
# load functions:  # hide
altersgruppen = altersgruppen_months

include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide


poda[1:10,:] |> println # hide
```


## Total population

```julia:./populationtotal
# hideall
plot(
    bar(jahre, [ (N_sum[j]) for j in jahre],
        color=lcolors, 
        left_margin=50px,
        #ylims=(80000000,110000), yticks=yticks, 
        yformatter=:plain,
        title="Bevölkerung", legend=:none),
    bar(jahre, [ (N_sum[j]) for j in jahre],
        color=lcolors, 
        left_margin=50px,
        ylims=(81000000,83500000), 
        yformatter=:plain,
        title="Bevölkerung", legend=:none)
)
savefig(joinpath(@OUTPUT, "population.svg")) 


function agplot(geschlecht="Insgesamt")
nam = repeat(altersgruppen, outer=length(jahre))
mn = [ 100*population(jahr=j, alter=a, geschlecht=geschlecht)/N_sum[j]
       for j in jahre
       for a in altersgruppen
       ]
sx = repeat(jahre, inner = length(altersgruppen))

groupedbar(string.(nam), mn, group = sx, ylabel = "% der Bevölkerung", 
           left_margin=50px,
           palette=lcolors, 
           title = "Veränderung der Altersgruppen-Verteilung $geschlecht")
end

for g in [ "Insgesamt", geschlechter... ]
	agplot(g)
	savefig(joinpath(@OUTPUT, "population-ages-$g.svg")) 
end



nam = repeat(altersgruppen, outer=length(geschlechter))
mn = [ 100*PAG_mean[(a, g)]
       for g in geschlechter
       for a in altersgruppen
       ]
sx = repeat(geschlechter, inner = length(altersgruppen))

groupedbar(string.(nam), mn, group = sx, ylabel = "% der Bevölkerung", 
           left_margin=50px,
           palette=lcolors, 
           title = "Durchschnitt Altersgruppen-Geschlechts-Verteilung")
savefig(joinpath(@OUTPUT, "PAG_mean.svg")) 



# grouped sum of raw population table for each Stichtag
tmp = combine(groupby(p, :Stichtag), 
              :Insgesamt=>sum)
tmp[:, :N_lookup] = [ get(N_sum, year(d)+1, missing) 
                      for d in tmp[:,1] ]
tmp |> println
```


\fig{./population}

## Age distributions by year
\fig{./population-ages-Insgesamt}

### Gender-specific age distributions by year
Plotting genders separately reveals the same year-patterns in the age groups for females as well as for males, but at gender related longevity patterns (males die earlier).

\fig{./population-ages-Weiblich}

\fig{./population-ages-Männlich}

To adjust for the changing age distributions accross years, the average joint age, gender distribution `PAG_mean=` $P(A, G)$ is computed.

\fig{./PAG_mean}

## Data Sanity Check
The lookup functions `population` are used in 
a multi-dimensional julia comprehension `[f(...) for ...]` and 
converted to a `DataFrame` `poda` (abbrev. population data).

As data sanity check it is tested whether `poda` groups sum to same value as original data in CSV file.

The data is comprised of rows like for the `0:30` age group:
\show{./deathdf}

```julia:./agegroups
# hideall
println(join([ "[$(x.start),$(x.stop)[" for x in  altersgruppen ], ", "))
```

Total population from lookup dictionary (`N_lookup` from `N_sum`, computed from `poda`, which is a table recreated by lookup function `population`) 
must match raw data (`Insgesamt_sum` is the sum over all ages grouped by `Stichtag` in `p`):
\output{./populationtotal}





