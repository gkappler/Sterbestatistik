# This file was generated, do not modify it. # hide
include("./_assets/scripts/groups.jl") # hide
altersgruppen = altersgruppen_months
include("./_assets/scripts/population.jl") # hide
include("./_assets/scripts/deaths.jl") # hide

f(;kw=missing, args...) = (N=population(; args...), D=deaths(; kw=kw,args...))

@show f(alter=0:30, geschlecht="Männlich", jahr=2020, kw=1)
@show f(alter=30:35, geschlecht="Männlich", jahr=2020)