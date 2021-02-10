@def title = "Decentral data preparation with julia?"
@def hascode = true
@def rss = ""
@def rss_title = "Decentral data preparation with julia?"
@def rss_pubdate = Date(2021, 2, 1)

@def tags = ["decentral", "data prep", "julia"]


Such data preparation 
feels like solving
a crossword puzzle.
Felt sometimes 
like catching fleas.
I often get impatient
and wonder:
am I wasting time with a task
that the devil prepared
to catch my life?

To not waste life, I wonder, how it should be...
so this official important data would not be painful to use.
Or painful only for one person once.
But then again,
are we not used to some data pain in 2020?

I wonder whether it would be best to have this data published a julia package, e.g.
```julia
using IMSterbestatistik
```
(where IM stands for Information Mycelium)

Or a InformationMycelium package
```julia
using InformationMycelium
@mycelium github.com/gkappler/Sterbestatistik
```
And then have the functions loaded into Main module by macro.

I would be interested to hear your idea and opinion.

## My impression from this exploration with public data: 
   - How easily can data published by state institutions be used for reproducible research? **space for improvement**
   - Publishing the scripts for data prep. 
   - Utility of julia language for data preparation,
   - can't we organize data prep of such data dezentrally?



# Datengrundlage
## Informations-Mycel
Die Daten des statistischen Bundesamtes sind Daten verfügbar nach Auswahl von Spalten.
Es existiert auch ein API zur Abfrage der Daten des statistischen Bundesamtes.
Dieses wurde hier nicht verwendet, da die Definition der Schnittstelle sehr umfangreich ist.
Für spezifische Daten wie hier ist das manuelle Herunterladen und Auslesen mit Hilfsfunktionen schneller umzusetzen.

CAVEAT:
- Alternative Data (not used): [Pyramide](https://service.destatis.de/bevoelkerungspyramide/index.html#!y=2018&v=2)
- [Podcast](https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Sterbefaelle-Lebenserwartung/Podcast/podcast-sterbefaelle.html)



