
context('search_helpers')

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_address(x= abc))
  # expect an error due to incorrect input
  expect_error(extract_address(x=a1b2c3))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(zesthelper(abc, rentzestimate, api_key, raw=FALSE))
  # expect an error due to incorrect input
  expect_error(zesthelper(zpid, abc, api_key, raw=FALSE))
  # expect an error due to incorrect input
  expect_error(zesthelper(zpid, rentzestimate, api_key, raw=FALSE))
  # expect an error due to incorrect input
  expect_error(zesthelper(zpid, rentzestimate, abc, raw=abc))
})

test_that(" provide the correct input", {
   # expect an error due to incorrect input
   expect_error(extract_zestimates(x= abc))
   # expect an error due to incorrect input
   expect_error(extract_zestimates(x=a1b2c3))
 })

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_rent_zestimates(x= abc))
  # expect an error due to incorrect input
  expect_error(extract_rent_zestimates(x=a1b2c3))
})
