df1 <- data.frame(
  int = 1:100,
  num = 1:100 / 10,
  fact = sample(rep_len(letters, 100)),
  stringsAsFactors = TRUE
)
df2 <- data.frame(
  int = 1:100,
  num = 1:100 / 100,
  fact = sample(rep_len(letters, 100)),
  stringsAsFactors = TRUE
)
filtered_data <- init_filtered_data(list(df1 = df1, df2 = df2))

# initialize ----
testthat::test_that("FilterPanelAPI constructor accepts a FilteredData object", {
  testthat::expect_no_error(FilterPanelAPI$new(filtered_data))
  testthat::expect_error(
    FilterPanelAPI$new(list(df1 = df1)),
    "Must inherit from class 'FilteredData', but has class 'list'."
  )
  testthat::expect_error(
    FilterPanelAPI$new(df1),
    "Must inherit from class 'FilteredData', but has class 'data.frame'."
  )
})

# set_filter_state ----
testthat::test_that("FilterPanelAPI$set_filter_state adds filter states", {
  datasets <- FilterPanelAPI$new(filtered_data)
  fs <- teal_slices(
    teal_slice(dataname = "df1", varname = "num", selected = c(5.1, 6.4), keep_na = FALSE, keep_inf = FALSE),
    teal_slice(dataname = "df1", varname = "fact", selected = c("a", "b"), keep_na = FALSE)
  )
  shiny::isolate(datasets$set_filter_state(fs))

  testthat::expect_length(shiny::isolate(datasets$get_filter_state()), 2)
})

# get_filter_state ----
testthat::test_that("get_filter_state returns `teal_slices` with features identical those in input, adds format", {
  datasets <- FilterPanelAPI$new(filtered_data)

  fs <- teal_slices(
    teal_slice(dataname = "df1", varname = "num", selected = c(5.1, 6.4), keep_na = FALSE, keep_inf = FALSE),
    teal_slice(dataname = "df1", varname = "fact", selected = c("a", "b"), keep_na = FALSE),
    teal_slice(dataname = "df2", varname = "int", selected = c(52, 65), keep_na = FALSE, keep_inf = FALSE)
  )
  datasets$set_filter_state(fs)

  fs_out <- unname(shiny::isolate(datasets$get_filter_state()))
  testthat::expect_true(compare_slices(
    fs[[1]], fs_out[[1]],
    fields = c("dataname", "varname", "selected", "keep_na", "keep_inf")
  ))
  testthat::expect_true(compare_slices(
    fs[[2]], fs_out[[2]],
    fields = c("dataname", "varname", "selected", "keep_na")
  ))
  testthat::expect_true(compare_slices(
    fs[[3]], fs_out[[3]],
    fields = c("dataname", "varname", "selected", "keep_na", "keep_inf")
  ))
})

# remove_filter_state ----
testthat::test_that("FilterPanelAPI$remove_filter_state removes filter states specified by `teal_slices`", {
  datasets <- FilterPanelAPI$new(filtered_data)
  fs <- teal_slices(
    teal_slice(dataname = "df1", varname = "num", selected = c(5.1, 6.4), keep_na = FALSE, keep_inf = FALSE),
    teal_slice(dataname = "df1", varname = "fact", selected = c("a", "b"), keep_na = FALSE),
    teal_slice(dataname = "df2", varname = "int", selected = c(52, 65), keep_na = FALSE, keep_inf = FALSE)
  )
  datasets$set_filter_state(fs)
  datasets$remove_filter_state(teal_slices(teal_slice(dataname = "df1", varname = "num")))

  testthat::expect_identical(
    shiny::isolate(unique(unlist(lapply(datasets$get_filter_state(), "[[", "varname")))),
    c("fact", "int")
  )
})

# clear_filter_states ----
testthat::test_that("FilterPanelAPI$clear_filter_states removes all filters of datasets in FilterPanelAPI", {
  datasets <- FilterPanelAPI$new(filtered_data)
  fs <- teal_slices(
    teal_slice(dataname = "df1", varname = "num", selected = c(5.1, 6.4), keep_na = FALSE, keep_inf = FALSE),
    teal_slice(dataname = "df1", varname = "fact", selected = c("a", "b"), keep_na = FALSE),
    teal_slice(dataname = "df2", varname = "int", selected = c(52, 65), keep_na = FALSE, keep_inf = FALSE)
  )
  datasets$set_filter_state(fs)

  testthat::expect_length(shiny::isolate(datasets$get_filter_state()), 3)

  datasets$clear_filter_states()

  testthat::expect_length(shiny::isolate(datasets$get_filter_state()), 0)
})

testthat::test_that("FilterPanelAPI$clear_filter_states remove the filters of the desired dataset only", {
  datasets <- FilterPanelAPI$new(filtered_data)
  fs <- teal_slices(
    teal_slice(dataname = "df1", varname = "num", selected = c(5.1, 6.4), keep_na = FALSE, keep_inf = FALSE),
    teal_slice(dataname = "df1", varname = "fact", selected = c("a", "b"), keep_na = FALSE),
    teal_slice(dataname = "df2", varname = "int", selected = c(52, 65), keep_na = FALSE, keep_inf = FALSE)
  )
  datasets$set_filter_state(fs)

  testthat::expect_length(shiny::isolate(datasets$get_filter_state()), 3)

  datasets$clear_filter_states(datanames = "df1")

  testthat::expect_length(shiny::isolate(datasets$get_filter_state()), 1)

  testthat::expect_identical(
    shiny::isolate(unique(unlist(lapply(datasets$get_filter_state(), "[[", "varname")))),
    "int"
  )
})



