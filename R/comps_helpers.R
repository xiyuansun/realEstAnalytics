#' @importFrom lubridate mdy
#' @importFrom assertthat assert_that
#' @import xml2 dplyr
#' @importFrom tidyr spread
#' @import magrittr


extract_address_comps <- function(xmlres,count){
  #find the address data from the API
  address_data <- xmlres %>% xml_nodes('address') %>% xml_children %>%  xml_text() %>%
    matrix(ncol=6,byrow=T) %>% data.frame()

  #formatting
  names(address_data) <- c("address", "zipcode", "city", "state", "lat","long")
  address_data <- address_data %>% mutate_at(c(1:6),as.character) %>% mutate_at(c("lat","long"),as.numeric)

  #local real estate data
  rcount <- xmlres %>% xml_nodes('localRealEstate') %>% xml_name() %>% length()
  region_data <- xmlres %>% xml_nodes('localRealEstate') %>% xml_children() %>%  xml_attrs() %>%
    unlist() %>% as.character() %>% matrix(nrow=rcount, byrow=T) %>% data.frame()

  names(region_data) <- c('region_name','region_id','type')
  return(data.frame(address_data,region_data))
}

extract_zestimates_comps <- function(xmlres, count){
  #find the zestimates from the API call
  zestimate_data <- xmlres %>% xml_nodes('zestimate')
  zcount <- xml_name(zestimate_data) %>% length()

  #unnesting the valuation range sub-list
  highlow <- zestimate_data %>% xml_nodes('valuationRange') %>% xml_children() %>% xml_text() %>%
    matrix(nrow=zcount,ncol=2, byrow=T) %>% data.frame()

  #formatting
  zestimate_data <- zestimate_data %>% xml_children() %>% xml_text() %>%
    matrix(nrow=zcount,ncol=6, byrow=T) %>% data.frame()

  zestimate_data <- cbind(zestimate_data[c(1,2,4,6)], highlow)
  names(zestimate_data) <- c("zestimate", "zest_lastupdated","zest_monthlychange","zest_percentile","zestimate_low","zestimate_high")

  zestimate_data <- zestimate_data %>%
    mutate_at(c(1,3:6),as.character) %>% mutate_at(c(1,3:6),as.numeric) %>%
    mutate_at(2,mdy)

  return(zestimate_data)
}

extract_rent_zestimates_comps <- function(xmlres, count){
  zestimate_data <- xmlres %>% xml_nodes('rentzestimate')
  zcount <- xml_name(zestimate_data) %>% length()
  highlow <- zestimate_data %>% xml_nodes('valuationRange') %>% xml_children() %>% xml_text() %>%
    matrix(nrow=zcount,ncol=2, byrow=T) %>% data.frame()

  zestimate_data <- zestimate_data %>% xml_children() %>% xml_text() %>%
    matrix(nrow=zcount,ncol=5, byrow=T) %>% data.frame()

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

  otherdata <- otherdata %>%  mutate_all(as.character) %>%
    mutate_at(which(!(names(otherdata)%in%c('lastSoldDate'))),as.numeric) #%>%
  #mutate_at(5, mdy)

  return(otherdata)
}
