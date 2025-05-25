#' Reads BAM files and counts reads per gene.
#'
#' @param bam_files Vector with paths to one or more BAM-files.
#' @param txdb A TxDb-object (GenomicFeatures) with GeneAnnotation.
#' @param ignore_strand Logic; `TRUE` counts independently of strand (default).
#' @param single_end Logisch; `TRUE` for single read (default).
#' @param mode Overlap-modus voor summarizeOverlaps (bijv. "Union", default).
#' @return Een RangedSummarizedExperiment met telmatrix (assay counts per gen × sample).
#' @details Deze functie gebruikt GenomicAlignments::summarizeOverlaps() om reads over exonen (per gen) op te tellen .
#' Groot voordeel is dat het grote bestanden in een SummarizedExperiment kan verwerken.
#' @export
countReads <- function(bam_files, txdb, ignore_strand=TRUE, single_end=TRUE,
                       mode="Union") {

  # Build genfeatures: exons grouped by gene
  exons_grl <- GenomicFeatures::exonsBy(txdb, by="gene")
  
  # count reads per gene
  se <- GenomicAlignments::summarizeOverlaps(
    features = exons_grl,
    reads = bam_files,
    mode = mode,
    singleEnd = single_end,
    ignore.strand = ignore_strand
  )
  return(se)
}

