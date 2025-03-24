library(VariantTools)
library(LungCancerLines)
bams <- LungCancerLines::LungCancerBamFiles()
bam <- bams$H1993

if (requireNamespace("gmapR", quietly=TRUE)) {
p53 <- gmapR:::exonsOnTP53Genome("TP53")
tally.param <- TallyVariantsParam(gmapR::TP53Genome(),
high_base_quality = 23L,
which = range(p53) + 5e4,
indels = TRUE, read_length = 75L)
called.variants <- callVariants(bam, tally.param)
} 

else {
data(vignette)
called.variants <- callVariants(tallies_H1993)

#post filter the variants that are too closely clustered on the genome
 pf.variants <- postFilterVariants(called.variants)

#subset the variants by those in an actual p53 exon (not an intron)
subsetByOverlaps(called.variants, p53, ignore.strand = TRUE)