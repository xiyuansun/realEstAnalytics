
context('GetUpdatedPropertyDetails')

set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
zws_id = getOption('ZillowR-zws_id')
zapi_key = getOption('ZillowR-zws_id')

test_that(" provide the correct zillow property ID", {
  expect_error(GetUpdatedPropertyDetails(zpid = abc,api_key = zapi_key,raw=FALSE))
  #identical(GetUpdatedPropertyDetails(zpid = '0000000',api_key = zapi_key,raw=FALSE),NA)
})

test_that(" provide the correct API key", {
  #identical(GetUpdatedPropertyDetails(zpid = '93961896',api_key = 'abc',raw=FALSE),NA)
  expect_error(GetUpdatedPropertyDetails(zpid = '93961896',api_key= a1b2c3,raw=FALSE))
  identical(ncol(GetUpdatedPropertyDetails(zpid='93961896' ,api_key= zapi_key)),23)
})


test_that(" provide the correct adress", {
  expect_error(GetUpdatedPropertyDetails(zpid = abc,api_key = zapi_key,raw=TRUE))
  expect_error(GetUpdatedPropertyDetails(zpid = a1b2c3,api_key = zapi_key,raw=TRUE))
})

test_that(" provide the correct API key", {
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key = abc,raw=TRUE))
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key= a1b2c3,raw=TRUE))
})

test_that(" provide the correct raw status", {
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key = zapi_key,raw=abc))
  expect_error(GetUpdatedPropertyDetails(zpid = '48749425',api_key= zapi_key,raw=a1b2c3))
})

