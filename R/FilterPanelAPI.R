# FilterPanelAPI ------

#' @name FilterPanelAPI
#' @docType class
#'
#' @title Class to encapsulate the API of the filter panel of a teal app
#'
#' @description
#' An API class for managing filter states in a teal application's filter panel.
#'
#' @details
#' The purpose of this class is to encapsulate the API of the filter panel in a
#' new class `FilterPanelAPI` so that it can be passed and used in the server
#' call of any module instead of passing the whole `FilteredData` object.
#'
#' This class is supported by methods to set, get, remove filter states in the
#' filter panel API.
#'
#' @examples
#' library(shiny)
#'
#' fd <- init_filtered_data(list(iris = iris))
#' fpa <- FilterPanelAPI$new(fd)
#'
#' # get the actual filter state --> empty named list
#' isolate(fpa$get_filter_state())
#'
#' # set a filter state
#' set_filter_state(
#'   fpa,
#'   teal_slices(
#'     teal_slice(dataname = "iris", varname = "Species", selected = "setosa", keep_na = TRUE)
#'   )
#' )
#'
#' # get the actual filter state --> named list with filters
#' isolate(fpa$get_filter_state())
#'
#' # remove all_filter_states
#' fpa$clear_filter_states()
#'
#' # get the actual filter state --> empty named list
#' isolate(fpa$get_filter_state())
#'
#' @export
#'
FilterPanelAPI <- R6::R6Class( # nolint
  "FilterPanelAPI",
  # public methods ----
  public = list(
    #' @description
    #' Initialize a `FilterPanelAPI` object.
    #' @param datasets (`FilteredData`)
    #'
    initialize = function(datasets) {
      checkmate::assert_class(datasets, "FilteredData")
      private$filtered_data <- datasets
    },

    #' @description
    #' Gets the reactive values from the active `FilterState` objects of the `FilteredData` object.
    #'
    #' Gets all active filters in the form of a nested list.
    #' The output list is a compatible input to `set_filter_state`.
    #'
    #' @return `list` with named elements corresponding to `FilteredDataset` objects with active filters.
    #'
    get_filter_state = function() {
      private$filtered_data$get_filter_state()
    },

    #' @description
    #' Sets active filter states.
    #' @param filter (`teal_slices`)
    #'
    #' @return `NULL`, invisibly.
    #'
    set_filter_state = function(filter) {
      private$filtered_data$set_filter_state(filter)
      invisible(NULL)
    },

    #' @description
    #' Remove one or more `FilterState` of a `FilteredDataset` in the `FilteredData` object.
    #'
    #' @param filter (`teal_slices`)
    #'   specifying `FilterState` objects to remove;
    #'   `teal_slice`s may contain only `dataname` and `varname`, other elements are ignored
    #'
    #' @return `NULL`, invisibly.
    #'
    remove_filter_state = function(filter) {
      private$filtered_data$remove_filter_state(filter)
      invisible(NULL)
    },

    #' @description
    #' Remove all `FilterStates` of the `FilteredData` object.
    #'
    #' @param datanames (`character`)
    #'  `datanames` to remove their `FilterStates`;
    #'  omit to remove all `FilterStates` in the `FilteredData` object
    #'
    #' @return `NULL`, invisibly.
    #'
    clear_filter_states = function(datanames) {
      datanames_to_remove <- if (missing(datanames)) private$filtered_data$datanames() else datanames
      private$filtered_data$clear_filter_states(datanames = datanames_to_remove)
      invisible(NULL)
    }
  ),
  # private methods ----
  private = list(
    filtered_data = NULL
  )
)
