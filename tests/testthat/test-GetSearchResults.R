
context('GetSearchResults')

test_that(" provide the correct adress", {
  # expect an error due to incorrect address
  expect_error(GetSearchResults(address = abc, citystatezip = 'Seattle, WA',rentzestimate = FALSE,zws_id = zws_id))
  # expect an error due to incorrect adress
  expect_error(GetSearchResults(address = a1b2c3, citystatezip = 'Seattle, WA',rentzestimate = FALSE,zws_id = zws_id))
})

test_that(" provide the correct ZIP code for which to search", {
  # expect an error due to incorrect citystatezip
  expect_error(GetSearchResults(address = '2114 Bigelow Ave', citystatezip = abc,rentzestimate = FALSE,zws_id = zws_id))
  # expect an error due to incorrect citystatezip
  expect_error(GetSearchResults(address = '2114 Bigelow Ave', citystatezip = a1b2c3,rentzestimate = FALSE,zws_id = zws_id))
})

test_that(" provide the correct The Zillow Web Service Identifier", {
  # expect an error due to incorrect The Zillow Web Service Identifier
  expect_error(GetSearchResults(address = '2114 Bigelow Ave', citystatezip = 'Seattle, WA',rentzestimate = FALSE,zws_id = abc))
  # expect an error due to incorrect The Zillow Web Service Identifier
  expect_error(GetSearchResults(address = '2114 Bigelow Ave', citystatezip = 'Seattle, WA',rentzestimate = FALSE,zws_id = a1b2c3))
})

test_that(" output is a list", {
  # expect data frame
  expect_is(GetSearchResults(address = '2114 Bigelow Ave', citystatezip = 'Seattle, WA',rentzestimate = FALSE,zws_id = zws_id), "list")
})

