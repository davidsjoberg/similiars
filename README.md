
<!-- README.md is generated from README.Rmd. Please edit that file -->

# similiars

<!-- badges: start -->

<!-- badges: end -->

The goal of similiars is to match strings to the most similiar string in
another vector.

## Installation

You can install the released version of similiars with:

``` r
remotes::install_github("davidsjoberg/similiars")
```

### `find_most_similiar_string`

The main function included is `find_most_similiar_string` which returns
a vector of the same length as the vector to be matched against another.

``` r
library(similiars)
library(stringr)

x <- c("aple", "anana", "pech")
find_most_similiar_string(x, fruit)
#> [1] "apple"  "banana" "peach"
```

### `find_string_distance`

The other function is `find_string_distance`. It returns a list of
dataframes for each word and how similiar each string is to all matched
strings. If you are not sure if there is a good match to be found it is
good practise to use this function before using
`find_most_similiar_string`.

``` r
library(similiars)
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

-----

If you find anything you want to improve, submit an issue :)
