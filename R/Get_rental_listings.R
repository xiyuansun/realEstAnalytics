#' Get Zillow rental listings time series data
#' @description reads the static .csv file for the desired Zillow Home Values series based on data type and geography, by building a url path to the .csv file hosted by Zillow
#' @name get_rental_listings
#' @param bedrooms a numeric value specifying the number of bedrooms. If not needed, leave at the default (1)
#' @param geography string specifying the desired geographic region to summarise. Choices are 'Metro','City','State','Neighborhood','Zip', and 'County'.
#' @param type (optional) a character string specifying housing type, from NULL,'SFR','Multi','Duplex','Condo/Co-op','Studio', and 'SFR/Condo'.
#' @param rate a string specifying the rate, either 'Total' or 'PerSqFt'
#' @export
#' @import lubridate rvest assertthat xml2
#' @return A tibble
#' @examples
#'
#' get_rental_listings(bedrooms=5, rate='PerSqFt', type="Studio",geography="Zip")
#'
#' get_rental_listings(bedrooms=1, rate='Total', type="Multi", geography="State")
####################
get_rental_listings<- function(bedrooms=1, type=NULL, geography="Zip", rate='Total'){
  initial_link <- 'http://files.zillowstatic.com/research/public/'
  #assert_that(as.character(type) %in% c(NULL,'SFR','Multi','Duplex','Condo/Co-op','Studio','SFR/Condo'), msg='invalid type')

  pathb <- build_path_bed(bedrooms, rental=T)
  if(!is.null(type)){
    pathb <- build_rent_type(type)
  }

  pathg <- build_path_geog(geography)

  if_else(rate=='PerSqFt', ratep <- 'PerSqft', ratep <- NULL)
  link <- paste0(initial_link,pathg,'MedianRentalPrice',ratep,'_',pathb,'.csv')
  print('attempting to read file:')
  print(as.character(link))
  out <- read_csv(link)
  return(out)
}

