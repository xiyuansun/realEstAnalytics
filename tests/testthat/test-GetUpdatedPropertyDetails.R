
context('GetUpdatedPropertyDetails')

test_that(" provide the correct adress", {
  # expect an error due to incorrect address
  expect_error(GetUpdatedPropertyDetails(zpid = abc,zws_id = zws_id))
  # expect an error due to incorrect adress
  expect_error(GetUpdatedPropertyDetails(zpid = a1b2c3,zws_id = zws_id))
})

test_that(" provide the correct ZIP code for which to search", {
  # expect an error due to incorrect citystatezip
  expect_error(GetUpdatedPropertyDetails(zpid = 48749425,zws_id = abc))
  # expect an error due to incorrect citystatezip
  expect_error(GetUpdatedPropertyDetails(zpid = 48749425,zws_id = a1b2c3))
})


test_that(" output is a list", {
  # expect list
  expect_is(GetUpdatedPropertyDetails(zpid = 48749425,zws_id = 'X1-ZWz181enkd4cgb_82rpe'), "list")
})

