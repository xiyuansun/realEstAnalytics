
<!-- README.md is generated from README.Rmd. Please edit that file -->
realEstAnalytics
================

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/xiyuansun/realEstAnalytics.svg?branch=master)](https://travis-ci.org/xiyuansun/realEstAnalytics) [![Codecov test coverage](https://codecov.io/gh/xiyuansun/realEstAnalytics/branch/master/graph/badge.svg)](https://codecov.io/gh/xiyuansun/realEstAnalytics?branch=master) <!-- badges: end -->

The goal of realEstAnalytics is to provide an R function for each zillow API service, making it easy to make API calls and process the responses into R-friendly data structures.

Website
-------

The package is hosted at <https://www.realestanalyticsr.com/>

Installation
------------

You can install the released version of realEstAnalytics from [Github](https://github.com) with:

``` r
library(devtools)
devtools::install_github("xiyuansun/realEstAnalytics")
```

Example
-------

Here are some basic examples of interfacing with Zillow's API in `R`. All calls to the API require a unique Zillow API key, which you can acquire by signing up at <https://www.zillow.com/howto/api/APIOverview.htm> .

First, you should always set your API key, also known as a Zillow Web Service ID (ZWSID):

``` r
library(realEstAnalytics)

#set the ZWS_ID
set_zillow_web_service_id('YOUR_API_KEY')
```

``` r
#retrieve the current ZWS_ID in use
zapi_key = getOption('ZillowR-zws_id')
```

You can get basic information on a property based on its address using `GetDeepSearchResults`. The return is a dataframe with the property's estimated value as well as other characteristics (i.e., bedrooms, bathrooms, etc.). To get results for more than one address at once, we recommend `GetDeepSearchResults_dataframe` rather than using an `apply()` or other mapping function.

``` r
GetDeepSearchResults('600 S. Quail Ct.', city='Newton',state='KS', zipcode=NULL,
                     api_key=getOption('ZillowR-zws_id'))
#> # A tibble: 1 x 26
#>   address zipcode city  state   lat  long region_name region_id type 
#>   <chr>   <chr>   <chr> <chr> <dbl> <dbl> <chr>       <chr>     <chr>
#> 1 600 S ~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#> # ... with 17 more variables: zestimate <dbl>, zest_lastupdated <date>,
#> #   zest_monthlychange <dbl>, zest_percentile <dbl>, zestimate_low <dbl>,
#> #   zestimate_high <dbl>, zpid <chr>, bathrooms <dbl>, bedrooms <dbl>,
#> #   finishedSqFt <dbl>, lastSoldDate <chr>, lastSoldPrice <dbl>,
#> #   lotSizeSqFt <dbl>, taxAssessment <dbl>, taxAssessmentYear <dbl>,
#> #   totalRooms <dbl>, yearBuilt <dbl>
```

Use the `GetComps` or `GetDeepComps` to get comparable properties for a given Zillow Property ID (limit 25 comparables). The return is a data frame with just the comparable addresses and their Zestimate values, with more property information available with `GetDeepComps`.

``` r
#retrieve the zpid from GetDeepSearchResults
zpidex <- GetDeepSearchResults('600 S. Quail Ct.', zipcode=67114,
                     rentzestimate=TRUE, api_key=getOption('ZillowR-zws_id'))$zpid

#GetComps for the '600 S. Quail Ct.' address
GetComps(zpidex, count=10, rentzestimate=TRUE, api_key = getOption('ZillowR-zws_id'))
#> # A tibble: 11 x 22
#>    address zipcode city  state   lat  long region_name region_id type 
#>    <chr>   <chr>   <chr> <chr> <dbl> <dbl> <chr>       <chr>     <chr>
#>  1 600 S ~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#>  2 2137 B~ 67114   Newt~ KS     38.0 -97.4 Newton      19619     city 
#>  3 2112 B~ 67114   Newt~ KS     38.0 -97.4 Newton      19619     city 
#>  4 427 Vi~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#>  5 410 Vi~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#>  6 2109 S~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#>  7 605 Au~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#>  8 506 Au~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#>  9 618 Au~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#> 10 3000 A~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#> 11 605 S ~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#> # ... with 13 more variables: zestimate <dbl>, zest_lastupdated <date>,
#> #   zest_monthlychange <dbl>, zest_percentile <dbl>, zestimate_low <dbl>,
#> #   zestimate_high <dbl>, rentzestimate <dbl>, rent_lastupdated <date>,
#> #   rent_monthlychange <dbl>, rentzestimate_low <dbl>,
#> #   rentzestimate_high <dbl>, zpid <chr>, compscore <dbl>
```

You can get the Zestimate (Zillow's estimated home value) with `GetZestimate`. The return is a data frame with the Zillow-estimated value of the home, either the property value or the estimated rental value (if `rentzestimate=TRUE`). This function works with either a single Zillow property ID or a vector of IDs:

``` r
#GetZestimate with a vector input
GetZestimate(zpids= zpidex ,
             rentzestimate=TRUE , api_key=getOption('ZillowR-zws_id'))
#> # A tibble: 1 x 20
#>   address zipcode city  state   lat  long region_name region_id type 
#>   <chr>   <chr>   <chr> <chr> <dbl> <dbl> <chr>       <chr>     <chr>
#> 1 600 S ~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#> # ... with 11 more variables: zestimate <dbl>, zest_lastupdated <date>,
#> #   zest_monthlychange <dbl>, zest_percentile <dbl>, zestimate_low <dbl>,
#> #   zestimate_high <dbl>, rentzestimate <dbl>, rent_lastupdated <date>,
#> #   rent_monthlychange <dbl>, rentzestimate_low <dbl>,
#> #   rentzestimate_high <dbl>
```

There are also a few options for retrieving non-API data. Get the time series of property values aggregated by region and type with `get_rental_listings` and/or `get_ZHVI_series`. These return dataframes of time series data for the selected geographic aggregation level and property type, read from a static .csv hosted by Zillow. For options on the arguments, see the introduction vignette.

``` r
#Pull the data by state and zipcode for 4 bedrooms
cityseries <- get_ZHVI_series(bedrooms=4,geography="Zip")
#> [1] "attempting to read file:"
#> [1] "http://files.zillowstatic.com/research/public/Zip/Zip_Zhvi_4bedroom.csv"
#> Parsed with column specification:
#> cols(
#>   .default = col_double(),
#>   RegionName = col_character(),
#>   City = col_character(),
#>   State = col_character(),
#>   Metro = col_character(),
#>   CountyName = col_character()
#> )
#> See spec(...) for full column specifications.

head(cityseries)
#> # A tibble: 6 x 283
#>   RegionID RegionName City  State Metro CountyName SizeRank `1996-04`
#>      <dbl> <chr>      <chr> <chr> <chr> <chr>         <dbl>     <dbl>
#> 1    84654 60657      Chic~ IL    Chic~ Cook Coun~        1    381400
#> 2    91982 77494      Katy  TX    Hous~ Harris Co~        2    241400
#> 3    84616 60614      Chic~ IL    Chic~ Cook Coun~        3    551500
#> 4    91940 77449      Katy  TX    Hous~ Harris Co~        4    109900
#> 5    93144 79936      El P~ TX    El P~ El Paso C~        5    102400
#> 6    91733 77084      Hous~ TX    Hous~ Harris Co~        6    121000
#> # ... with 275 more variables: `1996-05` <dbl>, `1996-06` <dbl>,
#> #   `1996-07` <dbl>, `1996-08` <dbl>, `1996-09` <dbl>, `1996-10` <dbl>,
#> #   `1996-11` <dbl>, `1996-12` <dbl>, `1997-01` <dbl>, `1997-02` <dbl>,
#> #   `1997-03` <dbl>, `1997-04` <dbl>, `1997-05` <dbl>, `1997-06` <dbl>,
#> #   `1997-07` <dbl>, `1997-08` <dbl>, `1997-09` <dbl>, `1997-10` <dbl>,
#> #   `1997-11` <dbl>, `1997-12` <dbl>, `1998-01` <dbl>, `1998-02` <dbl>,
#> #   `1998-03` <dbl>, `1998-04` <dbl>, `1998-05` <dbl>, `1998-06` <dbl>,
#> #   `1998-07` <dbl>, `1998-08` <dbl>, `1998-09` <dbl>, `1998-10` <dbl>,
#> #   `1998-11` <dbl>, `1998-12` <dbl>, `1999-01` <dbl>, `1999-02` <dbl>,
#> #   `1999-03` <dbl>, `1999-04` <dbl>, `1999-05` <dbl>, `1999-06` <dbl>,
#> #   `1999-07` <dbl>, `1999-08` <dbl>, `1999-09` <dbl>, `1999-10` <dbl>,
#> #   `1999-11` <dbl>, `1999-12` <dbl>, `2000-01` <dbl>, `2000-02` <dbl>,
#> #   `2000-03` <dbl>, `2000-04` <dbl>, `2000-05` <dbl>, `2000-06` <dbl>,
#> #   `2000-07` <dbl>, `2000-08` <dbl>, `2000-09` <dbl>, `2000-10` <dbl>,
#> #   `2000-11` <dbl>, `2000-12` <dbl>, `2001-01` <dbl>, `2001-02` <dbl>,
#> #   `2001-03` <dbl>, `2001-04` <dbl>, `2001-05` <dbl>, `2001-06` <dbl>,
#> #   `2001-07` <dbl>, `2001-08` <dbl>, `2001-09` <dbl>, `2001-10` <dbl>,
#> #   `2001-11` <dbl>, `2001-12` <dbl>, `2002-01` <dbl>, `2002-02` <dbl>,
#> #   `2002-03` <dbl>, `2002-04` <dbl>, `2002-05` <dbl>, `2002-06` <dbl>,
#> #   `2002-07` <dbl>, `2002-08` <dbl>, `2002-09` <dbl>, `2002-10` <dbl>,
#> #   `2002-11` <dbl>, `2002-12` <dbl>, `2003-01` <dbl>, `2003-02` <dbl>,
#> #   `2003-03` <dbl>, `2003-04` <dbl>, `2003-05` <dbl>, `2003-06` <dbl>,
#> #   `2003-07` <dbl>, `2003-08` <dbl>, `2003-09` <dbl>, `2003-10` <dbl>,
#> #   `2003-11` <dbl>, `2003-12` <dbl>, `2004-01` <dbl>, `2004-02` <dbl>,
#> #   `2004-03` <dbl>, `2004-04` <dbl>, `2004-05` <dbl>, `2004-06` <dbl>,
#> #   `2004-07` <dbl>, `2004-08` <dbl>, ...
```

Please see the vignette (under articles) to see further documentation and examples of `realEstAnalytics`' capabilities.
