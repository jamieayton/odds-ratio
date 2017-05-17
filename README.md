Odds Ratio
================

### Summary

A simple recreation of the table shown in Keith Cheung's [Fixed-Odds Betting and Traditional Odds](%22http://www.sportstradingnetwork.com/article/fixed-odds-betting-traditional-odds/%22) article.
This includes a function to find the value 'c' when the odds ratios are equal for a two-way & three-way market.

------------------------------------------------------------------------

### Definitions

For a two-way betting market we will use the following definitions:

-   `1/p` & `1/q` are 'true' odds; where `p` & `q` are the 'true' probabilities of events `p` & `q` occurring
-   similarly `1/x` & `1/y` are bookmakers odds; where `x` & `y` are the implied probabilities
-   `v` is the overround of the bookmakers market and thus *v* ≥ 1

For a three-way betting market we extend to:

-   `p, q & r` for 'true' probabilities
-   `x, y & z` for the bookmakers probabilities

Note that:

-   We have *p* + *q* = 1 (or *p* + *q* + *r* = 1 for a three-way market)
-   We have *x* + *y* = *v* (or *x* + *y* + *z* = *v*)

------------------------------------------------------------------------

### Function Definitions

For a given event with probability `p` & corresponding bookmakers probability `x`:

-   Define the yield to be
    $$ Yield(x,p) = \\dfrac{p}{x} - 1 $$
-   Define the odds ratio to be
    $$ OR(x,p) = \\dfrac{x/(1-x)}{p/(1-p)} $$

Here are these definitions as r functions:

``` r
yield <- function(bookmakers_prob, true_prob){
  
  x <- bookmakers_prob
  p <- true_prob
  
  # check are numbers and have length 1
  stopifnot(is.numeric(x) && is.numeric(p))
  stopifnot(length(x) == 1 && length(p)==1)
  
  # output
  p/x - 1
}
```

``` r
odds_ratio <- function(bookmakers_prob, true_prob){
  
  x <- bookmakers_prob
  p <- true_prob
  
  # check are numbers and have length 1
  stopifnot(is.numeric(x) && is.numeric(p))
  stopifnot(length(x) == 1 && length(p)==1)
  
  # output
  (x/(1-x)) / (p/(1-p))
}
```

------------------------------------------------------------------------

### Solver Functions

We will use the following solvers to find the value `c` when the odds ratios are equivalent for each event of the market.
The method defined in the article is a way to find the bookmakers odds from the true probabilities, but we will make the input to the solver ambiguous so we can supply either set of odds and the desired overround and simply find the corresponding `c`.

Note that these functions are not vectorised so we call them with either `lapply` or `purrr::pmap`.

``` r
two_way_market_solver <- function(odds_1, odds_2, overround){
  
  # check inputs are all numeric & length == 1
  stopifnot(all(is.numeric(odds_1), is.numeric(odds_2), is.numeric(overround)))
  stopifnot(all(length(odds_1) == 1, length(odds_2) == 1, length(overround) == 1))
  
  # adjust odds to probabilities
  p <- 1/odds_1
  q <- 1/odds_2
  
  # solver function: minimise 'x + y - v' to find c such that x + y = v
  find_c <- function(c){
    abs((c*p/(1-p+c*p)) + (c*q/(1-q+c*q)) - overround)
  }
  
  # use optim to solve with lower bound to prevent -ve roots
  optimised_solver <- optim(
    par = c(1), fn = find_c, method = "Brent", lower = 1e-03, upper = 1e+03
  )
  
  # output parameter from optim
  optimised_solver$par[1]
}
```

``` r
three_way_market_solver <- function(odds_1, odds_2, odds_3, overround){
  
  # check inputs are all numeric & length == 1
  stopifnot(all(is.numeric(odds_1), is.numeric(odds_2), is.numeric(odds_3), is.numeric(overround)))
  stopifnot(all(length(odds_1) == 1, length(odds_2) == 1, length(odds_3) == 1, length(overround) == 1))
  
  # adjust odds to probabilities
  p <- 1/odds_1
  q <- 1/odds_2
  r <- 1/odds_3
  
  # solver function: minimise 'x + y - v' to find c such that x + y = v
  find_c <- function(c){
    abs((c*p/(1-p+c*p)) + (c*q/(1-q+c*q)) + (c*r/(1-r+c*r)) - overround)
  }
  
  # use optim to solve with lower bound to prevent -ve roots
  optimised_solver <- optim(
    par = c(1), fn = find_c, method = "Brent", lower = 1e-03, upper = 1e+03
  )
  
  # output parameter from optim
  optimised_solver$par[1]
}
```

------------------------------------------------------------------------

### Examples

#### 1. Two-Way Market Table

