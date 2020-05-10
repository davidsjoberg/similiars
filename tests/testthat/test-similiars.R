library(testthat)
test_that("find_string_distance", {
  expect_true(is.list(find_string_distance("k", letters)))
  expect_true(is.data.frame(find_string_distance("k", letters)[[1]]))
  expect_error(is.data.frame(find_string_distance(1, letters)[[1]]))
  expect_warning(find_most_similiar_string(c("bgath", "peacj"), stringr::fruit),
                 "No single most similiar string found for 'bgath'. Returning NA. Most similiar strings were 'date', 'peach'.",
                 fixed = TRUE)
  expect_true(is.na(find_most_similiar_string(c("bgath", "peacj"),stringr::fruit,feeling_lucky = FALSE,verbose = FALSE)[1]))

})

test_that("find_most_similiar_string", {
  expect_equal(is.character(find_most_similiar_string("appl", stringr::fruit)), TRUE)
  expect_equal(find_most_similiar_string("appl", stringr::fruit), "apple")
  expect_equal(find_most_similiar_string(NA_character_, stringr::fruit), NA_character_)
  expect_error(find_string_distance(1, letters))
})
