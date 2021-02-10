+++
title = "Adjusted Weekly Mortality"
hascode = true
hasplotly = true
rss = ""
+++
@def tags = ["syntax", "code"]

Adjusting mortalities for age and gender for unbiased comparisons in an aging society.
# German Excess Death 2020? 


## Collecting values in a table
The lookup functions `population` and `deaths` are used in 
a multi-dimensional julia comprehension `[f(...) for ...]` and 
converted to a `DataFrame`.


```julia:./deathdf
# Julia sets of values in the condition variables:  # hide
include("./_assets/scripts/groups.jl") # hide
# load functions:  # hide
include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide

# sterberaten daten
srd = [ 
  ( alter = a,
    geschlecht=g, 
    jahr=j,
    N=population(alter=a, geschlecht=g, jahr=j),
    D=deaths(alter=a, geschlecht=g, jahr=j))
  for a in altersgruppen
  for g in geschlechter
  for j in jahre ] |> DataFrame;
srd[1:10,:] |> println
```

\show{./deathdf}

```julia:./agegroups
# hideall
println(join([ "[$(x.start),$(x.stop)[" for x in  altersgruppen ], ", "))
```


#### Total population (Sanity check)
Test whether `srd` groups sum to same value as original data in CSV file.
```julia:./populationtotal
gsrd = groupby(srd, :jahr)
N_sum = Dict(r[1] => r[2] for r in eachrow(combine(gsrd, :N=>sum)))

# grouped sum of population table for each Stichtag
gsrd = groupby(p, :Stichtag)
tmp = combine(gsrd, :Insgesamt=>sum)
tmp[:, :N_lookup] = [ get(N_sum, year(d)+1, missing) 
                      for d in tmp[:,1] ]
tmp |> println
```
\output{./populationtotal}


## Random Variables
Are the strict formulations in probability theory, for scientific notation.
### Observables:
- Deaths $D | J,W,G,A: \Omega \rightarrow \mathbb{N}$
- Population $N |J,G,A: \Omega \rightarrow \mathbb{N}$
### Conditioning Variables:
- Geschlechter/Gender $G: \Omega \rightarrow \{Männlich, Weiblich\}$
- Jahre/years $J: \Omega \rightarrow \{2016,\ldots,2020\}$
- Week: $W: \Omega \rightarrow \{1, \ldots, 53\}$
- altersgruppen, age: $A: \Omega \rightarrow \{\textoutput{./agegroups}\}$

## Probabilities and adjusted Expectations
Sterblichkeit adjustiert auf Durchschnitt:
$$
E^{adj}(D | J=j, W=w) = \sum_{a,g \in A, G} \left[ 
	\underbrace{E\left( \frac{D}{N} | A=a, G=g, J=j, W=w \right)}_{A \times G\text{ mortality rates}}
	\underbrace{P(A=a, G=g)}_{A \times G\text{ distribution}} 
  \right]
  	\underbrace{E(N)}_{\text{normalization}},
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


### Mittlere Wahrscheinlichkeit $P(A, G)$
```julia:./populationcellprob
using Statistics
using StatsPlots
srd[:,:P] = srd.N ./ [ N_sum[j] for j in srd.jahr ]
srd[:,:cell] = collect(zip(srd.alter,srd.geschlecht))
gsrd = groupby(srd, :cell)
P_mean = Dict([ r[1] => r[2] 
                for r in eachrow(combine(gsrd, :P=>mean))
			  ])
		
```

This plot is only for checking errors:
```julia:./populationcellprob2
# hideall
tmp = [ ( A=k[1].start, G=k[2], p = 100*v/(k[1].stop-k[1].start)) 
	    for (k,v) in P_mean ] |> DataFrame


@df tmp[sortperm(tmp.A),:] plot(:A,:p, group=:G, lw=3, legend=:bottomright,
    xlabel="Alter",
    ylabel="% Bevölkerung",
    title="Bevölkerungsanteil (mittel 2016-2020) in Deutschland",
)

savefig(joinpath(@OUTPUT, "Pmean.svg")) # hide
```

\fig{./Pmean}




```julia:./adjusted
adjusted = [
    ( jahr=j, alter=a, geschlecht=g,
      kw=kw,
    N = population(jahr=j,alter=a,geschlecht=g),
    D = deaths(jahr=j, alter=a, geschlecht=g, kw=kw),
    marginalP = P_mean[ (a,g) ])
    for a in altersgruppen, 
        kw in 1:53, 
        g in geschlechter,
        j in jahre
    if deaths(jahr=j,alter=a,geschlecht=g,kw=kw) isa Int] |> DataFrame
            
# Formel 3
EN_sum = mean(collect(values(N_sum)))
adjusted[:,:Dadj] = ( adjusted.D ./ adjusted.N ) .* adjusted.marginalP * EN_sum

adjusted[1:2,:] |> println
```
\output{./adjusted}


```julia:./plotdata
# hideall
adjusted[:,:cell] = collect(zip(adjusted.jahr, adjusted.kw))
plot_data = combine(groupby(adjusted,:cell),
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


# select(srd,tuple(:D, :expected))
expected_deaths = combine(groupby(plot_data,:Jahr), 
    :D_sum => sum, 
    :Dadj_sum => sum)
# Nicht korrigierte Rohdaten
@df expected_deaths plot(:Jahr,:D_sum_sum; label="data", lw=3,
	yformatter=:plain,
	left_margin=50px,
    legend=:bottomright)
@df expected_deaths plot!(:Jahr,:Dadj_sum_sum; label="age-sex adjusted", lw=3)

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


#### Alternative 
This is not computed
$E^{2020}(D | J=x)$: Sterblichkeit adjustiert auf Referenzjahr 2020 (Samuel Eckert?)
$$
E^{2020}(D | J=x) = \sum_{a,g \in A, G}\left[ 
	\underbrace{E\left( \frac{D}{N} | a=A, g=G, J=x \right)}_{A \times G\text{ mortality rates}}
	\underbrace{P(A=a, G=g | J=2020)}_{A \times G\text{ distribution}} 
  \right]
  	\underbrace{E(N | J=2020)}_{\text{normalization}}
$$


Die Alters- und Geschlechts-adjustierten Werte der Todesrate 
(korrigiert auf Alters- und Geschlechtsverteilung und bezogen auf Gesamtsterbezahl des Jahres 2020).
des Jahres 2020 sind bis zum Herbst unauffällig,
auch am Jahresende weniger auffällig als in den Rohdaten
(der Anteil älterer Bürger lag 2020 höher als im Schnitt).
Die Effekte 

\textoutput{./plotdata}


