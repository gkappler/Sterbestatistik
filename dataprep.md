+++
title = "Data preparation"
hascode = true
+++
@def tags = ["syntax", "code"]

A tutorial for *Scientific Data Preparation* with julia.
# German Excess Death 2020? 
formalizes the process of looking up the results of data function calls in data tables.
Lookup needs to be expressed in terms of a programming language, here julia.

Values need to be looked up 
for combinations of the following variables (and calendar week):
\input{julia}{/_assets/scripts/groups.jl}

As a human, I can lookup conveniently in the excel tables,
but the comma separates values are tedious.
What julia code is more simple?

### Population
The comma separated values (CSV) file would e.g. be loaded, trimmed and parsed 
\input{julia}{/_assets/scripts/population.jl}

This is not too painful and straight forward.
The aggregation with `UnitRange` is convenient
but can be further improved.


### Deaths statistics (XLSX)
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
