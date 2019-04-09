#' Get the 'Deep Search' results from the Zillow API
#' @description For a given address, extract property information including building data and Zestimates. At least one of zipcode or city/state information must be included.
#' @name GetDeepSearchResults
#' @param address (required) A character string specifying the address
#' @param city An optional character string specifying the city name
#' @param state An optional character string specifying the state name (abbreviated length 2)
#' @param zipcode An optional character or numeric string of length 5 specifying the zip code
#' @param rentzestimate if \code{TRUE}, gets the rent zestimate.
#' @param api_key (required) A unique character string specifying the Zillow user's API key
#' @param raw (optional) If \code{TRUE}, the raw xml document from the API call is returned. If \code{FALSE}, the data is extracted and formatted into a data frame.
#' @export
#' @import lubridate rvest assertthat xml2
#' @return If \code{raw=T}, the XML document directly from the API call. If \code{raw=F} (default), a data frame with columns corresponding to address information, Zestimates, and property information. The number of columns varies by property use type.
#' @examples
#' set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
#' zapi_key = getOption('ZillowR-zws_id')
#' GetDeepSearchResults(address='312 Hayward Ave.', city='Ames', state='IA', rentzestimate=TRUE, zipcode='50014', api_key=zapi_key)
#'


GetDeepSearchResults <- function(address, city=NULL, state=NULL, zipcode=NULL, rentzestimate=F, api_key, raw=F){
  assertthat::assert_that(is.character(address),
                          (!is.null(zipcode)|(!is.null(city)&(!is.null(state)))),
                          msg='Error: Invalid address/city/zip combo')
  assertthat::assert_that(is.character(api_key), msg='invalid api key')

  url = 'http://www.zillow.com/webservice/GetDeepSearchResults.htm'
  #parse address to url encoding
  address_as_url <- URLencode(address)
  #parse city names with spaces in them
  cityspace <- city %>% str_replace(" ","-")
  citystatezip = paste0(cityspace,if(!is.null(city)){','}, state,if(!is.null(state)){','},
                        zipcode)
  request <- url_encode_request(url,
                                'address' = address,
                                'citystatezip' = citystatezip,
                                'rentzestimate' = rentzestimate,
                                'zws-id' = api_key
  )



  #read data from API then get to the nodes
  xmlresult <- read_xml(request)
  if(raw==T) return(xmlresult)
  xmlresult<- xmlresult%>% xml_nodes('result')

  #check to make sure address worked
  if(xmlresult %>% html_text() %>% length() == 0){
    warning('invalid address, NAs returned')
    outdf <- c(address) %>% t() %>% data.frame()
    names(outdf) <- c('address')
    return(outdf)
  }

  #address data
  address_data <- xmlresult %>% lapply(extract_address) %>%  lapply(as.data.frame.list)
  address_data <- suppressWarnings(bind_rows(address_data))

  #zestimate data
  zestimate_data <- xmlresult %>% lapply(extract_zestimates) %>% lapply(as.data.frame.list)
  zestimate_data <- suppressWarnings(bind_rows(zestimate_data))

  #other property data
  richprop <- xmlresult %>% extract_otherdata

  #combine all of the data into 1 data frame
  outdf <- data.frame(address_data,zestimate_data,richprop)

  #rentzestimate data
  rent_zestimate_data <- NULL
  if(rentzestimate==T){
    rent_zestimate_data <- xmlresult %>% lapply(extract_rent_zestimates) %>% lapply(as.data.frame.list)
    rent_zestimate_data <- suppressWarnings(bind_rows(rent_zestimate_data))

    #combine all of the data into 1 data frame
    outdf <- data.frame(address_data,zestimate_data,rent_zestimate_data,richprop)
  }

  #return the dataframe
  return(outdf)
}

extract_address <- function(xmlres){
  address_data <- xmlres %>% xml_nodes('address') %>% xml_children %>%  xml_text() %>%
    matrix(ncol=6,byrow=T) %>% data.frame()
  names(address_data) <- c("address", "zipcode", "city", "state", "lat","long")
  address_data <- address_data %>% mutate_at(c("lat","long"),as.character) %>% mutate_at(c("lat","long"),as.numeric)

  nrs <- which((xmlres %>% xml_nodes('address') %>% xml_children %>%  xml_name)=='city') %>% length()
  region_data <- xmlres %>% xml_nodes('localRealEstate') %>% xml_children() %>%  xml_attrs() %>%
    unlist() %>% as.character() %>% matrix(nrow=nrs, byrow=T) %>% data.frame()
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

extract_otherdata <- function(xmlres){
  zpids <- xmlres %>% xml_nodes('zpid') %>% xml_text()
  #return(zpids)
  chars <- c('taxAssessmentYear','taxAssessment','yearBuilt','lotSizeSqFt','finishedSqFt',
             'bathrooms','bedrooms','totalRooms','lastSoldDate','lastSoldPrice')
  richdata <- chars %>% lapply(xml_nodes, x=xmlres) %>% lapply(xml_text) %>% unlist()

  richzpids <- chars %>% lapply(xml_nodes, x=xmlres) %>% lapply(xml_parent) %>%
    lapply(xml_nodes,'zpid') %>% lapply(xml_text)

  varnames <- rep(chars, times=c(sapply(richzpids,length)))
  richzpids <- richzpids %>% unlist()
  otherdata <- data.frame(zpid=richzpids,varnames, richdata) %>% spread(key=varnames,value=richdata)

  otherdata <- otherdata %>%  mutate_all(as.character) %>% mutate_at(-c(5), as.numeric) #%>%
  #mutate_at(5, mdy)

  return(otherdata)
}









