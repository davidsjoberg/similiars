library(testthat)
test_that("find_string_distance", {
  expect_equal(is.list(find_string_distance("k", letters)), TRUE)
  expect_equal(is.data.frame(find_string_distance("k", letters)[[1]]), TRUE)
  expect_error(is.data.frame(find_string_distance(1, letters)[[1]]))
})

test_that("find_most_similiar_string", {
  expect_equal(is.character(find_most_similiar_string("appl", stringr::fruit)), TRUE)
  expect_equal(find_most_similiar_string("appl", stringr::fruit), "apple")
  expect_warning(find_most_similiar_string(NA_character_, stringr::fruit))
  expect_error(find_string_distance(1, letters))
})
