
context('GetChart')

set_zillow_web_service_id('X1-ZWz181enkd4cgb_82rpe')
zws_id = getOption('ZillowR-zws_id')

test_that(" provide the correct zip code", {
  # expect an error due to incorrect zip code
  expect_error(GetChart(zpid = abc,zws_id ='X1-ZWz181enkd4cgb_82rpe', unit_type = 'dollar', width = 600, height = 300,chartDuration = '10years'))
  # expect an error due to incorrect zip code
  expect_error(GetChart(zpid = a1b2c3,zws_id ='X1-ZWz181enkd4cgb_82rpe', unit_type = 'dollar', width = 600, height = 300,chartDuration = '10years'))
})

test_that(" provide the correct zws id", {
  # expect an error due to incorrect zws id
  expect_error(GetChart(zpid = 48749425,zws_id =abc, unit_type = 'dollar', width = 600, height = 300,chartDuration = '10years'))
  # expect an error due to incorrect zws id
  expect_error(GetChart(zpid = 48749425,zws_id =a1b2c3, unit_type = 'dollar', width = 600, height = 300,chartDuration = '10years'))
})

test_that(" provide the correct unit type", {
  # expect an error due to incorrect unit type
  expect_error(GetChart(zpid = 48749425,zws_id ='X1-ZWz181enkd4cgb_82rpe', unit_type = abc, width = 600, height = 300,chartDuration = '10years'))
  # expect an error due to incorrect unit type
  expect_error(GetChart(zpid = 48749425,zws_id ='X1-ZWz181enkd4cgb_82rpe', unit_type = a1b2c3, width = 600, height = 300,chartDuration = '10years'))
})

test_that(" provide the correct withd and height", {
  # expect an error due to incorrect withd and height
  expect_error(GetChart(zpid = 48749425,zws_id ='X1-ZWz181enkd4cgb_82rpe', unit_type = 'dollar', width = abc, height = abc,chartDuration = '10years'))
  # expect an error due to incorrect withd and height
  expect_error(GetChart(zpid = 48749425,zws_id ='X1-ZWz181enkd4cgb_82rpe', unit_type = 'dollar', width = a1b2c3, height = a1b2c3,chartDuration = '10years'))
})


test_that(" provide the correct period", {
  # expect an error due to incorrect period
  expect_error(GetChart(zpid = 48749425,zws_id =zws_id, unit_type = 'dollar', width = 600, height = 300,chartDuration = abc))
  # expect an error due to incorrect period
  expect_error(GetChart(zpid = 48749425,zws_id =zws_id, unit_type = 'dollar', width = 600, height = 300,chartDuration = a1b2c3))
})

test_that(" output is a  list", {
  # expect list
  expect_is(GetChart(zpid = 48749425,zws_id =zws_id, unit_type = 'dollar', width = 600, height = 300,chartDuration = '10years'), "list")
})


