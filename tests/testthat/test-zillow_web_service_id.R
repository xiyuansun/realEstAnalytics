
context('zillow_web_service_id')


test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(get_zillow_web_service_id(x= abc))
  # expect an error due to incorrect input
  expect_error(get_zillow_web_service_id(x=a1b2c3))
})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(set_zillow_web_service_id(x= abc))
  # expect an error due to incorrect input
  expect_error(set_zillow_web_service_id(x=a1b2c3))
})

