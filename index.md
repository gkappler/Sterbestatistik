@def title = "German Excess Death 2020?"
@def tags = ["syntax", "code"]

# German Excess Death 2020?
This repository contains 
### Data
the official *data* from the "Statistisches Bundesamt" (in German),
  - Population :: by year, gender, and age (the data shown in population pyramids)
  - Death counts :: by week and year, also per gender and age.

### Analysis
The *analysis* aims at 
adjusting deaths statistics for 
bias effects in an aging population. 
Technically "average causal effects of year on mortalities", 
correct for age and gender.
Weekly adjusted death counts can be compared accross years 
without bias from the overall aging that occured from 2016 to 2020.

### Tutorial
This *tutorial* shows 
- how to prepare datasets in julia keyword functions
- Estimating average causal year-effects, corrected for age and gender.
- can such data prep code be shared efficiently with the community of information researchers.

On this data prep example I express data lookup as julia keyword functions 
(for providing value-conditions).
Calling a function is convenient.
Looking up values in tables is more tedious:


## Data
### **Data**: "Sterbefaelle-Lebenserwartung"
goal: julia function to look up information in official data tables.
```julia
deaths(year=2020, cw=1,
       geschlecht="Männlich",
       alter=50:60)
```

Source: [statistisches Bundesamt](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Sterbefaelle-Lebenserwartung/Tabellen/sonderauswertung-sterbefaelle.html) (Download [xlsx](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Sterbefaelle-Lebenserwartung/Tabellen/sonderauswertung-sterbefaelle.xlsx?__blob=publicationFile)),

The death count data is an **excel** file
with many tabs,
the gender needs to be looked up by tab
in the right one with data by calendar week.
The age groups are 0-30, then in 5-year groups, then more than 95.

### **Data**: Population statistics (pyramid)
goal: julia function to look up information in official data tables.
```julia
population(year=2020,
           geschlecht="Männlich",
           alter=50:60)
```

Source: [Statistisches Bundesamt, Tabelle 12411-0006](https://www-genesis.destatis.de/genesis//online?operation=table&code=12411-0006&bypass=true&levelindex=0&levelid=1612115589154#abreadcrumb)

The population statistics is a single
comma separated values file,
not simple, with some header information, and footer.
The age groups here are by year, with aggregation above 85.

