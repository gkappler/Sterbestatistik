+++
title = "Data preparation"
hascode = true
+++
@def tags = ["syntax", "code"]

\toc

## Overview
On this data prep example I express data lookup as julia keyword functions 
(for providing value-conditions).
Calling a function is convenient.
Looking up values in tables is more tedious:

### **Data**: Mortality statistics
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

### **Data**: Population statistics (pyramid)
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


# A tutorial for *Scientific Data Preparation* with julia.

Values need to be looked up 
for combinations of the following variables (and calendar week):
\input{julia}{/_assets/scripts/groups.jl}

As a human, I can lookup conveniently in the excel tables,
but the comma separates values are tedious.

The process of looking up data values needs to be formalized.
Lookup needs to be expressed in terms of a programming language, here julia function calls.
What julia function will be more simple?

## Population
The comma separated values (CSV) file would e.g. be loaded, trimmed and parsed 
\input{julia}{/_assets/scripts/population.jl}

This is not too painful and straight forward.
The aggregation with `UnitRange` is convenient
but can be further improved.


## Deaths statistics (XLSX)
But now with the excel it is funny.
\input{julia}{/_assets/scripts/deaths.jl}

I am sure there is a better way to do this.
                
Example tuple for testing:
```julia:./deaths_example.jl
include("./_assets/scripts/groups.jl") # hide
include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide

f(;kw=missing, args...) = (N=population(; args...), D=deaths(; kw=kw,args...))

@show f(alter=0:30, geschlecht="Männlich", jahr=2020, kw=1)
@show f(alter=30:35, geschlecht="Männlich", jahr=2020)
```
\output{./deaths_example.jl}

## Next steps
Data preparation never feels perfect.
Always keeps hurting a bit.
A next steps list helps
(to avoid the addiction of perfect):
- assert correct conditioning value
- `geschlecht`: internationalize, Symbol?
- all variables english?

Let me know what you find most important, please.
