
context('GetUpdatedPropertyDetails')

set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
zws_id = getOption('ZillowR-zws_id')
zapi_key = getOption('ZillowR-zws_id')

test_that(" provide the correct adress", {
  # expect an error due to incorrect address
  expect_error(GetUpdatedPropertyDetails(zpid = abc,api_key = zws_id))
  # expect an error due to incorrect adress
  expect_error(GetUpdatedPropertyDetails(zpid = a1b2c3,api_key = zws_id))
})

test_that(" provide the correct ZIP code for which to search", {
  # expect an error due to incorrect citystatezip
  expect_error(GetUpdatedPropertyDetails(zpid = 48749425,api_key = abc))
  # expect an error due to incorrect citystatezip
  expect_error(GetUpdatedPropertyDetails(zpid = 48749425,api_key= a1b2c3))
})


#test_that(" output is a list", {
  # expect list
#  expect_is(GetUpdatedPropertyDetails(zpid = 48749425,api_key = 'X1-ZWz181enkd4cgb_82rpe'), "list")
#})

