using CSV, DataFrames, StringEncodings

p = CSV.File(
    open(read, "data/12411-0006.csv", enc"ISO-8859-1");
    skipto=9, footerskip=4,
    delim=';', decimal=',',
    dateformat="dd.mm.yyy", 
    header=["Stichtag", "Altersgruppe","Männlich","Weiblich","Insgesamt" ]) |> DataFrame
p = p[p.Altersgruppe .!= "Insgesamt",:]

# Let's encode age ranges with UnitRange, and transform conveniently with CombinedParsers
using CombinedParsers
jahrp = Either("unter 1 Jahr" => 0:1,
               map(a -> a:a, 
                 Sequence(1, CombinedParsers.Numeric(Int),"-Jährige")),
               "85 Jahre und mehr" => 85:MAX-1,
               "Insgesamt" => 0:MAX-1)

p[!,"Altersgruppe"] = [ parse(jahrp, v)
                        for v in p[!,2] ];


using Dates
"better idea with Intervals?"
iseq(x,y) = [ e.start >= y.start && e.stop < y.stop
              for e in x ]
function population(; jahr, geschlecht="Insgesamt", alter)
    @assert geschlecht in geschlechter
    ## todo: boundary checks!
    rows = (p[:,1] .== Date(jahr-1,12,31)) .&
        iseq(p[:,2], alter)
    sum(p[rows, geschlecht])
end
