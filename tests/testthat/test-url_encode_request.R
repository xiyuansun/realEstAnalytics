
context('url_encode_request')

test_that(" provide the correct input", {
  expect_error(url_encode_request(x= abc,...))
  expect_error(url_encode_request(x=a1b2c3,...))

})

test_that("function creates proper URL request string", {
  absent_arg <- NULL
  character_arg <- 'Here I am!'
  numeric_arg <- 100

  expect_identical(
    url_encode_request('http://example.com/API.htm', absent_arg = absent_arg, character_arg = character_arg, numeric_arg = numeric_arg),
    'http://example.com/API.htm?character_arg=Here%20I%20am!&numeric_arg=100'
  )
})

