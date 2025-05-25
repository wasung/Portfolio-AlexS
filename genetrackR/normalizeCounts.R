#' Normalizes a count matrix via CPM of TPM.
#'
#' @param counts Ruwe telmatrix (matrix/data.frame) of SummarizedExperiment met assay `counts`.
#' @param txdb (optioneel) TxDb-object voor genannotatie; nodig voor TPMberekening.
#' @param method Normalisatiemethode: `"CPM"` (Counts Per Million) of `"TPM"` (Transcripts Per Million).
#' @return Matrix met genexpressiewaarden na normalisatie (zelfde dimensies als input).
#' @details *CPM*: deelt alle tellingswaarden in elke kolom door de kolomsom en vermenigvuldigt met 1e6.
#' *TPM*: deelt eerst counts per gen door de genlengte (in kilobasen) en schaalt dan per miljoen .
#' Bij TPM is het belangrijk om een TxDb te geven; de genlengtes worden berekend uit de totale exonlengte per gen.
#' @export
normalizeCounts <- function(counts, txdb=NULL, method=c("CPM","TPM")) {
  method <- match.arg(method)
  
  # Haal matrix uit SummarizedExperiment indien nodig
  if (inherits(counts, "SummarizedExperiment")) {
    counts <- SummarizedExperiment::assay(counts, "counts")
  }
  counts_mat <- as.matrix(counts)
  if (method == "CPM") {
    libSizes <- colSums(counts_mat)
    # Vermijd deling door 0
    if (any(libSizes == 0)) stop("Een van de samples heeft 0 reads.")
    cpm <- t(t(counts_mat) / libSizes) * 1e6
    return(cpm)
  }
  else if (method == "TPM") {
    if (is.null(txdb)) stop("Een TxDb-object is vereist voor TPMnormalisatie.")
    
    # Bereken genlengte (sum van exonlengtes per gen)
    exons_list <- GenomicFeatures::exonsBy(txdb, by="gene")
    exons_reduced <- lapply(exons_list, GenomicRanges::reduce)
    gene_length <- sapply(exons_reduced, function(x)
      sum(GenomicRanges::width(x)))
    genes <- rownames(counts_mat)
    if (!all(genes %in% names(gene_length))) stop("Niet alle genen in
countmatrix zitten in de annotatie.")
    lengths_kb <- gene_length[genes] / 1000 # conversion to kb
    
    # RPK (reads per kilobase)
    RPK <- counts_mat / lengths_kb
    
    # Sum van RPK per sample
    per_million <- colSums(RPK) / 1e6
    
    # Deel RPK door per_million om TPM te krijgen
    tpm <- t( t(RPK) / per_million )
    return(tpm)
  }
}    