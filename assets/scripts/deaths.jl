using XLSX
d = XLSX.readxlsx("data/sonderauswertung-sterbefaelle.xlsx")
function deaths(; alter::UnitRange, geschlecht, jahr, kw=missing)
	if kw === missing
		return sum(Int[ deaths(;alter=alter,geschlecht=geschlecht, jahr=jahr,kw=i)
             for i in 1:53
             if deaths(;alter=alter,geschlecht=geschlecht, jahr=jahr, kw=i) isa Integer])
			 
	end
    @assert geschlecht in geschlechter
    if alter==85:MAX
        return deaths(;alter=85:90,geschlecht=geschlecht, jahr=jahr, kw=kw)+
            deaths(;alter=90:95,geschlecht=geschlecht, jahr=jahr, kw=kw)+
            deaths(;alter=95:MAX,geschlecht=geschlecht, jahr=jahr, kw=kw)
    end
    # @assert alter isa UnitRange && alter.stop-alter.start==5 && alter.start<=95
    if alter.start >= 95
		#@warn "alter" alter
        alter = 95:MAX
    end    
    if alter.stop <= 30
		#@warn "alter" alter
        alter = 0:30
    end
    # skipping 11 lines,
    zeile = 11 +
        # 16 lines blocks for years,
        (2020-jahr)*16 + 
        # 5 year steps beginning age 30
        max(0, (alter.start-25)/5)
    ## look up gender tab
    tab = d["D_2016_2020_KW_AG_$geschlecht"]
    # and check in cw column, skipping first 3
    r = tab[convert(Int,zeile), kw+3]
	r isa Integer ? r : 0
end
