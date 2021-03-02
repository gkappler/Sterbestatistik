+++
title = "Data preparation"
hascode = true
+++
@def tags = ["syntax", "code"]

\toc

## A tutorial for *Scientific Data Preparation* with julia.

Values need to be looked up 
for combinations of the following variables (and calendar week or month):
\input{julia}{/_assets/scripts/groups.jl}

The process of looking up data values needs to be formalized.
Lookup needs to be expressed in terms of a programming language, here julia function calls.
What julia function will be more simple?

## Sources
On this data prep example I express data lookup as julia keyword functions 
(for providing value-conditions).
Calling a function is convenient.
Looking up values in tables is more tedious:

### Population statistics (pyramid)
**Goal**: julia function to look up information in official data tables.
```julia
population(year=2020,
           geschlecht="Männlich",
           alter=50:60)
```

**Source**: [Statistisches Bundesamt, Tabelle 12411-0006](https://www-genesis.destatis.de/genesis//online?operation=table&code=12411-0006&bypass=true&levelindex=0&levelid=1612115589154#abreadcrumb)

The population statistics is a single
comma separated values file,
not simple, with some header information, and footer.
The age groups here are by year, with aggregation above 85.

The comma separated values (CSV) file is loaded, trimmed and parsed straight forwardly
in [population.jl](https://github.com/gkappler/Sterbestatistik/blob/main/_assets/scripts/population.jl).
The aggregation with `UnitRange` is convenient
but can be further improved.

CAVEAT:
- Alternative Data (not used): [Pyramid](https://service.destatis.de/bevoelkerungspyramide/index.html#!y=2018&v=2)
- [Podcast](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Sterbefaelle-Lebenserwartung/Podcast/podcast-sterbefaelle.html)


### Mortality statistics
**Goal**: julia function to look up information in official data tables.
```julia
deaths(year=2020, cw=1,
       geschlecht="Männlich",
       alter=50:60)
```

**Source**: [statistisches Bundesamt, "Sterbefaelle-Lebenserwartung"](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Sterbefaelle-Lebenserwartung/Tabellen/sonderauswertung-sterbefaelle.html) (Download [xlsx](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Sterbefaelle-Lebenserwartung/Tabellen/sonderauswertung-sterbefaelle.xlsx?__blob=publicationFile)),

The death count data is an **excel** file
with many tabs,
the gender needs to be looked up by tab
in the right one with data by calendar week.
The age groups are 0-30, then in 5-year groups, then more than 95.

A human I can lookup conveniently in the excel tables
But formalizing julia lookup from excel is funny.
in [deaths.jl](https://github.com/gkappler/Sterbestatistik/blob/main/_assets/scripts/deaths.jl).

I am sure there is a better way to do this.
                
Example tuple for testing:
```julia:./deaths_example.jl
include("./_assets/scripts/groups.jl") # hide
altersgruppen = altersgruppen_months
include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide

f(;kw=missing, args...) = (N=population(; args...), D=deaths(; kw=kw,args...))

@show f(alter=0:30, geschlecht="Männlich", jahr=2020, kw=1)
@show f(alter=30:35, geschlecht="Männlich", jahr=2020)
```
\output{./deaths_example.jl}



[Read the results, or continue reading the details of data preparation:](/averageeffects_months/)



