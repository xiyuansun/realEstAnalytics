#' Get the results for comparable recent property sales for a given property
#'
#' For a given Zillow property ID, find valuation data for comparable recent property sales.
#' The returned data frame contains address information and Zestimate/Rental valuation information for the comparables.
#'
#' @name GetComps
#' @param zpid The Zillow property id to search for
#' @param count (integer) How many comparables to return? Maximum: 25
#' @param rentzestimate (logical) If \code{TRUE}, gets the rent zestimate.
#' @param api_key A character string specifying your unique Zillow API key
#' @param raw (logical) If \code{TRUE} the raw XML data from the API call is returned (i.e., the original ZillowR call)
#' @export
#' @importFrom assertthat assert_that
#' @importFrom dplyr bind_rows
#' @import magrittr
#' @import xml2
#' @importFrom tibble as_tibble
#' @return If \code{raw=T}, a raw XML document. If \code{raw=F} (default), a data frame with columns corresponding to address information, Zestimates, and property information. The number of columns varies by property use type.
#' @examples
#'
#' \dontrun{
#' #Comparable properties for 600 S. Quail Ct.
#'
#' GetComps(zpid='1340244', count=10, rentzestimate=TRUE,
#'  api_key = getOption('ZillowR-zws_id'))
#'  }
#'

GetComps <- function(zpid, count=10, rentzestimate=FALSE, api_key, raw=FALSE){
  assertthat::assert_that((is.character(zpid)|is.numeric(zpid)), msg='Error: Check zpid formatting')
  assertthat::assert_that(!is.null(api_key), msg='Error: Zillow API key required')
  assertthat::assert_that(is.logical(raw))
  assertthat::assert_that(is.numeric(count))

  url = "http://www.zillow.com/webservice/GetComps.htm"
  request <- url_encode_request(url,
                                'zpid' = zpid,
                                'count' = count,
                                'rentzestimate' = rentzestimate,
                                'zws-id' = api_key
  )
  #read data from API then get to the nodes
  xmlresult <-   read_xml(request)
  if(raw==TRUE){return(xmlresult)}

  xmlresult<- xmlresult %>%
    xml_nodes('response') %>%
    xml_nodes('properties')

  #check to make sure address worked
  if(xmlresult %>% html_text() %>% length() == 0){
    print('Warning: bad address')
    outdf <- c(zpid) %>% t() %>% data.frame()
    names(outdf) <- c('zpid')
    return(outdf)
  }

  #address data
  address_data <- xmlresult %>% lapply(extract_address_comps,count=count) %>%  lapply(as.data.frame.list)
  address_data <- suppressWarnings(bind_rows(address_data))

  #zestimate data
  zestimate_data <- xmlresult %>% lapply(extract_zestimates_comps, count=count) %>% lapply(as.data.frame.list)
  zestimate_data <- suppressWarnings(bind_rows(zestimate_data))

  #rentzestimate data
  rentzestimate_data <- NULL
  if(rentzestimate==T){
    rentzestimate_data <- xmlresult %>% lapply(extract_rent_zestimates_comps, count=count) %>% lapply(as.data.frame.list)
    rentzestimate_data <- suppressWarnings(bind_rows(rentzestimate_data))
  }
  #other property data
  compscore <- xmlresult%>% lapply(extract_compscores) %>% lapply(as.data.frame.list)
  compscore <- suppressWarnings(bind_rows(compscore))
  compscore <- rbind(c(as.numeric(zpid),NA),compscore)

  #combine all of the data into 1 data frame
  if(rentzestimate==T) {outdf <- data.frame(address_data,zestimate_data,rentzestimate_data,compscore)}
  if(rentzestimate==F) {outdf <- data.frame(address_data,zestimate_data,compscore)}

  #return the dataframe
  return(outdf  %>% as_tibble %>% mutate_at('zpid', as.character) %>% mutate_if(is.factor, as.character))
}

