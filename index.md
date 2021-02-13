@def title = "German Excess Death 2020?"
@def tags = ["syntax", "code"]

### Tutorial
This *tutorial* shows 
- how to [prepare](/dataprep/) datasets in julia keyword functions
- reproduce [weekly mortality graph](/averageeffects/#reproduction_of_data-visualisation_of_the_statistisches_bundesamt)
- Estimating [average causal year-effects](/averageeffects_months/#year_aggregated_mortality), corrected for age and gender.
and discusses some ideas how data prep code can be shared efficiently 
with the community of information researchers.


# German Excess Death 2020?
This repository uses
## Data
from the official data from the German "Statistisches Bundesamt",
  - [Population](/dataprep#data_mortality_statistics): by year, gender, and age (the data shown in population pyramids)
  - [Death counts](/dataprep/#data_population_statistics_pyramid): by week and year, also per gender and age.


## Analysis
adjusts deaths statistics for bias effects in an aging population
(i.e. average causal effects of year on mortality, correct for age and gender).
Weekly and monthly adjusted death counts can be compared accross years 
without bias from the overall aging that occured from 2016 to 2020.




### Random Variables
Are the strict formulations in probability theory, for scientific notation.
#### Conditioning Variables:
- Jahre/years $J: \Omega \rightarrow \{2016,\ldots,2020\}$
- Week: $W: \Omega \rightarrow \{1, \ldots, 53\}$

- Geschlechter/Gender $G: \Omega \rightarrow \{Männlich, Weiblich\}$
- altersgruppen, age: $A: \Omega \rightarrow \{a_1, \ldots, a_k\}$
  

#### Observables:
- Deaths are observed $D | J,W,G,A: \Omega \rightarrow \mathbb{N}$
- Population $N |J,G,A: \Omega \rightarrow \mathbb{N}$

Note: death statistics are observed for each week (as well as year, gender, age), 
but population statistics are observed only for combinations of year, gender, and age.

## Probabilities and adjusted Expectations
Death counts at week $J=j, W=w$ can be adjusted for
- $P(A=a, G=g)$: average joint distribution of age and gender, 
- $E(N)$: average population count,
both averaged accross all observed years.

$E^{adj}(D | J=j, W=w) =$
$$
\sum_{a,g \in A, G} \left[ 
	\underbrace{E\left( \frac{D}{N} | A=a, G=g, J=j, W=w \right)}_{A \times G\text{ mortality rates}}
	\underbrace{P(A=a, G=g)}_{\text{average} A \times G\text{ distribution}} 
  \right]
  	\underbrace{E(N)}_{\text{average population count}},
$$
$\forall j \in \{2016,\ldots,2020\}, w \in \{1,\ldots,53\}$

### Notes regarding Notation (Photo Rolf)
were expanded with $W$ for week number.

Formel (1)
$$
P^{2016}( I_+=1 | G=g, A=a) = E\left[\frac{D}{N} | A=a, G=g, J=2016, W=w \right]
$$

Formel (2)
$$
P^{2020}_{adj}( + ) = E^{adj}(D | J, W) / E(N)
$$

Formel (3)
$$
P(A=a, G=g)
$$




