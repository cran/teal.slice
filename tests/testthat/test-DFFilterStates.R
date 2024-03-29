# initialize ----
testthat::test_that("contructor accepts keys as string", {
  testthat::expect_no_error(
    DFFilterStates$new(data = data.frame(), dataname = "test", keys = "test")
  )
})

# get_filter_state ----
testthat::test_that("get_filter_state return `teal_slices` with include_varnames and count_type by default", {
  filter_states <- DFFilterStates$new(data = iris, dataname = "iris")
  fs <- teal_slices(
    count_type = "none",
    include_varnames = list(iris = colnames(iris))
  )
  testthat::expect_identical(
    shiny::isolate(filter_states$get_filter_state()),
    fs
  )
})

# get_call ----
testthat::test_that("get_call returns filter call on dataname with unprefixed variables in logical expression", {
  filter_states <- DFFilterStates$new(data = iris, dataname = "iris")
  fs <- teal_slices(
    teal_slice(dataname = "iris", varname = "Sepal.Length", selected = c(5.1, 6.4)),
    teal_slice(dataname = "iris", varname = "Species", selected = c("setosa", "versicolor"))
  )
  filter_states$set_filter_state(fs)
  testthat::expect_equal(
    shiny::isolate(filter_states$get_call()),
    quote(
      iris <- dplyr::filter(
        iris,
        Sepal.Length >= 5.1 & Sepal.Length <= 6.4 &
          Species %in% c("setosa", "versicolor")
      )
    )
  )
})
