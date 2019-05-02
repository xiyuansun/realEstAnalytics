
context('search_helpers')

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_address_search(x= abc))
  # expect an error due to incorrect input
  expect_error(extract_address_search(x=a1b2c3))
})

test_that(" provide the correct input", {
   # expect an error due to incorrect input
   expect_error(extract_otherdata_search(x= abc))
   # expect an error due to incorrect input
   expect_error(extract_otherdata_search(x=a1b2c3))
 })

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(GetDeepSearchResults(api_key=abc,address=as.character(namedvector['address']),
                                    zipcode=zip,city=city,state=state, rentzestimate=rentzestimate, raw=raw))
  # expect an error due to incorrect input
  expect_error(GetDeepSearchResults(api_key=api_key,address=as.character(namedvector['abc']),
                                    zipcode=zip,city=city,state=state, rentzestimate=rentzestimate, raw=raw))
  # expect an error due to incorrect input
  expect_error(GetDeepSearchResults(api_key=api_key,address=as.character(namedvector['address']),
                                    zipcode=abc,city=city,state=state, rentzestimate=rentzestimate, raw=raw))
  # expect an error due to incorrect input
  expect_error(GetDeepSearchResults(api_key=api_key,address=as.character(namedvector['address']),
                                    zipcode=zip,city=abc,state=state, rentzestimate=rentzestimate, raw=raw))
  # expect an error due to incorrect input
  expect_error(GetDeepSearchResults(api_key=api_key,address=as.character(namedvector['address']),
                                    zipcode=zip,city=city,state=abc, rentzestimate=rentzestimate, raw=raw))
  # expect an error due to incorrect input
  expect_error(GetDeepSearchResults(api_key=api_key,address=as.character(namedvector['address']),
                                    zipcode=zip,city=city,state=abc, rentzestimate=abc, raw=raw))
})
