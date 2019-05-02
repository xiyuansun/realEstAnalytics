
context('validate_arg')

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = abc,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = FALSE,class = abc,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = FALSE,class = NULL,length_min = abc,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})
 test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = FALSE,class = NULL,length_min = NULL,
                            length_max = abc,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})
 test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = FALSE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = abc,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = FALSE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = abc,
                            format = NULL,value_min = NULL,value_max = NULL))

})
 test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = FALSE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = abc,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = FALSE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = abc,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = FALSE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max =abc))

})


test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = abc,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = TRUE,class = abc,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = TRUE,class = NULL,length_min = abc,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = TRUE,class = NULL,length_min = NULL,
                            length_max = abc,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = TRUE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = abc,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = TRUE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = abc,
                            format = NULL,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = TRUE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = abc,value_min = NULL,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = TRUE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = abc,value_max = NULL))

})
test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= abc,required = TRUE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max =abc))

})

test_that(" provide the correct input", {
  # expect an error due to incorrect input
  expect_error(validate_arg(x= NULL,required = TRUE,class = NULL,length_min = NULL,
                            length_max = NULL,inclusion = NULL,exclusion = NULL,
                            format = NULL,value_min = NULL,value_max =abc))

})
