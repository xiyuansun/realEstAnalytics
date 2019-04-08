#' Get the results for comparable recent property sales for a given property
#' @description For a given address, extract property information including building data and Zestimates. At least one of zipcode or city/state information must be included.
#' @name GetComps
#' @param zpid The Zillow property id
#' @param count (integer) How many comparables to return?
#' @param rentzestimate if \code{TRUE}, gets the rent zestimate.
#' @param api_key character string specifying Zillow API key
#' @param raw logical, if \code{TRUE} the raw XML data from the API call is returned (i.e., the original ZillowR call)
#' @export
#' @import lubridate rvest assertthat xml2
#' @return If \code{raw=T}, a raw XML document. If \code{raw=F} (default), a data frame with columns corresponding to address information, Zestimates, and property information. The number of columns varies by property use type.
#' @examples
#' zapi_key = 'X1-ZWz181ckl6u9e3_9k5bc'
#' GetComps('1341571', count=10, rentzestimate=FALSE, api_key=zapi_key,raw=FALSE)
#'

GetComps <- function(zpid, count=10, rentzestimate=FALSE, api_key, raw=FALSE){
  assertthat::assert_that((is.character(zpid)|is.numeric(zpid)), msg='Error: Check zpid formatting')
  assertthat::assert_that(!is.null(api_key), msg='Error: Zillow API key required')
  assertthat::assert_that(is.logical(raw))
  assertthat::assert_that(is.numeric(count))

  #read data from API then get to the nodes
  xmlresult <-   read_xml(paste0("http://www.zillow.com/webservice/GetComps.htm?zws-id=", zapi_key,
                                 "&zpid=",zpid,"&count=",count,"&rentzestimate=",as.character(rentzestimate)))
  if(raw==TRUE){return(xmlresult)}

  xmlresult<- xmlresult %>% xml_nodes('response') %>% xml_nodes('properties')

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
  return(outdf)
}

extract_address_comps <- function(xmlres,count){
  address_data <- xmlres %>% xml_nodes('address') %>% xml_children %>%  xml_text() %>%
    matrix(ncol=6,byrow=T) %>% data.frame()
  names(address_data) <- c("address", "zipcode", "city", "state", "lat","long")
  address_data <- address_data %>% mutate_at(c("lat","long"),as.character) %>% mutate_at(c("lat","long"),as.numeric)
  region_data <- xmlres %>% xml_nodes('localRealEstate') %>% xml_children() %>%  xml_attrs() %>%
    unlist() %>% as.character() %>% matrix(nrow=count+1, byrow=T) %>% data.frame()
  names(region_data) <- c('region_name','region_id','type')
  return(data.frame(address_data,region_data))
}

extract_zestimates_comps <- function(xmlres, count){
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

extract_rent_zestimates_comps <- function(xmlres, count){
  zestimate_data <- xmlres %>% xml_nodes('rentzestimate')

  highlow <- zestimate_data %>% xml_nodes('valuationRange') %>% xml_children() %>% xml_text() %>%
    matrix(nrow=1+count,ncol=2, byrow=T) %>% data.frame()

  zestimate_data <- zestimate_data %>% xml_children() %>% xml_text() %>%
    matrix(nrow=1+count,ncol=5, byrow=T) %>% data.frame()

  zestimate_data <- cbind(zestimate_data[c(1,2,4)], highlow)
  names(zestimate_data) <- c("rentzestimate", "rent_lastupdated","rent_monthlychange","rentzestimate_low","rentzestimate_high")

  zestimate_data <- zestimate_data %>%
    mutate_at(c(1,3:5),as.character) %>% mutate_at(c(1,3:5),as.numeric) %>%
    mutate_at(2,mdy)

  return(zestimate_data)
}

extract_compscores<- function(xmlres){
  scores <- xmlres %>% xml_nodes('comparables') %>%
    xml_children() %>% xml_attrs() %>%
    unlist() %>% as.numeric
  zpid <- xmlres %>% xml_nodes('comparables') %>%
    xml_nodes('zpid') %>% xml_text() %>%
    as.numeric
  out <- data.frame(zpid,compscore=scores)
  return(out)
}
