#' Get Zestimates for a given Zillow property ID
#'
#' Returns a dataframe with the Zillow zestimate and/or rental valuation information for a given Zillow property ID.
#'
#' @name GetZestimates
#' @param zpids a single value or vector of Zillow property IDs
#' @param rentzestimate if \code{TRUE}, gets the rent zestimate.
#' @param api_key character string specifying Zillow API key
#' @param raw logical, if \code{TRUE} the raw XML data from the API call is returned (i.e., the original ZillowR call)
#' @export
#' @import xml2
#' @importFrom dplyr full_join
#' @importFrom assertthat assert_that
#' @importFrom tibble as_tibble
#' @import magrittr
#' @return A data frame with columns corresponding to zpid, Date, and Zestimate information
#' @examples
#' \dontrun{
#' zapi_key = getOption('ZillowR-zws_id')
#'
#' zpid='1341571'
#'
#' GetZestimate(zpids=zpid,rentzestimate=TRUE,api_key=zapi_key)
#' }

GetZestimate <- function(zpids, rentzestimate=FALSE, api_key, raw=FALSE){
  assertthat::assert_that((is.character(zpids)|is.numeric(zpids)), msg='Error: Check zpid formatting')
  assertthat::assert_that(!is.null(api_key), msg='Error: Zillow API key required')
  assertthat::assert_that(is.logical(raw))

  zpids <- as.data.frame(zpids)
  results <- zpids %>% apply(1,zesthelper, rentzestimate, api_key, raw=raw)
  if(raw==TRUE){
    names(results) <- zpids
    return(results)}
  if(raw==FALSE){
    results <- results %>% lapply(as.data.frame.list)
    #combine each result
    i=1
    outdf <- results[[1]]
    while(i<length(results)){
      outdf <- suppressWarnings(suppressMessages(full_join(outdf,results[[i+1]])))
      i=i+1
    }
    return(outdf %>% as_tibble %>% mutate_if(is.factor, as.character))
  }
}



