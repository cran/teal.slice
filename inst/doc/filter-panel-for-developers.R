## ----message=FALSE, warning=FALSE---------------------------------------------
library(teal.slice)

datasets <- init_filtered_data(list(iris = iris, mtcars = mtcars))

set_filter_state(
  datasets = datasets,
  filter = teal_slices(
    teal_slice(dataname = "iris", varname = "Species", selected = "virginica", keep_na = FALSE),
    teal_slice(dataname = "mtcars", id = "4 cyl", title = "4 Cylinders", expr = "cyl == 4"),
    teal_slice(dataname = "mtcars", varname = "mpg", selected = c(20.0, 25.0), keep_na = FALSE, keep_inf = FALSE),
    include_varnames = list(iris = c("Species", "Sepal.Length")),
    exclude_varnames = list(mtcars = "cyl")
  )
)

## ----message=FALSE, warning=FALSE---------------------------------------------
set_filter_state(
  datasets = datasets,
  filter = teal_slices(
    teal_slice(dataname = "mtcars", varname = "mpg", selected = c(22.0, 25.0))
  )
)

## ----message=FALSE, warning=FALSE---------------------------------------------
get_filter_state(datasets)

## ----message=FALSE, warning=FALSE---------------------------------------------
remove_filter_state(
  datasets = datasets,
  filter = teal_slices(
    teal_slice(dataname = "iris", varname = "Species")
  )
)

## ----message=FALSE, warning=FALSE---------------------------------------------
clear_filter_states(datasets)

## -----------------------------------------------------------------------------
set_filter_state(
  datasets,
  teal_slices(
    include_varnames = list(
      iris = c("Species", "Sepal.Length"),
      mtcard = c("cyl", "mpg")
    )
  )
)

## -----------------------------------------------------------------------------
set_filter_state(
  datasets,
  teal_slices(
    exclude_varnames = list(
      iris = c("Species", "Sepal.Length"),
      mtcard = c("cyl", "mpg")
    )
  )
)

## -----------------------------------------------------------------------------
library(shiny)

# initializing FilteredData
datasets <- init_filtered_data(list(iris = iris, mtcars = mtcars))

# setting initial filters
set_filter_state(
  datasets = datasets,
  filter = teal_slices(
    teal_slice(dataname = "iris", varname = "Species", selected = "virginica", keep_na = FALSE),
    teal_slice(dataname = "mtcars", id = "4 cyl", title = "4 Cylinders", expr = "cyl == 4"),
    teal_slice(dataname = "mtcars", varname = "mpg", selected = c(20.0, 25.0), keep_na = FALSE, keep_inf = FALSE),
    include_varnames = list(iris = c("Species", "Sepal.Length")),
    exclude_varnames = list(mtcars = "cyl"),
    count_type = "all",
    allow_add = TRUE
  )
)

ui <- fluidPage(
  shinyjs::useShinyjs(),
  fluidRow(
    column(
      width = 9,
      id = "teal_primary_col",
      tagList(
        actionButton("add_species_filter", "Set iris$Species filter"),
        actionButton("remove_species_filter", "Remove iris$Species filter"),
        actionButton("remove_all_filters", "Remove all filters"),
        verbatimTextOutput("rcode"),
        verbatimTextOutput("filter_state")
      )
    ),
    column(
      width = 3,
      id = "teal_secondary_col",
      datasets$ui_filter_panel("filter_panel")
    )
  )
)

server <- function(input, output, session) {
  # calling filter panel module
  datasets$srv_filter_panel("filter_panel")

  # displaying actual filter states
  output$filter_state <- renderPrint(print(get_filter_state(datasets), trim = FALSE))

  # displaying reproducible filter call
  output$rcode <- renderText(
    paste(
      sapply(c("iris", "mtcars"), datasets$get_call),
      collapse = "\n"
    )
  )

  # programmatic interaction with FilteredData
  observeEvent(input$add_species_filter, {
    set_filter_state(
      datasets,
      teal_slices(
        teal_slice(dataname = "iris", varname = "Species", selected = c("setosa", "versicolor"))
      )
    )
  })

  # programmatic removal of the FilterState
  observeEvent(input$remove_species_filter, {
    remove_filter_state(
      datasets,
      teal_slices(
        teal_slice(dataname = "iris", varname = "Species")
      )
    )
  })
  observeEvent(input$remove_all_filters, clear_filter_states(datasets))
}

if (interactive()) {
  shinyApp(ui, server)
}

