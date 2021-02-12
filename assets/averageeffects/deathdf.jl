# This file was generated, do not modify it. # hide
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