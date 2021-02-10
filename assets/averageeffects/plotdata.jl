# This file was generated, do not modify it. # hide
# hideall
adjusted[:,:cell] = collect(zip(adjusted.jahr, adjusted.kw))
plot_data = combine(groupby(adjusted,:cell),
    :D => sum,
    :Sadj => sum,
    :Sadj2020 => sum)
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
	xlims=(1,52),
    ylims=(0,32000), yticks=yticks, yformatter=:plain,
    legend=:bottomright
)
savefig(joinpath(@OUTPUT, "deaths.svg")) # hide


@df plot_data plot(:kw, :Sadj2020_sum, group=:Jahr;lw=3,
    palette=lcolors, 
    xlabel="Kalenderwoche",
    title="Adjustierte (2020) Sterbefallzahlen in Deutschland",
	xlims=(1,52),
    ylims=(0,32000), yticks=yticks, yformatter=:plain,
    legend=:bottomright
)
savefig(joinpath(@OUTPUT, "adjusted_deaths.svg")) # hide


# select(srd,tuple(:D, :expected))
expected_deaths = combine(groupby(plot_data,:Jahr), 
    :D_sum => sum, 
    :Sadj_sum => sum, 
    :Sadj2020_sum => sum)
# Nicht korrigierte Rohdaten
@df expected_deaths plot(:Jahr,:D_sum_sum; label="data", lw=3,
    legend=:bottomright)
@df expected_deaths plot!(:Jahr,:Sadj_sum_sum; label="age-sex adjusted", lw=3)
plt = @df expected_deaths plot!(:Jahr,:Sadj2020_sum_sum; label="age-sex adjusted 2020", lw=3)

savefig(joinpath(@OUTPUT, "adjusted_deaths_years.svg")) # hide
#fdplotly(json(plt)) # hide