#' Get the 'Deep Search' results from the Zillow API for a dataframe of addresses
#'
#' A wrapper for \code{GetDeepSearchResults} that takes data frames with address information as inputs rather than a single address,
#' and returns the search results for all addresses
#'
#' @name GetDeepSearchResults_dataframe
#' @param .df a dataframe with address data
#' @param col.address a numeric value specifying which column in \code{.df} contains the addresses
#' @param col.zipcode a numeric value specifying which column contains the zipcodes (required if no city/state information)
#' @param col.city a numeric value specifying which column contains the city (required if no zipcode information)
#' @param col.state a numeric value specifying which column contains the state abbrev. (required if no zipcode information)
#' @param api_key a character string specifying the unique Zillow API key
#' @param rentzestimate if \code{TRUE}, additional zestimates for rental prices are returned.
#' @param raw logical, if \code{TRUE}, a list with raw XML documents  (i.e., the original ZillowR call) for each property in the data frame is returned
#' @export
#' @importFrom dplyr full_join
#' @importFrom assertthat assert_that
#' @importFrom tibble as_tibble
#' @import magrittr
#' @import xml2
#' @return A data frame with columns corresponding to address, property, and Zestimate information
#' @examples
#' \dontrun{
#' zapi_key = getOption('ZillowR-zws_id')
#'
#' adrs <- c('733 Normandy Ct', '600 South Quail Ct','2902 Wood St', '3425 Locust St.')
#'
#' locations <- data.frame(address=adrs,zipcode=c('67114','67114','50014', '64109'),
#' state=c("KS","KS","IA","MO"), city=c("Newton","Newton","Ames","Kansas City"))
#'
#' GetDeepSearchResults_dataframe(locations, col.address=1, col.zipcode=2,
#' col.city=4, col.state=3,api_key=zapi_key)
#'
#' }

GetDeepSearchResults_dataframe <- function(.df, col.address, col.zipcode=NULL, col.city=NULL, col.state=NULL, rentzestimate=F, api_key, raw=FALSE){
  assertthat::assert_that(!is.null(col.zipcode) | (!is.null(col.state)&!is.null(col.city)), msg='Missing either zip or city/state info')
  assertthat::assert_that(!is.null(col.address), msg='Missing address column')
  assertthat::assert_that(!is.null(api_key), msg='Valid Zillow API key required')

  #split off the necessary data
  propdata <- data.frame(address=.df[,col.address],zip=.df[,col.zipcode], city=.df[,col.city], state=.df[,col.state])

  #apply the helper function
  propdata <- propdata %>% apply(1,applier, rentzestimate=rentzestimate, api_key=api_key, raw=raw)
  if(raw==TRUE){
    names(propdata) <- .df[,col.address]
    return(propdata)}
  if(raw==FALSE){
  propdata <- propdata %>% lapply(as.data.frame.list)
  #combine each result
  i=1
  outdf <- propdata[[1]]
  while(i<length(propdata)){
    outdf <- suppressWarnings(suppressMessages(full_join(outdf,propdata[[i+1]])))
    i=i+1
  }
  return(outdf %>% as_tibble %>% mutate_at('zpid', as.character))
  }
}

