#' Get Zillow Home Value Index time series data
#' @description reads the static .csv file for the desired Zillow Home Values series based on data type and geography, by building a url path to the .csv file hosted by Zillow
#' @name get_ZHVI_series
#' @param bedrooms a numeric value specifying the number of bedrooms. If not needed, leave at the default (1)
#' @param geography string specifying the desired geographic region to summarise. Choices are 'Metro','City','State','Neighborhood','Zip', and 'County'.
#' @param allhomes logical, set to \code{TRUE} If you do not want a specific # of bedrooms or type of home
#' @param tier one of 'ALL','T' (for top), 'B' (for bottom), or 'M' (for median)
#' @param summary logical, if \code{TRUE}, the ZHVI summary for all homes is returned
#' @param other
#' @export
#' @import lubridate rvest assertthat xml2
#' @return A tibble
#' @examples
#'
#' #2 bedrooms by zipcode
#' #get_ZHVI_series(bedrooms=2, tier='B',geography="Zip")
#'
#' #the ZHVI summary for all homes by State
#' #get_ZHVI_series(geography="State", summary=T)
#'
#'
get_ZHVI_series <- function(bedrooms=1, geography="Metro", allhomes = F, tier='ALL', summary = F, other=NULL){
  initial_link <- 'http://files.zillowstatic.com/research/public/'
  if(allhomes==F & summary==F){
    assert_that(bedrooms %in% c(1:5), msg='invalid number of rooms')
    pathb <- build_path_bed(bedrooms)
  }
  if(allhomes == T & summary==F){
    assert_that(!is.null(tier) | summary==F, msg='invalid tier for all homes')
    pathb <- build_path_allhomes(tier)
  }

  pathg <- build_path_geog(geography)

  link <- ifelse(summary, paste0(initial_link,pathg,'Zhvi_','Summary_AllHomes.csv'),
                 paste0(initial_link, pathg, 'Zhvi_', pathb, '.csv'))

  if(allhomes==T & tier == 'M' & summary==F){ link <- paste0(initial_link, pathg, pathb, '.csv')}
  if(!is.null(other)){link <- paste0(initial_link, pathg, build_path_allhomes(tier='ALL', other=other), '.csv')}
  #if(!is.null(other)){link <- paste0(initial_link, pathg, build_path_o(other))}
  print('attempting to read file:')
  print(as.character(link))
  out <- read_csv(link)
  return(out)
}




##################
##Helpers
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

