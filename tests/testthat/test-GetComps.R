
context('GetComps')
set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
zapi_key = getOption('ZillowR-zws_id')

test_that(" provide the correct zip code", {
  # expect an error due to incorrect zip code
  expect_error(GetComps(abc, count=10, rentzestimate=FALSE, api_key=zapi_key,raw=FALSE))
  # expect an error due to incorrect zip code
  expect_error(GetDeepComps(a1b2c3, count=10, rentzestimate=FALSE, api_key=zapi_key,raw=FALSE))
})

test_that(" provide the correct count code", {
  # expect an error due to incorrect count code
  expect_error(GetComps('1341571', count=abc, rentzestimate=TRUE, api_key=zapi_key,raw=FALSE))
  # expect an error due to incorrect count code
  expect_error(GetComps('1341571', count=a1b2c3, rentzestimate=TRUE, api_key=zapi_key,raw=FALSE))
})

test_that(" do not include a rentzestimate", {
  # expect an error due to incorrect rentzestimate
  expect_error(GetComps('1341571', count=10, rentzestimate=abs, api_key=zapi_key,raw=FALSE))
  # expect an error due to incorrect zip code
  expect_error(GetComps('1341571', count=10, rentzestimate=a1b2c3, api_key=zapi_key,raw=FALSE))
})

test_that(" provide the correct api key", {
  # expect an error due to incorrect api key
  expect_error(GetComps('1341571', count=10, rentzestimate=FALSE, api_key=abc,raw=FALSE))
  # expect an error due to incorrect api key
  expect_error(GetComps('1341571', count=10, rentzestimate=FALSE, api_key=a1b2c3,raw=FALSE))
})

test_that(" output is a dataframe", {
  # expect data frame
  expect_s3_class(GetComps('1341571', count=10, rentzestimate=FALSE, api_key=zapi_key,raw=FALSE), "data.frame")
})

