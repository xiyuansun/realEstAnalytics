
context('url_encode_request')

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(url_encode_request(x= abc,...))
  # expect an error due to incorrect input
  expect_error(url_encode_request(x=a1b2c3,...))
})

