@def title = "Decentral data preparation with julia?"
@def hascode = true
@def rss = ""
@def rss_title = "Decentral data preparation with julia?"
@def rss_pubdate = Date(2021, 2, 1)

@def tags = ["decentral", "data prep", "julia"]

# Discussion

\toc


## Tools
### How was julia language for data preparation?
Most actual data prep I did in `R` in the past.
So I compare this experience with `julia` 
(which I appreciate mainly as a programming language).

Clearly `julia` functions have been much simpler to write 
because R forces you to think in vectorized data, while
julia simply removes that extra thought.
That makes writing and reading and understanding clearer.
Of course, again, just a wonderful experience of expressing myself to the machine.

Yet, assertions (boundary checks) and age interval aggregation are prototyped, and could use a bit more rigor.

#### Range Aggregation?
I wonder, how to most generally solve a best estimate (possibly distribution) for
the counts in any range of years `olderthan:youngerthan`, 
based off the different age range data specifications (yearly and 5-yearly).
- population pyramid data (0:1:95, 95:MAX)
- mortalities data (0:25, 25:5:85, 85:MAX)
If you have an idea, I am curious to read it!
I will think a bit about it when I am forced to confront such problem again.

### Franklin
I liked literal programming in [Franklin](https://franklinjl.org/code/) and Firefox 
(quick iterations of editing/reviewing thanks to live updates without reloading).
Franklin is great for writing up (and then publish) analyses in julia.
The [templates](https://tlienart.github.io/FranklinTemplates.jl/)
are nice (Tufte style, too!).

#### Markdown
However, Markdown does not feel very natural to me.
With markdown, I cannot execute code in my emacs editor.
(Like with org).
I would so much prefer writing org!
So next will be to print julia [`Trie`](https://github.com/gkappler/Tries.jl)`{Int,`[`OrgEntry`](https://github.com/gkappler/OrgParser)`}` to some Franklin markdown.



## Was data accessible robustly for reproducible research? 
My impression from this exploration with 
### public data of the [German Statistisches Bundesamt](https://www-genesis.destatis.de/genesis/online): 
The population was a CSV file with that can robustly be used in science with general tools (removing some custom shinannigan header and footer).
The weekly mortalities have been a "Sonderauswertung", an XLSX file with human reader audience. 
Mimicking human lookup is data sudoku, and is bug-prone.
**There is space for data publishing improvement.**


There also is an API for data query from the Bundesamt.
The API was not used because the interface definition manual is a very comprehensive read.
For two specific dataset it was more effective to 
1. manually download data table files, 
2. parse them with standard `XLSX`, `CSV` packages, and 
3. wire the lookup in functions.
It would be a nice grant project to write a julia package to make the remote data available by julia function calls like in [InformationMycelium.jl](/reflection/#information_mycelium).



### google forms
Creating google forms is easy and nice and fast.
This data will be available as google spreadsheet.
These still need to be included in the Franklin julia scripts.

**What other options are there?**
A questionaire, even if complicated, is a simple [finite state machine](https://en.wikipedia.org/wiki/Finite-state_machine].
Using the OrGitBot state machine you can create fancy easy forms with the Telegram messenger.
Release will be soon!

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

### Can't we organize data prep of such data dezentrally?
How we share data, analyses, results, and thoughts online is the crucial question of the digital age.
The current answers are mostly tormenting for me.
I get used to services.
I love my linux machines and the servers I run independently.
How we can simplify and clarify information sharing keeps me up at night.


#### Information Mycelium
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

