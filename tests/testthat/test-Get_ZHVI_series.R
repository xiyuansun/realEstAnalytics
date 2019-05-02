
context('Get_ZHVI_series')

#' get_ZHVI_series(allhomes=TRUE, tier="B",geography="Zip")
#'
test_that(" provide the correct number of bedrooms", {
# expect an error due to incorrect number of bedrooms
expect_error(get_ZHVI_series(allhomes =abc, tier='B',geography="Zip"))
# expect an error due to incorrect number of bedrooms
expect_error(get_ZHVI_series(allhomes =a1b2c3, tier='B',geography="Zip"))
})

test_that(" provide the correct number of bedrooms", {
   # expect an error due to incorrect number of bedrooms
   expect_error(get_ZHVI_series(allhomes =TRUE, tier=abc,geography="Zip"))
   # expect an error due to incorrect number of bedrooms
   expect_error(get_ZHVI_series(allhomes =TRUE, tier='B',geography=abc))
 })
 test_that(" provide the correct number of bedrooms", {
   # expect an error due to incorrect number of bedrooms
   expect_error(get_ZHVI_series(allhomes =F, tier=abc,geography="Zip"))
   # expect an error due to incorrect number of bedrooms
   expect_error(get_ZHVI_series(allhomes =F, tier='B',geography=abc))
 })

test_that(" provide the correct number of bedrooms", {
  # expect an error due to incorrect number of bedrooms
  expect_error(get_ZHVI_series(bedrooms=abc, tier='B',geography="Zip"))
  # expect an error due to incorrect number of bedrooms
  expect_error(get_ZHVI_series(bedrooms=a1b2c3, tier='B',geography="Zip"))
})

test_that(" provide the correct tire", {
  # expect an error due to incorrect tire
  expect_error(get_ZHVI_series(bedrooms=2, tier=abc,geography="Zip"))
  # expect an error due to incorrect tire
  expect_error(get_ZHVI_series(bedrooms=2, tier=a1b2c3,geography="Zip"))
})

test_that(" provide the correct zip code", {
  # expect an error due to incorrect zip code
  expect_error(get_ZHVI_series(bedrooms=2, tier='B',geography=abc))
  # expect an error due to incorrect zip code
  expect_error(get_ZHVI_series(bedrooms=2, tier='B',geography=a1b2c3))
})

test_that(" provide the correct zip code", {
  # expect an error due to incorrect zip code
  expect_error(get_ZHVI_series(geography=abc, summary=T))
  # expect an error due to incorrect summary
  expect_error(get_ZHVI_series(geography="State", summary=abc))
})

test_that(" provide the correct zip code", {
  # expect an error due to incorrect zip code
  expect_error(get_ZHVI_series(geography=abc, summary=F))
  # expect an error due to incorrect summary
  expect_error(get_ZHVI_series(geography="State", summary=abc))
})
test_that(" output is a dataframe", {
  # expect data frame
  expect_s3_class(get_ZHVI_series(bedrooms=2, tier='B',geography="Zip"), "data.frame")
  expect_s3_class(get_ZHVI_series(geography="State", summary=T), "data.frame")
})
test_that(" output is a dataframe", {
  # expect data frame
  expect_s3_class(get_ZHVI_series(bedrooms=2, tier='B',geography="Zip"), "data.frame")
  expect_s3_class(get_ZHVI_series(geography="State", summary=F), "data.frame")
})



