+++
title = "Adjusted Weekly Mortality"
hascode = true
hasplotly = true
rss = ""
+++
@def tags = ["syntax", "code"]

Adjusting mortalities for age and gender 
for an unbiased comparisons in an aging society.
# German Excess Death 2020? 


## Collecting values in a table
The lookup functions `population` are used in 
a multi-dimensional julia comprehension `[f(...) for ...]` and 
converted to a `DataFrame` `poda` (abbrev. population data).


```julia:./deathdf
# Julia sets of values in the condition variables:  # hide
include("./_assets/scripts/groups.jl") # hide
# load functions:  # hide
include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide

poda = [ 
  ( alter = a,
    geschlecht=g, 
    jahr=j,
    N=population(alter=a, geschlecht=g, jahr=j)
#    D=deaths(alter=a, geschlecht=g, jahr=j)
  )
  for a in altersgruppen
  for g in geschlechter
  for j in jahre 
  ] |> DataFrame;
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
```
Total population computed from two tables (lookup `poda` and raw data `p`) must match:
\output{./populationtotal}


## Random Variables
Are the strict formulations in probability theory, for scientific notation.
### Conditioning Variables:
- Jahre/years $J: \Omega \rightarrow \{2016,\ldots,2020\}$
- Week: $W: \Omega \rightarrow \{1, \ldots, 53\}$

- Geschlechter/Gender $G: \Omega \rightarrow \{Männlich, Weiblich\}$
- altersgruppen, age: $A: \Omega \rightarrow \{\textoutput{./agegroups}\}$


### Observables:
- Deaths are observed $D | J,W,G,A: \Omega \rightarrow \mathbb{N}$
- Population $N |J,G,A: \Omega \rightarrow \mathbb{N}$

Note: death statistics are observed for each week (as well as year, gender, age), 
but population statistics are observed only for combinations of year, gender, and age.

## Probabilities and adjusted Expectations
Death counts at week $J=j, W=w$ can be adjusted for
- $P(A=a, G=g)$: average joint distribution of age and gender, 
- $E(N)$: average population count,
both averaged accross all observed years.

$E^{adj}(D | J=j, W=w) =$
$$
\sum_{a,g \in A, G} \left[ 
	\underbrace{E\left( \frac{D}{N} | A=a, G=g, J=j, W=w \right)}_{A \times G\text{ mortality rates}}
	\underbrace{P(A=a, G=g)}_{\text{average} A \times G\text{ distribution}} 
  \right]
  	\underbrace{E(N)}_{\text{average population count}},
$$
$\forall j \in \{2016,\ldots,2020\}, w \in \{1,\ldots,53\}$

### Notes regarding Notation (Photo Rolf)
were expanded with $W$ for week number.
#### Formel (1)
$$
P^{2016}( I_+=1 | G=g, A=a) = E\left[\frac{D}{N} | A=a, G=g, J=2016, W=w \right]
$$

#### Formel (2)
$$
P^{2020}_{adj}( + ) = E^{adj}(D | J, W) / E(N)
$$

#### Formel (3)
$$
P(A=a, G=g)
$$


### Average joint age, gender distribution `PAG_mean=` $P(A, G)$
```julia:./populationcellprob
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
		
```

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


### Adjusted data
For adjustment, age and gender specific mortality is estimated for each calendar week, 
from  `population` as well as `deaths` data,
and adjusted according to the formula above,
converted to a `DataFrame` `moda` (abbrev. mortality data).
```julia:./adjusted
moda = [
    ( jahr=j, alter=a, geschlecht=g,
      kw=kw,
      N = population(jahr=j,alter=a,geschlecht=g),
      D = deaths(jahr=j, alter=a, geschlecht=g, kw=kw),
      marginalP = PAG_mean[ (a,g) ]
	)
    for a in altersgruppen, 
        kw in 1:53, 
        g in geschlechter,
        j in jahre
    if deaths(jahr=j,alter=a,geschlecht=g,kw=kw) isa Int
	] |> DataFrame

# Formel 3
EN_sum = mean(collect(values(N_sum)))
moda[:,:Dadj] = round.(( moda.D ./ moda.N ) .* moda.marginalP * EN_sum)

moda[1:2,:] |> println
```


