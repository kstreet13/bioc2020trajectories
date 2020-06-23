#' @title Download and import the raw dataset.
#'
#' @description Download the dataset from GEO, filter, and create a
#' \code{SingleCellExperiment object}
#'
#' @export
importRawData <- function(){
  require(BiocFileCache)
  require(SingleCellExperiment)
  require(rappdirs)
  url <- "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE114687&format=file&file=GSE114687%5Fpseudospace%5Fcds%2Erds%2Egz"
  path <- paste0(rappdirs::user_cache_dir(), basename(url))
  bfc <- BiocFileCache::BiocFileCache(path, ask = FALSE)
  addCds <- bfcadd(bfc, "cds", fpath = url)
  con <- gzcon(gzfile(addCds))
  cds <- readRDS(con)

  # Extract useful info from the cellDataSet object
  counts <- cds@assayData$exprs
  phenoData <- pData(cds@phenoData)
  rd <- SimpleList(
    tSNEorig = cbind(cds@phenoData@data$TSNE.1, cds@phenoData@data$TSNE.2)
  )
  rm(cds) ; gc(verbose = FALSE)
  filt <- apply(counts, 1, function(x){
    sum(x >= 2) >= 15
  })
  counts <- counts[filt, ]
  sce <- SingleCellExperiment::SingleCellExperiment(assays=list(counts=counts),
                              colData = phenoData,
                              reducedDims = rd)
  return(sce)
}
