#!/usr/bin/Rscript

# Load packages.
library(jsonlite)
library(ggplot2)
library(magrittr)
library(dplyr)
library(urltools)

# Import dependencies.
source('iris/plots.R')

# https://github.com/trestletech/plumber/issues/66
#* @filter cors
function(res) {
  res$setHeader('Access-Control-Allow-Origin', '*') # Or whatever
  plumber::forward()
}

# https://www.rplumber.io/docs/rendering-and-output.html#boxed-vs-unboxed-json
# https://www.rplumber.io/docs/rendering-and-output.html#response-object
#* Result:
#* {"status":200,"data":{"message":"Hello World"}}
#* @serializer unboxedJSON
#* @get /
function(){
  status <- 200
  message <- 'Hello World'

  list(
    status = 200,
    data = list(
      message = message
    )
  )
}

#* Plot out data from the iris dataset
#* @serializer contentType list(type='image/png')
#* @post /iris
function(req, res) {
  # dataset <- read.csv("/home/fan/Desktop/nuxt-plumber-master/iris.txt")
  title <- 'All Species'
  raw <- req$postBody
  str(raw, list.len=ncol(raw))
  # contents = list(formContents = Rook::Multipart$parse(req))
  # str(contents[[1]])
  # dataset <- read.csv("/tmp/RtmpHQOEmk/filea493597f431")
  # str(dataset)
  multipart <- mime::parse_multipart(req)
  # 
  # in_file <- multipart$datapath
  tryCatch({
  dataset <- read.csv(multipart$file$datapath)
},      error = function(e) {
  # return a safeError if a parsing error occurs
  return(res)
}
  )
  # Filter if the raw was specified.
  if (length(raw) == 0) {
    str('stop now!')
    message <- "Missing params."
    status <- 400 # Bad request

    output <- list(
      status = jsonlite::unbox(status),
      data = list(
        message = jsonlite::unbox(message)
      )
    )

    res$setHeader('Content-type', 'application/json')
    res$status <- status
    res$body <- toJSON(output)
    return(res)
  }

  # Parse the query.
  # https://cran.r-project.org/web/packages/urltools/vignettes/urltools.html
  params <- param_get(
    raw,
    parameter_names = c(
      "plot",
      'species',
      'measurement',
      'grid'
    )
  )
  plot <- "boxplot"
  species <- params$species
  measurement <- params$measurement
  grid <- params$grid

  tmp <- tempfile()
  png(tmp, width = 8, height = 8, units = 'in', res = 100)
  # Render box plot
  if (!is.na(plot) && plot == 'boxplot') {
    str('boxplot!')
    print(plotBox(dataset, measurement))
  }

  dev.off()
  readBin(tmp, "raw", n = file.info(tmp)$size)
}
