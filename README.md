
<!-- README.md is generated from README.Rmd. Please edit that file -->

# similiars

<!-- badges: start -->

[![R-CMD-check](https://github.com/davidsjoberg/similiars/workflows/R-CMD-check/badge.svg)](https://github.com/davidsjoberg/similiars/actions)
<!-- badges: end -->

The goal of similars is to match strings to the most similar string in
another vector.

## Installation

You can install the released version of `similiars` with:

``` r
remotes::install_github("davidsjoberg/similiars")
```

### `find_most_similar_string`

The main function included is `find_most_similar_string` which returns a
vector of the same length as the vector to be matched against another.

``` r
library(similiars)

x <- c("battman", "Y-men", "Supergrl")
find_most_similar_string(x, superheroes)
#> [1] "Batman"    "X-Men"     "Supergirl"
```

### `find_string_distance`

The other function is `find_string_distance`. It returns a list of
dataframes for each word and how similar each string is to all matched
strings. If you are not sure if there is a good match to be found it is
good practise to use this function before using
`find_most_similar_string`.

``` r
find_string_distance(c("aple", "abna"),
                     c("banana", "apple", "pineapple"))
#> $aple
#> # A tibble: 3 x 3
#>   input_string string    string_distance
#>   <chr>        <chr>               <dbl>
#> 1 aple         apple                   1
#> 2 aple         banana                  5
#> 3 aple         pineapple               5
#> 
#> $abna
#> # A tibble: 3 x 3
#>   input_string string    string_distance
#>   <chr>        <chr>               <dbl>
#> 1 abna         banana                  3
#> 2 abna         apple                   4
#> 3 abna         pineapple               7
```

### `case_when_skeleton`

If you want manual control over which should be replaced you can create
a `case_when` code chunk to use in your script.

``` r
# Misspelled vector
supr_heros   <- c("Btman", "Supergrl", "Tor", "Capitan 'Murica")
# Corrected vector
super_heroes <- find_most_similar_string(supr_heros, superheroes)

# Make case_when skeleton to replace
case_when_skeleton(supr_heros, super_heroes)
#> case_when(
#>     supr_heros == "Btman" ~ "Batman",
#>     supr_heros == "Supergrl" ~ "Supergirl",
#>     supr_heros == "Tor" ~ "Thor",
#>     supr_heros == "Capitan 'Murica" ~ "Captain America",
#>   T ~ supr_heros
#> )
```

-----

If you find anything you want to improve, submit an issue :)
