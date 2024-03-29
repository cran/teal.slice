testthat::test_that("init_filter_states returns a DFFilterStates object if passed an empty data.frame", {
  testthat::expect_no_error(
    filter_states <- init_filter_states(data.frame(), dataname = "test")
  )
  testthat::expect_true(
    is(filter_states, "DFFilterStates")
  )
})

testthat::test_that("init_filter_states returns a MatrixFilterStates object if passed an empty matrix", {
  testthat::expect_no_error(
    filter_states <- init_filter_states(matrix(), dataname = "test")
  )
  testthat::expect_true(
    is(filter_states, "MatrixFilterStates")
  )
})

testthat::test_that("init_filter_states returns an MAEFilterStates object if passed an object of class MAE", {
  testthat::skip_if_not_installed("MultiAssayExperiment")
  mock_mae <- structure(list(), class = "MultiAssayExperiment")
  testthat::expect_no_error(
    filter_states <- init_filter_states(mock_mae, dataname = "test")
  )
  testthat::expect_true(is(filter_states, "MAEFilterStates"))
})

testthat::test_that("init_filter_states returns an SEFilterStates object if passed an object of class SE", {
  testthat::skip_if_not_installed("SummarizedExperiment")
  mock_se <- structure(list(), class = "SummarizedExperiment")
  testthat::expect_no_error(
    filter_states <- init_filter_states(
      mock_se,
      dataname = "test"
    )
  )
  testthat::expect_true(is(filter_states, "SEFilterStates"))
})
