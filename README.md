
<!-- README.md is generated from README.Rmd. Please edit that file -->

# realEstAnalytics

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/xiyuansun/realEstAnalytics.svg?branch=master)](https://travis-ci.org/xiyuansun/realEstAnalytics)
<!-- badges: end -->

The goal of realEstAnalytics is to …

## Installation

You can install the released version of realEstAnalytics from
[CRAN](https://CRAN.R-project.org) with:

``` r
library(devtools)
install_github("xiyuansun/realEstAnalytics")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(realEstAnalytics)
#> Warning: replacing previous import 'dplyr::intersect' by
#> 'lubridate::intersect' when loading 'realEstAnalytics'
#> Warning: replacing previous import 'dplyr::union' by 'lubridate::union'
#> when loading 'realEstAnalytics'
#> Warning: replacing previous import 'dplyr::setdiff' by 'lubridate::setdiff'
#> when loading 'realEstAnalytics'
## basic example code
set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
zapi_key = getOption('ZillowR-zws_id')
zpid='48749425'
GetZestimate(zpids=zpid,rentzestimate=TRUE,api_key=zapi_key)
#> Warning in as.POSIXlt.POSIXct(x, tz): unknown timezone 'zone/tz/2019a.1.0/
#> zoneinfo/America/Chicago'
#> # A tibble: 1 x 20
#>   address zipcode city  state   lat  long region_name region_id type 
#>   <fct>   <fct>   <fct> <fct> <dbl> <dbl> <fct>       <fct>     <fct>
#> 1 2114 B… 98109   Seat… WA     47.6 -122. East Queen… 271856    neig…
#> # … with 11 more variables: zestimate <dbl>, zest_lastupdated <date>,
#> #   zest_monthlychange <dbl>, zest_percentile <dbl>, zestimate_low <dbl>,
#> #   zestimate_high <dbl>, rentzestimate <dbl>, rent_lastupdated <date>,
#> #   rent_monthlychange <dbl>, rentzestimate_low <dbl>,
#> #   rentzestimate_high <dbl>
GetDeepSearchResults(address='312 Hayward Ave.', city='Ames', state='IA', rentzestimate=TRUE, zipcode='50014', api_key=zapi_key)
#> # A tibble: 3 x 24
#>   address zipcode city  state   lat  long region_name region_id type 
#>   <chr>   <fct>   <fct> <fct> <dbl> <dbl> <fct>       <fct>     <fct>
#> 1 312 Ha… 50014   Ames  IA     42.0 -93.7 South Camp… 764178    neig…
#> 2 312 Ha… 50014   Ames  IA     42.0 -93.7 South Camp… 764178    neig…
#> 3 312 Ha… 50014   Ames  IA     42.0 -93.7 South Camp… 764178    neig…
#> # … with 15 more variables: zestimate <dbl>, zest_lastupdated <date>,
#> #   zest_monthlychange <dbl>, zest_percentile <dbl>, zestimate_low <dbl>,
#> #   zestimate_high <dbl>, rentzestimate <dbl>, rent_lastupdated <date>,
#> #   rent_monthlychange <dbl>, rentzestimate_low <dbl>,
#> #   rentzestimate_high <dbl>, zpid <fct>, bathrooms <dbl>, bedrooms <dbl>,
#> #   finishedSqFt <dbl>
GetUpdatedPropertyDetails(zpid=zpid,api_key= zapi_key)
#>              address zipcode    city state      lat      long      useCode
#> 1 2114 Bigelow Ave N   98109 Seattle    WA 47.63793 -122.3479 SingleFamily
#>   bedrooms bathrooms finishedSqFt lotSizeSqFt yearBuilt yearUpdated
#> 1        4       3.0         3470        4680      1924        2003
#>   numFloors basement        roof                  view parkingType
#> 1         2 Finished Composition Water, City, Mountain  Off-street
#>   heatingSources heatingSystem
#> 1            Gas    Forced air
#>                                                                                         rooms
#> 1 Laundry room, Walk-in closet, Master bath, Office, Dining room, Family room, Breakfast nook
#>   currentMonth total
#> 1            1     1
```
