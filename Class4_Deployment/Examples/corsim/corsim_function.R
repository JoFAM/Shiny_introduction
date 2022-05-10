#' Function to create a specific correlation between two variables
#' 
#' This function is based on the principle that the correlation between
#' two vectors with mean 0 is equal to the cosine of the angle between them.
#' It allows you to define (up to a point) the distribution of the residuals
#' of y on x
#' 
#' @param x a fixed vector
#' @param y a vector to be rotated as to get the correct correlation
#' @param rho the required correlation
#' 
#' @return a rotated vector \code{y} with the required correlation
#' 
corsim <- function(x,y,rho){
  n     <- length(x)
  if(length(y) != n) stop("Lengths x and y should match")
  # calculate the corresponding angle for a correlation of rho
  theta <- acos(rho)             # corresponding angle
  
  # means and sds
  meanx <- mean(x)
  meany <- mean(y)
  X     <- cbind((x - meanx), 
                 (y - meany))         # matrix

  Id   <- diag(n)                               # identity matrix
  Q    <- qr.Q(qr(X[ , 1]))      # QR-decomposition, just matrix Q
  P    <- tcrossprod(Q)          # = Q Q'       # projection onto space defined by x1
  y_orthogonal  <- (Id-P) %*% X[ ,2]                 
  xy_orth <- cbind(X[,1], y_orthogonal)                # bind to matrix
  
  rescale <- sqrt(colSums(xy_orth^2))
  # colsums to rescale
  Y    <- xy_orth /rep(rescale, each = n)  # scale columns to length 1
  
  out <- Y[ , 2] + (1 / tan(theta)) * Y[ , 1]     # final new vector
  out*rescale[2] + meany
}
