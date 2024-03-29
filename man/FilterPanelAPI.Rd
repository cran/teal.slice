% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilterPanelAPI.R
\docType{class}
\name{FilterPanelAPI}
\alias{FilterPanelAPI}
\title{Class to encapsulate the API of the filter panel of a teal app}
\description{
An API class for managing filter states in a teal application's filter panel.
}
\details{
The purpose of this class is to encapsulate the API of the filter panel in a
new class \code{FilterPanelAPI} so that it can be passed and used in the server
call of any module instead of passing the whole \code{FilteredData} object.

This class is supported by methods to set, get, remove filter states in the
filter panel API.
}
\examples{
library(shiny)

fd <- init_filtered_data(list(iris = iris))
fpa <- FilterPanelAPI$new(fd)

# get the actual filter state --> empty named list
isolate(fpa$get_filter_state())

# set a filter state
set_filter_state(
  fpa,
  teal_slices(
    teal_slice(dataname = "iris", varname = "Species", selected = "setosa", keep_na = TRUE)
  )
)

# get the actual filter state --> named list with filters
isolate(fpa$get_filter_state())

# remove all_filter_states
fpa$clear_filter_states()

# get the actual filter state --> empty named list
isolate(fpa$get_filter_state())

}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-FilterPanelAPI-new}{\code{FilterPanelAPI$new()}}
\item \href{#method-FilterPanelAPI-get_filter_state}{\code{FilterPanelAPI$get_filter_state()}}
\item \href{#method-FilterPanelAPI-set_filter_state}{\code{FilterPanelAPI$set_filter_state()}}
\item \href{#method-FilterPanelAPI-remove_filter_state}{\code{FilterPanelAPI$remove_filter_state()}}
\item \href{#method-FilterPanelAPI-clear_filter_states}{\code{FilterPanelAPI$clear_filter_states()}}
\item \href{#method-FilterPanelAPI-clone}{\code{FilterPanelAPI$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilterPanelAPI-new"></a>}}
\if{latex}{\out{\hypertarget{method-FilterPanelAPI-new}{}}}
\subsection{Method \code{new()}}{
Initialize a \code{FilterPanelAPI} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilterPanelAPI$new(datasets)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{datasets}}{(\code{FilteredData})}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilterPanelAPI-get_filter_state"></a>}}
\if{latex}{\out{\hypertarget{method-FilterPanelAPI-get_filter_state}{}}}
\subsection{Method \code{get_filter_state()}}{
Gets the reactive values from the active \code{FilterState} objects of the \code{FilteredData} object.

Gets all active filters in the form of a nested list.
The output list is a compatible input to \code{set_filter_state}.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilterPanelAPI$get_filter_state()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
\code{list} with named elements corresponding to \code{FilteredDataset} objects with active filters.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilterPanelAPI-set_filter_state"></a>}}
\if{latex}{\out{\hypertarget{method-FilterPanelAPI-set_filter_state}{}}}
\subsection{Method \code{set_filter_state()}}{
Sets active filter states.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilterPanelAPI$set_filter_state(filter)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{filter}}{(\code{teal_slices})}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{NULL}, invisibly.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilterPanelAPI-remove_filter_state"></a>}}
\if{latex}{\out{\hypertarget{method-FilterPanelAPI-remove_filter_state}{}}}
\subsection{Method \code{remove_filter_state()}}{
Remove one or more \code{FilterState} of a \code{FilteredDataset} in the \code{FilteredData} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilterPanelAPI$remove_filter_state(filter)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{filter}}{(\code{teal_slices})
specifying \code{FilterState} objects to remove;
\code{teal_slice}s may contain only \code{dataname} and \code{varname}, other elements are ignored}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{NULL}, invisibly.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilterPanelAPI-clear_filter_states"></a>}}
\if{latex}{\out{\hypertarget{method-FilterPanelAPI-clear_filter_states}{}}}
\subsection{Method \code{clear_filter_states()}}{
Remove all \code{FilterStates} of the \code{FilteredData} object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilterPanelAPI$clear_filter_states(datanames)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{datanames}}{(\code{character})
\code{datanames} to remove their \code{FilterStates};
omit to remove all \code{FilterStates} in the \code{FilteredData} object}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
\code{NULL}, invisibly.
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-FilterPanelAPI-clone"></a>}}
\if{latex}{\out{\hypertarget{method-FilterPanelAPI-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{FilterPanelAPI$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
