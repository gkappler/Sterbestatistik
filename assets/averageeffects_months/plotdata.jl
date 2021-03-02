# This file was generated, do not modify it. # hide
# hideall
moda[:,:cell] = collect(zip(moda.jahr, moda.month))
plot_data = combine(groupby(moda,:cell),
    :D => sum,
    :Dadj => sum)
plot_data[:,:Jahr] = [ x[1] for x in plot_data[:,1] ]
plot_data[:,:month] = [ x[2] for x in plot_data[:,1] ];
# plot_data = plot_data[(plot_data.D_sum .> 0) .| (plot_data.month .<= 52),:]

#using PlotlyJS
#plotly()
# Farben Bundesamt
yticks = 0:10000:110000
xticks = 1:12
@df plot_data plot(:month, :D_sum, group=:Jahr; lw=3, 
    palette=lcolors, 
    xlabel="Monat",
    title="Monatliche Sterbefallzahlen in Deutschland",
	left_margin=50px,
	xticks=xticks, 
	ylims=(0,110000), yticks=yticks, 
	yformatter=:plain,
    legend=:bottomright
)
savefig(joinpath(@OUTPUT, "deaths.svg")) # hide


@df plot_data plot(:month, :Dadj_sum, group=:Jahr;lw=3,
    palette=lcolors, 
    xlabel="Monat",
    title="Adjustierte (2020) Sterbefallzahlen in Deutschland",
	left_margin=50px,
	xticks=xticks, 
    ylims=(0,110000), yticks=yticks, 
	yformatter=:plain,
    legend=:bottomright
)
savefig(joinpath(@OUTPUT, "adjusted_deaths.svg")) # hide


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