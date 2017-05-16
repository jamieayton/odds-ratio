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

Note that:

-   For a three-way market we will use terms `p, q & r` for 'true' probabilities & `x, y & z` for the bookmakers probabilities
-   We have *p* + *q* = 1 (or *p* + *q* + *r* = 1 for a three-way market)
-   We have *x* + *y* = *v* (or *x* + *y* + *z* = *v*)

------------------------------------------------------------------------

### Two-Way Market Table

|   1/p|         1/q|       1/x|        1/y|      v|       Y(x)|        Y(y)|   OR(x,p)|   OR(y,q)|
|-----:|-----------:|---------:|----------:|------:|----------:|-----------:|---------:|---------:|
|  2.00|    2.000000|  1.850139|   1.850139|  1.081|  0.4250694|   0.4250694|  1.176279|  1.176279|
|  1.96|    2.041667|  1.816078|   1.885501|  1.081|  0.4367746|   0.4133068|  1.176358|  1.176358|
|  1.92|    2.086956|  1.781907|   1.923804|  1.081|  0.4489101|   0.4009892|  1.176610|  1.176610|
|  1.88|    2.136364|  1.747626|   1.965427|  1.081|  0.4615034|   0.3880721|  1.177058|  1.177058|
|  1.84|    2.190476|  1.713236|   2.010822|  1.081|  0.4745846|   0.3745055|  1.177731|  1.177731|
|  1.80|    2.250000|  1.678735|   2.060524|  1.081|  0.4881863|   0.3602328|  1.178663|  1.178663|
|  1.76|    2.315790|  1.644125|   2.115176|  1.081|  0.5023441|   0.3451895|  1.179894|  1.179894|
|  1.72|    2.388889|  1.609407|   2.175554|  1.081|  0.5170971|   0.3293015|  1.181477|  1.181477|
|  1.68|    2.470588|  1.574580|   2.242604|  1.081|  0.5324883|   0.3124827|  1.183473|  1.183473|
|  1.64|    2.562500|  1.539646|   2.317496|  1.081|  0.5485649|   0.2946326|  1.185962|  1.185962|
|  1.60|    2.666667|  1.504606|   2.401685|  1.081|  0.5653791|   0.2756318|  1.189045|  1.189045|
|  1.56|    2.785714|  1.469462|   2.497010|  1.081|  0.5829887|   0.2553369|  1.192854|  1.192854|
|  1.52|    2.923077|  1.434216|   2.605829|  1.081|  0.6014580|   0.2335731|  1.197560|  1.197560|
|  1.48|    3.083333|  1.398871|   2.731212|  1.081|  0.6208589|   0.2101227|  1.203396|  1.203396|
|  1.44|    3.272727|  1.363432|   2.877230|  1.081|  0.6412720|   0.1847090|  1.210682|  1.210682|
|  1.40|    3.500000|  1.327904|   3.049399|  1.081|  0.6627885|   0.1569712|  1.219870|  1.219870|
|  1.36|    3.777778|  1.292297|   3.255377|  1.081|  0.6855124|   0.1264235|  1.231624|  1.231624|
|  1.32|    4.125000|  1.256625|   3.506098|  1.081|  0.7095640|   0.0923875|  1.246958|  1.246958|
|  1.28|    4.571429|  1.220908|   3.817705|  1.081|  0.7350844|   0.0538729|  1.267496|  1.267496|
|  1.24|    5.166667|  1.185183|   4.214987|  1.081|  0.7622446|   0.0093524|  1.296013|  1.296013|
|  1.20|    6.000000|  1.149514|   4.737837|  1.081|  0.7912612|  -0.0436938|  1.337672|  1.337672|
|  1.16|    7.250000|  1.114022|   5.453994|  1.081|  0.8224330|  -0.1097939|  1.403235|  1.403235|
|  1.12|    9.333333|  1.078984|   6.484995|  1.081|  0.8562356|  -0.1980363|  1.519297|  1.519297|
|  1.08|   13.500000|  1.045135|   8.052421|  1.081|  0.8936440|  -0.3294503|  1.772441|  1.772441|
|  1.06|   17.666667|  1.029290|   9.136062|  1.081|  0.9144244|  -0.4262606|  2.048493|  2.048493|
|  1.04|   26.000000|  1.015090|  10.431260|  1.081|  0.9375866|  -0.5603361|  2.650759|  2.650759|
|  1.02|   51.000000|  1.004291|  11.727109|  1.081|  0.9649910|  -0.7504488|  4.661088|  4.661088|
|  1.01|  101.000000|  1.001118|  12.177815|  1.081|  0.9813047|  -0.8695266|  8.946292|  8.946292|
