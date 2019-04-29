#' Get Zillow Home Value Index time series data
#'
#' Reads the static .csv file for Zillow Home Values series by type and geography,
#' building a URL path to the .csv file. Options are available for a variety of home sizes and types,
#' as well as tiers if you wish to view other data that is aggregated. The return is a dataframe with time series observations aggregated by region.
#'
#' @name get_ZHVI_series
#' @param bedrooms a numeric value specifying the number of bedrooms. If not needed, leave at the default (1)
#' @param geography (required) string specifying the desired geographic region to summarise. Choices are 'Metro', 'City', 'State', 'Neighborhood', 'Zip', and 'County'.
#' @param allhomes logical, set to \code{TRUE} If you do not want a specific # of bedrooms or type of home
#' @param tier one of 'ALL','T' (for top), 'B' (for bottom), or 'M' (for median)
#' @param summary logical, if \code{TRUE}, the ZHVI summary for all homes is returned
#' @param other Other possible options from the Zillow home data series. Default is \code{NULL}. Possible options are strings "Median Home Price Per Sq Ft", and "Increasing" or "Decreasing"
#' @export
#' @importFrom readr read_csv
#' @return A tibble. Columns returned correspond to geographic identification information and dates for which the time series observations are available.
#' @examples
#' #All homes, bottom tier, by zipcode
#' \dontrun{
#'
#' get_ZHVI_series(allhomes=TRUE, tier="B",geography="Zip")
#'
#' }
#'
#' #2 bedrooms by city
#' \dontrun{
#' get_ZHVI_series(bedrooms=2,geography="City")
#'
#' }
#'
#' #the ZHVI summary for all homes by State
#' \dontrun{
#'
#' get_ZHVI_series(geography="State", summary=TRUE)
#'
#' }
#'
#'
get_ZHVI_series <- function(bedrooms=1, geography="Metro", allhomes = F, tier='ALL', summary = F, other=NULL){
  initial_link <- 'http://files.zillowstatic.com/research/public/'
  if(allhomes==F & summary==F){
    assert_that(bedrooms %in% c(1:5,'C','SFR'), msg='invalid number of rooms')
    pathb <- build_path_bed(bedrooms)
  }
  if(allhomes == T & summary==F){
    assert_that(!is.null(tier) | summary==F, msg='invalid tier for all homes')
    pathb <- build_path_allhomes(tier)
  }

  pathg <- build_path_geog(geography)

  link <- ifelse(summary, paste0(initial_link,pathg,'Zhvi_','Summary_AllHomes.csv'),
                 paste0(initial_link, pathg, 'Zhvi_', pathb, '.csv'))

  if(allhomes==T & tier == 'M' & summary==F){ link <- paste0(initial_link, pathg, pathb, '.csv')}
  if(!is.null(other)){link <- paste0(initial_link, pathg, build_path_allhomes(tier='ALL', other=other), '.csv')}
  #if(!is.null(other)){link <- paste0(initial_link, pathg, build_path_o(other))}
  print('attempting to read file:')
  print(as.character(link))
  out <- readr::read_csv(link)
  return(out)
}




