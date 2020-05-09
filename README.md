
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

## Examples

This is a basic example. How similiar is `aple` to the strings `banana,
apple and pineapple`.

``` r
library(similiars)
find_string_distance("aple",
                     c("banana", "apple", "pineapple"))
#> $aple
#> # A tibble: 3 x 3
#>   input_string string    string_distance
#>   <chr>        <chr>               <dbl>
#> 1 aple         apple                   1
#> 2 aple         banana                  5
#> 3 aple         pineapple               5
```

The other function included is `find_`

``` r
library(similiars)
library(stringr)

x <- c("aple", "anana", "pech")
find_most_similiar_string(x, fruit)
#> [1] "apple"  "banana" "peach"
```

-----

If you find anything you want to improve, submit an issue :)
