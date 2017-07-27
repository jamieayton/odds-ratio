# True Odds Estimation
Jamie Ayton  
`r format(Sys.time(), '%d %B %Y')`  




### Summary

I have previously shown how to calculate the [Odds Ratio](http://htmlpreview.github.io/?https://github.com/jamieayton/odds-ratio/blob/master/odds-ratio.html) and how to estimate the true odds (and thus the true probabilities) from given Bookmakers odds.
Lets compare the 'Odds Ratio' method to a couple of other methods of estimating the true odds - 'Proportional Odds' & the '[Power Odds](http://www.jmlr.org/papers/volume10/vovk09a/vovk09a.pdf)'.  

We will compare the three methods by calculating the implied true probabilities for each method and then calculating Ranked Probability Score for real bookmakers odds for the 1x2 market of a selection of football matches. The odds data is from [www.football-data.co.uk](http://www.football-data.co.uk/).  

***


### Definitions

First lets fully define the different methods.  

For a three-way market, given bookmakers odds `1/p, 1/q, 1/r` with corresponding probabilities `p, q, r`; we wish to find true odds `1/x, 1/y, 1/z` with corresponding probabilities `x, y, z` such that $x + y + z = 1$.  

* Proportional Odds:  
    Let $v = p + q + r$, then we define $(x, y, z) := (\ p/v,\ q/v,\ r/v \ )$.

* Odds Ratio:  
    We defined the Odds Ratio of `x` & `p` to be $OR(x,p)$ and we find `x, y, z` such that $OR(x,p) = OR(y,q) = OR(z,r)$.

* Power Odds:  
    Define $(x, y, z) := (\ p^{-\lambda},\ q^{-\lambda},\ r^{-\lambda} \ )$, where $\lambda \in \mathbb{R}$ is chosen such that $x + y + z = 1$.


***


### Data








As mentioned the data is from [www.football-data.co.uk](http://www.football-data.co.uk/) and I have applied the following filters.  

* The leagues selected are: *English Premier League, English Championship, English League One, English League Two, Scottish Premiership, German Bundesliga, Italian Serie A, Spanish La Liga, French Ligue One*  
* The seasons selected are: *2016-17, 2015-16, 2014-15, 2013-14, 2012-13*  
* The odds are from the following bookmakers: *Bet Brain - Max, Bet Brain - Average, Bet365, Pinnacle Sports*  
* If any of the odds are missing then all the data for that specific game is removed from the dataset.
* If any of the odds values are invalid (ie. odds that are less than 1), again, all the data for that specific game is removed.


That leaves us with 18,499 matches across 4 
different bookmakers; giving us 73,996 individual odds values.  


***

### RPS Comparison





















Below is a table comparing the calculated RPS values (lower is better) across the differents true odds estimates for the  various different bookmakers.


|Bookmaker           |Matches |Overround |Original Odds |Proportional Odds |Ratio Odds |Power Odds |
|:-------------------|:-------|:---------|:-------------|:-----------------|:----------|:----------|
|Bet Brain - Average |18499   |1.063     |0.300399      |0.299906          |0.299750   |0.299708   |
|Bet Brain - Max     |18499   |1.002     |0.299801      |0.299757          |0.299771   |0.299782   |
|Bet365              |18499   |1.044     |0.300147      |0.299892          |0.299786   |0.299763   |
|Pinnacle Sports     |18499   |1.024     |0.299724      |0.299660          |0.299625   |0.299614   |
|Total               |73996   |1.033     |0.300018      |0.299804          |0.299733   |0.299717   |

We see that in general the RPS value is lowest for the 'Power Odds', then 'Ratio Odds', 'Proportional Odds' and finally the 'Original Odds' have the highest RPS values. This means that in general that the 'Power' method produces odds which are closest to the True Odds of all the methods.  
Curiously this is not true for the bookmaker 'Bet Brain - Max', perhaps this is due to the very low overround.  
We also note that the bookmaker 'Pinnacle Sports' consistently has the lowest RPS regardless of the odds method.  


***



### Pinnacle Sports Odds

Let's focus on the 'Pinnacle Sports' odds and try to look at the different odds methods in more detail. 

&nbsp; 
  
### Odds Comparison

First lets visually compare the odds to the original odds.  


<img src="true-odds-estimation_files/figure-html/plot - odds & probs comparison-1.png" style="display: block; margin: auto;" />


* Fig 1.1 : 
    + For large odds values the differences between the different methods & the $y = x$ dotted line becomes more apparent. We see that the 'Estimated Odds' are larger however the 'Ratio Odds' & 'Power Odds' diverge away above the dotted line.
    + For small odds values it is very hard to distinguish the methods from the 'Original Odds' and from each other. 
    + The majority of the data falls within the 'small odds values' range - it is clear that we are not going to learn anything from plotting 'Odds vs Odds'.
* Fig 1.2 : 
    + Converting to a 'Probability vs Probability' plot is actually worse than the 'Odds vs Odds' plot! This time we can't see if there are any differences at all. We will need to come up with another way to plot the data.  
  

&nbsp;


Since Fig 1.1 shows a general increase for large odds value - lets try plotting the change in the value of the odds in the form of a scalar value, where the scalar multiple $\lambda$ is such that $\text{Estimated True Odds} = \lambda * \text{Original Odds}$.  

&nbsp;

<img src="true-odds-estimation_files/figure-html/plot - odds & probs scalar increase -1.png" style="display: block; margin: auto;" />

* Fig 1.3: Odds Plot
    + The fitted curves for the different methods are above the $y = 1$ dotted line. So the True Odds are greater than the Original Odds across the whole range.
    + We see that the scalar increase for the 'Proportional Odds' method is quite uniform across the whole range. So this method increases the 'Original Odds' by the same scalar amount across the whole odds range.
    + The Power Odds & Ratio Odds have a linear trend between the Original Odds value and the scalar multiple - so as the odds value increases the scalar multiple also increases. 
    + We have an intersection point at Original Odds of ~ 3.0.  
      Above this point the 'Power Odds' method produces the largest True Odds values and the 'Proportional Odds' method produces the smallest True Odds values.  
      Below this point the 'Power Odds' method produces the smallest True Odds values and the 'Proportional Odds' produces the largest True Odds values.  

* Fig 1.4: Probability Plot
    + This plot just shows the same as the Odds plot, however since probabilities are the inverse of the odds values our whole plot is inversed, including the scalar multiples.  






&nbsp;


So now we understand how the various methods differ in producing 'True Odds' across the range of our 'Original Odds', but how does this link to the RPS values which showed that the 'Power Odds' method was the most accurate.  

Lets visualize the RPS values as a comparison to the Original Odds values.  

&nbsp;

&nbsp;

### RPS Comparison

If we try to plot the RPS values we will run into the same situation that we did with visualizing the odds values - the values will be too close to distinguish the different odds methods. So similar to the odds plots we will need to plot a variable which represents the change in the RPS value.  

Lets define the RPS Difference $\lambda$ to be such that $\lambda = \text{RPS}_{\text{True Odds}} - \text{RPS}_{\text{Original Odds}}$. Then if $\lambda < 0$ this means that the 'True Odds' produced are more accurate than the 'Original odds', and conversely if $\lambda > 0$ then the 'Original odds' are more accurate.  

  
<img src="true-odds-estimation_files/figure-html/- rps comparison diff-1.png" style="display: block; margin: auto;" />

Lets breakdown the graph by each Odds Method: 

* Power Odds  
    + More accurate than the 'Original Odds' for the whole probability domain - since the RPS Difference value is negative.
    + Most accurate method for (approximately) Original Probability < ~0.25 & 0.5 < Original Probability.
    + Least accurate method for 0.3 < Original Probability < 0.4.
* Proportional Odds  
    + More accurate than the 'Original Odds' for 0.2 < Original Probability < 0.65.
    + Most accurate method for 0.3 < Original Probability < 0.4.
    + Least accurate method for Original Probability < 0.3 & 0.4 < Original Probability
* Ratio Odds  
    + More accurate than the 'Original Odds' for 0.1 < Original Probability < 0.8.
    + It appears there are two very small regions around Original Probability = 0.3 & Original Probability = 0.4 where this method is the most accurate method.
    + This method doesn't appear to be the least accurate method for any probability domain.



&nbsp;

  

### A Combined Method

What determines these cut off points where the most accurate method switches between the various odds methods?  

If we could determine these cut off points we could create a more accurate method for determining the True Odds by picking the most appropriate method given the Original Odds values.  

Lets consider some other factors which might effect these cut off points:  

1. Odds Type - for example, does the odds value relate to 'Home', 'Draw' or 'Away' match outcome?
2. Favourite - does it affect the cutoff if the Home team is the favourite or if the Away team is the favourite?
3. Overround - as the overround increase does this effect the cut off points or promote a different method?
4. Bookmaker - do we see the same patterns for all bookmakers?

  
In order to investigate these factors we need a method for determining these cut off points. We will do this by fitting a [LOESS Model]("https://en.wikipedia.org/wiki/Local_regression") using the Original Probabilities as our predictor variable (since it is defined regularly on the domain $\left[0, 1\right]$), and the RPS values or change in RPS values as a response variable. We can then use these predictions to determine the values where there are crossovers.






As an example - lets take the RPS Comparison from above & calculate the intersection points between the various methods.


<img src="true-odds-estimation_files/figure-html/- rps comparison crossover points-1.png" style="display: block; margin: auto;" />


From Fig 1.7 we see that we can define a new Odds Method by choosing a different method for different domains of the Original Probabilties:  


|Lower Bound|Original Probabilities|Upper Bound|   Odds Method   |
|----------:|:--------------------:|:----------|:---------------:|
|          0|        < x <=        |0.27401    |   Power Odds    |
|    0.27401|        < x <=        |0.29634    |   Ratio Odds    |
|    0.29634|        < x <=        |0.44363    |Proportional Odds|
|    0.44363|        < x <=        |0.45983    |   Ratio Odds    |
|    0.45983|        < x <=        |1.0        |   Power Odds    |

&nbsp; 

Finally - here is a table comparing the RPS values for the Original Odds method, the 3 True Odds methods already seen, and the Combined Method for determining True Odds. We already know that the Power Odds method is the most accurate of the 3 methods - and the Combined Method is more accurate but only by a very small amount.  



|Matches |Overround |Combined Method |Original Odds |Power Odds |Proportional Odds |Ratio Odds |
|:-------|:---------|:---------------|:-------------|:----------|:-----------------|:----------|
|18499   |1.024285  |0.299611        |0.299724      |0.299614   |0.29966           |0.299625   |

&nbsp; 

***

### Further Investigations

There are other factors that could affect which odds method is the most accurate for predicting the 'True Odds':

* Overround
* Bookmaker - this factor is heavily linked to the 'Overround' since each bookmaker will run a different Overround %
* Which team is the favourite - ie. either Home team or the Away team
* The match outcome that is being predicted - for example the 'Draw' odds value is usually a midpoint between the other two odds values.

The above factors are all heavily linked together so it is difficult to analyse each individually. For example the 'Bookmaker' & 'Overround' factors are heavily linked since each bookmaker will run a different Overround %, but then the overround could also depend on the league that the odds are from since liquidity might be lower in this league.

&nbsp; 

***

### Finale 

In summary we see that:

* The 'Pinnacle Sports' odds are the most accurate set of Original Odds
* The Power Odds method is the most accurate overall method for predicting the 'True Odds' from the Original Odds
    - The Power Odds method is the most accurate method for 'large' & 'small' values of the Original Probabilities
    - The Proportional Odds method is the most accurate method for 'medium' values of the Original Probabilities
* We can create a combined method using the most accurate method for different domains of Original Probabilities
* There are lots of other factors that could effect which Odds method is the most accurate for predicting 'True Odds'

&nbsp; 

***