# WRAPPER FUNCTIONS ----
# get_filter_state ----
testthat::test_that("get_filter_state returns `teal_slices` with features identical to those in input", {
  testthat::skip_if_not_installed("MultiAssayExperiment")
  utils::data(miniACC, package = "MultiAssayExperiment")
  datasets <- init_filtered_data(list(iris = iris, mae = miniACC))
  fs <- teal_slices(
    teal_slice("iris", "Species", selected = c("setosa", "versicolor")),
    teal_slice("iris", "Sepal.Length", selected = c(5.1, 6.4)),
    teal_slice("mae", "years_to_birth", selected = c(30, 50), keep_na = TRUE, keep_inf = FALSE),
    teal_slice("mae", "vital_status", selected = "1", keep_na = FALSE),
    teal_slice("mae", "gender", selected = "female", keep_na = TRUE),
    teal_slice("mae", "ARRAY_TYPE", selected = "", keep_na = TRUE, experiment = "RPPAArray", arg = "subset")
  )
  set_filter_state(datasets, filter = fs)

  fs_out <- shiny::isolate(get_filter_state(datasets))

  testthat::expect_true(compare_slices(
    fs[[1]], fs_out[[1]],
    fields = c("dataname", "varname", "selected")
  ))
  testthat::expect_true(compare_slices(
    fs[[2]], fs_out[[2]],
    fields = c("dataname", "varname", "selected")
  ))
  testthat::expect_true(compare_slices(
    fs[[3]], fs_out[[3]],
    fields = c("dataname", "varname", "selected", "keep_na", "keep_inf", "experiment", "target")
  ))
  testthat::expect_true(compare_slices(
    fs[[4]], fs_out[[4]],
    fields = c("dataname", "varname", "selected", "keep_na", "experiment", "target")
  ))
  testthat::expect_true(compare_slices(
    fs[[5]], fs_out[[5]],
    fields = c("dataname", "varname", "selected", "keep_na", "experiment", "target")
  ))
  testthat::expect_true(compare_slices(
    fs[[6]], fs_out[[6]],
    fields = c("dataname", "varname", "selected", "keep_na", "experiment", "target")
  ))
})

# remove_filter_state ----
testthat::test_that("remove_filter_state removes filter state specified by `teal_slices`", {
  testthat::skip_if_not_installed("MultiAssayExperiment")
  utils::data(miniACC, package = "MultiAssayExperiment")
  datasets <- init_filtered_data(list(iris = iris, mae = miniACC))
  fs <- teal_slices(
    teal_slice("iris", "Species", selected = c("setosa", "versicolor")),
    teal_slice("iris", "Sepal.Length", selected = c(5.1, 6.4)),
    teal_slice("mae", "years_to_birth", selected = c(30, 50), keep_na = TRUE, keep_inf = FALSE),
    teal_slice("mae", "vital_status", selected = "1", keep_na = FALSE),
    teal_slice("mae", "gender", selected = "female", keep_na = TRUE),
    teal_slice("mae", "ARRAY_TYPE", selected = "", keep_na = TRUE, experiment = "RPPAArray", arg = "subset")
  )
  set_filter_state(datasets, fs)
  testthat::expect_no_error(
    remove_filter_state(datasets, teal_slices(teal_slice(dataname = "iris", varname = "Species")))
  )
  testthat::expect_identical(
    shiny::isolate(unique(unlist(lapply(get_filter_state(datasets), "[[", "varname")))),
    c("Sepal.Length", "years_to_birth", "vital_status", "gender", "ARRAY_TYPE")
  )
})

# clear_filter_states ----
testthat::test_that("clear_filter_states removes all filter states", {
  testthat::skip_if_not_installed("MultiAssayExperiment")
  utils::data(miniACC, package = "MultiAssayExperiment")
  datasets <- init_filtered_data(list(iris = iris, mae = miniACC))
  fs <- teal_slices(
    teal_slice("iris", "Species", selected = c("setosa", "versicolor")),
    teal_slice("iris", "Sepal.Length", selected = c(5.1, 6.4)),
    teal_slice("mae", "years_to_birth", selected = c(30, 50), keep_na = TRUE, keep_inf = FALSE),
    teal_slice("mae", "vital_status", selected = "1", keep_na = FALSE),
    teal_slice("mae", "gender", selected = "female", keep_na = TRUE),
    teal_slice("mae", "ARRAY_TYPE", selected = "", keep_na = TRUE, experiment = "RPPAArray", arg = "subset")
  )
  set_filter_state(datasets, fs)
  testthat::expect_no_error(
    clear_filter_states(datasets)
  )
  testthat::expect_s3_class(shiny::isolate(get_filter_state(datasets)), "teal_slices")
  testthat::expect_length(shiny::isolate(get_filter_state(datasets)), 0)
})
