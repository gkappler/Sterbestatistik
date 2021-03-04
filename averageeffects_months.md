+++
title = "Adjusted Weekly Mortality"
hascode = true
hasplotly = true
rss = ""
+++
@def tags = ["syntax", "code"]

Adjusting mortalities for age and gender 
for an unbiased comparisons in an aging society, has there been
# German Excess Mortality in 2020? 
Before reading this document, please consider betting your expectation in our questionaire for a publication with 
[Prof. Rolf Steyer](https://www.metheval.uni-jena.de/team_mitarbeiter.php?select=1):


[Yes, take me to the questionaire!](https://docs.google.com/forms/d/e/1FAIpQLScXsUuYoDmr5vBBh2cvXrwy1q3gs_JW99k4g6etx_uZ5-8oeQ/viewform?usp=sf_link)


```julia:./deathdf
# hideall
# Julia sets of values in the condition variables:  # hide
include("./_assets/scripts/groups.jl") # hide
# load functions:  # hide
altersgruppen = altersgruppen_months
include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide
```

```julia:./agegroups
# hideall
println(join([ "[$(x.start),$(x.stop)[" for x in  altersgruppen ], ", "))
```

### Adjusted data
For adjustment, age and gender specific mortality is estimated for each calendar week, 
from  `population` as well as `deaths` data,
and adjusted according to the [formula](/#probabilities_and_adjusted_expectations),
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


## Data-Visualisation in style of *Statistisches Bundesamt*
See also the weekly mortality from 2016-2020 [comparison with official plotting](/averageeffects/#reproduction_of_data-visualisation_of_the_statistisches_bundesamt).

\fig{./deaths}

In an aging society the actual mortality counts are biased.

\fig{./adjusted_deaths}

The age- and gender-adjusted mortality counts in 2020 are generally lower than the unadjusted counts
because the German population has been steadily aging in recent years.

### Year aggregated mortality
The total count of deceased persons in the given year is computed by summing monthly mortality results,
in total numbers, as well as adjusted by age and gender.

\fig{./adjusted_deaths_years}


When adjusted for age and gender, the year 2020 has the second lowest mortality (among years 2016 to 2020) in Germany.
Only the directly preceding year 2019 had even lower mortality.
A fact that is notable because in 2020 no strong catch-up effect can be observed.

```julia:./total_deaths
# hideall
D_2016_2021_Tage = Dict( j => d 
	for (j,d) in zip((2020,2019,2018, 2017, 2016), 
	                 (982489,  939520,  954874,  932263,  910899)))
expected_deaths[:,:totalxls] = 
	[ D_2016_2021_Tage[j] for j in expected_deaths.Jahr ]
println(select(expected_deaths, "totalxls"=>"Total", "D_sum_sum"=>"Total sum", "D_sum_sum_EN" => "N adjusted", "Dadj_sum_sum" => "age-gender adjusted"))
```
\output{./total_deaths}

`Total` is the crude counts (`Total sum` is for sanity check), `age-gender adjusted` is the mortalities adjusted to average distribution of age and gender accross 2016:2020.
`N adjusted` is the mortality adjusted to the assumption that all years had fixed population $E(N)$ used in the adjustment formula.

<!-- Yet, comparing these numbers unadjusted (`difference`) again is not fair, considering the population growth from 2016 to 2020: -->

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

## Print & Media references:
- https://www.br.de/nachrichten/wissen/sind-2020-weniger-menschen-gestorben-als-in-den-jahren-davor
