#' Exports a table (CSV) or ggplot to file.
#'
#' @param data Een data.frame/matrix (voor type="table") of een ggplot-object (voor type="plot").
#' @param filename Bestandsnaam inclusief extensie (bv. "output.csv" of "figure.png").
#' @param path (optioneel) Directory-pad om het bestand in op te slaan (default current dir).
#' @param type `"table"` of `"plot"`. Bepaalt of er een CSV wordt weggeschreven of een plot file (ggplot2).
#' @details De functie maakt de directory aan indien die nog niet bestaat. Bij type="table" wordt `write.csv` gebruikt. Bij type="plot" wordt `ggsave` gebruikt.
#' @export
exportResults <- function(data, filename, path=".", type=c("table","plot")) {
  type <- match.arg(type)
  if (!dir.exists(path)) dir.create(path, recursive=TRUE)
  fullfile <- file.path(path, filename)
  if (type == "table") {
    if (!(is.data.frame(data) || is.matrix(data))) stop("Data moet een
data.frame of matrix zijn.")
    utils::write.csv(data, file=fullfile, row.names=TRUE)
  } else if (type == "plot") {
    if (!inherits(data, "ggplot")) stop("for plot-export the data needs to be a ggplot-object")
    ggplot2::ggsave(fullfile, plot=data)
  }
  message("Result has been saved to: ", fullfile)
}