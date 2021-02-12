# This file was generated, do not modify it. # hide
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