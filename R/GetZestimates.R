#' Get Zestimates for a given Zillow property ID
#' @description A wrapper for \code{GetDeepSearchResults} that takes data frames with address information as inputs rather than a single address,
#' and returns the search results for all addresses
#' @name GetZestimates
#' @param zpids a single value or vector of Zillow property ids
#' @param rentzestimate if \code{TRUE}, gets the rent zestimate.
#' @param api_key character string specifying Zillow API key
#' @param raw logical, if \code{TRUE} the raw XML data from the API call is returned (i.e., the original ZillowR call)
#' @export
#' @import lubridate rvest assertthat xml2
#' @return A data frame with columns corresponding to zpid, Date, and Zestimate information
#' @examples
#' library(tidyverse)
#'
#' zapi_key = 'X1-ZWz181ckl6u9e3_9k5bc'
#'
#' zpid='1341571'
#'
#'
#' GetZestimate(zpids=zpid,rentzestimate=TRUE,api_key=zapi_key)

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
      outdf <- suppressWarnings(full_join(outdf,results[[i+1]]))
      i=i+1
    }
    return(outdf)
  }
}

zesthelper <- function(zpid, rentzestimate, api_key, raw=FALSE){
  urlrent <- tolower(as.character(rentzestimate))

  #read data from API then get to the nodes
  xmlresult <- read_xml(paste0("http://www.zillow.com/webservice/GetZestimate.htm?zws-id=", api_key,
                               "&zpid=",zpid, "&rentzestimate=",urlrent)) %>%
    xml_nodes('response')
  if(raw==TRUE){return(xmlresult)}
  #check to make sure address worked, if not return NAs
  if(xmlresult %>% xml_nodes('zestimate') %>% html_text() %>% length() == 0){
    warning('invalid zpid(s) or Zestimate not found, NAs returned')
    outdf <- as.numeric(c(zpid)) %>% t() %>% data.frame()
    names(outdf) <- c('zpid')
    return(outdf)
  }

  #if the API call worked, extract xml data and format into data frame
  addressdata <- extract_address(xmlresult)
  zestimatedata <- extract_zestimates(xmlresult)
  rentzestimates <- NULL; if(rentzestimate==T){rentzestimates<- extract_rent_zestimates(xmlresult)}
  outvector <- c(addressdata,zestimatedata,rentzestimates)
  #names(outvector) <- c('zpid',"Date", "Zestimate","Low","High", "Change", "Percentile")
  return(outvector)
}

extract_address <- function(xmlres){
  address_data <- xmlres %>% xml_nodes('address') %>% xml_children %>%  xml_text() %>%
    matrix(ncol=6,byrow=T) %>% data.frame()
  names(address_data) <- c("address", "zipcode", "city", "state", "lat","long")
  address_data <- address_data %>% mutate_at(c("lat","long"),as.character) %>% mutate_at(c("lat","long"),as.numeric)

  region_data <- xmlres %>% xml_nodes('localRealEstate') %>% xml_children() %>%  xml_attrs() %>%
    unlist() %>% as.character() %>% matrix(nrow=1, byrow=T) %>% data.frame()
  names(region_data) <- c('region_name','region_id','type')
  return(data.frame(address_data,region_data))
}

extract_zestimates <- function(xmlres){
  zestimate_data <- xmlres %>% xml_nodes('zestimate')

  highlow <- zestimate_data %>% xml_nodes('valuationRange') %>% xml_children() %>% xml_text() %>%
    matrix(ncol=2, byrow=T) %>% data.frame()

  zestimate_data <- zestimate_data %>% xml_children() %>% xml_text() %>%
    matrix(ncol=6, byrow=T) %>% data.frame()

  zestimate_data <- cbind(zestimate_data[c(1,2,4,6)], highlow)
  names(zestimate_data) <- c("zestimate", "zest_lastupdated","zest_monthlychange","zest_percentile","zestimate_low","zestimate_high")

  zestimate_data <- zestimate_data %>%
    mutate_at(c(1,3:6),as.character) %>% mutate_at(c(1,3:6),as.numeric) %>%
    mutate_at(2,mdy)

  return(zestimate_data)
}

extract_rent_zestimates <- function(xmlres){
  zestimate_data <- xmlres %>% xml_nodes('rentzestimate')

  highlow <- zestimate_data %>% xml_nodes('valuationRange') %>% xml_children() %>% xml_text() %>%
    matrix(ncol=2, byrow=T) %>% data.frame()

  zestimate_data <- zestimate_data %>% xml_children() %>% xml_text() %>%
    matrix(ncol=5, byrow=T) %>% data.frame()

  zestimate_data <- cbind(zestimate_data[c(1,2,4)], highlow)
  names(zestimate_data) <- c("rentzestimate", "rent_lastupdated","rent_monthlychange","rentzestimate_low","rentzestimate_high")

  zestimate_data <- zestimate_data %>%
    mutate_at(c(1,3:5),as.character) %>% mutate_at(c(1,3:5),as.numeric) %>%
    mutate_at(2,mdy)

  return(zestimate_data)
}

