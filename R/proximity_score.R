# Inspired from the EMT package from Uwe Menzel
# Uwe Menzel (2013). EMT: Exact Multinomial Test: Goodness-of-Fit Test for Discrete
# Multivariate data. R package version 1.1. https://CRAN.R-project.org/package=EMT
# citation(EMT)

.findVectors <- function(groups, size) {
  if (groups == 1) {
    mat <- size
  }
  else {
    mat <- matrix(rep(0, groups - 1), nrow = 1)
    for (i in 1:size) {
      mat <- rbind(mat, .findVectors(groups - 1, i))
    }
    mat <- cbind(mat, size - rowSums(mat))
  }
  return(mat)
}

.multinomial.test <- function(clMatrix, groups, props) {
  size <- ncol(clMatrix)
  eventMat <- .findVectors(length(groups), size)
  eventProb <- apply(eventMat, 1, function(x) {
    dmultinom(x,  size = size, prob = props)
  })
  pvalues <- apply(clMatrix, 1, function(conds){
    real <- as.vector(table(factor(conds, levels = groups)))
    pObs <- dmultinom(real, size, props)
    p.value <- sum(eventProb[eventProb <= pObs])
    return(p.value)
  })
  res <- -stats::qnorm(unlist(pvalues) / 2)
  return(res)
}

#' @title Proximity score.
#'
#' @description Compute a proximity score to show whether nearby cells have the
#' same condition of not
#' 
#' @return A list with two components:
#' \itemize{
#'   \item \code{scores} is the raw score, a vector with one value per cell.
#'   \item \code{scaled_scores} is the score after local smoothing. A vector with one value per cell.
#' }
#' 
#' @details The score is computed in two steps. First, a score is computed for 
#' each cell. The distribution of labels among the \code{k}-nearest- neighbours 
#' is computed to the overall distribution for  all cells. This yields a p-value 
#' based on the multinomial distribution, which is squared to return the scores. 
#' 
#' Then, splines are used to smooth the scores along the reduced dimension space, 
#' with \code{smooth} nodes.  This yields the scaled_scores.
#' @param rd The reduced dimension matrix of the cells
#' @param cl the vector of conditions
#' @param k The number of neighbours to consider when computing the score.
#'  Default to 10.
#' @param smooth The smoothing parameter. Default to k. Lower values mean that
#' we smooth more.
#' @importFrom magrittr %>%
#' @import RANN purrr
#' @importFrom mgcv gam
#' @export
proximity_score <- function(rd, cl, k = 10, smooth = k) {
  # Code inspired from the monocle3 package
  # https://github.com/cole-trapnell-lab/monocle3/blob/9becd94f60930c2a9b51770e3818c194dd8201eb/R/cluster_cells.R#L194

  props <- as.vector(table(cl) / length(cl))
  groups <- unique(cl)
  if (length(groups) == 1) stop("cl should have at least 2 classes")

  # Get the graph
  # We need to add 1 because by default, nn2 counts each cell as its own
  # neighbour
  tmp <- RANN::nn2(rd, rd, k + 1, searchtype = "standard")
  neighborMatrix <- tmp[[1]]
  # Remove each cell from being it's own neighbour
  distMatrix <- tmp[[2]][, -1]
  distMatrix <- 1 / distMatrix
  distMatrix <- distMatrix / rowSums(distMatrix)
  clMatrix <- matrix(factor(cl)[neighborMatrix], ncol = k + 1)
  simMatrix <- clMatrix == clMatrix[, 1]
  # Remove each cell from being it's own neighbour
  simMatrix <- simMatrix[, -1]

  # Get the basic scores
  scores <- rowMeans(simMatrix)

  # Get the smoothed scores
  scaled_scores <- .multinomial.test(clMatrix, groups, props)
  scaled_scores <- unlist(scaled_scores)
  names(scaled_scores) <- rownames(rd)
  formula <- paste0("scaled_scores ~ s(",
                    paste0("rd[, ", seq_len(ncol(rd)), "], ", collapse = ""),
                    "k = smooth)")
  mm <- mgcv::gam(as.formula(formula))
  scaled_scores <- predict(mm, type = "response")

  return(list("scores" = scores, "scaled_scores" = scaled_scores))
}
