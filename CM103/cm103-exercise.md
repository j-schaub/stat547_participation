cm103 Worksheet
================

``` r
suppressPackageStartupMessages(library(tidyverse)) # Loads purrr, too
library(repurrrsive) # Contains data examples
library(listviewer) # For viewing JSON/lists interactively
library(knitr)
```

Resources
---------

This week, we'll be drawing from [Jenny Bryan's `purrr` tutorial](https://jennybc.github.io/purrr-tutorial/). Specifically:

-   The [`map` tutorial](https://jennybc.github.io/purrr-tutorial/ls01_map-name-position-shortcuts.html)
-   The [GitHub users tutorial](https://jennybc.github.io/purrr-tutorial/ls02_map-extraction-advanced.html) is similar.

In addition:

-   Do you feel that you need a refresher on lists and vectors in R? Check out the [Vectors and Lists](https://jennybc.github.io/purrr-tutorial/bk00_vectors-and-lists.html) part of the tutorial.
-   Are you familiar with the `apply` family of functions in Base R? You might find Jenny's ["Relationship to base and plyr functions"](https://jennybc.github.io/purrr-tutorial/bk01_base-functions.html) great for bridging the gap to `purrr`.

Review Vectors and Lists
------------------------

Vectors:

-   hold multiple entries of the same type.
-   coerced to the least-informative data type in the vector.
-   subset with single square brackets

Lists:

-   hold multiple entries of anything.
-   no entries are coerced (as a result of being able to hold anything)
-   subset with `[`, `[[`, or `$`.

Review Vectorization
--------------------

= element-wise application of a function.

Examples:

``` r
(1:10) ^ 2
```

    ##  [1]   1   4   9  16  25  36  49  64  81 100

``` r
(1:10) * (1:2)
```

    ##  [1]  1  4  3  8  5 12  7 16  9 20

``` r
commute <- c(40, 20, 35, 15)
person <- c("Parveen", "Leo", "Shawn", "Emmotions")
str_c(person, " takes ", commute, " minutes to commute to work.")
```

    ## [1] "Parveen takes 40 minutes to commute to work."  
    ## [2] "Leo takes 20 minutes to commute to work."      
    ## [3] "Shawn takes 35 minutes to commute to work."    
    ## [4] "Emmotions takes 15 minutes to commute to work."

`purrr`
-------

`purrr` is great when vectorization does not apply!

Particularly useful if your data is in JSON format.

Example:

1.  Explore the `wesanderson` list (comes with `repurrrsive` package). Hint: `str()` might help. It's a list of vectors.
2.  Use what you know about R to write code that extracts a vector of the first elements of each vector contained in `wesanderson`.

``` r
wesanderson
```

    ## $GrandBudapest
    ## [1] "#F1BB7B" "#FD6467" "#5B1A18" "#D67236"
    ## 
    ## $Moonrise1
    ## [1] "#F3DF6C" "#CEAB07" "#D5D5D3" "#24281A"
    ## 
    ## $Royal1
    ## [1] "#899DA4" "#C93312" "#FAEFD1" "#DC863B"
    ## 
    ## $Moonrise2
    ## [1] "#798E87" "#C27D38" "#CCC591" "#29211F"
    ## 
    ## $Cavalcanti
    ## [1] "#D8B70A" "#02401B" "#A2A475" "#81A88D" "#972D15"
    ## 
    ## $Royal2
    ## [1] "#9A8822" "#F5CDB4" "#F8AFA8" "#FDDDA0" "#74A089"
    ## 
    ## $GrandBudapest2
    ## [1] "#E6A0C4" "#C6CDF7" "#D8A499" "#7294D4"
    ## 
    ## $Moonrise3
    ## [1] "#85D4E3" "#F4B5BD" "#9C964A" "#CDC08C" "#FAD77B"
    ## 
    ## $Chevalier
    ## [1] "#446455" "#FDD262" "#D3DDDC" "#C7B19C"
    ## 
    ## $Zissou
    ## [1] "#3B9AB2" "#78B7C5" "#EBCC2A" "#E1AF00" "#F21A00"
    ## 
    ## $FantasticFox
    ## [1] "#DD8D29" "#E2D200" "#46ACC8" "#E58601" "#B40F20"
    ## 
    ## $Darjeeling
    ## [1] "#FF0000" "#00A08A" "#F2AD00" "#F98400" "#5BBCD6"
    ## 
    ## $Rushmore
    ## [1] "#E1BD6D" "#EABE94" "#0B775E" "#35274A" "#F2300F"
    ## 
    ## $BottleRocket
    ## [1] "#A42820" "#5F5647" "#9B110E" "#3F5151" "#4E2A1E" "#550307" "#0C1707"
    ## 
    ## $Darjeeling2
    ## [1] "#ECCBAE" "#046C9A" "#D69C4E" "#ABDDDE" "#000000"

``` r
str(wesanderson)
```

    ## List of 15
    ##  $ GrandBudapest : chr [1:4] "#F1BB7B" "#FD6467" "#5B1A18" "#D67236"
    ##  $ Moonrise1     : chr [1:4] "#F3DF6C" "#CEAB07" "#D5D5D3" "#24281A"
    ##  $ Royal1        : chr [1:4] "#899DA4" "#C93312" "#FAEFD1" "#DC863B"
    ##  $ Moonrise2     : chr [1:4] "#798E87" "#C27D38" "#CCC591" "#29211F"
    ##  $ Cavalcanti    : chr [1:5] "#D8B70A" "#02401B" "#A2A475" "#81A88D" ...
    ##  $ Royal2        : chr [1:5] "#9A8822" "#F5CDB4" "#F8AFA8" "#FDDDA0" ...
    ##  $ GrandBudapest2: chr [1:4] "#E6A0C4" "#C6CDF7" "#D8A499" "#7294D4"
    ##  $ Moonrise3     : chr [1:5] "#85D4E3" "#F4B5BD" "#9C964A" "#CDC08C" ...
    ##  $ Chevalier     : chr [1:4] "#446455" "#FDD262" "#D3DDDC" "#C7B19C"
    ##  $ Zissou        : chr [1:5] "#3B9AB2" "#78B7C5" "#EBCC2A" "#E1AF00" ...
    ##  $ FantasticFox  : chr [1:5] "#DD8D29" "#E2D200" "#46ACC8" "#E58601" ...
    ##  $ Darjeeling    : chr [1:5] "#FF0000" "#00A08A" "#F2AD00" "#F98400" ...
    ##  $ Rushmore      : chr [1:5] "#E1BD6D" "#EABE94" "#0B775E" "#35274A" ...
    ##  $ BottleRocket  : chr [1:7] "#A42820" "#5F5647" "#9B110E" "#3F5151" ...
    ##  $ Darjeeling2   : chr [1:5] "#ECCBAE" "#046C9A" "#D69C4E" "#ABDDDE" ...

``` r
str(wesanderson[2])
```

    ## List of 1
    ##  $ Moonrise1: chr [1:4] "#F3DF6C" "#CEAB07" "#D5D5D3" "#24281A"

``` r
#2.
lapply(wesanderson, `[[`, 1) %>% 
  kable()
```

<table class="kable_wrapper">
<tbody>
<tr>
<td>
| x        |
|:---------|
| \#F1BB7B |

</td>
<td>
| x        |
|:---------|
| \#F3DF6C |

</td>
<td>
| x        |
|:---------|
| \#899DA4 |

</td>
<td>
| x        |
|:---------|
| \#798E87 |

</td>
<td>
| x        |
|:---------|
| \#D8B70A |

</td>
<td>
| x        |
|:---------|
| \#9A8822 |

</td>
<td>
| x        |
|:---------|
| \#E6A0C4 |

</td>
<td>
| x        |
|:---------|
| \#85D4E3 |

</td>
<td>
| x        |
|:---------|
| \#446455 |

</td>
<td>
| x        |
|:---------|
| \#3B9AB2 |

</td>
<td>
| x        |
|:---------|
| \#DD8D29 |

</td>
<td>
| x        |
|:---------|
| \#FF0000 |

</td>
<td>
| x        |
|:---------|
| \#E1BD6D |

</td>
<td>
| x        |
|:---------|
| \#A42820 |

</td>
<td>
| x        |
|:---------|
| \#ECCBAE |

</td>
</tr>
</tbody>
</table>
``` r
# or...
x <- character(0)
for (i in 1:length(wesanderson)) x[i] <- wesanderson[[i]][1]
x
```

    ##  [1] "#F1BB7B" "#F3DF6C" "#899DA4" "#798E87" "#D8B70A" "#9A8822" "#E6A0C4"
    ##  [8] "#85D4E3" "#446455" "#3B9AB2" "#DD8D29" "#FF0000" "#E1BD6D" "#A42820"
    ## [15] "#ECCBAE"

`str()` is not always useful! Try checking the structure of `got_chars` (= Game of Thrones characters):

``` r
str(got_chars)
```

    ## List of 30
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1022"
    ##   ..$ id         : int 1022
    ##   ..$ name       : chr "Theon Greyjoy"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Ironborn"
    ##   ..$ born       : chr "In 278 AC or 279 AC, at Pyke"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:3] "Prince of Winterfell" "Captain of Sea Bitch" "Lord of the Iron Islands (by law of the green lands)"
    ##   ..$ aliases    : chr [1:4] "Prince of Fools" "Theon Turncloak" "Reek" "Theon Kinslayer"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Greyjoy of Pyke"
    ##   ..$ books      : chr [1:3] "A Game of Thrones" "A Storm of Swords" "A Feast for Crows"
    ##   ..$ povBooks   : chr [1:2] "A Clash of Kings" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Alfie Allen"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1052"
    ##   ..$ id         : int 1052
    ##   ..$ name       : chr "Tyrion Lannister"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr ""
    ##   ..$ born       : chr "In 273 AC, at Casterly Rock"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:2] "Acting Hand of the King (former)" "Master of Coin (former)"
    ##   ..$ aliases    : chr [1:11] "The Imp" "Halfman" "The boyman" "Giant of Lannister" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/2044"
    ##   ..$ allegiances: chr "House Lannister of Casterly Rock"
    ##   ..$ books      : chr [1:2] "A Feast for Crows" "The World of Ice and Fire"
    ##   ..$ povBooks   : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Peter Dinklage"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1074"
    ##   ..$ id         : int 1074
    ##   ..$ name       : chr "Victarion Greyjoy"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Ironborn"
    ##   ..$ born       : chr "In 268 AC or before, at Pyke"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:2] "Lord Captain of the Iron Fleet" "Master of the Iron Victory"
    ##   ..$ aliases    : chr "The Iron Captain"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Greyjoy of Pyke"
    ##   ..$ books      : chr [1:3] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords"
    ##   ..$ povBooks   : chr [1:2] "A Feast for Crows" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr ""
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1109"
    ##   ..$ id         : int 1109
    ##   ..$ name       : chr "Will"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr ""
    ##   ..$ born       : chr ""
    ##   ..$ died       : chr "In 297 AC, at Haunted Forest"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr ""
    ##   ..$ aliases    : chr ""
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: list()
    ##   ..$ books      : chr "A Clash of Kings"
    ##   ..$ povBooks   : chr "A Game of Thrones"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr "Bronson Webb"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1166"
    ##   ..$ id         : int 1166
    ##   ..$ name       : chr "Areo Hotah"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Norvoshi"
    ##   ..$ born       : chr "In 257 AC or before, at Norvos"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr "Captain of the Guard at Sunspear"
    ##   ..$ aliases    : chr ""
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Nymeros Martell of Sunspear"
    ##   ..$ books      : chr [1:3] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords"
    ##   ..$ povBooks   : chr [1:2] "A Feast for Crows" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:2] "Season 5" "Season 6"
    ##   ..$ playedBy   : chr "DeObia Oparei"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1267"
    ##   ..$ id         : int 1267
    ##   ..$ name       : chr "Chett"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr ""
    ##   ..$ born       : chr "At Hag's Mire"
    ##   ..$ died       : chr "In 299 AC, at Fist of the First Men"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr ""
    ##   ..$ aliases    : chr ""
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: list()
    ##   ..$ books      : chr [1:2] "A Game of Thrones" "A Clash of Kings"
    ##   ..$ povBooks   : chr "A Storm of Swords"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr ""
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1295"
    ##   ..$ id         : int 1295
    ##   ..$ name       : chr "Cressen"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr ""
    ##   ..$ born       : chr "In 219 AC or 220 AC"
    ##   ..$ died       : chr "In 299 AC, at Dragonstone"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr "Maester"
    ##   ..$ aliases    : chr ""
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: list()
    ##   ..$ books      : chr [1:2] "A Storm of Swords" "A Feast for Crows"
    ##   ..$ povBooks   : chr "A Clash of Kings"
    ##   ..$ tvSeries   : chr "Season 2"
    ##   ..$ playedBy   : chr "Oliver Ford"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/130"
    ##   ..$ id         : int 130
    ##   ..$ name       : chr "Arianne Martell"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr "Dornish"
    ##   ..$ born       : chr "In 276 AC, at Sunspear"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr "Princess of Dorne"
    ##   ..$ aliases    : chr ""
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Nymeros Martell of Sunspear"
    ##   ..$ books      : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ povBooks   : chr "A Feast for Crows"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr ""
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1303"
    ##   ..$ id         : int 1303
    ##   ..$ name       : chr "Daenerys Targaryen"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr "Valyrian"
    ##   ..$ born       : chr "In 284 AC, at Dragonstone"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:5] "Queen of the Andals and the Rhoynar and the First Men, Lord of the Seven Kingdoms" "Khaleesi of the Great Grass Sea" "Breaker of Shackles/Chains" "Queen of Meereen" ...
    ##   ..$ aliases    : chr [1:11] "Dany" "Daenerys Stormborn" "The Unburnt" "Mother of Dragons" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/1346"
    ##   ..$ allegiances: chr "House Targaryen of King's Landing"
    ##   ..$ books      : chr "A Feast for Crows"
    ##   ..$ povBooks   : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Emilia Clarke"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1319"
    ##   ..$ id         : int 1319
    ##   ..$ name       : chr "Davos Seaworth"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Westeros"
    ##   ..$ born       : chr "In 260 AC or before, at King's Landing"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:4] "Ser" "Lord of the Rainwood" "Admiral of the Narrow Sea" "Hand of the King"
    ##   ..$ aliases    : chr [1:5] "Onion Knight" "Davos Shorthand" "Ser Onions" "Onion Lord" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/1676"
    ##   ..$ allegiances: chr [1:2] "House Baratheon of Dragonstone" "House Seaworth of Cape Wrath"
    ##   ..$ books      : chr "A Feast for Crows"
    ##   ..$ povBooks   : chr [1:3] "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:5] "Season 2" "Season 3" "Season 4" "Season 5" ...
    ##   ..$ playedBy   : chr "Liam Cunningham"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/148"
    ##   ..$ id         : int 148
    ##   ..$ name       : chr "Arya Stark"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr "Northmen"
    ##   ..$ born       : chr "In 289 AC, at Winterfell"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr "Princess"
    ##   ..$ aliases    : chr [1:16] "Arya Horseface" "Arya Underfoot" "Arry" "Lumpyface" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Stark of Winterfell"
    ##   ..$ books      : list()
    ##   ..$ povBooks   : chr [1:5] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Feast for Crows" ...
    ##   ..$ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Maisie Williams"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/149"
    ##   ..$ id         : int 149
    ##   ..$ name       : chr "Arys Oakheart"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Reach"
    ##   ..$ born       : chr "At Old Oak"
    ##   ..$ died       : chr "In 300 AC, at the Greenblood"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr "Ser"
    ##   ..$ aliases    : chr ""
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Oakheart of Old Oak"
    ##   ..$ books      : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ povBooks   : chr "A Feast for Crows"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr ""
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/150"
    ##   ..$ id         : int 150
    ##   ..$ name       : chr "Asha Greyjoy"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr "Ironborn"
    ##   ..$ born       : chr "In 275 AC or 276 AC, at Pyke"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:3] "Princess" "Captain of the Black Wind" "Conqueror of Deepwood Motte"
    ##   ..$ aliases    : chr [1:2] "Esgred" "The Kraken's Daughter"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/1372"
    ##   ..$ allegiances: chr [1:2] "House Greyjoy of Pyke" "House Ironmaker"
    ##   ..$ books      : chr [1:2] "A Game of Thrones" "A Clash of Kings"
    ##   ..$ povBooks   : chr [1:2] "A Feast for Crows" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:3] "Season 2" "Season 3" "Season 4"
    ##   ..$ playedBy   : chr "Gemma Whelan"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/168"
    ##   ..$ id         : int 168
    ##   ..$ name       : chr "Barristan Selmy"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Westeros"
    ##   ..$ born       : chr "In 237 AC"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:2] "Ser" "Hand of the Queen"
    ##   ..$ aliases    : chr [1:5] "Barristan the Bold" "Arstan Whitebeard" "Ser Grandfather" "Barristan the Old" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr [1:2] "House Selmy of Harvest Hall" "House Targaryen of King's Landing"
    ##   ..$ books      : chr [1:5] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Feast for Crows" ...
    ##   ..$ povBooks   : chr "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:4] "Season 1" "Season 3" "Season 4" "Season 5"
    ##   ..$ playedBy   : chr "Ian McElhinney"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/2066"
    ##   ..$ id         : int 2066
    ##   ..$ name       : chr "Varamyr"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Free Folk"
    ##   ..$ born       : chr "At a village Beyond the Wall"
    ##   ..$ died       : chr "In 300 AC, at a village Beyond the Wall"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr ""
    ##   ..$ aliases    : chr [1:3] "Varamyr Sixskins" "Haggon" "Lump"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: list()
    ##   ..$ books      : chr "A Storm of Swords"
    ##   ..$ povBooks   : chr "A Dance with Dragons"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr ""
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/208"
    ##   ..$ id         : int 208
    ##   ..$ name       : chr "Brandon Stark"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Northmen"
    ##   ..$ born       : chr "In 290 AC, at Winterfell"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr "Prince of Winterfell"
    ##   ..$ aliases    : chr [1:3] "Bran" "Bran the Broken" "The Winged Wolf"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Stark of Winterfell"
    ##   ..$ books      : chr "A Feast for Crows"
    ##   ..$ povBooks   : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:5] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Isaac Hempstead-Wright"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/216"
    ##   ..$ id         : int 216
    ##   ..$ name       : chr "Brienne of Tarth"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr ""
    ##   ..$ born       : chr "In 280 AC"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr ""
    ##   ..$ aliases    : chr [1:3] "The Maid of Tarth" "Brienne the Beauty" "Brienne the Blue"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr [1:3] "House Baratheon of Storm's End" "House Stark of Winterfell" "House Tarth of Evenfall Hall"
    ##   ..$ books      : chr [1:3] "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ povBooks   : chr "A Feast for Crows"
    ##   ..$ tvSeries   : chr [1:5] "Season 2" "Season 3" "Season 4" "Season 5" ...
    ##   ..$ playedBy   : chr "Gwendoline Christie"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/232"
    ##   ..$ id         : int 232
    ##   ..$ name       : chr "Catelyn Stark"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr "Rivermen"
    ##   ..$ born       : chr "In 264 AC, at Riverrun"
    ##   ..$ died       : chr "In 299 AC, at the Twins"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr "Lady of Winterfell"
    ##   ..$ aliases    : chr [1:5] "Catelyn Tully" "Lady Stoneheart" "The Silent Sistet" "Mother Mercilesr" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/339"
    ##   ..$ allegiances: chr [1:2] "House Stark of Winterfell" "House Tully of Riverrun"
    ##   ..$ books      : chr [1:2] "A Feast for Crows" "A Dance with Dragons"
    ##   ..$ povBooks   : chr [1:3] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords"
    ##   ..$ tvSeries   : chr [1:3] "Season 1" "Season 2" "Season 3"
    ##   ..$ playedBy   : chr "Michelle Fairley"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/238"
    ##   ..$ id         : int 238
    ##   ..$ name       : chr "Cersei Lannister"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr "Westerman"
    ##   ..$ born       : chr "In 266 AC, at Casterly Rock"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:5] "Light of the West" "Queen Dowager" "Protector of the Realm" "Lady of Casterly Rock" ...
    ##   ..$ aliases    : list()
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/901"
    ##   ..$ allegiances: chr "House Lannister of Casterly Rock"
    ##   ..$ books      : chr [1:3] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords"
    ##   ..$ povBooks   : chr [1:2] "A Feast for Crows" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Lena Headey"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/339"
    ##   ..$ id         : int 339
    ##   ..$ name       : chr "Eddard Stark"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Northmen"
    ##   ..$ born       : chr "In 263 AC, at Winterfell"
    ##   ..$ died       : chr "In 299 AC, at Great Sept of Baelor in King's Landing"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr [1:5] "Lord of Winterfell" "Warden of the North" "Hand of the King" "Protector of the Realm" ...
    ##   ..$ aliases    : chr [1:3] "Ned" "The Ned" "The Quiet Wolf"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/232"
    ##   ..$ allegiances: chr "House Stark of Winterfell"
    ##   ..$ books      : chr [1:5] "A Clash of Kings" "A Storm of Swords" "A Feast for Crows" "A Dance with Dragons" ...
    ##   ..$ povBooks   : chr "A Game of Thrones"
    ##   ..$ tvSeries   : chr [1:2] "Season 1" "Season 6"
    ##   ..$ playedBy   : chr [1:3] "Sean Bean" "Sebastian Croft" "Robert Aramayo"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/529"
    ##   ..$ id         : int 529
    ##   ..$ name       : chr "Jaime Lannister"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Westerlands"
    ##   ..$ born       : chr "In 266 AC, at Casterly Rock"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:3] "Ser" "Lord Commander of the Kingsguard" "Warden of the East (formerly)"
    ##   ..$ aliases    : chr [1:4] "The Kingslayer" "The Lion of Lannister" "The Young Lion" "Cripple"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Lannister of Casterly Rock"
    ##   ..$ books      : chr [1:2] "A Game of Thrones" "A Clash of Kings"
    ##   ..$ povBooks   : chr [1:3] "A Storm of Swords" "A Feast for Crows" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:5] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Nikolaj Coster-Waldau"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/576"
    ##   ..$ id         : int 576
    ##   ..$ name       : chr "Jon Connington"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Stormlands"
    ##   ..$ born       : chr "In or between 263 AC and 265 AC"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:3] "Lord of Griffin's Roost" "Hand of the King" "Hand of the True King"
    ##   ..$ aliases    : chr "Griffthe Mad King's Hand"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr [1:2] "House Connington of Griffin's Roost" "House Targaryen of King's Landing"
    ##   ..$ books      : chr [1:3] "A Storm of Swords" "A Feast for Crows" "The World of Ice and Fire"
    ##   ..$ povBooks   : chr "A Dance with Dragons"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr ""
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/583"
    ##   ..$ id         : int 583
    ##   ..$ name       : chr "Jon Snow"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Northmen"
    ##   ..$ born       : chr "In 283 AC"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr "Lord Commander of the Night's Watch"
    ##   ..$ aliases    : chr [1:8] "Lord Snow" "Ned Stark's Bastard" "The Snow of Winterfell" "The Crow-Come-Over" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Stark of Winterfell"
    ##   ..$ books      : chr "A Feast for Crows"
    ##   ..$ povBooks   : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Kit Harington"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/60"
    ##   ..$ id         : int 60
    ##   ..$ name       : chr "Aeron Greyjoy"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Ironborn"
    ##   ..$ born       : chr "In or between 269 AC and 273 AC, at Pyke"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr [1:2] "Priest of the Drowned God" "Captain of the Golden Storm (formerly)"
    ##   ..$ aliases    : chr [1:2] "The Damphair" "Aeron Damphair"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Greyjoy of Pyke"
    ##   ..$ books      : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Dance with Dragons"
    ##   ..$ povBooks   : chr "A Feast for Crows"
    ##   ..$ tvSeries   : chr "Season 6"
    ##   ..$ playedBy   : chr "Michael Feast"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/605"
    ##   ..$ id         : int 605
    ##   ..$ name       : chr "Kevan Lannister"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr ""
    ##   ..$ born       : chr "In 244 AC"
    ##   ..$ died       : chr "In 300 AC, at King's Landing"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr [1:4] "Ser" "Master of laws" "Lord Regent" "Protector of the Realm"
    ##   ..$ aliases    : chr ""
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/327"
    ##   ..$ allegiances: chr "House Lannister of Casterly Rock"
    ##   ..$ books      : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Feast for Crows"
    ##   ..$ povBooks   : chr "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:4] "Season 1" "Season 2" "Season 5" "Season 6"
    ##   ..$ playedBy   : chr "Ian Gelder"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/743"
    ##   ..$ id         : int 743
    ##   ..$ name       : chr "Melisandre"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr "Asshai"
    ##   ..$ born       : chr "At Unknown"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr ""
    ##   ..$ aliases    : chr [1:5] "The Red Priestess" "The Red Woman" "The King's Red Shadow" "Lady Red" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: list()
    ##   ..$ books      : chr [1:3] "A Clash of Kings" "A Storm of Swords" "A Feast for Crows"
    ##   ..$ povBooks   : chr "A Dance with Dragons"
    ##   ..$ tvSeries   : chr [1:5] "Season 2" "Season 3" "Season 4" "Season 5" ...
    ##   ..$ playedBy   : chr "Carice van Houten"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/751"
    ##   ..$ id         : int 751
    ##   ..$ name       : chr "Merrett Frey"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Rivermen"
    ##   ..$ born       : chr "In 262 AC"
    ##   ..$ died       : chr "In 300 AC, at Near Oldstones"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr ""
    ##   ..$ aliases    : chr "Merrett Muttonhead"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/712"
    ##   ..$ allegiances: chr "House Frey of the Crossing"
    ##   ..$ books      : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Feast for Crows" "A Dance with Dragons"
    ##   ..$ povBooks   : chr "A Storm of Swords"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr ""
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/844"
    ##   ..$ id         : int 844
    ##   ..$ name       : chr "Quentyn Martell"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Dornish"
    ##   ..$ born       : chr "In 281 AC, at Sunspear, Dorne"
    ##   ..$ died       : chr "In 300 AC, at Meereen"
    ##   ..$ alive      : logi FALSE
    ##   ..$ titles     : chr "Prince"
    ##   ..$ aliases    : chr [1:4] "Frog" "Prince Frog" "The prince who came too late" "The Dragonrider"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Nymeros Martell of Sunspear"
    ##   ..$ books      : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Feast for Crows"
    ##   ..$ povBooks   : chr "A Dance with Dragons"
    ##   ..$ tvSeries   : chr ""
    ##   ..$ playedBy   : chr ""
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/954"
    ##   ..$ id         : int 954
    ##   ..$ name       : chr "Samwell Tarly"
    ##   ..$ gender     : chr "Male"
    ##   ..$ culture    : chr "Andal"
    ##   ..$ born       : chr "In 283 AC, at Horn Hill"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr ""
    ##   ..$ aliases    : chr [1:7] "Sam" "Ser Piggy" "Prince Pork-chop" "Lady Piggy" ...
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr ""
    ##   ..$ allegiances: chr "House Tarly of Horn Hill"
    ##   ..$ books      : chr [1:3] "A Game of Thrones" "A Clash of Kings" "A Dance with Dragons"
    ##   ..$ povBooks   : chr [1:2] "A Storm of Swords" "A Feast for Crows"
    ##   ..$ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "John Bradley-West"
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/957"
    ##   ..$ id         : int 957
    ##   ..$ name       : chr "Sansa Stark"
    ##   ..$ gender     : chr "Female"
    ##   ..$ culture    : chr "Northmen"
    ##   ..$ born       : chr "In 286 AC, at Winterfell"
    ##   ..$ died       : chr ""
    ##   ..$ alive      : logi TRUE
    ##   ..$ titles     : chr "Princess"
    ##   ..$ aliases    : chr [1:3] "Little bird" "Alayne Stone" "Jonquil"
    ##   ..$ father     : chr ""
    ##   ..$ mother     : chr ""
    ##   ..$ spouse     : chr "https://www.anapioficeandfire.com/api/characters/1052"
    ##   ..$ allegiances: chr [1:2] "House Baelish of Harrenhal" "House Stark of Winterfell"
    ##   ..$ books      : chr "A Dance with Dragons"
    ##   ..$ povBooks   : chr [1:4] "A Game of Thrones" "A Clash of Kings" "A Storm of Swords" "A Feast for Crows"
    ##   ..$ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##   ..$ playedBy   : chr "Sophie Turner"

Exploring lists
---------------

1.  `str()`: embrace `list.len` and `max.level`

``` r
str(got_chars, list.len = 4) #will truncate the main list, but also the lists within the lists
```

    ## List of 30
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1022"
    ##   ..$ id         : int 1022
    ##   ..$ name       : chr "Theon Greyjoy"
    ##   ..$ gender     : chr "Male"
    ##   .. [list output truncated]
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1052"
    ##   ..$ id         : int 1052
    ##   ..$ name       : chr "Tyrion Lannister"
    ##   ..$ gender     : chr "Male"
    ##   .. [list output truncated]
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1074"
    ##   ..$ id         : int 1074
    ##   ..$ name       : chr "Victarion Greyjoy"
    ##   ..$ gender     : chr "Male"
    ##   .. [list output truncated]
    ##  $ :List of 18
    ##   ..$ url        : chr "https://www.anapioficeandfire.com/api/characters/1109"
    ##   ..$ id         : int 1109
    ##   ..$ name       : chr "Will"
    ##   ..$ gender     : chr "Male"
    ##   .. [list output truncated]
    ##   [list output truncated]

``` r
str(got_chars, list.len = 4, max.level = 1) #will show only the first main list, 2 will show the next
```

    ## List of 30
    ##  $ :List of 18
    ##  $ :List of 18
    ##  $ :List of 18
    ##  $ :List of 18
    ##   [list output truncated]

``` r
                                            #level of lists, etc...
str(got_chars[[1]])
```

    ## List of 18
    ##  $ url        : chr "https://www.anapioficeandfire.com/api/characters/1022"
    ##  $ id         : int 1022
    ##  $ name       : chr "Theon Greyjoy"
    ##  $ gender     : chr "Male"
    ##  $ culture    : chr "Ironborn"
    ##  $ born       : chr "In 278 AC or 279 AC, at Pyke"
    ##  $ died       : chr ""
    ##  $ alive      : logi TRUE
    ##  $ titles     : chr [1:3] "Prince of Winterfell" "Captain of Sea Bitch" "Lord of the Iron Islands (by law of the green lands)"
    ##  $ aliases    : chr [1:4] "Prince of Fools" "Theon Turncloak" "Reek" "Theon Kinslayer"
    ##  $ father     : chr ""
    ##  $ mother     : chr ""
    ##  $ spouse     : chr ""
    ##  $ allegiances: chr "House Greyjoy of Pyke"
    ##  $ books      : chr [1:3] "A Game of Thrones" "A Storm of Swords" "A Feast for Crows"
    ##  $ povBooks   : chr [1:2] "A Clash of Kings" "A Dance with Dragons"
    ##  $ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##  $ playedBy   : chr "Alfie Allen"

1.  Interactive exploration: `View()` and `listviewer::jsonedit(..., mode = "view")`

``` r
#View(got_chars)
jsonedit(got_chars, mode="view")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-c58398c2a32f1eeafd5a">{"x":{"data":[{"url":"https://www.anapioficeandfire.com/api/characters/1022","id":1022,"name":"Theon Greyjoy","gender":"Male","culture":"Ironborn","born":"In 278 AC or 279 AC, at Pyke","died":"","alive":true,"titles":["Prince of Winterfell","Captain of Sea Bitch","Lord of the Iron Islands (by law of the green lands)"],"aliases":["Prince of Fools","Theon Turncloak","Reek","Theon Kinslayer"],"father":"","mother":"","spouse":"","allegiances":"House Greyjoy of Pyke","books":["A Game of Thrones","A Storm of Swords","A Feast for Crows"],"povBooks":["A Clash of Kings","A Dance with Dragons"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Alfie Allen"},{"url":"https://www.anapioficeandfire.com/api/characters/1052","id":1052,"name":"Tyrion Lannister","gender":"Male","culture":"","born":"In 273 AC, at Casterly Rock","died":"","alive":true,"titles":["Acting Hand of the King (former)","Master of Coin (former)"],"aliases":["The Imp","Halfman","The boyman","Giant of Lannister","Lord Tywin's Doom","Lord Tywin's Bane","Yollo","Hugor Hill","No-Nose","Freak","Dwarf"],"father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/2044","allegiances":"House Lannister of Casterly Rock","books":["A Feast for Crows","The World of Ice and Fire"],"povBooks":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Peter Dinklage"},{"url":"https://www.anapioficeandfire.com/api/characters/1074","id":1074,"name":"Victarion Greyjoy","gender":"Male","culture":"Ironborn","born":"In 268 AC or before, at Pyke","died":"","alive":true,"titles":["Lord Captain of the Iron Fleet","Master of the Iron Victory"],"aliases":"The Iron Captain","father":"","mother":"","spouse":"","allegiances":"House Greyjoy of Pyke","books":["A Game of Thrones","A Clash of Kings","A Storm of Swords"],"povBooks":["A Feast for Crows","A Dance with Dragons"],"tvSeries":"","playedBy":""},{"url":"https://www.anapioficeandfire.com/api/characters/1109","id":1109,"name":"Will","gender":"Male","culture":"","born":"","died":"In 297 AC, at Haunted Forest","alive":false,"titles":"","aliases":"","father":"","mother":"","spouse":"","allegiances":[],"books":"A Clash of Kings","povBooks":"A Game of Thrones","tvSeries":"","playedBy":"Bronson Webb"},{"url":"https://www.anapioficeandfire.com/api/characters/1166","id":1166,"name":"Areo Hotah","gender":"Male","culture":"Norvoshi","born":"In 257 AC or before, at Norvos","died":"","alive":true,"titles":"Captain of the Guard at Sunspear","aliases":"","father":"","mother":"","spouse":"","allegiances":"House Nymeros Martell of Sunspear","books":["A Game of Thrones","A Clash of Kings","A Storm of Swords"],"povBooks":["A Feast for Crows","A Dance with Dragons"],"tvSeries":["Season 5","Season 6"],"playedBy":"DeObia Oparei"},{"url":"https://www.anapioficeandfire.com/api/characters/1267","id":1267,"name":"Chett","gender":"Male","culture":"","born":"At Hag's Mire","died":"In 299 AC, at Fist of the First Men","alive":false,"titles":"","aliases":"","father":"","mother":"","spouse":"","allegiances":[],"books":["A Game of Thrones","A Clash of Kings"],"povBooks":"A Storm of Swords","tvSeries":"","playedBy":""},{"url":"https://www.anapioficeandfire.com/api/characters/1295","id":1295,"name":"Cressen","gender":"Male","culture":"","born":"In 219 AC or 220 AC","died":"In 299 AC, at Dragonstone","alive":false,"titles":"Maester","aliases":"","father":"","mother":"","spouse":"","allegiances":[],"books":["A Storm of Swords","A Feast for Crows"],"povBooks":"A Clash of Kings","tvSeries":"Season 2","playedBy":"Oliver Ford"},{"url":"https://www.anapioficeandfire.com/api/characters/130","id":130,"name":"Arianne Martell","gender":"Female","culture":"Dornish","born":"In 276 AC, at Sunspear","died":"","alive":true,"titles":"Princess of Dorne","aliases":"","father":"","mother":"","spouse":"","allegiances":"House Nymeros Martell of Sunspear","books":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"povBooks":"A Feast for Crows","tvSeries":"","playedBy":""},{"url":"https://www.anapioficeandfire.com/api/characters/1303","id":1303,"name":"Daenerys Targaryen","gender":"Female","culture":"Valyrian","born":"In 284 AC, at Dragonstone","died":"","alive":true,"titles":["Queen of the Andals and the Rhoynar and the First Men, Lord of the Seven Kingdoms","Khaleesi of the Great Grass Sea","Breaker of Shackles/Chains","Queen of Meereen","Princess of Dragonstone"],"aliases":["Dany","Daenerys Stormborn","The Unburnt","Mother of Dragons","Mother","Mhysa","The Silver Queen","Silver Lady","Dragonmother","The Dragon Queen","The Mad King's daughter"],"father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/1346","allegiances":"House Targaryen of King's Landing","books":"A Feast for Crows","povBooks":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Emilia Clarke"},{"url":"https://www.anapioficeandfire.com/api/characters/1319","id":1319,"name":"Davos Seaworth","gender":"Male","culture":"Westeros","born":"In 260 AC or before, at King's Landing","died":"","alive":true,"titles":["Ser","Lord of the Rainwood","Admiral of the Narrow Sea","Hand of the King"],"aliases":["Onion Knight","Davos Shorthand","Ser Onions","Onion Lord","Smuggler"],"father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/1676","allegiances":["House Baratheon of Dragonstone","House Seaworth of Cape Wrath"],"books":"A Feast for Crows","povBooks":["A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"tvSeries":["Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Liam Cunningham"},{"url":"https://www.anapioficeandfire.com/api/characters/148","id":148,"name":"Arya Stark","gender":"Female","culture":"Northmen","born":"In 289 AC, at Winterfell","died":"","alive":true,"titles":"Princess","aliases":["Arya Horseface","Arya Underfoot","Arry","Lumpyface","Lumpyhead","Stickboy","Weasel","Nymeria","Squan","Saltb","Cat of the Canaly","Bets","The Blind Girh","The Ugly Little Girl","Mercedenl","Mercye"],"father":"","mother":"","spouse":"","allegiances":"House Stark of Winterfell","books":[],"povBooks":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Feast for Crows","A Dance with Dragons"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Maisie Williams"},{"url":"https://www.anapioficeandfire.com/api/characters/149","id":149,"name":"Arys Oakheart","gender":"Male","culture":"Reach","born":"At Old Oak","died":"In 300 AC, at the Greenblood","alive":false,"titles":"Ser","aliases":"","father":"","mother":"","spouse":"","allegiances":"House Oakheart of Old Oak","books":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"povBooks":"A Feast for Crows","tvSeries":"","playedBy":""},{"url":"https://www.anapioficeandfire.com/api/characters/150","id":150,"name":"Asha Greyjoy","gender":"Female","culture":"Ironborn","born":"In 275 AC or 276 AC, at Pyke","died":"","alive":true,"titles":["Princess","Captain of the Black Wind","Conqueror of Deepwood Motte"],"aliases":["Esgred","The Kraken's Daughter"],"father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/1372","allegiances":["House Greyjoy of Pyke","House Ironmaker"],"books":["A Game of Thrones","A Clash of Kings"],"povBooks":["A Feast for Crows","A Dance with Dragons"],"tvSeries":["Season 2","Season 3","Season 4"],"playedBy":"Gemma Whelan"},{"url":"https://www.anapioficeandfire.com/api/characters/168","id":168,"name":"Barristan Selmy","gender":"Male","culture":"Westeros","born":"In 237 AC","died":"","alive":true,"titles":["Ser","Hand of the Queen"],"aliases":["Barristan the Bold","Arstan Whitebeard","Ser Grandfather","Barristan the Old","Old Ser"],"father":"","mother":"","spouse":"","allegiances":["House Selmy of Harvest Hall","House Targaryen of King's Landing"],"books":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Feast for Crows","The World of Ice and Fire"],"povBooks":"A Dance with Dragons","tvSeries":["Season 1","Season 3","Season 4","Season 5"],"playedBy":"Ian McElhinney"},{"url":"https://www.anapioficeandfire.com/api/characters/2066","id":2066,"name":"Varamyr","gender":"Male","culture":"Free Folk","born":"At a village Beyond the Wall","died":"In 300 AC, at a village Beyond the Wall","alive":false,"titles":"","aliases":["Varamyr Sixskins","Haggon","Lump"],"father":"","mother":"","spouse":"","allegiances":[],"books":"A Storm of Swords","povBooks":"A Dance with Dragons","tvSeries":"","playedBy":""},{"url":"https://www.anapioficeandfire.com/api/characters/208","id":208,"name":"Brandon Stark","gender":"Male","culture":"Northmen","born":"In 290 AC, at Winterfell","died":"","alive":true,"titles":"Prince of Winterfell","aliases":["Bran","Bran the Broken","The Winged Wolf"],"father":"","mother":"","spouse":"","allegiances":"House Stark of Winterfell","books":"A Feast for Crows","povBooks":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 6"],"playedBy":"Isaac Hempstead-Wright"},{"url":"https://www.anapioficeandfire.com/api/characters/216","id":216,"name":"Brienne of Tarth","gender":"Female","culture":"","born":"In 280 AC","died":"","alive":true,"titles":"","aliases":["The Maid of Tarth","Brienne the Beauty","Brienne the Blue"],"father":"","mother":"","spouse":"","allegiances":["House Baratheon of Storm's End","House Stark of Winterfell","House Tarth of Evenfall Hall"],"books":["A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"povBooks":"A Feast for Crows","tvSeries":["Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Gwendoline Christie"},{"url":"https://www.anapioficeandfire.com/api/characters/232","id":232,"name":"Catelyn Stark","gender":"Female","culture":"Rivermen","born":"In 264 AC, at Riverrun","died":"In 299 AC, at the Twins","alive":false,"titles":"Lady of Winterfell","aliases":["Catelyn Tully","Lady Stoneheart","The Silent Sistet","Mother Mercilesr","The Hangwomans"],"father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/339","allegiances":["House Stark of Winterfell","House Tully of Riverrun"],"books":["A Feast for Crows","A Dance with Dragons"],"povBooks":["A Game of Thrones","A Clash of Kings","A Storm of Swords"],"tvSeries":["Season 1","Season 2","Season 3"],"playedBy":"Michelle Fairley"},{"url":"https://www.anapioficeandfire.com/api/characters/238","id":238,"name":"Cersei Lannister","gender":"Female","culture":"Westerman","born":"In 266 AC, at Casterly Rock","died":"","alive":true,"titles":["Light of the West","Queen Dowager","Protector of the Realm","Lady of Casterly Rock","Queen Regent"],"aliases":[],"father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/901","allegiances":"House Lannister of Casterly Rock","books":["A Game of Thrones","A Clash of Kings","A Storm of Swords"],"povBooks":["A Feast for Crows","A Dance with Dragons"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Lena Headey"},{"url":"https://www.anapioficeandfire.com/api/characters/339","id":339,"name":"Eddard Stark","gender":"Male","culture":"Northmen","born":"In 263 AC, at Winterfell","died":"In 299 AC, at Great Sept of Baelor in King's Landing","alive":false,"titles":["Lord of Winterfell","Warden of the North","Hand of the King","Protector of the Realm","Regent"],"aliases":["Ned","The Ned","The Quiet Wolf"],"father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/232","allegiances":"House Stark of Winterfell","books":["A Clash of Kings","A Storm of Swords","A Feast for Crows","A Dance with Dragons","The World of Ice and Fire"],"povBooks":"A Game of Thrones","tvSeries":["Season 1","Season 6"],"playedBy":["Sean Bean","Sebastian Croft","Robert Aramayo"]},{"url":"https://www.anapioficeandfire.com/api/characters/529","id":529,"name":"Jaime Lannister","gender":"Male","culture":"Westerlands","born":"In 266 AC, at Casterly Rock","died":"","alive":true,"titles":["Ser","Lord Commander of the Kingsguard","Warden of the East (formerly)"],"aliases":["The Kingslayer","The Lion of Lannister","The Young Lion","Cripple"],"father":"","mother":"","spouse":"","allegiances":"House Lannister of Casterly Rock","books":["A Game of Thrones","A Clash of Kings"],"povBooks":["A Storm of Swords","A Feast for Crows","A Dance with Dragons"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5"],"playedBy":"Nikolaj Coster-Waldau"},{"url":"https://www.anapioficeandfire.com/api/characters/576","id":576,"name":"Jon Connington","gender":"Male","culture":"Stormlands","born":"In or between 263 AC and 265 AC","died":"","alive":true,"titles":["Lord of Griffin's Roost","Hand of the King","Hand of the True King"],"aliases":"Griffthe Mad King's Hand","father":"","mother":"","spouse":"","allegiances":["House Connington of Griffin's Roost","House Targaryen of King's Landing"],"books":["A Storm of Swords","A Feast for Crows","The World of Ice and Fire"],"povBooks":"A Dance with Dragons","tvSeries":"","playedBy":""},{"url":"https://www.anapioficeandfire.com/api/characters/583","id":583,"name":"Jon Snow","gender":"Male","culture":"Northmen","born":"In 283 AC","died":"","alive":true,"titles":"Lord Commander of the Night's Watch","aliases":["Lord Snow","Ned Stark's Bastard","The Snow of Winterfell","The Crow-Come-Over","The 998th Lord Commander of the Night's Watch","The Bastard of Winterfell","The Black Bastard of the Wall","Lord Crow"],"father":"","mother":"","spouse":"","allegiances":"House Stark of Winterfell","books":"A Feast for Crows","povBooks":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Kit Harington"},{"url":"https://www.anapioficeandfire.com/api/characters/60","id":60,"name":"Aeron Greyjoy","gender":"Male","culture":"Ironborn","born":"In or between 269 AC and 273 AC, at Pyke","died":"","alive":true,"titles":["Priest of the Drowned God","Captain of the Golden Storm (formerly)"],"aliases":["The Damphair","Aeron Damphair"],"father":"","mother":"","spouse":"","allegiances":"House Greyjoy of Pyke","books":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Dance with Dragons"],"povBooks":"A Feast for Crows","tvSeries":"Season 6","playedBy":"Michael Feast"},{"url":"https://www.anapioficeandfire.com/api/characters/605","id":605,"name":"Kevan Lannister","gender":"Male","culture":"","born":"In 244 AC","died":"In 300 AC, at King's Landing","alive":false,"titles":["Ser","Master of laws","Lord Regent","Protector of the Realm"],"aliases":"","father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/327","allegiances":"House Lannister of Casterly Rock","books":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Feast for Crows"],"povBooks":"A Dance with Dragons","tvSeries":["Season 1","Season 2","Season 5","Season 6"],"playedBy":"Ian Gelder"},{"url":"https://www.anapioficeandfire.com/api/characters/743","id":743,"name":"Melisandre","gender":"Female","culture":"Asshai","born":"At Unknown","died":"","alive":true,"titles":"","aliases":["The Red Priestess","The Red Woman","The King's Red Shadow","Lady Red","Lot Seven"],"father":"","mother":"","spouse":"","allegiances":[],"books":["A Clash of Kings","A Storm of Swords","A Feast for Crows"],"povBooks":"A Dance with Dragons","tvSeries":["Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Carice van Houten"},{"url":"https://www.anapioficeandfire.com/api/characters/751","id":751,"name":"Merrett Frey","gender":"Male","culture":"Rivermen","born":"In 262 AC","died":"In 300 AC, at Near Oldstones","alive":false,"titles":"","aliases":"Merrett Muttonhead","father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/712","allegiances":"House Frey of the Crossing","books":["A Game of Thrones","A Clash of Kings","A Feast for Crows","A Dance with Dragons"],"povBooks":"A Storm of Swords","tvSeries":"","playedBy":""},{"url":"https://www.anapioficeandfire.com/api/characters/844","id":844,"name":"Quentyn Martell","gender":"Male","culture":"Dornish","born":"In 281 AC, at Sunspear, Dorne","died":"In 300 AC, at Meereen","alive":false,"titles":"Prince","aliases":["Frog","Prince Frog","The prince who came too late","The Dragonrider"],"father":"","mother":"","spouse":"","allegiances":"House Nymeros Martell of Sunspear","books":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Feast for Crows"],"povBooks":"A Dance with Dragons","tvSeries":"","playedBy":""},{"url":"https://www.anapioficeandfire.com/api/characters/954","id":954,"name":"Samwell Tarly","gender":"Male","culture":"Andal","born":"In 283 AC, at Horn Hill","died":"","alive":true,"titles":"","aliases":["Sam","Ser Piggy","Prince Pork-chop","Lady Piggy","Sam the Slayer","Black Sam","Lord of Ham"],"father":"","mother":"","spouse":"","allegiances":"House Tarly of Horn Hill","books":["A Game of Thrones","A Clash of Kings","A Dance with Dragons"],"povBooks":["A Storm of Swords","A Feast for Crows"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"John Bradley-West"},{"url":"https://www.anapioficeandfire.com/api/characters/957","id":957,"name":"Sansa Stark","gender":"Female","culture":"Northmen","born":"In 286 AC, at Winterfell","died":"","alive":true,"titles":"Princess","aliases":["Little bird","Alayne Stone","Jonquil"],"father":"","mother":"","spouse":"https://www.anapioficeandfire.com/api/characters/1052","allegiances":["House Baelish of Harrenhal","House Stark of Winterfell"],"books":"A Dance with Dragons","povBooks":["A Game of Thrones","A Clash of Kings","A Storm of Swords","A Feast for Crows"],"tvSeries":["Season 1","Season 2","Season 3","Season 4","Season 5","Season 6"],"playedBy":"Sophie Turner"}],"options":{"mode":"view","modes":["code","form","text","tree","view"]}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
1.  Don't be afraid to check out a subset! `names()` comes in handy, too.

``` r
str(got_chars[[1]])
```

    ## List of 18
    ##  $ url        : chr "https://www.anapioficeandfire.com/api/characters/1022"
    ##  $ id         : int 1022
    ##  $ name       : chr "Theon Greyjoy"
    ##  $ gender     : chr "Male"
    ##  $ culture    : chr "Ironborn"
    ##  $ born       : chr "In 278 AC or 279 AC, at Pyke"
    ##  $ died       : chr ""
    ##  $ alive      : logi TRUE
    ##  $ titles     : chr [1:3] "Prince of Winterfell" "Captain of Sea Bitch" "Lord of the Iron Islands (by law of the green lands)"
    ##  $ aliases    : chr [1:4] "Prince of Fools" "Theon Turncloak" "Reek" "Theon Kinslayer"
    ##  $ father     : chr ""
    ##  $ mother     : chr ""
    ##  $ spouse     : chr ""
    ##  $ allegiances: chr "House Greyjoy of Pyke"
    ##  $ books      : chr [1:3] "A Game of Thrones" "A Storm of Swords" "A Feast for Crows"
    ##  $ povBooks   : chr [1:2] "A Clash of Kings" "A Dance with Dragons"
    ##  $ tvSeries   : chr [1:6] "Season 1" "Season 2" "Season 3" "Season 4" ...
    ##  $ playedBy   : chr "Alfie Allen"

``` r
names(got_chars[[1]]) #names of the lists within the main list
```

    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"

Exploring `purrr` fundamentals
------------------------------

Apply a function to each element in a list/vector with `map`.

General usage: `purrr::map(VECTOR_OR_LIST, YOUR_FUNCTION)`

Note:

-   `map` always returns a list.
-   `YOUR_FUNCTION` can return anything!

Toy example 1: without using vectorization, take the square root of the following vector:

``` r
x <- 1:10
map(x, sqrt) #always outputs a list
```

    ## [[1]]
    ## [1] 1
    ## 
    ## [[2]]
    ## [1] 1.414214
    ## 
    ## [[3]]
    ## [1] 1.732051
    ## 
    ## [[4]]
    ## [1] 2
    ## 
    ## [[5]]
    ## [1] 2.236068
    ## 
    ## [[6]]
    ## [1] 2.44949
    ## 
    ## [[7]]
    ## [1] 2.645751
    ## 
    ## [[8]]
    ## [1] 2.828427
    ## 
    ## [[9]]
    ## [1] 3
    ## 
    ## [[10]]
    ## [1] 3.162278

Toy example 2 (functions on-the-fly): without using vectorization, square each component of `x`:

``` r
square <- function(x){
  x^2
}

map(x, square)
```

    ## [[1]]
    ## [1] 1
    ## 
    ## [[2]]
    ## [1] 4
    ## 
    ## [[3]]
    ## [1] 9
    ## 
    ## [[4]]
    ## [1] 16
    ## 
    ## [[5]]
    ## [1] 25
    ## 
    ## [[6]]
    ## [1] 36
    ## 
    ## [[7]]
    ## [1] 49
    ## 
    ## [[8]]
    ## [1] 64
    ## 
    ## [[9]]
    ## [1] 81
    ## 
    ## [[10]]
    ## [1] 100

``` r
# defining the function within map
map(x, function(x){
  x^2
})
```

    ## [[1]]
    ## [1] 1
    ## 
    ## [[2]]
    ## [1] 4
    ## 
    ## [[3]]
    ## [1] 9
    ## 
    ## [[4]]
    ## [1] 16
    ## 
    ## [[5]]
    ## [1] 25
    ## 
    ## [[6]]
    ## [1] 36
    ## 
    ## [[7]]
    ## [1] 49
    ## 
    ## [[8]]
    ## [1] 64
    ## 
    ## [[9]]
    ## [1] 81
    ## 
    ## [[10]]
    ## [1] 100

Want a vector to be returned? Must specify the `typeof()` of the vector. Use `map_dbl()` to specify an output vector of type "double" for the above (check out the documentation `?map` for the acceptable vector types):

``` r
map_dbl(x, sqrt) #double is 'decimal'
```

    ##  [1] 1.000000 1.414214 1.732051 2.000000 2.236068 2.449490 2.645751
    ##  [8] 2.828427 3.000000 3.162278

``` r
map_dbl(x, sqrt) %>% 
typeof()
```

    ## [1] "double"

Does your function have other arguments? You can specify them afterwards in the ellipses (`...`).

``` r
map_chr(x, str_c, "potato.", sep="-")
```

    ##  [1] "1-potato."  "2-potato."  "3-potato."  "4-potato."  "5-potato." 
    ##  [6] "6-potato."  "7-potato."  "8-potato."  "9-potato."  "10-potato."

``` r
map_chr(x, str_c, "potato.", sep="-") %>% 
  typeof()
```

    ## [1] "character"

Your Turn: `purrr` fundamentals
-------------------------------

1.  Let's retry the `wesanderson` example: use `purrr` to write code that extracts a vector of the first elements of each vector contained in `wesanderson`. Play around with the following, too:
    -   Use `head` instead of writing your own function.
    -   Try different `map` functions, even the "wrong" types.
    -   Use the ``` ``[`` ``` function if you're feeling daring.

``` r
map_chr(wesanderson, `[[`, 1) #outputs vector
```

    ##  GrandBudapest      Moonrise1         Royal1      Moonrise2     Cavalcanti 
    ##      "#F1BB7B"      "#F3DF6C"      "#899DA4"      "#798E87"      "#D8B70A" 
    ##         Royal2 GrandBudapest2      Moonrise3      Chevalier         Zissou 
    ##      "#9A8822"      "#E6A0C4"      "#85D4E3"      "#446455"      "#3B9AB2" 
    ##   FantasticFox     Darjeeling       Rushmore   BottleRocket    Darjeeling2 
    ##      "#DD8D29"      "#FF0000"      "#E1BD6D"      "#A42820"      "#ECCBAE"

``` r
# or
vec1 <- function(x) x[1]
map_chr(wesanderson, vec1)
```

    ##  GrandBudapest      Moonrise1         Royal1      Moonrise2     Cavalcanti 
    ##      "#F1BB7B"      "#F3DF6C"      "#899DA4"      "#798E87"      "#D8B70A" 
    ##         Royal2 GrandBudapest2      Moonrise3      Chevalier         Zissou 
    ##      "#9A8822"      "#E6A0C4"      "#85D4E3"      "#446455"      "#3B9AB2" 
    ##   FantasticFox     Darjeeling       Rushmore   BottleRocket    Darjeeling2 
    ##      "#DD8D29"      "#FF0000"      "#E1BD6D"      "#A42820"      "#ECCBAE"

``` r
#Method 2: head()
map_chr(wesanderson, head, n=1)
```

    ##  GrandBudapest      Moonrise1         Royal1      Moonrise2     Cavalcanti 
    ##      "#F1BB7B"      "#F3DF6C"      "#899DA4"      "#798E87"      "#D8B70A" 
    ##         Royal2 GrandBudapest2      Moonrise3      Chevalier         Zissou 
    ##      "#9A8822"      "#E6A0C4"      "#85D4E3"      "#446455"      "#3B9AB2" 
    ##   FantasticFox     Darjeeling       Rushmore   BottleRocket    Darjeeling2 
    ##      "#DD8D29"      "#FF0000"      "#E1BD6D"      "#A42820"      "#ECCBAE"

1.  Check that each character's list entry in `got_chars` has the same names as everyone else (that is, list component names, not character names). Here's one way to do it:
    1.  Use the `names` function.
    2.  Then, bind the names together in a single character.
    3.  Then, apply the `table()` function.

``` r
map(got_chars, names)
```

    ## [[1]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[2]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[3]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[4]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[5]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[6]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[7]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[8]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[9]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[10]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[11]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[12]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[13]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[14]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[15]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[16]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[17]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[18]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[19]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[20]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[21]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[22]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[23]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[24]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[25]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[26]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[27]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[28]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[29]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"   
    ## 
    ## [[30]]
    ##  [1] "url"         "id"          "name"        "gender"      "culture"    
    ##  [6] "born"        "died"        "alive"       "titles"      "aliases"    
    ## [11] "father"      "mother"      "spouse"      "allegiances" "books"      
    ## [16] "povBooks"    "tvSeries"    "playedBy"

Shortcut functions
------------------

We can do the subsetting much easier with these shortcuts: just replace function with either:

-   index you'd like to subset by, or
-   name you'd like to subset by.

``` r
map_chr(wesanderson, 1) %>% 
  unname()
```

    ##  [1] "#F1BB7B" "#F3DF6C" "#899DA4" "#798E87" "#D8B70A" "#9A8822" "#E6A0C4"
    ##  [8] "#85D4E3" "#446455" "#3B9AB2" "#DD8D29" "#FF0000" "#E1BD6D" "#A42820"
    ## [15] "#ECCBAE"

Your turn: shortcut functions
-----------------------------

1.  For the `got_chars` data:

-   What are the titles of each character?
-   Is a vector output appropriate here?
-   Use a pipe.

Note: each character's list entry has a component named `titles` as the 9th entry.

``` r
map(got_chars, 'titles') #vector output not useful because all different lengths (lists in lists)
```

    ## [[1]]
    ## [1] "Prince of Winterfell"                                
    ## [2] "Captain of Sea Bitch"                                
    ## [3] "Lord of the Iron Islands (by law of the green lands)"
    ## 
    ## [[2]]
    ## [1] "Acting Hand of the King (former)" "Master of Coin (former)"         
    ## 
    ## [[3]]
    ## [1] "Lord Captain of the Iron Fleet" "Master of the Iron Victory"    
    ## 
    ## [[4]]
    ## [1] ""
    ## 
    ## [[5]]
    ## [1] "Captain of the Guard at Sunspear"
    ## 
    ## [[6]]
    ## [1] ""
    ## 
    ## [[7]]
    ## [1] "Maester"
    ## 
    ## [[8]]
    ## [1] "Princess of Dorne"
    ## 
    ## [[9]]
    ## [1] "Queen of the Andals and the Rhoynar and the First Men, Lord of the Seven Kingdoms"
    ## [2] "Khaleesi of the Great Grass Sea"                                                  
    ## [3] "Breaker of Shackles/Chains"                                                       
    ## [4] "Queen of Meereen"                                                                 
    ## [5] "Princess of Dragonstone"                                                          
    ## 
    ## [[10]]
    ## [1] "Ser"                       "Lord of the Rainwood"     
    ## [3] "Admiral of the Narrow Sea" "Hand of the King"         
    ## 
    ## [[11]]
    ## [1] "Princess"
    ## 
    ## [[12]]
    ## [1] "Ser"
    ## 
    ## [[13]]
    ## [1] "Princess"                    "Captain of the Black Wind"  
    ## [3] "Conqueror of Deepwood Motte"
    ## 
    ## [[14]]
    ## [1] "Ser"               "Hand of the Queen"
    ## 
    ## [[15]]
    ## [1] ""
    ## 
    ## [[16]]
    ## [1] "Prince of Winterfell"
    ## 
    ## [[17]]
    ## [1] ""
    ## 
    ## [[18]]
    ## [1] "Lady of Winterfell"
    ## 
    ## [[19]]
    ## [1] "Light of the West"      "Queen Dowager"         
    ## [3] "Protector of the Realm" "Lady of Casterly Rock" 
    ## [5] "Queen Regent"          
    ## 
    ## [[20]]
    ## [1] "Lord of Winterfell"     "Warden of the North"   
    ## [3] "Hand of the King"       "Protector of the Realm"
    ## [5] "Regent"                
    ## 
    ## [[21]]
    ## [1] "Ser"                              "Lord Commander of the Kingsguard"
    ## [3] "Warden of the East (formerly)"   
    ## 
    ## [[22]]
    ## [1] "Lord of Griffin's Roost" "Hand of the King"       
    ## [3] "Hand of the True King"  
    ## 
    ## [[23]]
    ## [1] "Lord Commander of the Night's Watch"
    ## 
    ## [[24]]
    ## [1] "Priest of the Drowned God"             
    ## [2] "Captain of the Golden Storm (formerly)"
    ## 
    ## [[25]]
    ## [1] "Ser"                    "Master of laws"        
    ## [3] "Lord Regent"            "Protector of the Realm"
    ## 
    ## [[26]]
    ## [1] ""
    ## 
    ## [[27]]
    ## [1] ""
    ## 
    ## [[28]]
    ## [1] "Prince"
    ## 
    ## [[29]]
    ## [1] ""
    ## 
    ## [[30]]
    ## [1] "Princess"

1.  For the `got_chars` data:

-   Extract a list of the "name" and "born" data for each person.
    -   Use the function ``` ``[`` ``` or `extract()` (from the `magrittr` package, does the same thing) function to do the subsetting
-   What happens when we switch to `map_dfr` instead of `map`? How about `map_dfc`?

``` r
desired_info <- c("name", "born")
#map(got_chars[1], extract, desired_info)
```

Note: as Jenny says, it's always safer (from a programming perspective) to work with output that's more predictable. The following would be safer, and is still readable:

``` r
got_chars %>% {
    tibble(
        name = map_chr(., "name"),
        born = map_chr(., "born")
    )
}
```

    ## # A tibble: 30 x 2
    ##    name               born                                  
    ##    <chr>              <chr>                                 
    ##  1 Theon Greyjoy      In 278 AC or 279 AC, at Pyke          
    ##  2 Tyrion Lannister   In 273 AC, at Casterly Rock           
    ##  3 Victarion Greyjoy  In 268 AC or before, at Pyke          
    ##  4 Will               ""                                    
    ##  5 Areo Hotah         In 257 AC or before, at Norvos        
    ##  6 Chett              At Hag's Mire                         
    ##  7 Cressen            In 219 AC or 220 AC                   
    ##  8 Arianne Martell    In 276 AC, at Sunspear                
    ##  9 Daenerys Targaryen In 284 AC, at Dragonstone             
    ## 10 Davos Seaworth     In 260 AC or before, at King's Landing
    ## # ... with 20 more rows

Note the curly braces "tricks" the object prior to the pipe from entering as the first argument to `tibble`, because ``` ``{`` ``` only returns the last line evaluated. In this case there are two: the above code is equivalent to

``` r
got_chars %>% {
    .
    tibble(
        name = map_chr(., "name"),
        born = map_chr(., "born")
    )
}
```

    ## # A tibble: 30 x 2
    ##    name               born                                  
    ##    <chr>              <chr>                                 
    ##  1 Theon Greyjoy      In 278 AC or 279 AC, at Pyke          
    ##  2 Tyrion Lannister   In 273 AC, at Casterly Rock           
    ##  3 Victarion Greyjoy  In 268 AC or before, at Pyke          
    ##  4 Will               ""                                    
    ##  5 Areo Hotah         In 257 AC or before, at Norvos        
    ##  6 Chett              At Hag's Mire                         
    ##  7 Cressen            In 219 AC or 220 AC                   
    ##  8 Arianne Martell    In 276 AC, at Sunspear                
    ##  9 Daenerys Targaryen In 284 AC, at Dragonstone             
    ## 10 Davos Seaworth     In 260 AC or before, at King's Landing
    ## # ... with 20 more rows
