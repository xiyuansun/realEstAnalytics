
context('comp_helpers')

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_address_comps(x= abc,count))
  # expect an error due to incorrect input
  expect_error(extract_address_search(x=xmlres,abc))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_zestimates_comps(x= abc,count))
  # expect an error due to incorrect input
  expect_error(extract_zestimates_comps(x=xmlres,abc))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_rent_zestimates_comps(x= abc,count))
  # expect an error due to incorrect input
  expect_error(extract_rent_zestimates_comps(x=xmlres,abc))
})

 test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(extract_compscores(x= abc))
  # expect an error due to incorrect input
  expect_error(extract_compscores(x=a1b2c3))
})

test_that(" provide the correct input", {
   # expect an error due to incorrect input
   expect_error(extract_otherdata(x= abc))
   # expect an error due to incorrect input
   expect_error(extract_otherdata(x=a1b2c3))
 })
