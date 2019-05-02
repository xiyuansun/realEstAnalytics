
context('GetUpdatedPropertyDetails')

set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
zws_id = getOption('ZillowR-zws_id')
zapi_key = getOption('ZillowR-zws_id')

test_that(" provide the correct adress", {
  # expect an error due to incorrect address
  expect_error(GetUpdatedPropertyDetails(zpid = abc,api_key = zapi_key,raw=FALSE))
  # expect an error due to incorrect adress
  expect_error(GetUpdatedPropertyDetails(zpid = a1b2c3,api_key = zapi_key,raw=FALSE))
})

test_that(" provide the correct ZIP code for which to search", {
  # expect an error due to incorrect citystatezip
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key = abc,raw=FALSE))
  # expect an error due to incorrect citystatezip
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key= a1b2c3,raw=FALSE))
})


test_that(" provide the correct adress", {
  # expect an error due to incorrect address
  expect_error(GetUpdatedPropertyDetails(zpid = abc,api_key = zapi_key,raw=TRUE))
  # expect an error due to incorrect adress
  expect_error(GetUpdatedPropertyDetails(zpid = a1b2c3,api_key = zapi_key,raw=TRUE))
})

test_that(" provide the correct ZIP code for which to search", {
  # expect an error due to incorrect citystatezip
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key = abc,raw=TRUE))
  # expect an error due to incorrect citystatezip
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key= a1b2c3,raw=TRUE))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key = zapi_key,raw=abc))
  # expect an error due to incorrect input
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key= zapi_key,raw=a1b2c3))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_editedfacts(abc,byrow=T))
  # expect an error due to incorrect input
  expect_error(extract_editedfacts(a1b2c3,byrow=F))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_pageview(abc,"total"))
  # expect an error due to incorrect input
  expect_error(extract_pageview("currentMonth",abc))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_address_e(c(abc, "zipcode", "city", "state", "lat","long")))
  # expect an error due to incorrect input
  expect_error(extract_address_e(c("address", abc, "city", "state", "lat","long")))
  # expect an error due to incorrect input
  expect_error(extract_address_e(c("address", "zipcode", abc, "state", "lat","long")))
  # expect an error due to incorrect input
  expect_error(extract_address_e(c("address", "zipcode", "city", abc, "lat","long")))
  # expect an error due to incorrect input
  expect_error(extract_address_e(c("address", "zipcode", "city", "state", abc,"long")))
  # expect an error due to incorrect input
  expect_error(extract_address_e(c("address", "zipcode", "city", "state", "lat",abc)))
})
#test_that(" output is a list", {
  # expect list
#  expect_is(GetUpdatedPropertyDetails(zpid = 48749425,api_key = 'X1-ZWz181enkd4cgb_82rpe'), "list")
#})

