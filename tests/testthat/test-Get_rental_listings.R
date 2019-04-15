
context('Get_rental_listings')

test_that(" provide the correct number of bedrooms", {
  # expect an error due to incorrect number of bedrooms
  expect_error(get_rental_listings(bedrooms=abc, rate='PerSqFt', type="Studio",geography="Zip"))
  # expect an error due to incorrect number of bedrooms
  expect_error(get_rental_listings(bedrooms=abc, rate='Total', type="Multi", geography="State"))
})

test_that(" provide the correct rate", {
  # expect an error due to incorrect rate
  expect_error(get_rental_listings(bedrooms=5, rate=abc, type="Studio",geography="Zip"))
  # expect an error due to incorrect rate
  expect_error(get_rental_listings(bedrooms=1, rate=abc, type="Multi", geography="State"))
})

test_that(" provide the correct type of apartment", {
  # expect an error due to incorrect type of apartment
  expect_error(get_rental_listings(bedrooms=5, rate='PerSqFt', type=abc,geography="Zip"))
  # expect an error due to incorrect type of apartment
  expect_error(get_rental_listings(bedrooms=1, rate='Total', type=abc, geography="State"))
})

test_that(" provide the correct zip code", {
  # expect an error due to incorrect zip code
  expect_error(get_rental_listings(bedrooms=5, rate='PerSqFt', type="Studio",geography=abc))
  # expect an error due to incorrect zip code
  expect_error(get_rental_listings(bedrooms=1, rate='Total', type="Multi", geography=abc))
})

test_that(" output is a dataframe", {
  # expect data frame
  expect_s3_class(get_rental_listings(bedrooms=5, rate='PerSqFt', type="Studio",geography="Zip"), "data.frame")
  expect_s3_class(get_rental_listings(bedrooms=5, rate='PerSqFt', type="Studio",geography="State"), "data.frame")
})

