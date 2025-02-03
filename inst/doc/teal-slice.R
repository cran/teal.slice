## ----echo=FALSE, out.width='60%'----------------------------------------------
knitr::include_graphics("./images/teal-slice/filter-panel.png")

## ----warning=FALSE, message=FALSE---------------------------------------------
library(shiny)
library(teal.slice)

# create a FilteredData object
datasets <- init_filtered_data(list(iris = iris, mtcars = mtcars))

# setting initial state
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
  fluidRow(
    column(
      width = 9,
      tabsetPanel(
        tabPanel(title = "iris", dataTableOutput("iris_table")),
        tabPanel(title = "mtcars", dataTableOutput("mtcars_table"))
      )
    ),
    # ui for the filter panel
    column(width = 3, datasets$ui_filter_panel("filter_panel"))
  )
)

server <- function(input, output, session) {
  # this is the shiny server function for the filter panel and the datasets
  # object can now be used inside the application
  datasets$srv_filter_panel("filter_panel")

  # get the filtered datasets and put them inside reactives for analysis
  iris_filtered_data <- reactive(datasets$get_data(dataname = "iris", filtered = TRUE))
  mtcars_filtered_data <- reactive(datasets$get_data(dataname = "mtcars", filtered = TRUE))

  output$iris_table <- renderDataTable(iris_filtered_data())
  output$mtcars_table <- renderDataTable(mtcars_filtered_data())
}

if (interactive()) {
  shinyApp(ui, server)
}

