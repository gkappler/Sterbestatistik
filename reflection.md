@def title = "Decentral data preparation with julia?"
@def hascode = true
@def rss = ""
@def rss_title = "Decentral data preparation with julia?"
@def rss_pubdate = Date(2021, 2, 1)

@def tags = ["decentral", "data prep", "julia"]

# Discussion
This page's [repository](https://github.com/gkappler/Sterbestatistik) details code how to 
prepare data from CSV and XLSX files in julia for statistical analyses,
and performes adjusting mortality for age and gender 
in the framework of conditional and average (causal) effects.

\toc



## How accessible was the open data?
My impression from this exploration with public data of the
### [German Statistisches Bundesamt](https://www-genesis.destatis.de/genesis/online):
Population data is a CSV file that can be used with general tools (removing some custom shinannigan header and footer).
The weekly mortalities have been a "Sonderauswertung", an XLSX file with human reader audience. 
Mimicking human lookup is data sudoku, and is bug-prone.
**There is space for data publishing improvement.**

There also is an API for data query from the Bundesamt.
The API was not used because the interface definition manual is a very comprehensive read.
For the two datasets used it was more effective to 
1. manually download data table files, 
2. parse them with standard `XLSX`, `CSV` packages, and 
3. wire the lookup in functions.
It would be a nice project to write a julia package to make the remote data available by julia function calls like in [InformationMycelium.jl](/reflection/#information_mycelium).

Die Daten des statistischen Bundesamtes sind verfügbar nach Auswahl von Spalten.
Es existiert auch ein API zur Abfrage der Daten des statistischen Bundesamtes.
Dieses wurde hier nicht verwendet, da die Definition der Schnittstelle sehr umfangreich ist.
Für spezifische Daten wie hier ist das manuelle Herunterladen und Auslesen mit Hilfsfunktionen schneller umzusetzen.


### Google Forms
Creating google forms for the expectation questionaire was easy and fast.
This data is be available as google spreadsheet and 
requires to be included in the Franklin julia scripts.

**What other options are there?**
A questionaire, even if complicated, is a simple [finite state machine](https://en.wikipedia.org/wiki/Finite-state_machine).
Using the OrGitBot state machine you can create fancy easy forms with the Telegram messenger.
Release will be soon!



## How was `julia` language for data preparation?
Writing `julia` functions have been much simpler 
than doing data preparation in `R` because `R` forces you to think in vectorized data.
(Before I did most data prep in `R` and 
appreciated `julia` mainly as a programming language.)
`Julia` simply removes that extra layer of thought.
That makes writing and reading and understanding clearer.
`Julia`, again, was just a wonderful experience of expressing myself to the machine.


### Franklin Markdown
I liked literal programming in [Franklin](https://franklinjl.org/code/)
(quick iterations of editing/reviewing thanks to live updates without reloading).
Franklin is great for writing up (and then publish) analyses in julia.
The [templates](https://tlienart.github.io/FranklinTemplates.jl/)
are nice, and have a Tufte style, too!

However, writing Markdown does not feel very natural to me.
With markdown, I cannot execute code in my emacs editor.
(Like with org).
I would so much prefer writing org!
So next will be to print julia [`Trie`](https://github.com/gkappler/Tries.jl)`{Int,`[`OrgEntry`](https://github.com/gkappler/OrgParser)`}` to some Franklin markdown.


## Was Data Preparation Painful?
This data preparation 
felt like solving
data sudoku.
Sometimes 
like catching fleas.
With the XLSX I got impatient
and wondered:
am I wasting time with a task
that the devil prepared
to catch my life?

This important official data should not be painful to use!
To not waste life, I wonder, how it should be...
Painful only for one person once 
(Instead of me *and* also all else who use this data!
Aren't all data analysts fed up with the data pain in 2020?)

Currently, assertions (age boundary checks) and age interval aggregation are prototyped, and could use more rigor.

### Range Aggregation?
How can counts in any range of years `olderthan:youngerthan`
estimated generally (possibly with distribution), 
based off different age interval-width data specifications (yearly and 5-yearly)?
- population pyramid data (0:1:95, 95:MAX)
- mortalities data (0:25, 25:5:85, 85:MAX)
If you have an idea, I am curious to read it!
I will think about it when I am forced to confront such problem again.


## Can we distribute data preparation dezentrally?
How we share data, analyses, results, and thoughts online is the crucial question of the digital age.
The current answers are mostly tormenting for me.
I get used to services.
I love my linux machines and the servers I run independently.
How we can simplify and clarify information sharing keeps me up at night.


### Information Mycelium
I task myself with the `InformationMycelium` package
```julia
using InformationMycelium
@mycelium github.com/gkappler/Sterbestatistik

deaths(country=:de, year=2020, cw=1,
       gender=:male,
	   age=50:60)
	   
population(year=2020,
           gender=:diverse, # or whatever
           age=50:60)
```

And then have the functions `population`, `deaths`, ... loaded into Main module by macro `mycelium`.

I would be interested to hear your ideas and opinion on
- keyword functions (lazy computations)?
- `Tables` interface (sql-like selections)?


- data standards (parsers) and
- functional mechanics



## Next steps
Data preparation never feels perfect.
Always keeps hurting a bit.
A next steps list helps
(to avoid the addiction of perfect):
- assert correct conditioning value
- `geschlecht`: internationalize, Symbol?
- all variables english?

Let me know what you find most important, please.