The following table is a recreation of the table shown in the referenced article - I have limited the table to show the top 10 rows.

|   1/p|   1/q|   1/x|   1/y|      v|    Y(x)|    Y(y)|  OR(x,p)|  OR(y,q)|
|-----:|-----:|-----:|-----:|------:|-------:|-------:|--------:|--------:|
|  2.00|  2.00|  1.85|  1.85|  1.081|  -0.075|  -0.075|    1.176|    1.176|
|  1.96|  2.04|  1.82|  1.89|  1.081|  -0.073|  -0.076|    1.176|    1.176|
|  1.92|  2.09|  1.78|  1.92|  1.081|  -0.072|  -0.078|    1.177|    1.177|
|  1.88|  2.14|  1.75|  1.97|  1.081|  -0.070|  -0.080|    1.177|    1.177|
|  1.84|  2.19|  1.71|  2.01|  1.081|  -0.069|  -0.082|    1.178|    1.178|
|  1.80|  2.25|  1.68|  2.06|  1.081|  -0.067|  -0.084|    1.179|    1.179|
|  1.76|  2.32|  1.64|  2.12|  1.081|  -0.066|  -0.087|    1.180|    1.180|
|  1.72|  2.39|  1.61|  2.18|  1.081|  -0.064|  -0.089|    1.181|    1.181|
|  1.68|  2.47|  1.57|  2.24|  1.081|  -0.063|  -0.092|    1.183|    1.183|
|  1.64|  2.56|  1.54|  2.32|  1.081|  -0.061|  -0.096|    1.186|    1.186|

------------------------------------------------------------------------

#### 2. Three-Way Market Table

The following example shows the same set of made-up odds for a three-way market, but this time we will see what happens as the overround increases.

|   1/p|   1/q|    1/r|   1/x|   1/y|    1/z|     v|  OR(x,p)|  OR(y,q)|  OR(z,r)|
|-----:|-----:|------:|-----:|-----:|------:|-----:|--------:|--------:|--------:|
|  1.66|  3.33|  10.25|  1.66|  3.33|  10.25|  1.00|    1.000|    1.000|    1.000|
|  1.66|  3.33|  10.25|  1.65|  3.29|  10.08|  1.01|    1.019|    1.019|    1.019|
|  1.66|  3.33|  10.25|  1.64|  3.25|   9.91|  1.02|    1.038|    1.038|    1.038|
|  1.66|  3.33|  10.25|  1.62|  3.21|   9.75|  1.03|    1.057|    1.057|    1.057|
|  1.66|  3.33|  10.25|  1.61|  3.17|   9.59|  1.04|    1.077|    1.077|    1.077|
|  1.66|  3.33|  10.25|  1.60|  3.13|   9.43|  1.05|    1.097|    1.097|    1.097|
|  1.66|  3.33|  10.25|  1.59|  3.09|   9.28|  1.06|    1.117|    1.117|    1.117|
|  1.66|  3.33|  10.25|  1.58|  3.05|   9.13|  1.07|    1.137|    1.137|    1.137|
|  1.66|  3.33|  10.25|  1.57|  3.01|   8.98|  1.08|    1.158|    1.158|    1.158|
|  1.66|  3.33|  10.25|  1.56|  2.98|   8.84|  1.09|    1.179|    1.179|    1.179|
|  1.66|  3.33|  10.25|  1.55|  2.94|   8.70|  1.10|    1.201|    1.201|    1.201|

------------------------------------------------------------------------

#### 3. Estimating True Probabilities from Bookmakers Odds

The following example shows a set of real bookmakers odds `1/x`, `1/y`, `1/z` for a three-way market, and we will use these to estimate the true odds `1/p`, `1/q`, `1/r`.
To achieve this we will use the three-way market solver function, and supply it with the bookmakers odds but set the overround argument to be 1. This means the function will find the value `c` which corresponds to the odds ratios being equal and the overround being equal to 1.

|   1/x|    1/y|    1/z|       v|   1/p|    1/q|    1/r|  OR(x,p)|  OR(y,q)|  OR(z,r)|
|-----:|------:|------:|-------:|-----:|------:|------:|--------:|--------:|--------:|
|  1.11|  12.00|  28.50|  1.0209|  1.12|  13.23|  31.58|    1.112|    1.112|    1.112|
|  1.16|   9.00|  21.00|  1.0208|  1.17|   9.66|  22.65|    1.083|    1.083|    1.083|
|  2.74|   3.33|   2.82|  1.0199|  2.79|   3.40|   2.87|    1.030|    1.030|    1.030|
|  4.44|   3.78|   1.88|  1.0206|  4.56|   3.87|   1.91|    1.034|    1.034|    1.034|

------------------------------------------------------------------------
