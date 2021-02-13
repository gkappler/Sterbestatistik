# This file was generated, do not modify it. # hide
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