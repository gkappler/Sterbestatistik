# This file was generated, do not modify it. # hide
# hideall
moda[:,:jg] = collect(zip(moda.jahr, moda.geschlecht))
combine(groupby(moda,:jg),
    :D => sum) |> println

combine(groupby(moda,:jahr),
    :D => sum) |> println

using CSV
CSV.write("_assets/data.csv", moda)