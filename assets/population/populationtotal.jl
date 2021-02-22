# This file was generated, do not modify it. # hide
# hideall
plot(
    bar(jahre, [ (N_sum[j]) for j in jahre],
        color=lcolors, 
        left_margin=50px,
        #ylims=(80000000,110000), yticks=yticks, 
        yformatter=:plain,
        title="Bevölkerung", legend=:none),
    bar(jahre, [ (N_sum[j]) for j in jahre],
        color=lcolors, 
        left_margin=50px,
        ylims=extrema(values(N_sum)), 
        yformatter=:plain,
        title="Bevölkerung", legend=:none)
)
savefig(joinpath(@OUTPUT, "population.svg")) 


function agplot(geschlecht="Insgesamt")
nam = repeat(altersgruppen, outer=length(jahre))
mn = [ 100*population(jahr=j, alter=a, geschlecht=geschlecht)/N_sum[j]
       for j in jahre
       for a in altersgruppen
       ]
sx = repeat(jahre, inner = length(altersgruppen))

groupedbar(string.(nam), mn, group = sx, ylabel = "% der Bevölkerung", 
           left_margin=50px,
           palette=lcolors, 
           title = "Veränderung der Altersgruppen-Verteilung $geschlecht")
end

for g in [ "Insgesamt", geschlechter... ]
	agplot(g)
	savefig(joinpath(@OUTPUT, "population-ages-$g.svg")) 
end



nam = repeat(altersgruppen, outer=length(geschlechter))
mn = [ 100*PAG_mean[(a, g)]
       for g in geschlechter
       for a in altersgruppen
       ]
sx = repeat(geschlechter, inner = length(altersgruppen))

groupedbar(string.(nam), mn, group = sx, ylabel = "% der Bevölkerung", 
           left_margin=50px,
           palette=lcolors, 
           title = "Durchschnittliche der Altersgruppen-Geschlechts-Verteilung")
savefig(joinpath(@OUTPUT, "PAG_mean.svg")) 



# grouped sum of raw population table for each Stichtag
tmp = combine(groupby(p, :Stichtag), 
              :Insgesamt=>sum)
tmp[:, :N_lookup] = [ get(N_sum, year(d)+1, missing) 
                      for d in tmp[:,1] ]
tmp |> println