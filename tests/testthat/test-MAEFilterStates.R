# initialize ----
testthat::test_that("constructor accepts a MultiAssayExperiment", {
  testthat::skip_if_not_installed("MultiAssayExperiment")
  utils::data(miniACC, package = "MultiAssayExperiment")
  testthat::expect_no_error(
    MAEFilterStates$new(data = miniACC, dataname = "miniACC")
  )
  testthat::expect_error(
    MAEFilterStates$new(data = miniACC[[1]], dataname = "miniACC"),
    "Assertion on 'data' failed"
  )
})

# get_filter_state ----
testthat::test_that("get_filter_state returns `teal_slices` with include_varname by default and count_type=none", {
  testthat::skip_if_not_installed("MultiAssayExperiment")
  utils::data(miniACC, package = "MultiAssayExperiment")
  filter_states <- MAEFilterStates$new(data = miniACC, dataname = "miniACC")
  fs <- teal_slices(
    count_type = "none",
    include_varnames = list(miniACC = colnames(SummarizedExperiment::colData(miniACC)))
  )

  testthat::expect_identical(
    shiny::isolate(filter_states$get_filter_state()),
    fs
  )
})

# get_call ----
testthat::test_that("get_call returns subsetByColData call with varnames prefixed by dataname$", {
  testthat::skip_if_not_installed("MultiAssayExperiment")
  utils::data(miniACC, package = "MultiAssayExperiment")
  filter_states <- MAEFilterStates$new(data = miniACC, dataname = "miniacc")
  filter_states$set_filter_state(
    teal_slices(
      teal_slice(
        dataname = "miniacc", varname = "years_to_birth", selected = c(18, 60), keep_na = FALSE, keep_inf = FALSE
      )
    )
  )

  testthat::expect_equal(
    shiny::isolate(filter_states$get_call()),
    quote(
      miniacc <- MultiAssayExperiment::subsetByColData(
        miniacc,
        miniacc$years_to_birth >= 18 & miniacc$years_to_birth <= 60
      )
    )
  )
})
