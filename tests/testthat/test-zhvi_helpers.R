
context('zhvi_helpers')

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(build_path_geog (x= abc))
  # expect an error due to incorrect input
  expect_error(build_path_geog (x=a1b2c3))
})

test_that(" provide the correct input", {
   # expect an error due to incorrect input
   expect_error(build_path_bed(x= abc,rental=F))
   # expect an error due to incorrect input
   expect_error(build_path_bed(x= bedrooms,rental=abc))
 })

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(build_path_allhomes(tier=abc, other=NULL))
  # expect an error due to incorrect input
  expect_error(build_path_allhomes(tier='ALL', other=abc))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(build_rent_type(abc))
  # expect an error due to incorrect input
  expect_error(build_rent_type(a1b2c3))
})
