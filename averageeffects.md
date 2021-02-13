+++
title = "Adjusted Weekly Mortality"
hascode = true
hasplotly = true
rss = ""
+++
@def tags = ["syntax", "code"]

# Adjusting weekly mortalities for age and gender 
for unbiased graphical comparisons in an aging society.

```julia:./deathdf
# hideall
# Julia sets of values in the condition variables:  # hide
include("./_assets/scripts/groups.jl") # hide
# load functions:  # hide
altersgruppen = altersgruppen_kw
include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide
```

```julia:./agegroups
# hideall
println(join([ "[$(x.start),$(x.stop)[" for x in  altersgruppen ], ", "))
```


## Adjusted data
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
plot_data = plot_data[(plot_data.D_sum .> 0) .| (plot_data.kw .<= 52),:]

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
[Official mortality analysis](https://www.destatis.de/DE/Themen/Querschnitt/Corona/_Grafik/_Interaktiv/woechentliche-sterbefallzahlen-jahre.html?nn=209016) shows a graph of weekly mortality from 2016-2020.
([Also check the more interactive visualization](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Sterbefaelle-Lebenserwartung/sterbefallzahlen.html).)

Our reproduction seems identical:
\fig{./deaths}

The age- and gender-adjusted mortality counts in 2020 are low until autumn.
The mortality increase in Winter 2020 is less pronounced than when looking at values 
biased by the confounders from an aging society.

\fig{./adjusted_deaths}


### Year aggregated mortality
The weekly mortalities cannot be consistently summed up to year-related statistics (because parts of the last week are part of the first weeks of suceeding year). 
The official statistics lists 53 weeks only for 2020, exaggerating the 2020 count below.
[Please see correct year aggregated statistics computed from adjusting by months.](/averageeffects_months/#year_aggregated_mortality)



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

