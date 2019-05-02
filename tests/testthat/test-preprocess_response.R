
context('preprocess_response')

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(preprocess_response(x= abc))
  # expect an error due to incorrect input
  expect_error(preprocess_response(x=a1b2c3))
})