\output{./adjusted}


```julia:./plotdata
# hideall
moda[:,:cell] = collect(zip(moda.jahr, moda.kw))
plot_data = combine(groupby(moda,:cell),
    :D => sum,
    :Dadj => sum)
plot_data[:,:Jahr] = [ x[1] for x in plot_data[:,1] ]
plot_data[:,:kw] = [ x[2] for x in plot_data[:,1] ];
plot_data = plot_data[plot_data.kw .<= 52,:]

#using PlotlyJS
#plotly()
# Farben Bundesamt
lcolors = [ "#006298", "#A02438", "#449ADC", "#002B52", "#EC4A60" ]
yticks = 0:5000:30000
@df plot_data plot(:kw, :D_sum, group=:Jahr; lw=3, 
    palette=lcolors, 
    xlabel="Kalenderwoche",
    title="Wöchentliche Sterbefallzahlen in Deutschland",
	left_margin=50px,
    ylims=(0,32000), yticks=yticks, yformatter=:plain,
    legend=:bottomright
)
savefig(joinpath(@OUTPUT, "deaths.svg")) # hide


@df plot_data plot(:kw, :Dadj_sum, group=:Jahr;lw=3,
    palette=lcolors, 
    xlabel="Kalenderwoche",
    title="Adjustierte (2020) Sterbefallzahlen in Deutschland",
	left_margin=50px,
    ylims=(0,32000), yticks=yticks, yformatter=:plain,
    legend=:bottomright
)
savefig(joinpath(@OUTPUT, "adjusted_deaths.svg")) # hide


# select(poda,tuple(:D, :expected))
expected_deaths = combine(groupby(plot_data,:Jahr), 
    :D_sum => sum, 
    :Dadj_sum => sum)
# Nicht korrigierte Rohdaten
@df expected_deaths plot(:Jahr,:D_sum_sum; label="data", lw=3,
	yformatter=:plain,
	left_margin=50px,
    legend=:bottomright)
@df expected_deaths plot!(:Jahr,:Dadj_sum_sum; label="age-gender adjusted", lw=3)

savefig(joinpath(@OUTPUT, "adjusted_deaths_years.svg")) # hide
#fdplotly(json(plt)) # hide
```


## Reproduction of Data-Visualisation of the *Statistisches Bundesamt*
[Official mortality analysis](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Sterbefaelle-Lebenserwartung/sterbefallzahlen.html) shows a graph of weekly mortalityfrom 2016-2020.

Our reproduction seems identical:
\fig{./deaths}

The age- and gender-adjusted mortality counts in 2020 are low until autumn.
The mortality increase in Winter 2020 is less pronounced than when looking at values 
biased by the confounders from an aging society.

\fig{./adjusted_deaths}


### Year aggregated mortality
Summing weekly mortality results in the total count of deceiced persons in the given year,
in total numbers, as well as adjusted by age and gender.


\fig{./adjusted_deaths_years}

Yet, comparing these numbers unadjusted (`difference`) again is not fair, considering the population growth from 2016 to 2020:
`D_sum_sum` is the "data", `Dadj_sum_sum` is the "age-gender-adjusted" curve above.
`D_pop_adj` is the mortality adjusted to the assumption that all years had fixed population $E(N)$ used in the adjustment formula.

```julia:./total_deaths
expected_deaths[:,:Population] = 
	[ N_sum[j] for j in expected_deaths.Jahr ]
expected_deaths[:,:D_pop_adj] = 
	round.(EN_sum * expected_deaths.D_sum_sum ./ expected_deaths.Population )
expected_deaths[:,:difference] = 
	expected_deaths.Dadj_sum_sum .- expected_deaths.D_sum_sum
expected_deaths[:,:difference_adj] = 
	round.(expected_deaths.Dadj_sum_sum .- expected_deaths.D_pop_adj)
println(expected_deaths)
```
\output{./total_deaths}

When adjusted for age and gender, the year 2020 has the second lowest mortality (among years 2016 to 2020).
2020 saw 30'000-40'000 deaths less than would have been expected,
given average mortality rates from 2016-2020 and the joint age-gender distribution in 2020.
Only the directly preceding year 2019 had even lower mortality
(a fact that is notable because no catch-up effect can be observed).




