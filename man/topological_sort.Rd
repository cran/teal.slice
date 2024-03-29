% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FilteredData-utils.R
\name{topological_sort}
\alias{topological_sort}
\title{Topological graph sort}
\usage{
topological_sort(graph)
}
\arguments{
\item{graph}{(\verb{named list}) with node vector elements}
}
\description{
Graph is a \code{list} which for each node contains a vector of child nodes
in the returned list, parents appear before their children.
}
\details{
Implementation of \code{Kahn} algorithm with a modification to maintain the order of input elements.
}
\keyword{internal}
