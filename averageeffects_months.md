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


## Random Variables
are the strict formulations in probability theory, for scientific notation.
### Conditioning Variables:
- Jahre/years $J: \Omega \rightarrow \{2016,\ldots,2020\}$
- Months: $M: \Omega \rightarrow \{1, \ldots, 12\}$

- Geschlechter/Gender $G: \Omega \rightarrow \{Männlich, Weiblich\}$
- altersgruppen, age: $A: \Omega \rightarrow \{\textoutput{./agegroups}\}$


### Observables:
- Deaths are observed $D | J,M,G,A: \Omega \rightarrow \mathbb{N}$
- Population $N |J,G,A: \Omega \rightarrow \mathbb{N}$

Note: death statistics are observed for each month (as well as year, gender, age), 
but population statistics are observed only for combinations of year, gender, and age.

## Probabilities and adjusted Expectations
Death counts at month $J=j, M=m$ can be adjusted for
- $P(A=a, G=g)$: average joint distribution of age and gender, 
- $E(N)$: average population count,
both averaged accross all observed years.

$E^{adj}(D | J=j, M=m) =$
$$
\sum_{a,g \in A, G} \left[ 
	\underbrace{E\left( \frac{D}{N} | A=a, G=g, J=j, M=m \right)}_{A \times G\text{ mortality rates}}
	\underbrace{P(A=a, G=g)}_{\text{average} A \times G\text{ distribution}} 
  \right]
  	\underbrace{E(N)}_{\text{average population count}},
$$
$\forall j \in \{2016,\ldots,2020\}, w \in \{1,\ldots,12\}$

### Notes regarding Notation (Photo Rolf)
were expanded with $M$ for month number.
#### Formel (1)
$$
P^{2016}( I_+=1 | G=g, A=a) = E\left[\frac{D}{N} | A=a, G=g, J=2016, M=m \right]
$$

#### Formel (2)
$$
P^{2020}_{adj}( + ) = E^{adj}(D | J, M) / E(N)
$$

#### Formel (3)
$$
P(A=a, G=g)
$$


### Adjusted data
For adjustment, age and gender specific mortality is estimated for each calendar week, 
from  `population` as well as `deaths` data,
and adjusted according to the formula above,
converted to a `DataFrame` `moda` (abbrev. mortality data).
```julia:./adjusted

moda = [
    ( jahr=j, alter=a, geschlecht=g,
      month=m,
      N = population(jahr=j,alter=a,geschlecht=g),
      D = deaths(jahr=j, alter=a, geschlecht=g, month=m),
      marginalP = PAG_mean[ (a,g) ]
    )
    for a in altersgruppen_months, 
        m in 1:12, 
        g in geschlechter,
        j in jahre
    if deaths(jahr=j,alter=a,geschlecht=g,month=m) isa Int
	] |> DataFrame

# Formel 3
EN_sum = mean(collect(values(N_sum)))
moda[:,:Dadj] = round.(( moda.D ./ moda.N ) .* moda.marginalP * EN_sum)

moda[1:2,:] |> println
```


\output{./adjusted}


```julia:./plotdata
# hideall
moda[:,:cell] = collect(zip(moda.jahr, moda.month))
plot_data = combine(groupby(moda,:cell),
    :D => sum,
    :Dadj => sum)
plot_data[:,:Jahr] = [ x[1] for x in plot_data[:,1] ]
plot_data[:,:month] = [ x[2] for x in plot_data[:,1] ];
# plot_data = plot_data[(plot_data.D_sum .> 0) .| (plot_data.month .<= 52),:]

#using PlotlyJS
#plotly()
# Farben Bundesamt
lcolors = [ "#006298", "#A02438", "#449ADC", "#002B52", "#EC4A60" ]
yticks = 0:10000:110000
xticks = 1:12
@df plot_data plot(:month, :D_sum, group=:Jahr; lw=3, 
    palette=lcolors, 
    xlabel="Monat",
    title="Monatliche Sterbefallzahlen in Deutschland",
	left_margin=50px,
	xticks=xticks, 
	ylims=(0,110000), yticks=yticks, 
	yformatter=:plain,
    legend=:bottomright
)
savefig(joinpath(@OUTPUT, "deaths.svg")) # hide


@df plot_data plot(:month, :Dadj_sum, group=:Jahr;lw=3,
    palette=lcolors, 
    xlabel="Monat",
    title="Adjustierte (2020) Sterbefallzahlen in Deutschland",
	left_margin=50px,
	xticks=xticks, 
    ylims=(0,110000), yticks=yticks, 
	yformatter=:plain,
    legend=:bottomright
)
savefig(joinpath(@OUTPUT, "adjusted_deaths.svg")) # hide


expected_deaths = combine(groupby(plot_data,:Jahr), 
    :D_sum => sum, 
    :Dadj_sum => sum)
expected_deaths[:,:D_sum_sum_EN] = round.(expected_deaths.D_sum_sum ./ [ N_sum[y] for y in expected_deaths.Jahr ] * EN_sum)
# Nicht korrigierte Rohdaten
@df expected_deaths plot(:Jahr,:D_sum_sum; label="data", lw=3,
	yformatter=:plain,
	left_margin=50px,
    legend=:bottomright)
@df expected_deaths plot!(:Jahr,:D_sum_sum_EN; label="N adjusted", lw=3)
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
Summing weekly mortality results in the total count of deceased persons in the given year,
in total numbers, as well as adjusted by age and gender.


\fig{./adjusted_deaths_years}

Yet, comparing these numbers unadjusted (`difference`) again is not fair, considering the population growth from 2016 to 2020:
`D_sum_sum` is the "data", `Dadj_sum_sum` is the "age-gender-adjusted" curve above.
`D_pop_adj` is the mortality adjusted to the assumption that all years had fixed population $E(N)$ used in the adjustment formula.

```julia:./total_deaths
D_2016_2021_Tage = Dict( j => d 
	for (j,d) in zip((2020,2019,2018, 2017, 2016), 
	                 (982489,  939520,  954874,  932263,  910899)))
expected_deaths[:,:totalxls] = 
	[ D_2016_2021_Tage[j] for j in expected_deaths.Jahr ]
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


When adjusted for age and gender, the year 2020 has the second lowest mortality (among years 2016 to 2020) in Germany.


2020 saw (how could this be computed?) deaths less/more than would have been expected
given average mortality rates from 2016-2020 and the joint age-gender distribution in 2020.
Only the directly preceding year 2019 had even lower mortality.
A fact that is notable because in 2020 no strong catch-up effect can be observed.



### Sanity check: deaths per year and gender

```julia:./deathtable
# hideall
moda[:,:jg] = collect(zip(moda.jahr, moda.geschlecht))
combine(groupby(moda,:jg),
    :D => sum) |> println

combine(groupby(moda,:jahr),
    :D => sum) |> println

using CSV
CSV.write("_assets/data.csv", moda)
```


\output{./deathtable}

