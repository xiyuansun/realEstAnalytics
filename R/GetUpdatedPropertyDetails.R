#' Make request to Zillow API GetUpdatedPropertyDetails Web Service
#'
#' For a specified property, the GetUpdatedPropertyDetails API returns all of
#' the home facts that have been edited by the home's owner or agent.
#'
#' @return The result set contains the following attributes:
#'
#' \itemize{
#'   \item Property address
#'   \item Zillow property identifier
#'   \item Posting details such as the agent name, MLS number, price, and
#'       posting type (For Sale or Make Me Move(tm))
#'   \item Up to five photos of the property
#'   \item Updated home facts such as beds, baths, square footage, home
#'       description, and neighborhood and school names
#' }
#'
#' @param zpid The Zillow Property ID for the property for which to obtain
#'     information. Required.
#' @param api_key character string specifying Zillow API key
#' @param raw logical, if \code{TRUE} the raw XML data from the API call is returned (i.e., the original ZillowR call)
#'
#' @return A data frame with columns corresponding to zpid, Date, and updated property information
#'
#' @export
#' @import rvest assertthat xml2
#'
#' @examples
#' \dontrun{
#' zapi_key = getOption('ZillowR-zws_id')
#' zpid='48749425'
#'
#' GetUpdatedPropertyDetails(zpid,api_key= zapi_key)
#' }
GetUpdatedPropertyDetails <- function(
  zpid,api_key, raw=FALSE
) {
  assertthat::assert_that((is.character(zpid)|is.numeric(zpid)), msg='Error: Check zpid formatting')
  assertthat::assert_that(!is.null(api_key), msg='Error: Zillow API key required')
  assertthat::assert_that(is.logical(raw))

  url = 'http://www.zillow.com/webservice/GetUpdatedPropertyDetails.htm'
  request <- url_encode_request(url,
                                'zpid' = zpid,
                                'zws-id' = api_key)
  xmlresult <- read_xml(request) %>%
    xml_nodes('response')

  if(raw==TRUE){return(xmlresult)}
  #check to make sure address worked, if not return NAs
  if(xmlresult %>% xml_nodes('zpid') %>% html_text() %>% length() == 0){
    warning('invalid zpid(s) not found, NAs returned')
    outdf <- as.numeric(c(zpid)) %>% t() %>% data.frame()
    names(outdf) <- c('zpid')
    return(outdf)
  }

  address_data <- xmlresult %>% xml_nodes('address') %>% xml_children %>%  xml_text() %>%
    matrix(ncol=6,byrow=T) %>% data.frame()
  names(address_data) <- c("address", "zipcode", "city", "state", "lat","long")
  address_data <- address_data %>% mutate_at(c("lat","long"),as.character) %>% mutate_at(c("lat","long"),as.numeric)

  editted_factnames <- xmlresult %>% xml_nodes('editedFacts') %>% xml_children() %>% xml_name()
  editted_factsdata <- xmlresult %>% xml_nodes('editedFacts') %>% xml_children %>%  xml_text() %>%
    matrix(ncol=length(editted_factnames),byrow=T) %>% data.frame()
  names(editted_factsdata) <- c(editted_factnames)

  pageview_data <- xmlresult %>% xml_nodes('pageViewCount') %>% xml_children %>%  xml_text() %>%
    matrix(ncol=2,byrow=T) %>% data.frame()
  names(pageview_data) <- c("currentMonth","total")

  outdf <- data.frame(address_data,editted_factsdata,pageview_data)

  return(outdf)
}





