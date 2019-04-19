
context('GetDeepSearchResults_dataframe')

set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
zapi_key = getOption('ZillowR-zws_id')

test_that(" provide the correct adress", {
  # expect an error due to incorrect address
  expect_error(GetDeepSearchResults_dataframe(col.address=abc, col.zipcode=2, col.city=4,col.state=3,api_key=zapi_key))
  # expect an error due to incorrect adress
  expect_error(GetDeepSearchResults_dataframe(col.address=a1b2c3, col.zipcode=2, col.city=4,col.state=3,api_key=zapi_key))
})

test_that(" provide the correct zip code", {
  # expect an error due to incorrect zip code
  expect_error(GetDeepSearchResults_dataframe(col.address=1, col.zipcode=abc, col.city=4,col.state=3,api_key=zapi_key))
  # expect an error due to incorrect zip code
  expect_error(GetDeepSearchResults_dataframe(col.address=1, col.zipcode=a1b2c3, col.city=4,col.state=3,api_key=zapi_key))
})

test_that(" provide the correct city name", {
  # expect an error due to incorrect city name
  expect_error(GetDeepSearchResults_dataframe(col.address=1, col.zipcode=2, col.city=abc,col.state=3,api_key=zapi_key))
  # expect an error due to incorrect city name
  expect_error(GetDeepSearchResults_dataframe(col.address=1, col.zipcode=2, col.city=a1b2c3,col.state=3,api_key=zapi_key))
})

test_that(" provide the correct state name", {
  # expect an error due to incorrect state name
  expect_error(GetDeepSearchResults_dataframe(col.address=1, col.zipcode=2, col.city=4,col.state=abc,api_key=zapi_key))
  # expect an error due to incorrect state name
  expect_error(GetDeepSearchResults_dataframe(col.address=1, col.zipcode=2, col.city=4,col.state=a1b2c3,api_key=zapi_key))
})

test_that(" provide the correct api key", {
  # expect an error due to incorrect state name
  expect_error(GetDeepSearchResults_dataframe(col.address=1, col.zipcode=2, col.city=4,col.state=3,api_key=abc))
  # expect an error due to incorrect state name
  expect_error(GetDeepSearchResults_dataframe(col.address=1, col.zipcode=2, col.city=4,col.state=3,api_key=a1b2c3))
})

test_that(" output is a dataframe", {
  # expect data frame
  expect_s3_class(GetDeepSearchResults_dataframe(data.frame(address=c('733 Normandy Ct', '600 South Quail Ct','2902 Wood St', '3425 Locust St.'),
                                                            zipcode=c('67114','67114','50014', '64109'),
                                                            state=c("KS","KS","IA","MO"), city=c("Newton","Newton","Ames","Kansas City")),
                                                col.address=1, col.zipcode=2, col.city=4,col.state=3,api_key=zapi_key), "data.frame")
})


