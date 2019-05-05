
<!-- README.md is generated from README.Rmd. Please edit that file -->
realEstAnalytics
================

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/xiyuansun/realEstAnalytics.svg?branch=master)](https://travis-ci.org/xiyuansun/realEstAnalytics) [![Codecov test coverage](https://codecov.io/gh/xiyuansun/realEstAnalytics/branch/master/graph/badge.svg)](https://codecov.io/gh/xiyuansun/realEstAnalytics?branch=master) <!-- badges: end -->

The goal of realEstAnalytics is to provide an R function for each zillow API service, making it easy to make API calls and process the responses into R-friendly data structures.

Website
-------

-   The package is hosted at <https://www.realestanalyticsr.com/>

-   For an Rshiny app demonstrating some of the package's capabilities, go to <https://xiyuansun2010.shinyapps.io/realEstAnalytics_shiny_app/> (Note: Valid API key required for use)

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

Calling the Zillow API from R
-----------------------------

You can get basic information on a property based on its address using `GetDeepSearchResults`. The return is a dataframe with the property's estimated value as well as other characteristics (i.e., bedrooms, bathrooms, etc.). To get results for more than one address at once, we recommend `GetDeepSearchResults_dataframe` rather than using an `apply()` or other mapping function, because some addresses have multiple properties.

``` r
GetDeepSearchResults('2902 Wood St.', city='Ames',state='IA', zipcode=50014,
                     rentzestimate=TRUE,
                     api_key=getOption('ZillowR-zws_id'))
#> # A tibble: 1 x 31
#>   address zipcode city  state   lat  long region_name region_id type 
#>   <chr>   <chr>   <chr> <chr> <dbl> <dbl> <chr>       <chr>     <chr>
#> 1 2902 W~ 50014   Ames  IA     42.0 -93.7 College Cr~ 764177    neig~
#> # ... with 22 more variables: zestimate <dbl>, zest_lastupdated <date>,
#> #   zest_monthlychange <dbl>, zest_percentile <dbl>, zestimate_low <dbl>,
#> #   zestimate_high <dbl>, rentzestimate <dbl>, rent_lastupdated <date>,
#> #   rent_monthlychange <dbl>, rentzestimate_low <dbl>,
#> #   rentzestimate_high <dbl>, zpid <chr>, bathrooms <dbl>, bedrooms <dbl>,
#> #   finishedSqFt <dbl>, lastSoldDate <chr>, lastSoldPrice <dbl>,
#> #   lotSizeSqFt <dbl>, taxAssessment <dbl>, taxAssessmentYear <dbl>,
#> #   totalRooms <dbl>, yearBuilt <dbl>
```

Use the `GetComps` or `GetDeepComps` to get comparable properties for a given Zillow Property ID (limit 25 comparables). The return is a data frame with the most comparable addresses and their Zestimate values, with more property information (i.e., the `GetDeepSearchResults` variables) available from `GetDeepComps`.

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
#>  7 605 S ~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#>  8 605 Au~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#>  9 506 Au~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#> 10 618 Au~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#> 11 3000 A~ 67114   Newt~ KS     38.0 -97.3 Newton      19619     city 
#> # ... with 13 more variables: zestimate <dbl>, zest_lastupdated <date>,
#> #   zest_monthlychange <dbl>, zest_percentile <dbl>, zestimate_low <dbl>,
#> #   zestimate_high <dbl>, rentzestimate <dbl>, rent_lastupdated <date>,
#> #   rent_monthlychange <dbl>, rentzestimate_low <dbl>,
#> #   rentzestimate_high <dbl>, zpid <chr>, compscore <dbl>
```

You can get the Zestimate (Zillow's estimated home value) with `GetZestimate`. The return is a data frame with the Zillow-estimated value of the home, either the property value or the estimated rental value (if `rentzestimate=TRUE`). This function works with either a single Zillow property ID or a vector of IDs:

``` r
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

If you want more detailed information on a specific property (such as utilities, appliances, and other building information), you can specify the ZPID and return the results with `GetUpdatedPropertyDetails`:

``` r
GetUpdatedPropertyDetails(zpid=2084934591 ,
                           api_key= getOption('ZillowR-zws_id'))
#>                    address zipcode city state     lat      long
#> 1 312 Hayward Ave UNIT 102   50014 Ames    IA 42.0198 -93.65168
#>            useCode bedrooms bathrooms finishedSqFt heatingSources numUnits
#> 1 MultiFamily5Plus        1       1.0          400     Other, Gas        6
#>   currentMonth total
#> 1            1     1
```

Non-API Regional Time Series Data
---------------------------------

There are also a few options for retrieving non-API data. Get the time series of property values aggregated by region and type with `get_rental_listings` and/or `get_ZHVI_series`. These return dataframes of time series data for the selected geographic aggregation level and property type, read from a static .csv hosted by Zillow. For options on the arguments, see the introduction vignette.

For the median home property values:

``` r
#Pull the data by zipcode for 4 bedrooms
get_ZHVI_series(bedrooms=3,geography="Zip")
```

For the median rental values:

``` r
#Rental values for Single Family Residences by State
get_rental_listings(type='SFR', rate='PerSqFt',geography="State")
```

For both functions, the return is a dataframe with the first few columns giving the geographic region and the rest corresponding to monthly observations. This dataframe can be reshaped or formatted as necessary for analysis.

Please see the vignette (under articles) to see further documentation and examples of `realEstAnalytics`' capabilities.
