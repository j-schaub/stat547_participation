Class Meeting 4 Worksheet
================

``` r
suppressPackageStartupMessages(library(tidyverse))
library(repurrrsive)
library(knitr)
```

Resources
=========

All are from [Jenny's `purrr` tutorial](https://jennybc.github.io/purrr-tutorial/). Specifically:

-   Parallel mapping: [Jenny's "Specifying the function in map() + parallel mapping"](https://jennybc.github.io/purrr-tutorial/ls03_map-function-syntax.html#parallel_map)
-   List columns in data frames; nesting: [Jenny's "List Columns"](https://jennybc.github.io/purrr-tutorial/ls13_list-columns.html).

The all-encompassing application near the bottom of this worksheet is from [Jenny's "Sample from groups, n varies by group"](https://jennybc.github.io/purrr-tutorial/ls12_different-sized-samples.html)

Parallel Mapping
================

We're going to work with toy cases first before the more realistic data analytic tasks, because they are easier to learn.

In some cases, functions are not vectorized (str\_c, etc...)

Want to vectorize over two iterables? Use the `map2` family:

``` r
a <- c(1,2,3)
b <- c(4,5,6)
#define function in argument
map2(a, b, function(x, y) x*y)
```

    ## [[1]]
    ## [1] 4
    ## 
    ## [[2]]
    ## [1] 10
    ## 
    ## [[3]]
    ## [1] 18

``` r
#write the formula without a function
map2(a, b, ~ .x * .y)
```

    ## [[1]]
    ## [1] 4
    ## 
    ## [[2]]
    ## [1] 10
    ## 
    ## [[3]]
    ## [1] 18

``` r
# If just one operation
map2(a, b, `*`)
```

    ## [[1]]
    ## [1] 4
    ## 
    ## [[2]]
    ## [1] 10
    ## 
    ## [[3]]
    ## [1] 18

``` r
#outputs a vector instead of a list
map2_dbl(a, b, `*`)
```

    ## [1]  4 10 18

More than 2? Use the `pmap` family:

``` r
a <- c(1,2,3)
b <- c(4,5,6)
c <- c(7,8,9)
pmap(list(a, b, c), function(x, y, z) x*y*z)
```

    ## [[1]]
    ## [1] 28
    ## 
    ## [[2]]
    ## [1] 80
    ## 
    ## [[3]]
    ## [1] 162

``` r
pmap(list(a, b, c), ~ ..1 * ..2 * ..3)
```

    ## [[1]]
    ## [1] 28
    ## 
    ## [[2]]
    ## [1] 80
    ## 
    ## [[3]]
    ## [1] 162

``` r
pmap_dbl(list(a, b, c), ~ ..1 * ..2 * ..3)
```

    ## [1]  28  80 162

Your Turn
---------

Using the following two vectors...

``` r
commute <- c(10, 50, 35)
name <- c("Parveen", "Kayden", "Shawn")
```

use `map2_chr()` to come up with the following output in three ways:

``` r
str_c(name, " takes ", commute, " minutes to get to work.")
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

1.  By defining a function before feeding it into `map2()` -- call it `comm_fun`.

``` r
#function needs to 
comm_fun <- function(x,y) str_c(x, " takes ", y, " minutes to get to work.")
  
#use map2
map2_chr(name, commute, comm_fun)
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

1.  By defining a function "on the fly" within the `map2()` function.

``` r
map2_chr(name, commute, function(t, s) str_c(t, " takes ", s, " minutes to get to work."))
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

1.  By defining a formula.

``` r
map2_chr(name, commute, ~ str_c(.x, " takes ", .y, " minutes to get to work."))
```

    ## [1] "Parveen takes 10 minutes to get to work."
    ## [2] "Kayden takes 50 minutes to get to work." 
    ## [3] "Shawn takes 35 minutes to get to work."

List columns
============

What are they?
--------------

A tibble can hold a list as a column, too:

``` r
(listcol_tib <- tibble(
  a = c(1,2,3),
  b = list(1,2,3),
  c = list(sum, sqrt, str_c),
  d = list(x=1, y=sum, z=iris)
))
```

    ## # A tibble: 3 x 4
    ##       a b         c         d                     
    ##   <dbl> <list>    <list>    <list>                
    ## 1     1 <dbl [1]> <builtin> <dbl [1]>             
    ## 2     2 <dbl [1]> <builtin> <builtin>             
    ## 3     3 <dbl [1]> <fn>      <data.frame [150 x 5]>

Printing to screen doesn't reveal the contents! `str()` helps here:

``` r
str(listcol_tib)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    3 obs. of  4 variables:
    ##  $ a: num  1 2 3
    ##  $ b:List of 3
    ##   ..$ : num 1
    ##   ..$ : num 2
    ##   ..$ : num 3
    ##  $ c:List of 3
    ##   ..$ :function (..., na.rm = FALSE)  
    ##   ..$ :function (x)  
    ##   ..$ :function (..., sep = "", collapse = NULL)  
    ##  $ d:List of 3
    ##   ..$ x: num 1
    ##   ..$ y:function (..., na.rm = FALSE)  
    ##   ..$ z:'data.frame':    150 obs. of  5 variables:
    ##   .. ..$ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
    ##   .. ..$ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
    ##   .. ..$ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
    ##   .. ..$ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
    ##   .. ..$ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

Extract a list column in the same way as a vector column:

``` r
print(listcol_tib$a)  # Vector
```

    ## [1] 1 2 3

``` r
print(listcol_tib$b)  # List
```

    ## [[1]]
    ## [1] 1
    ## 
    ## [[2]]
    ## [1] 2
    ## 
    ## [[3]]
    ## [1] 3

This is where `map()` comes in handy! Let's make a tibble using the `got_chars` data, with two columns: "name" and "aliases", where "aliases" is a list-column (remember that each character can have a number of aliases different than 1):

1.  Pipe `got_chars` into `{` with `tibble()`.
2.  Specify the columns with `purrr` mappings.

``` r
#check column names
str(got_chars[1])
```

    ## List of 1
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

``` r
got_alias <- got_chars %>% 
  {tibble(
  name = map(., `[[`, 'name'),
  aliases = map(., `[[`, 'aliases')
  )}

got_alias
```

    ## # A tibble: 30 x 2
    ##    name      aliases   
    ##    <list>    <list>    
    ##  1 <chr [1]> <chr [4]> 
    ##  2 <chr [1]> <chr [11]>
    ##  3 <chr [1]> <chr [1]> 
    ##  4 <chr [1]> <chr [1]> 
    ##  5 <chr [1]> <chr [1]> 
    ##  6 <chr [1]> <chr [1]> 
    ##  7 <chr [1]> <chr [1]> 
    ##  8 <chr [1]> <chr [1]> 
    ##  9 <chr [1]> <chr [11]>
    ## 10 <chr [1]> <chr [5]> 
    ## # ... with 20 more rows

``` r
str(got_alias)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    30 obs. of  2 variables:
    ##  $ name   :List of 30
    ##   ..$ : chr "Theon Greyjoy"
    ##   ..$ : chr "Tyrion Lannister"
    ##   ..$ : chr "Victarion Greyjoy"
    ##   ..$ : chr "Will"
    ##   ..$ : chr "Areo Hotah"
    ##   ..$ : chr "Chett"
    ##   ..$ : chr "Cressen"
    ##   ..$ : chr "Arianne Martell"
    ##   ..$ : chr "Daenerys Targaryen"
    ##   ..$ : chr "Davos Seaworth"
    ##   ..$ : chr "Arya Stark"
    ##   ..$ : chr "Arys Oakheart"
    ##   ..$ : chr "Asha Greyjoy"
    ##   ..$ : chr "Barristan Selmy"
    ##   ..$ : chr "Varamyr"
    ##   ..$ : chr "Brandon Stark"
    ##   ..$ : chr "Brienne of Tarth"
    ##   ..$ : chr "Catelyn Stark"
    ##   ..$ : chr "Cersei Lannister"
    ##   ..$ : chr "Eddard Stark"
    ##   ..$ : chr "Jaime Lannister"
    ##   ..$ : chr "Jon Connington"
    ##   ..$ : chr "Jon Snow"
    ##   ..$ : chr "Aeron Greyjoy"
    ##   ..$ : chr "Kevan Lannister"
    ##   ..$ : chr "Melisandre"
    ##   ..$ : chr "Merrett Frey"
    ##   ..$ : chr "Quentyn Martell"
    ##   ..$ : chr "Samwell Tarly"
    ##   ..$ : chr "Sansa Stark"
    ##  $ aliases:List of 30
    ##   ..$ : chr  "Prince of Fools" "Theon Turncloak" "Reek" "Theon Kinslayer"
    ##   ..$ : chr  "The Imp" "Halfman" "The boyman" "Giant of Lannister" ...
    ##   ..$ : chr "The Iron Captain"
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr  "Dany" "Daenerys Stormborn" "The Unburnt" "Mother of Dragons" ...
    ##   ..$ : chr  "Onion Knight" "Davos Shorthand" "Ser Onions" "Onion Lord" ...
    ##   ..$ : chr  "Arya Horseface" "Arya Underfoot" "Arry" "Lumpyface" ...
    ##   ..$ : chr ""
    ##   ..$ : chr  "Esgred" "The Kraken's Daughter"
    ##   ..$ : chr  "Barristan the Bold" "Arstan Whitebeard" "Ser Grandfather" "Barristan the Old" ...
    ##   ..$ : chr  "Varamyr Sixskins" "Haggon" "Lump"
    ##   ..$ : chr  "Bran" "Bran the Broken" "The Winged Wolf"
    ##   ..$ : chr  "The Maid of Tarth" "Brienne the Beauty" "Brienne the Blue"
    ##   ..$ : chr  "Catelyn Tully" "Lady Stoneheart" "The Silent Sistet" "Mother Mercilesr" ...
    ##   ..$ : list()
    ##   ..$ : chr  "Ned" "The Ned" "The Quiet Wolf"
    ##   ..$ : chr  "The Kingslayer" "The Lion of Lannister" "The Young Lion" "Cripple"
    ##   ..$ : chr "Griffthe Mad King's Hand"
    ##   ..$ : chr  "Lord Snow" "Ned Stark's Bastard" "The Snow of Winterfell" "The Crow-Come-Over" ...
    ##   ..$ : chr  "The Damphair" "Aeron Damphair"
    ##   ..$ : chr ""
    ##   ..$ : chr  "The Red Priestess" "The Red Woman" "The King's Red Shadow" "Lady Red" ...
    ##   ..$ : chr "Merrett Muttonhead"
    ##   ..$ : chr  "Frog" "Prince Frog" "The prince who came too late" "The Dragonrider"
    ##   ..$ : chr  "Sam" "Ser Piggy" "Prince Pork-chop" "Lady Piggy" ...
    ##   ..$ : chr  "Little bird" "Alayne Stone" "Jonquil"

Write the solution down carefully -- we'll be referring to `got_alias` later.

Making: Your Turn
-----------------

Extract the aliases of Melisandre (a character from Game of Thrones) from the `got_alias` data frame we just made. Try two approaches:

Approach 1: Without piping

1.  Make a list of aliases by extracting the list column in `got_alias`.
2.  Set the names of this new list as the character names (from the other column of `got_chars`).
3.  Subset the newly-named list to Melisandre.

``` r
#(alias_list <- FILL)
#names(alias_list) <- FILL
#SUBSET_HERE
```

Approach 2: With piping

1.  Pipe `got_alias` into the `setNames()` function, to make a list of aliases, named after the person. Do you need `{` here?
2.  Then, pipe that into a subsetting function to subset Melisandre.

``` r
#got_alias %>% FILL_THIS_IN
```

Nesting/Unnesting; Operating
----------------------------

**Question**: What would tidy data of `got_alias` look like? Remember what `got_alias` holds:

Let's make a tidy data frame! First, let's take a closer look at `tidyr::unnest()` after making a tibble of preferred ice cream flavours:

``` r
(icecream <- tibble(
    name = c("Jacob", "Elena", "Mitchell"),
    flav = list(c("strawberry", "chocolate", "lemon"),
                c("straciatella", "strawberry"),
                c("garlic", "tiger tail"))
))
```

    ## # A tibble: 3 x 2
    ##   name     flav     
    ##   <chr>    <list>   
    ## 1 Jacob    <chr [3]>
    ## 2 Elena    <chr [2]>
    ## 3 Mitchell <chr [2]>

I can make a tidy data frame *without* list columns using `tidyr::unnest()`:

``` r
icecream %>% 
    unnest(flav)
```

    ## # A tibble: 7 x 2
    ##   name     flav        
    ##   <chr>    <chr>       
    ## 1 Jacob    strawberry  
    ## 2 Jacob    chocolate   
    ## 3 Jacob    lemon       
    ## 4 Elena    straciatella
    ## 5 Elena    strawberry  
    ## 6 Mitchell garlic      
    ## 7 Mitchell tiger tail

How would I subset all people that like strawberry ice cream? We can either use the tidy data, or the list data directly:

From "normal" tidy data:

``` r
icecream %>% 
    unnest(flav) %>% 
    filter(flav == "strawberry")
```

    ## # A tibble: 2 x 2
    ##   name  flav      
    ##   <chr> <chr>     
    ## 1 Jacob strawberry
    ## 2 Elena strawberry

From list-column data:

``` r
icecream %>% 
  filter(map_lgl(flav, ~ any(.x == "strawberry")))
```

    ## # A tibble: 2 x 2
    ##   name  flav     
    ##   <chr> <list>   
    ## 1 Jacob <chr [3]>
    ## 2 Elena <chr [2]>

Nesting/Unnesting: Your Turn
----------------------------

`unnest()` the `got_alias` tibble. Hint: there should be a hiccup. Check out the `str()`ucture of `got_alias` -- are all elements of the list column vectors? Would using `tidyr::drop_na()` be a good idea here?

``` r
#got_alias %>% 
  #unnest(aliases)

#fixing the error
str(got_alias)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    30 obs. of  2 variables:
    ##  $ name   :List of 30
    ##   ..$ : chr "Theon Greyjoy"
    ##   ..$ : chr "Tyrion Lannister"
    ##   ..$ : chr "Victarion Greyjoy"
    ##   ..$ : chr "Will"
    ##   ..$ : chr "Areo Hotah"
    ##   ..$ : chr "Chett"
    ##   ..$ : chr "Cressen"
    ##   ..$ : chr "Arianne Martell"
    ##   ..$ : chr "Daenerys Targaryen"
    ##   ..$ : chr "Davos Seaworth"
    ##   ..$ : chr "Arya Stark"
    ##   ..$ : chr "Arys Oakheart"
    ##   ..$ : chr "Asha Greyjoy"
    ##   ..$ : chr "Barristan Selmy"
    ##   ..$ : chr "Varamyr"
    ##   ..$ : chr "Brandon Stark"
    ##   ..$ : chr "Brienne of Tarth"
    ##   ..$ : chr "Catelyn Stark"
    ##   ..$ : chr "Cersei Lannister"
    ##   ..$ : chr "Eddard Stark"
    ##   ..$ : chr "Jaime Lannister"
    ##   ..$ : chr "Jon Connington"
    ##   ..$ : chr "Jon Snow"
    ##   ..$ : chr "Aeron Greyjoy"
    ##   ..$ : chr "Kevan Lannister"
    ##   ..$ : chr "Melisandre"
    ##   ..$ : chr "Merrett Frey"
    ##   ..$ : chr "Quentyn Martell"
    ##   ..$ : chr "Samwell Tarly"
    ##   ..$ : chr "Sansa Stark"
    ##  $ aliases:List of 30
    ##   ..$ : chr  "Prince of Fools" "Theon Turncloak" "Reek" "Theon Kinslayer"
    ##   ..$ : chr  "The Imp" "Halfman" "The boyman" "Giant of Lannister" ...
    ##   ..$ : chr "The Iron Captain"
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr ""
    ##   ..$ : chr  "Dany" "Daenerys Stormborn" "The Unburnt" "Mother of Dragons" ...
    ##   ..$ : chr  "Onion Knight" "Davos Shorthand" "Ser Onions" "Onion Lord" ...
    ##   ..$ : chr  "Arya Horseface" "Arya Underfoot" "Arry" "Lumpyface" ...
    ##   ..$ : chr ""
    ##   ..$ : chr  "Esgred" "The Kraken's Daughter"
    ##   ..$ : chr  "Barristan the Bold" "Arstan Whitebeard" "Ser Grandfather" "Barristan the Old" ...
    ##   ..$ : chr  "Varamyr Sixskins" "Haggon" "Lump"
    ##   ..$ : chr  "Bran" "Bran the Broken" "The Winged Wolf"
    ##   ..$ : chr  "The Maid of Tarth" "Brienne the Beauty" "Brienne the Blue"
    ##   ..$ : chr  "Catelyn Tully" "Lady Stoneheart" "The Silent Sistet" "Mother Mercilesr" ...
    ##   ..$ : list()
    ##   ..$ : chr  "Ned" "The Ned" "The Quiet Wolf"
    ##   ..$ : chr  "The Kingslayer" "The Lion of Lannister" "The Young Lion" "Cripple"
    ##   ..$ : chr "Griffthe Mad King's Hand"
    ##   ..$ : chr  "Lord Snow" "Ned Stark's Bastard" "The Snow of Winterfell" "The Crow-Come-Over" ...
    ##   ..$ : chr  "The Damphair" "Aeron Damphair"
    ##   ..$ : chr ""
    ##   ..$ : chr  "The Red Priestess" "The Red Woman" "The King's Red Shadow" "Lady Red" ...
    ##   ..$ : chr "Merrett Muttonhead"
    ##   ..$ : chr  "Frog" "Prince Frog" "The prince who came too late" "The Dragonrider"
    ##   ..$ : chr  "Sam" "Ser Piggy" "Prince Pork-chop" "Lady Piggy" ...
    ##   ..$ : chr  "Little bird" "Alayne Stone" "Jonquil"

``` r
got_alias %>% 
  drop_na() %>% 
  unnest(aliases) 
```

    ## # A tibble: 114 x 1
    ##    aliases           
    ##    <chr>             
    ##  1 Prince of Fools   
    ##  2 Theon Turncloak   
    ##  3 Reek              
    ##  4 Theon Kinslayer   
    ##  5 The Imp           
    ##  6 Halfman           
    ##  7 The boyman        
    ##  8 Giant of Lannister
    ##  9 Lord Tywin's Doom 
    ## 10 Lord Tywin's Bane 
    ## # ... with 104 more rows

We can also do the opposite with `tidyr::nest()`. Try it with the `iris` data frame:

1.  Group by species.
2.  `nest()`!

``` r
iris %>% 
  group_by(Species) %>% 
  nest()
```

    ## # A tibble: 3 x 2
    ##   Species    data             
    ##   <fct>      <list>           
    ## 1 setosa     <tibble [50 x 4]>
    ## 2 versicolor <tibble [50 x 4]>
    ## 3 virginica  <tibble [50 x 4]>

Keep the nested `iris` data frame above going! Keep piping:

-   Fit a linear regression model with `lm()` to `Sepal.Length ~ Sepal.Width`, separately for each species.
    -   Inspect, to see what's going on.
-   Get the slope and intercept information by applying `broom::tidy()` to the output of `lm()`.
-   `unnest` the outputted data frames from `broom::tidy()`.

Application: Time remaining?
============================

If time remains, here is a good exercise to put everything together.

[Hilary Parker tweet](https://twitter.com/hspter/status/739886244692295680): "How do you sample from groups, with a different sample size for each group?"

[Solution by Jenny Bryan](https://jennybc.github.io/purrr-tutorial/ls12_different-sized-samples.html):

1.  Nest by species.
2.  Specify sample size for each group.
3.  Do the subsampling of each group.

Let's give it a try:

Summary:
========

-   tibbles can hold columns that are lists, too!
    -   Useful for holding variable-length data.
    -   Useful for holding unusual data (example: a probability density function)
    -   Whereas `dplyr` maps vectors of length `n` to `n`, or `n` to `1`...
    -   ...list columns allow us to map `n` to any general length `m` (example: regression on groups)
-   `purrr` is a useful tool for operating on list-columns.
-   `purrr` allows for parallel mapping of iterables (vectors/lists) with the `map2` and `pmap` families.
