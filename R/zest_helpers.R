#' @importFrom lubridate mdy
#' @importFrom assertthat assert_that
#' @import xml2 dplyr
#' @import magrittr
#'
extract_address <- function(xmlres){
  address_data <- xmlres %>% xml_nodes('address') %>% xml_children %>%  xml_text() %>%
    matrix(ncol=6,byrow=T) %>% data.frame()
  names(address_data) <- c("address", "zipcode", "city", "state", "lat","long")
  address_data <- address_data %>% mutate_at(c(1:6),as.character) %>% mutate_at(c("lat","long"),as.numeric)

  rcount <- xmlres %>% xml_nodes('localRealEstate') %>% xml_name() %>% length()
  region_data <- xmlres %>% xml_nodes('localRealEstate') %>% xml_children() %>%  xml_attrs() %>%
    unlist() %>% as.character() %>% matrix(nrow=rcount, byrow=T) %>% data.frame()
  names(region_data) <- c('region_name','region_id','type')
  return(data.frame(address_data,region_data))
}

extract_zestimates <- function(xmlres){
  zestimate_data <- xmlres %>% xml_nodes('zestimate')
  zcount <- xml_name(zestimate_data) %>% length()
  highlow <- zestimate_data %>% xml_nodes('valuationRange') %>% xml_children() %>% xml_text() %>%
    matrix(nrow= zcount, ncol=2, byrow=T) %>% data.frame()

  zestimate_data <- zestimate_data %>% xml_children() %>% xml_text() %>%
    matrix(nrow= zcount, ncol=6, byrow=T) %>% data.frame()

  zestimate_data <- cbind(zestimate_data[c(1,2,4,6)], highlow)
  names(zestimate_data) <- c("zestimate", "zest_lastupdated","zest_monthlychange","zest_percentile","zestimate_low","zestimate_high")

  zestimate_data <- zestimate_data %>%
    mutate_at(c(1,3:6),as.character) %>% mutate_at(c(1,3:6),as.numeric) %>%
    mutate_at(2,mdy)

  return(zestimate_data)
}

extract_rent_zestimates <- function(xmlres){
  zestimate_data <- xmlres %>% xml_nodes('rentzestimate')
  zcount <- xml_name(zestimate_data) %>% length()
  highlow <- zestimate_data %>% xml_nodes('valuationRange') %>% xml_children() %>% xml_text() %>%
    matrix(nrow=zcount,ncol=2, byrow=T) %>% data.frame()

  zestimate_data <- zestimate_data %>% xml_children() %>% xml_text() %>%
    matrix(nrow= zcount, ncol=5, byrow=T) %>% data.frame()

  zestimate_data <- cbind(zestimate_data[c(1,2,4)], highlow)
  names(zestimate_data) <- c("rentzestimate", "rent_lastupdated","rent_monthlychange","rentzestimate_low","rentzestimate_high")

  zestimate_data <- zestimate_data %>%
    mutate_at(c(1,3:5),as.character) %>% mutate_at(c(1,3:5),as.numeric) %>%
    mutate_at(2,mdy)

  return(zestimate_data)
}

zesthelper <- function(zpid, rentzestimate, api_key, raw=FALSE){
  urlrent <- tolower(as.character(rentzestimate))
  url = 'http://www.zillow.com/webservice/GetZestimate.htm'
  #read data from API then get to the nodes
  request <- url_encode_request(url,
                                'zpid' = zpid,
                                'rentzestimate' = rentzestimate,
                                'zws-id' = api_key
  )
  xmlresult <- read_xml(request) %>%
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
