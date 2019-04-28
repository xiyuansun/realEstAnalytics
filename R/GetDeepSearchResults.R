#' Get the 'Deep Search' results from the Zillow API
#'
#' For a given address, extract property information including building data and Zestimates.
#' At least one of zipcode or city/state information must be included.
#'
#' @name GetDeepSearchResults
#' @param address (required) A character string specifying the address
#' @param city An optional character string specifying the city name
#' @param state An optional character string specifying the state name (abbreviated length 2)
#' @param zipcode An optional character or numeric string of length 5 specifying the zip code
#' @param rentzestimate if \code{TRUE}, gets the rent zestimate.
#' @param api_key (required) A unique character string specifying the Zillow user's API key
#' @param raw (optional) If \code{TRUE}, the raw xml document from the API call is returned. If \code{FALSE}, the data is extracted and formatted into a data frame.
#' @export
#' @importFrom rvest html_text
#' @importFrom assertthat assert_that
#' @importFrom dplyr bind_rows
#' @importFrom stringr str_replace
#' @importFrom utils URLencode
#' @importFrom tibble as_tibble
#' @import magrittr
#' @import xml2
#' @return If \code{raw=T}, the XML document directly from the API call. If \code{raw=F} (default), a data frame with columns corresponding to address information, Zestimates, and property information. The number of columns varies by property use type.
#' @examples
#' \dontrun{zapi_key = getOption('ZillowR-zws_id')}
#'
#' \dontrun{GetDeepSearchResults(address='600 S. Quail Ct.', zipcode='67114',
#'  rentzestimate=FALSE, api_key=zapi_key) }
#'
#' \dontrun{GetDeepSearchResults(address='312 Hayward Ave.', city='Ames', state='IA',
#'  rentzestimate=TRUE, zipcode='50014', api_key=zapi_key) }
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
  address_data <- xmlresult %>% lapply(extract_address_search) %>%  lapply(as.data.frame.list)
  address_data <- suppressWarnings(bind_rows(address_data))

  #zestimate data
  zestimate_data <- xmlresult %>% lapply(extract_zestimates) %>% lapply(as.data.frame.list)
  zestimate_data <- suppressWarnings(bind_rows(zestimate_data))

  #other property data
  richprop <- xmlresult %>% extract_otherdata_search

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
  return(outdf %>% mutate_at(1:4, as.character) %>%
           mutate_at('zpid', as.character) %>% mutate_if(is.factor, as.character) %>%
           as_tibble())
}




