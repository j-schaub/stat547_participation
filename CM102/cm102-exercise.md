STAT 547 Class Meeting 02 Worksheet
================

``` r
suppressPackageStartupMessages(library(tidyverse))
library(gapminder)
library(testthat)
```

    ## 
    ## Attaching package: 'testthat'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     matches

    ## The following object is masked from 'package:purrr':
    ## 
    ##     is_null

``` r
library(knitr)
```

Resources
---------

Today's lesson has been drawn from the following resources:

1.  Mostly [stat545.com: character data](http://stat545.com/block028_character-data.html)
    -   See the ["Resources" section](http://stat545.com/block028_character-data.html#resources) for a more comprehensive listing of resources based on the character problem you're facing.
2.  [Older stat545 notes](http://stat545.com/block022_regular-expression.html)
3.  [r4ds: strings](https://r4ds.had.co.nz/strings.html).
4.  [`stringr` vignette](https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html)

Basic String Manipulation
-------------------------

**Goal**: Go over some basic functionality of `stringr`.

There's that famous sentence about the quick brown fox that contains all letters of the alphabet, although I don't quite remember the sentence. Demo: Check to see if it's in the `sentences` data. Try:

`str_detect(string, pattern)`
`str_subset(string, pattern)`

``` r
fox <- str_subset(sentences, pattern = "fox")
fox
```

    ## [1] "The quick fox jumped on the sleeping cat."

Not quite the sentence I was thinking of. How many words does it contain? Use `str_split(string, pattern)`, noting its output (list).

``` r
str_split(fox, pattern = " ")[[1]] %>%  #indexing list 1
  length()
```

    ## [1] 8

``` r
#outputs a list, because we only put in vector of length 1
#but we have the option of putting in a longer vector and splits all into lists
```

Exercise: does this sentence contain all letters of the alphabet? Hints:

-   Split by `""`.
-   Consider putting all in lowercase with `str_to_lower()`.
-   Use the base R `table()` function.

``` r
fox %>% 
  str_to_lower() %>% #makes all letters lowercase
  str_split("") %>% 
  `[[`(1) %>%   #`[[` is a function that indexes a list, argument is index (back ticks)
  table()
```

    ## .
    ##   . a c d e f g h i j k l m n o p q s t u x 
    ## 7 1 1 2 1 5 1 1 2 2 1 1 1 1 2 2 2 1 1 3 2 1

Working in a data frame? `tidyr` has its own version of this. Here's an example from Resource 1, with the fruit data:

``` r
tibble(fruit)
```

    ## # A tibble: 80 x 1
    ##    fruit       
    ##    <chr>       
    ##  1 apple       
    ##  2 apricot     
    ##  3 avocado     
    ##  4 banana      
    ##  5 bell pepper 
    ##  6 bilberry    
    ##  7 blackberry  
    ##  8 blackcurrant
    ##  9 blood orange
    ## 10 blueberry   
    ## # ... with 70 more rows

``` r
tibble(fruit) %>%
  separate(fruit, into = c("pre", "post"), sep = " ")
```

    ## Warning: Expected 2 pieces. Missing pieces filled with `NA` in 69 rows [1,
    ## 2, 3, 4, 6, 7, 8, 10, 11, 12, 14, 15, 16, 18, 19, 20, 21, 22, 23, 24, ...].

    ## # A tibble: 80 x 2
    ##    pre          post  
    ##    <chr>        <chr> 
    ##  1 apple        <NA>  
    ##  2 apricot      <NA>  
    ##  3 avocado      <NA>  
    ##  4 banana       <NA>  
    ##  5 bell         pepper
    ##  6 bilberry     <NA>  
    ##  7 blackberry   <NA>  
    ##  8 blackcurrant <NA>  
    ##  9 blood        orange
    ## 10 blueberry    <NA>  
    ## # ... with 70 more rows

Demo: we can substitute, too. Replace the word "fox" with "giraffe" using `str_replace(string, pattern, replacement)`:

``` r
fox %>% 
    str_replace(pattern = "fox", replacement = "giraffe")
```

    ## [1] "The quick giraffe jumped on the sleeping cat."

Know the position you want to extract/replace? Try `str_sub()`.

`str_pad()` extends each string to a minimum length:

``` r
fruit %>% head
```

    ## [1] "apple"       "apricot"     "avocado"     "banana"      "bell pepper"
    ## [6] "bilberry"

``` r
fruit %>% 
    str_pad(width=7, side="right", pad="$") %>%  #padding a string 
    head()
```

    ## [1] "apple$$"     "apricot"     "avocado"     "banana$"     "bell pepper"
    ## [6] "bilberry"

`str_length()` (Not the same as `length()`!)

``` r
str_length(fruit) #gives length of each element
```

    ##  [1]  5  7  7  6 11  8 10 12 12  9 11 10 12 10  9  6 12 10 10  7  9  8  7
    ## [24]  6  4 11  6  8 10  6  3 10 10  5 10  5  8 11  9  6  6 10  7  5  4  6
    ## [47]  6  9  5  8  9  3  5  6  6  6 12  5  4  9  8  9  4 11  6 17  6  6  8
    ## [70]  9 10 10 11  7 10 10  9  9 10 10

``` r
str_length(gapminder$pop) %>% 
  head()    #works for numeric values too
```

    ## [1] 7 7 8 8 8 8

``` r
length(fruit) #only gives the number of elements
```

    ## [1] 80

`str_c()` for concatenating strings. Check the docs for an excellent explanation using a matrix.

``` r
words %>% 
  head(8)
```

    ## [1] "a"        "able"     "about"    "absolute" "accept"   "account" 
    ## [7] "achieve"  "across"

``` r
str_c(words[1:4], words[5:8], sep=" & ") #basically puts vectors into columns and pairs them up with sep
```

    ## [1] "a & accept"        "able & account"    "about & achieve"  
    ## [4] "absolute & across"

``` r
str_c(words[3:4], words[5:8], sep=" & ") #will repeat if vectors arent the same length
```

    ## [1] "about & accept"     "absolute & account" "about & achieve"   
    ## [4] "absolute & across"

``` r
str_c(words[3:4], words[5:8], sep=" & ", collapse=", ") #takes output of binding and binds again
```

    ## [1] "about & accept, absolute & account, about & achieve, absolute & across"

There's a (more limited) `tidyr` version. Straight from Resource 1:

``` r
fruit_df <- tibble(
  fruit1 = fruit[1:4],
  fruit2 = fruit[5:8]
)
fruit_df %>% 
  unite("flavor_combo", fruit1, fruit2, sep = " & ")
```

    ## # A tibble: 4 x 1
    ##   flavor_combo         
    ##   <chr>                
    ## 1 apple & bell pepper  
    ## 2 apricot & bilberry   
    ## 3 avocado & blackberry 
    ## 4 banana & blackcurrant

Exercise: Populate your Participation Repo
------------------------------------------

So, you don't want to manually make 12 folders for your participation repo. I hear you. Let's do that by making a character vector with entries `"cm101"`, `"cm102"`, ..., `"cm112"`.

(If you've already done this, it's still a useful exercise!)

### Make Folders

Let's make those folders!

1.  Make a character vector with entries `"01"`, `"02"`, ..., `12` with `str_pad()`.

``` r
(num <- str_pad(c(1:12), width = 2, side = 'left', pad = '0'))
```

    ##  [1] "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12"

1.  Use `str_c()` to combine `"cm1"` with the numbers:
    -   If your system uses "" instead of "/", you might need two backslashes.

``` r
(folders <- str_c('CM1', num, sep = ""))
```

    ##  [1] "CM101" "CM102" "CM103" "CM104" "CM105" "CM106" "CM107" "CM108"
    ##  [9] "CM109" "CM110" "CM111" "CM112"

``` r
# could also do with paste: (folder_names <- paste("CM1", num, sep = ""))
```

1.  Use `testthat` to check that each entry of `folders` has 5 characters. You might find the base R `all()` function useful.

``` r
test_that("folder names are length 5.", {
    expect_true(all(str_length(folders) == 5))   #no news is good news
})
```

1.  BONUS: If applicable, make the folders using `dir.create()`.
    -   Note: `dir.create()` requires the full path to be specified. You might find the `here::here()` function useful.
    -   This code might work (depending on your directory): `for (folder in folders) dir.create(here::here(folder))`
    -   We'll learn how to use `purrr` instead of loops next week.

### Make README's

Now, let's seed the folders with README's.

1.  Add `/README.md` to the end of the folder names stored in `folders`:

``` r
(files <- str_c(folders, '/README.md'))
```

    ##  [1] "CM101/README.md" "CM102/README.md" "CM103/README.md"
    ##  [4] "CM104/README.md" "CM105/README.md" "CM106/README.md"
    ##  [7] "CM107/README.md" "CM108/README.md" "CM109/README.md"
    ## [10] "CM110/README.md" "CM111/README.md" "CM112/README.md"

1.  Make a vector of contents to put in each README. Put a title and body.
    -   Hint: Use `\n` to indicate a new line! This works in graphs, too.

``` r
(contents <- paste('\n# Participation Folder for Class', num, '\nThe contents of this file were created during class'))
```

    ##  [1] "\n# Participation Folder for Class 01 \nThe contents of this file were created during class"
    ##  [2] "\n# Participation Folder for Class 02 \nThe contents of this file were created during class"
    ##  [3] "\n# Participation Folder for Class 03 \nThe contents of this file were created during class"
    ##  [4] "\n# Participation Folder for Class 04 \nThe contents of this file were created during class"
    ##  [5] "\n# Participation Folder for Class 05 \nThe contents of this file were created during class"
    ##  [6] "\n# Participation Folder for Class 06 \nThe contents of this file were created during class"
    ##  [7] "\n# Participation Folder for Class 07 \nThe contents of this file were created during class"
    ##  [8] "\n# Participation Folder for Class 08 \nThe contents of this file were created during class"
    ##  [9] "\n# Participation Folder for Class 09 \nThe contents of this file were created during class"
    ## [10] "\n# Participation Folder for Class 10 \nThe contents of this file were created during class"
    ## [11] "\n# Participation Folder for Class 11 \nThe contents of this file were created during class"
    ## [12] "\n# Participation Folder for Class 12 \nThe contents of this file were created during class"

``` r
cat(contents)
```

    ## 
    ## # Participation Folder for Class 01 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 02 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 03 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 04 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 05 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 06 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 07 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 08 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 09 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 10 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 11 
    ## The contents of this file were created during class 
    ## # Participation Folder for Class 12 
    ## The contents of this file were created during class

1.  BONUS: Write the README's to file using base R's `write(x, file)`:
    -   `for (i in 1:length(files)) write(contents[i], files[i])`
    -   There's a better alternative to a loop using `purrr`. Next week's topic!
    -   This code might not work, depending on your workind directory and system.

Regular Expressions (aka regex)
-------------------------------

Great resource is [r4ds](https://r4ds.had.co.nz/strings.html#matching-patterns-with-regular-expressions)!

Premable:

-   Useful for identifying *patterns*, not exact character specifications.
-   Hard to read and write!
-   We'll focus on finding *matches* (the hardest part). You can also use regex to manipulate strings -- but we'll delegate that to [r4ds: strings: tools](https://r4ds.had.co.nz/strings.html#tools).

Staying true to Resource 1, let's work with the gapminder countries:

``` r
library(gapminder)
countries <- levels(gapminder$country)
```

### The "any character"

Find all countries in the gapminder data set with the following pattern: "i", followed by any single character, followed by "a":

``` r
str_subset(countries, pattern = "i.a") #. means "any single character"
```

    ##  [1] "Argentina"                "Bosnia and Herzegovina"  
    ##  [3] "Burkina Faso"             "Central African Republic"
    ##  [5] "China"                    "Costa Rica"              
    ##  [7] "Dominican Republic"       "Hong Kong, China"        
    ##  [9] "Jamaica"                  "Mauritania"              
    ## [11] "Nicaragua"                "South Africa"            
    ## [13] "Swaziland"                "Taiwan"                  
    ## [15] "Thailand"                 "Trinidad and Tobago"

Here, `.` stands for "any single character".

But, where's Italy? Case-sensitive!

Let's use `str_view_all()` to see the matches:

``` r
str_view_all(countries, pattern = "i.a")  #output vector and show you exactly where it is
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-4365341c6cdd5fe09d90">{"x":{"html":"<ul>\n  <li>Afghanistan<\/li>\n  <li>Albania<\/li>\n  <li>Algeria<\/li>\n  <li>Angola<\/li>\n  <li>Argent<span class='match'>ina<\/span><\/li>\n  <li>Australia<\/li>\n  <li>Austria<\/li>\n  <li>Bahrain<\/li>\n  <li>Bangladesh<\/li>\n  <li>Belgium<\/li>\n  <li>Benin<\/li>\n  <li>Bolivia<\/li>\n  <li>Bosnia and Herzegov<span class='match'>ina<\/span><\/li>\n  <li>Botswana<\/li>\n  <li>Brazil<\/li>\n  <li>Bulgaria<\/li>\n  <li>Burk<span class='match'>ina<\/span> Faso<\/li>\n  <li>Burundi<\/li>\n  <li>Cambodia<\/li>\n  <li>Cameroon<\/li>\n  <li>Canada<\/li>\n  <li>Central Afr<span class='match'>ica<\/span>n Republic<\/li>\n  <li>Chad<\/li>\n  <li>Chile<\/li>\n  <li>Ch<span class='match'>ina<\/span><\/li>\n  <li>Colombia<\/li>\n  <li>Comoros<\/li>\n  <li>Congo, Dem. Rep.<\/li>\n  <li>Congo, Rep.<\/li>\n  <li>Costa R<span class='match'>ica<\/span><\/li>\n  <li>Cote d'Ivoire<\/li>\n  <li>Croatia<\/li>\n  <li>Cuba<\/li>\n  <li>Czech Republic<\/li>\n  <li>Denmark<\/li>\n  <li>Djibouti<\/li>\n  <li>Domin<span class='match'>ica<\/span>n Republic<\/li>\n  <li>Ecuador<\/li>\n  <li>Egypt<\/li>\n  <li>El Salvador<\/li>\n  <li>Equatorial Guinea<\/li>\n  <li>Eritrea<\/li>\n  <li>Ethiopia<\/li>\n  <li>Finland<\/li>\n  <li>France<\/li>\n  <li>Gabon<\/li>\n  <li>Gambia<\/li>\n  <li>Germany<\/li>\n  <li>Ghana<\/li>\n  <li>Greece<\/li>\n  <li>Guatemala<\/li>\n  <li>Guinea<\/li>\n  <li>Guinea-Bissau<\/li>\n  <li>Haiti<\/li>\n  <li>Honduras<\/li>\n  <li>Hong Kong, Ch<span class='match'>ina<\/span><\/li>\n  <li>Hungary<\/li>\n  <li>Iceland<\/li>\n  <li>India<\/li>\n  <li>Indonesia<\/li>\n  <li>Iran<\/li>\n  <li>Iraq<\/li>\n  <li>Ireland<\/li>\n  <li>Israel<\/li>\n  <li>Italy<\/li>\n  <li>Jama<span class='match'>ica<\/span><\/li>\n  <li>Japan<\/li>\n  <li>Jordan<\/li>\n  <li>Kenya<\/li>\n  <li>Korea, Dem. Rep.<\/li>\n  <li>Korea, Rep.<\/li>\n  <li>Kuwait<\/li>\n  <li>Lebanon<\/li>\n  <li>Lesotho<\/li>\n  <li>Liberia<\/li>\n  <li>Libya<\/li>\n  <li>Madagascar<\/li>\n  <li>Malawi<\/li>\n  <li>Malaysia<\/li>\n  <li>Mali<\/li>\n  <li>Maur<span class='match'>ita<\/span>nia<\/li>\n  <li>Mauritius<\/li>\n  <li>Mexico<\/li>\n  <li>Mongolia<\/li>\n  <li>Montenegro<\/li>\n  <li>Morocco<\/li>\n  <li>Mozambique<\/li>\n  <li>Myanmar<\/li>\n  <li>Namibia<\/li>\n  <li>Nepal<\/li>\n  <li>Netherlands<\/li>\n  <li>New Zealand<\/li>\n  <li>N<span class='match'>ica<\/span>ragua<\/li>\n  <li>Niger<\/li>\n  <li>Nigeria<\/li>\n  <li>Norway<\/li>\n  <li>Oman<\/li>\n  <li>Pakistan<\/li>\n  <li>Panama<\/li>\n  <li>Paraguay<\/li>\n  <li>Peru<\/li>\n  <li>Philippines<\/li>\n  <li>Poland<\/li>\n  <li>Portugal<\/li>\n  <li>Puerto Rico<\/li>\n  <li>Reunion<\/li>\n  <li>Romania<\/li>\n  <li>Rwanda<\/li>\n  <li>Sao Tome and Principe<\/li>\n  <li>Saudi Arabia<\/li>\n  <li>Senegal<\/li>\n  <li>Serbia<\/li>\n  <li>Sierra Leone<\/li>\n  <li>Singapore<\/li>\n  <li>Slovak Republic<\/li>\n  <li>Slovenia<\/li>\n  <li>Somalia<\/li>\n  <li>South Afr<span class='match'>ica<\/span><\/li>\n  <li>Spain<\/li>\n  <li>Sri Lanka<\/li>\n  <li>Sudan<\/li>\n  <li>Swaz<span class='match'>ila<\/span>nd<\/li>\n  <li>Sweden<\/li>\n  <li>Switzerland<\/li>\n  <li>Syria<\/li>\n  <li>Ta<span class='match'>iwa<\/span>n<\/li>\n  <li>Tanzania<\/li>\n  <li>Tha<span class='match'>ila<\/span>nd<\/li>\n  <li>Togo<\/li>\n  <li>Trin<span class='match'>ida<\/span>d and Tobago<\/li>\n  <li>Tunisia<\/li>\n  <li>Turkey<\/li>\n  <li>Uganda<\/li>\n  <li>United Kingdom<\/li>\n  <li>United States<\/li>\n  <li>Uruguay<\/li>\n  <li>Venezuela<\/li>\n  <li>Vietnam<\/li>\n  <li>West Bank and Gaza<\/li>\n  <li>Yemen, Rep.<\/li>\n  <li>Zambia<\/li>\n  <li>Zimbabwe<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
``` r
str_view_all(countries, pattern = "i.a", match=TRUE) #highlights the instances it finds
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-6fe9fde1c9cb0c77a76d">{"x":{"html":"<ul>\n  <li>Argent<span class='match'>ina<\/span><\/li>\n  <li>Bosnia and Herzegov<span class='match'>ina<\/span><\/li>\n  <li>Burk<span class='match'>ina<\/span> Faso<\/li>\n  <li>Central Afr<span class='match'>ica<\/span>n Republic<\/li>\n  <li>Ch<span class='match'>ina<\/span><\/li>\n  <li>Costa R<span class='match'>ica<\/span><\/li>\n  <li>Domin<span class='match'>ica<\/span>n Republic<\/li>\n  <li>Hong Kong, Ch<span class='match'>ina<\/span><\/li>\n  <li>Jama<span class='match'>ica<\/span><\/li>\n  <li>Maur<span class='match'>ita<\/span>nia<\/li>\n  <li>N<span class='match'>ica<\/span>ragua<\/li>\n  <li>South Afr<span class='match'>ica<\/span><\/li>\n  <li>Swaz<span class='match'>ila<\/span>nd<\/li>\n  <li>Ta<span class='match'>iwa<\/span>n<\/li>\n  <li>Tha<span class='match'>ila<\/span>nd<\/li>\n  <li>Trin<span class='match'>ida<\/span>d and Tobago<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Exercise: Canada isn't the only country with three interspersed "a"'s. Find the others. Try both `str_view_all()` and `str_subset()`.

``` r
str_view_all(countries, pattern = 'a.a.a', match = TRUE)
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-783ff952a1492c4325a7">{"x":{"html":"<ul>\n  <li>C<span class='match'>anada<\/span><\/li>\n  <li>M<span class='match'>adaga<\/span>scar<\/li>\n  <li>P<span class='match'>anama<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
``` r
str_subset(countries, pattern ='a.a.a')
```

    ## [1] "Canada"     "Madagascar" "Panama"

Let's define a handy function:

``` r
str_view_all_match <- function(countries, pattern) {
    str_view_all(countries, pattern, match=TRUE)
}
str_view_all_match(countries, pattern = "i.a")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-22c75353c6288f8d76ee">{"x":{"html":"<ul>\n  <li>Argent<span class='match'>ina<\/span><\/li>\n  <li>Bosnia and Herzegov<span class='match'>ina<\/span><\/li>\n  <li>Burk<span class='match'>ina<\/span> Faso<\/li>\n  <li>Central Afr<span class='match'>ica<\/span>n Republic<\/li>\n  <li>Ch<span class='match'>ina<\/span><\/li>\n  <li>Costa R<span class='match'>ica<\/span><\/li>\n  <li>Domin<span class='match'>ica<\/span>n Republic<\/li>\n  <li>Hong Kong, Ch<span class='match'>ina<\/span><\/li>\n  <li>Jama<span class='match'>ica<\/span><\/li>\n  <li>Maur<span class='match'>ita<\/span>nia<\/li>\n  <li>N<span class='match'>ica<\/span>ragua<\/li>\n  <li>South Afr<span class='match'>ica<\/span><\/li>\n  <li>Swaz<span class='match'>ila<\/span>nd<\/li>\n  <li>Ta<span class='match'>iwa<\/span>n<\/li>\n  <li>Tha<span class='match'>ila<\/span>nd<\/li>\n  <li>Trin<span class='match'>ida<\/span>d and Tobago<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
### The escape

What if I wanted to literally search for countries with a period in the name? Escape with `\`, although R requires a double escape.

``` r
str_view_all_match(countries, pattern = "\\.")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-a79b37085ecd5a6184a7">{"x":{"html":"<ul>\n  <li>Congo, Dem<span class='match'>.<\/span> Rep<span class='match'>.<\/span><\/li>\n  <li>Congo, Rep<span class='match'>.<\/span><\/li>\n  <li>Korea, Dem<span class='match'>.<\/span> Rep<span class='match'>.<\/span><\/li>\n  <li>Korea, Rep<span class='match'>.<\/span><\/li>\n  <li>Yemen, Rep<span class='match'>.<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Why does R require a double escape? It does one level of escaping before "executing" the regex.

-   See `?Quotes`
-   Try searching for "s. " (without quotes) in this document (don't forget to select "Regex")

### Character Classes

-   `[letters]` matches a single character that's either l, e, t, ..., or s.
-   `[^letters]`: anything *but* these letters.

See more at: <https://r4ds.had.co.nz/strings.html#character-classes-and-alternatives>

Note that not all special characters "work" within `[]`, but some do, and do not always carry the same meaning (like `^`)! From said resource, they are:

> `$` `.` `|` `?` `*` `+` `(` `)` `[` `{`. Unfortunately, a few characters have special meaning even inside a character class and must be handled with backslash escapes: `]` `\` `^` and `-`.

Exercise: Find all countries with three non-vowels next to each other.

``` r
str_view_all_match(countries, pattern = "[^aeiou][^aeiou][^aeiou]")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-ac23a5b09e13e07be9ba">{"x":{"html":"<ul>\n  <li><span class='match'>Afg<\/span>hanistan<\/li>\n  <li><span class='match'>Alb<\/span>ania<\/li>\n  <li><span class='match'>Alg<\/span>eria<\/li>\n  <li><span class='match'>Ang<\/span>ola<\/li>\n  <li><span class='match'>Arg<\/span>entina<\/li>\n  <li>Au<span class='match'>str<\/span>alia<\/li>\n  <li>Au<span class='match'>str<\/span>ia<\/li>\n  <li>Ba<span class='match'>ngl<\/span>adesh<\/li>\n  <li>Bosnia a<span class='match'>nd <\/span>Herzegovina<\/li>\n  <li>Bo<span class='match'>tsw<\/span>ana<\/li>\n  <li>Ce<span class='match'>ntr<\/span>a<span class='match'>l A<\/span>frica<span class='match'>n R<\/span>epublic<\/li>\n  <li>Congo<span class='match'>, D<\/span>e<span class='match'>m. <\/span>Rep.<\/li>\n  <li>Congo<span class='match'>, R<\/span>ep.<\/li>\n  <li>Cote<span class='match'> d'<\/span>Ivoire<\/li>\n  <li>Cze<span class='match'>ch <\/span>Republic<\/li>\n  <li>Dominica<span class='match'>n R<\/span>epublic<\/li>\n  <li><span class='match'>Egy<\/span>pt<\/li>\n  <li><span class='match'>El <\/span>Salvador<\/li>\n  <li>Equatoria<span class='match'>l G<\/span>uinea<\/li>\n  <li><span class='match'>Eth<\/span>iopia<\/li>\n  <li>Ho<span class='match'>ng <\/span>Ko<span class='match'>ng,<\/span><span class='match'> Ch<\/span>ina<\/li>\n  <li><span class='match'>Ind<\/span>ia<\/li>\n  <li><span class='match'>Ind<\/span>onesia<\/li>\n  <li><span class='match'>Isr<\/span>ael<\/li>\n  <li>Korea<span class='match'>, D<\/span>e<span class='match'>m. <\/span>Rep.<\/li>\n  <li>Korea<span class='match'>, R<\/span>ep.<\/li>\n  <li>Netherla<span class='match'>nds<\/span><\/li>\n  <li>Ne<span class='match'>w Z<\/span>ealand<\/li>\n  <li>Sao Tome a<span class='match'>nd <\/span>Principe<\/li>\n  <li>Saudi<span class='match'> Ar<\/span>abia<\/li>\n  <li>Slova<span class='match'>k R<\/span>epublic<\/li>\n  <li>Sou<span class='match'>th <\/span><span class='match'>Afr<\/span>ica<\/li>\n  <li><span class='match'>Syr<\/span>ia<\/li>\n  <li>Trinidad a<span class='match'>nd <\/span>Tobago<\/li>\n  <li>Unite<span class='match'>d K<\/span>i<span class='match'>ngd<\/span>om<\/li>\n  <li>Unite<span class='match'>d S<\/span>tates<\/li>\n  <li>We<span class='match'>st <\/span>Ba<span class='match'>nk <\/span>a<span class='match'>nd <\/span>Gaza<\/li>\n  <li>Yeme<span class='match'>n, <\/span>Rep.<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
### Or

-   Use `|` to denote "or".
-   "And" is implied otherwise, and has precedence.
-   Use parentheses to indicate precedence.

Beer or bear?

``` r
c("bear", "beer", "bar") %>% 
    str_view_all_match(pattern = "be(e|a)r")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-d832d8e0742406a4a01f">{"x":{"html":"<ul>\n  <li><span class='match'>bear<\/span><\/li>\n  <li><span class='match'>beer<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
### Quantifiers/Repetition

The handy ones are:

-   `*` for 0 or more of the preceding character
-   `+` for 1 or more of the preceding character
-   `?` for 0 or 1 of the preceding character

See list at <https://r4ds.had.co.nz/strings.html#repetition>

Find all countries that have any number of o's (but at least 1) following r:

``` r
str_view_all_match(countries, "ro+")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-7e3deaea7298a00bb857">{"x":{"html":"<ul>\n  <li>Came<span class='match'>roo<\/span>n<\/li>\n  <li>Como<span class='match'>ro<\/span>s<\/li>\n  <li>C<span class='match'>ro<\/span>atia<\/li>\n  <li>Monteneg<span class='match'>ro<\/span><\/li>\n  <li>Mo<span class='match'>ro<\/span>cco<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Find all countries that have exactly two e's next two each other:

``` r
str_view_all_match(countries, "e{2}")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-d79f5c8dfbae02c574ca">{"x":{"html":"<ul>\n  <li>Gr<span class='match'>ee<\/span>ce<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Exercise: Find all countries that have either "a" or "e", twice in a row (with a changeover allowed, such as "ae" or "ea"):

``` r
str_view_all_match(countries, pattern="(e|a){2}")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-a33f549d9678ea93452b">{"x":{"html":"<ul>\n  <li>Equatorial Guin<span class='match'>ea<\/span><\/li>\n  <li>Eritr<span class='match'>ea<\/span><\/li>\n  <li>Gr<span class='match'>ee<\/span>ce<\/li>\n  <li>Guin<span class='match'>ea<\/span><\/li>\n  <li>Guin<span class='match'>ea<\/span>-Bissau<\/li>\n  <li>Isr<span class='match'>ae<\/span>l<\/li>\n  <li>Kor<span class='match'>ea<\/span>, Dem. Rep.<\/li>\n  <li>Kor<span class='match'>ea<\/span>, Rep.<\/li>\n  <li>New Z<span class='match'>ea<\/span>land<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
### Position indicators

-   `^` corresponds to the **beginning** of the line.
-   `$` corresponds to the **end** of the line.

Countries that end in "land":

``` r
str_view_all_match(countries, pattern = "land$")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-bd877a69fe3f4e23f456">{"x":{"html":"<ul>\n  <li>Fin<span class='match'>land<\/span><\/li>\n  <li>Ice<span class='match'>land<\/span><\/li>\n  <li>Ire<span class='match'>land<\/span><\/li>\n  <li>New Zea<span class='match'>land<\/span><\/li>\n  <li>Po<span class='match'>land<\/span><\/li>\n  <li>Swazi<span class='match'>land<\/span><\/li>\n  <li>Switzer<span class='match'>land<\/span><\/li>\n  <li>Thai<span class='match'>land<\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
``` r
str_view_all_match(countries, pattern = "$")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-1bc5ed272c702f4fe710">{"x":{"html":"<ul>\n  <li>Afghanistan<span class='match'><\/span><\/li>\n  <li>Albania<span class='match'><\/span><\/li>\n  <li>Algeria<span class='match'><\/span><\/li>\n  <li>Angola<span class='match'><\/span><\/li>\n  <li>Argentina<span class='match'><\/span><\/li>\n  <li>Australia<span class='match'><\/span><\/li>\n  <li>Austria<span class='match'><\/span><\/li>\n  <li>Bahrain<span class='match'><\/span><\/li>\n  <li>Bangladesh<span class='match'><\/span><\/li>\n  <li>Belgium<span class='match'><\/span><\/li>\n  <li>Benin<span class='match'><\/span><\/li>\n  <li>Bolivia<span class='match'><\/span><\/li>\n  <li>Bosnia and Herzegovina<span class='match'><\/span><\/li>\n  <li>Botswana<span class='match'><\/span><\/li>\n  <li>Brazil<span class='match'><\/span><\/li>\n  <li>Bulgaria<span class='match'><\/span><\/li>\n  <li>Burkina Faso<span class='match'><\/span><\/li>\n  <li>Burundi<span class='match'><\/span><\/li>\n  <li>Cambodia<span class='match'><\/span><\/li>\n  <li>Cameroon<span class='match'><\/span><\/li>\n  <li>Canada<span class='match'><\/span><\/li>\n  <li>Central African Republic<span class='match'><\/span><\/li>\n  <li>Chad<span class='match'><\/span><\/li>\n  <li>Chile<span class='match'><\/span><\/li>\n  <li>China<span class='match'><\/span><\/li>\n  <li>Colombia<span class='match'><\/span><\/li>\n  <li>Comoros<span class='match'><\/span><\/li>\n  <li>Congo, Dem. Rep.<span class='match'><\/span><\/li>\n  <li>Congo, Rep.<span class='match'><\/span><\/li>\n  <li>Costa Rica<span class='match'><\/span><\/li>\n  <li>Cote d'Ivoire<span class='match'><\/span><\/li>\n  <li>Croatia<span class='match'><\/span><\/li>\n  <li>Cuba<span class='match'><\/span><\/li>\n  <li>Czech Republic<span class='match'><\/span><\/li>\n  <li>Denmark<span class='match'><\/span><\/li>\n  <li>Djibouti<span class='match'><\/span><\/li>\n  <li>Dominican Republic<span class='match'><\/span><\/li>\n  <li>Ecuador<span class='match'><\/span><\/li>\n  <li>Egypt<span class='match'><\/span><\/li>\n  <li>El Salvador<span class='match'><\/span><\/li>\n  <li>Equatorial Guinea<span class='match'><\/span><\/li>\n  <li>Eritrea<span class='match'><\/span><\/li>\n  <li>Ethiopia<span class='match'><\/span><\/li>\n  <li>Finland<span class='match'><\/span><\/li>\n  <li>France<span class='match'><\/span><\/li>\n  <li>Gabon<span class='match'><\/span><\/li>\n  <li>Gambia<span class='match'><\/span><\/li>\n  <li>Germany<span class='match'><\/span><\/li>\n  <li>Ghana<span class='match'><\/span><\/li>\n  <li>Greece<span class='match'><\/span><\/li>\n  <li>Guatemala<span class='match'><\/span><\/li>\n  <li>Guinea<span class='match'><\/span><\/li>\n  <li>Guinea-Bissau<span class='match'><\/span><\/li>\n  <li>Haiti<span class='match'><\/span><\/li>\n  <li>Honduras<span class='match'><\/span><\/li>\n  <li>Hong Kong, China<span class='match'><\/span><\/li>\n  <li>Hungary<span class='match'><\/span><\/li>\n  <li>Iceland<span class='match'><\/span><\/li>\n  <li>India<span class='match'><\/span><\/li>\n  <li>Indonesia<span class='match'><\/span><\/li>\n  <li>Iran<span class='match'><\/span><\/li>\n  <li>Iraq<span class='match'><\/span><\/li>\n  <li>Ireland<span class='match'><\/span><\/li>\n  <li>Israel<span class='match'><\/span><\/li>\n  <li>Italy<span class='match'><\/span><\/li>\n  <li>Jamaica<span class='match'><\/span><\/li>\n  <li>Japan<span class='match'><\/span><\/li>\n  <li>Jordan<span class='match'><\/span><\/li>\n  <li>Kenya<span class='match'><\/span><\/li>\n  <li>Korea, Dem. Rep.<span class='match'><\/span><\/li>\n  <li>Korea, Rep.<span class='match'><\/span><\/li>\n  <li>Kuwait<span class='match'><\/span><\/li>\n  <li>Lebanon<span class='match'><\/span><\/li>\n  <li>Lesotho<span class='match'><\/span><\/li>\n  <li>Liberia<span class='match'><\/span><\/li>\n  <li>Libya<span class='match'><\/span><\/li>\n  <li>Madagascar<span class='match'><\/span><\/li>\n  <li>Malawi<span class='match'><\/span><\/li>\n  <li>Malaysia<span class='match'><\/span><\/li>\n  <li>Mali<span class='match'><\/span><\/li>\n  <li>Mauritania<span class='match'><\/span><\/li>\n  <li>Mauritius<span class='match'><\/span><\/li>\n  <li>Mexico<span class='match'><\/span><\/li>\n  <li>Mongolia<span class='match'><\/span><\/li>\n  <li>Montenegro<span class='match'><\/span><\/li>\n  <li>Morocco<span class='match'><\/span><\/li>\n  <li>Mozambique<span class='match'><\/span><\/li>\n  <li>Myanmar<span class='match'><\/span><\/li>\n  <li>Namibia<span class='match'><\/span><\/li>\n  <li>Nepal<span class='match'><\/span><\/li>\n  <li>Netherlands<span class='match'><\/span><\/li>\n  <li>New Zealand<span class='match'><\/span><\/li>\n  <li>Nicaragua<span class='match'><\/span><\/li>\n  <li>Niger<span class='match'><\/span><\/li>\n  <li>Nigeria<span class='match'><\/span><\/li>\n  <li>Norway<span class='match'><\/span><\/li>\n  <li>Oman<span class='match'><\/span><\/li>\n  <li>Pakistan<span class='match'><\/span><\/li>\n  <li>Panama<span class='match'><\/span><\/li>\n  <li>Paraguay<span class='match'><\/span><\/li>\n  <li>Peru<span class='match'><\/span><\/li>\n  <li>Philippines<span class='match'><\/span><\/li>\n  <li>Poland<span class='match'><\/span><\/li>\n  <li>Portugal<span class='match'><\/span><\/li>\n  <li>Puerto Rico<span class='match'><\/span><\/li>\n  <li>Reunion<span class='match'><\/span><\/li>\n  <li>Romania<span class='match'><\/span><\/li>\n  <li>Rwanda<span class='match'><\/span><\/li>\n  <li>Sao Tome and Principe<span class='match'><\/span><\/li>\n  <li>Saudi Arabia<span class='match'><\/span><\/li>\n  <li>Senegal<span class='match'><\/span><\/li>\n  <li>Serbia<span class='match'><\/span><\/li>\n  <li>Sierra Leone<span class='match'><\/span><\/li>\n  <li>Singapore<span class='match'><\/span><\/li>\n  <li>Slovak Republic<span class='match'><\/span><\/li>\n  <li>Slovenia<span class='match'><\/span><\/li>\n  <li>Somalia<span class='match'><\/span><\/li>\n  <li>South Africa<span class='match'><\/span><\/li>\n  <li>Spain<span class='match'><\/span><\/li>\n  <li>Sri Lanka<span class='match'><\/span><\/li>\n  <li>Sudan<span class='match'><\/span><\/li>\n  <li>Swaziland<span class='match'><\/span><\/li>\n  <li>Sweden<span class='match'><\/span><\/li>\n  <li>Switzerland<span class='match'><\/span><\/li>\n  <li>Syria<span class='match'><\/span><\/li>\n  <li>Taiwan<span class='match'><\/span><\/li>\n  <li>Tanzania<span class='match'><\/span><\/li>\n  <li>Thailand<span class='match'><\/span><\/li>\n  <li>Togo<span class='match'><\/span><\/li>\n  <li>Trinidad and Tobago<span class='match'><\/span><\/li>\n  <li>Tunisia<span class='match'><\/span><\/li>\n  <li>Turkey<span class='match'><\/span><\/li>\n  <li>Uganda<span class='match'><\/span><\/li>\n  <li>United Kingdom<span class='match'><\/span><\/li>\n  <li>United States<span class='match'><\/span><\/li>\n  <li>Uruguay<span class='match'><\/span><\/li>\n  <li>Venezuela<span class='match'><\/span><\/li>\n  <li>Vietnam<span class='match'><\/span><\/li>\n  <li>West Bank and Gaza<span class='match'><\/span><\/li>\n  <li>Yemen, Rep.<span class='match'><\/span><\/li>\n  <li>Zambia<span class='match'><\/span><\/li>\n  <li>Zimbabwe<span class='match'><\/span><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Countries that start with "Ca":

``` r
str_view_all_match(countries, pattern = "^Ca")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-35d3a0aa774e2191a233">{"x":{"html":"<ul>\n  <li><span class='match'>Ca<\/span>mbodia<\/li>\n  <li><span class='match'>Ca<\/span>meroon<\/li>\n  <li><span class='match'>Ca<\/span>nada<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Countries without a vowel? The word should start with a non-vowel, continue as a non-vowel, and end:

``` r
str_view_all_match(countries, "^[^aeiouAEIOU]*$") #^ means something different inside and outside of []
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-df3239bd5031b27af170">{"x":{"html":"<ul>\n  <li><\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
``` r
# * give me 0 or more of the preceding character (unspecified and unlimited repeat)
```

### Groups

We can refer to parentheses groups:

``` r
str_view_all(c("abad", "abbd"), pattern="(a)(b)\\1") #() forms group -> (a) is group 1, (b) is group 2
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-88b59f622880295e9a2a">{"x":{"html":"<ul>\n  <li><span class='match'>aba<\/span>d<\/li>\n  <li>abbd<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
``` r
str_view_all(c("abad", "abbd"), pattern="(a)(b)\\2") #\\ specifies repeating group 2
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-60cc7c3eaec1439e06c2">{"x":{"html":"<ul>\n  <li>abad<\/li>\n  <li><span class='match'>abb<\/span>d<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Note that the parentheses are first resolved, THEN referred to. NOT re-executed.

``` r
str_view_all(c("bananas"), "(.)(.)\\1\\2.*\\1\\2")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-17b53474250db258ef57">{"x":{"html":"<ul>\n  <li>bananas<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
``` r
# "anything" following by "anything", repeat first group, repeat second group, repeat any number of times, repeat group 1, repeat group 2
# First group resolves to 'a' and second group resolves to 'n' because that's the only thing that makes the whole expression "(.)(.)\\1\\2" work
# ex. 'ba' for groups 1 and 2, but not repeated "baba", try next. "an" and is repeated "anan" so it works
```

We can refer to them later in the search, too:

``` r
str_view_all(c("bananas", "Who can? Bananas can."), "(.)(.)\\1\\2.*\\1\\2")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-206e13dde6ee925ffa43">{"x":{"html":"<ul>\n  <li>bananas<\/li>\n  <li>Who can? B<span class='match'>ananas can<\/span>.<\/li>\n<\/ul>"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Final Exercises
---------------

Convert `words` to pig latin, which involves:

1.  Make the first letter the last letter
    -   Get the first letter with `str_sub(string, start, end)`.
2.  Remove the first letter from `words`.
    -   Hint: leave the `end` argument blank.
3.  Add "ay" to the end of the word.
    -   Use `str_c()`.

``` r
#YOUR_CODE_HERE
```

Find all countries that end in "y"

``` r
#str_view_all_match(countries, "YOUR_REGEX_HERE")
```

Find all countries that have the same letter repeated twice (like "Greece", which has "ee").

``` r
#str_view_all_match(countries, "YOUR_REGEX_HERE")
```

Find all countries that end in two vowels.

``` r
#str_view_all_match(countries, "YOUR_REGEX_HERE")
```

Find all countries that start with two non-vowels. How is this different from finding all countries that end in *at least* two non-vowels? Hint: Syria.

``` r
#countries %>% 
    #str_to_lower() %>% 
    #str_view_all_match("YOUR_REGEX_HERE")
```

Find all countries that have either "oo" or "cc" in them.

``` r
#str_view_all_match(countries, "YOUR_REGEX_HERE")
```
