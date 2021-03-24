#!/usr/bin/Rscript

# http://ggplot2.tidyverse.org/reference/geom_point.html
plotBox <- function(data, measurement) {

  # Compare both - sepal and petal.
  measurement.length <- data[,1]
  measurement.width <- data[,3]


  # Create an empty array.
  xlabel <- c()
  ylabel <- c()
  ggtitle <- c()

  xlabel <- paste('Data', collapse = '')
  ylabel <- paste( 'Value', collapse = '')
  ggtitle <- paste("Boxplot")

  # Create a group-means data set
  # sum <- data %>%
  #         group_by(Species) %>%
          # summarise(measurement.length = mean(measurement.length),
          #           measurement.width  = mean(measurement.width))

  scatter <- ggplot(data = data, aes(y = measurement.length, x = measurement.width))
  scatter +

    geom_boxplot()+ 

    # Add another layer and increase the size of the group means:
    # geom_point(data = sum, size = 4, aes(shape = Species)) +

    # To set the symbols manually, we can use the symbol codes in
    # scale_shape_manual() added to your print function.
    scale_shape_manual(values = c(0, 16, 3)) +

    # Polish the plot labels and titles.
    xlab(xlabel) +
    ylab(ylabel) +
    ggtitle(ggtitle)
}



