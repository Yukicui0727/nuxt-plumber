#!/usr/bin/Rscript

library(plumber)
r <- plumb('/home/fan/Desktop/nuxt-plumber-master/server/app.R')  # Where 'app.R' is the location of the file shown above
r$run(port = 8000)



