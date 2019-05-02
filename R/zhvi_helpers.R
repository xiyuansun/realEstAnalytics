#' @importFrom assertthat assert_that
#' @import magrittr

##################
##Helpers
build_path_geog <- function(geography){
  assertthat::assert_that(geography %in% c('Metro','City','State','Neighborhood','Zip', 'County'), msg = 'invalid geography type')
  pathG <- paste0(geography,'/',geography,'_')
  return(pathG)
}

build_path_bed <- function(bedrooms, rental=F){
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

############################
build_rent_type <- function(type){
  pathmat <-  data.frame(ty=c('SFR','Multi','Duplex','Condo/Co-op','Studio','SFR/Condo'),
                         path= c('Sfr','Mfr5Plus','DuplexTriplex','CondoCoop','Studio','AllHomes'))
  pathb <- pathmat$path[pathmat$ty==type] %>% as.character
  return(pathb)
}
