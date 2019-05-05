
context('GetDeepSearchResults')

set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
zapi_key = getOption('ZillowR-zws_id')

test_that(" provide the correct adress", {
  # expect an error due to incorrect address
  expect_error(GetDeepSearchResults(address= abc, city='Ames', state='IA', zipcode='50014', api_key=zapi_key))
  # expect an error due to incorrect adress
  expect_error(GetDeepSearchResults(address= a1b2c3, city='Ames', state='IA', zipcode='50014', api_key=zapi_key))
})

test_that(" provide the correct city name", {
  # expect an error due to incorrect city name
  expect_error(GetDeepSearchResults(address= '312 Hayward Ave.', city=abc, state='IA', zipcode='50014', api_key=zapi_key))
  # expect an error due to incorrect city name
  expect_error(GetDeepSearchResults(address= '312 Hayward Ave.', city=a1b2c3, state='IA', zipcode='50014', api_key=zapi_key))
})

test_that(" provide the correct state name", {
  # expect an error due to incorrect state name
  expect_error(GetDeepSearchResults(address= '312 Hayward Ave.', city='Ames', state=abc, zipcode='50014', api_key=zapi_key))
  # expect an error due to incorrect state name
  expect_error(GetDeepSearchResults(address= '312 Hayward Ave.', city='Ames', state=a1b2c3, zipcode='50014', api_key=zapi_key))
})

test_that(" provide the correct zip code", {
  # expect an error due to incorrect zip code
  expect_error(GetDeepSearchResults(address='312 Hayward Ave.', city='Ames', state='IA', zipcode=abc, api_key=zapi_key))
  # expect an error due to incorrect zip code
  expect_error(GetDeepSearchResults(address='312 Hayward Ave.', city='Ames', state='IA', zipcode=a1b2c3, api_key=zapi_key))
})

test_that(" provide the correct api key", {
  # expect an error due to incorrect api key
  expect_error(GetDeepSearchResults(address='312 Hayward Ave.', city='Ames', state='IA', zipcode='50014', api_key=abc))
  # expect an error due to incorrect api key
  expect_error(GetDeepSearchResults(address='312 Hayward Ave.', city='Ames', state='IA', zipcode='50014', api_key=a1b2c3))
})

test_that(" output is a dataframe", {
  # expect data frame
  expect_s3_class(GetDeepSearchResults(address='312 Hayward Ave.', city='Ames', state='IA', zipcode='50014', api_key=zapi_key), "data.frame")
})

test_that(" bad address gives warning", {
  # expect data frame
  expect_warning(GetDeepSearchResults(address='312 Hayward Ave. UNIT 3311', city='Ames', state='IA',
                                      zipcode='50014', api_key=zapi_key))
})

test_that(" rentzestimate returns rent zestimates", {
  # expect data frame
  expect_true('rentzestimate' %in% (GetDeepSearchResults(address='312 Hayward Ave.',
                                       city='Ames', state='IA', zipcode='50014',
                                       api_key=zapi_key, rentzestimate=TRUE) %>% names())
              )
})

test_that(" raw returns raw", {
  # expect data frame
  expect_s3_class(GetDeepSearchResults(address='312 Hayward Ave.',
                                       city='Ames', state='IA', zipcode='50014', api_key=zapi_key, raw=TRUE),
                  c("xml_document", "xml_node"))
})
