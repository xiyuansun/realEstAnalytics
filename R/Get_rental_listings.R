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

############################
build_path_geog <- function(geography){
  assertthat::assert_that(geography %in% c('Metro','City','State','Neighborhood','Zip', 'County'), msg = 'invalid geography type')
  pathG <- paste0(geography,'/',geography,'_')
  return(pathG)
}

build_path_bed<- function(bedrooms, rental=F){
  options <- c(1:5,'C','SFR')
  assert_that(as.character(bedrooms) %in% options, msg='Specify bedrooms (1-5) or C for condo or SFR for single family residence')
  if(bedrooms %in% c(1:4)){
    pathb <- paste0(bedrooms,'bedroom')
    if(rental==T) pathb <- paste0(bedrooms,'Bedroom')
  }
  if(bedrooms == 5){
    pathb <- '5BedroomOrMore'
  }
  if(bedrooms == 'C'){
    pathb <- 'Condominum'
  }
  if(bedrooms == 'SFR'){
    pathb <- 'SingleFamilyResidence'
  }
  return(pathb)
}

build_path_allhomes <- function(tier='ALL', other=NULL){

  tierpath <- data.frame(tie = c('ALL','B','T','M'),
                         path = c('AllHomes','BottomTier','TopTier','MedianValuePerSqft_AllHomes'))
  pathb <- tierpath$path[tierpath$tie==tier] %>% as.character()
  if(tier=='ALL' & !is.null(other)){
    path_o <- paste0('PctOfHomes',other,'InValues_',pathb)
    if(other=='Median Home Price Per Sq Ft') path_o <- paste0('MedianValuePerSqft_',pathb)
    pathb <- path_o
  }
  return(pathb)
}

build_rent_type <- function(type){
  pathmat <-  data.frame(ty=c('SFR','Multi','Duplex','Condo/Co-op','Studio','SFR/Condo'),
                         path= c('Sfr','Mfr5Plus','DuplexTriplex','CondoCoop','Studio','AllHomes'))
  pathb <- pathmat$path[pathmat$ty==type] %>% as.character
  return(pathb)
}
