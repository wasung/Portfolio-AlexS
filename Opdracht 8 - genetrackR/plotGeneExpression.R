#' Visualizes gene expression as barplots.
#'
#' @param expr_data Genexpressie data (matrix/data.frame of SummarizedExperiment) met genen in rijen en samples in kolommen.
#' @param geneID Karakter; de gennaam (of -ID) om de expressie over alle samples te tonen.
#' @param sampleID Karakter; de sample-naam om de expressie van alle genen in dat sample te tonen.
#' @param normalized Logisch; `TRUE` voor genormaliseerde data, `FALSE` voor ruwe counts.
#' @details Geeft een barplot terug. Indien `geneID` is opgegeven, plott de expressie van dat gen over de kolommen (samples).
#' Indien `sampleID` is opgegeven, toont het de top 20 meest expressieve genen in dat sample.
#' Indien beide opgegeven zijn of geen, wordt een foutmelding
gegenereerd.
#' @return Een ggplot-object (invisible) van het gemaakte diagram.
#' @export
plotGeneExpression <- function(expr_data, geneID=NULL, sampleID=NULL,
                               normalized=TRUE) {
  # Haal matrix uit SummarizedExperiment indien nodig
  if (inherits(expr_data, "SummarizedExperiment")) {
    expr_data <- SummarizedExperiment::assay(expr_data, ifelse(normalized,
                                                               "TPM", "counts"))
  }
  expr_mat <- as.matrix(expr_data)
  if (!is.null(geneID) && is.null(sampleID)) {
    if (!(geneID %in% rownames(expr_mat))) stop("geneID niet gevonden in
dataset.")
    values <- expr_mat[geneID, ]
    df <- data.frame(Sample=colnames(expr_mat),
                     Expression=as.numeric(values))
    p <- ggplot2::ggplot(df, ggplot2::aes(x=Sample, y=Expression)) +
      ggplot2::geom_bar(stat="identity") +
      ggplot2::labs(title=paste("Expressie van gen", geneID),
                    y="Expressiewaarde")
    print(p)
    return(invisible(p))
  }
  if (!is.null(sampleID) && is.null(geneID)) {if (!(sampleID %in% colnames(expr_mat))) stop("sampleID niet gevonden in
dataset.")
    values <- expr_mat[, sampleID]
    # Selecteer top 20 genen
    topn <- head(sort(values, decreasing=TRUE), 20)
    df <- data.frame(Gene=factor(names(topn), levels=names(topn)),
                     Expression=as.numeric(topn))
    p <- ggplot2::ggplot(df, ggplot2::aes(x=Gene, y=Expression)) +
      ggplot2::geom_bar(stat="identity") +
      ggplot2::coord_flip() +
      ggplot2::labs(title=paste("Top genexpressie in sample", sampleID),
                    y="Expressiewaarde")
    print(p)
    return(invisible(p))
  }
  stop("Geef óf geneID óf sampleID op, niet beide of geen.")
}