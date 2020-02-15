library(gplots)
library(RColorBrewer)
library(cluster)
library(truffle)

wgs_mt <- truffle::import_truffle(path = "data/truffle_runs/all_nprcs_rminfo_autosomal_wgs_biallelic_mt.ibd")
wgs_both <- truffle::import_truffle(path = "data/truffle_runs/all_nprcs_rminfo_autosomal_wgs_biallelic_mt.ibd")
                                
snpgdsTRUFFLE2GDS <- function() {

}

makeClusterMatrix <- function(data, values, diagonal = 0) {
    
    data$ID1 = as.character(data$ID1)
    data$ID2 = as.character(data$ID2)
    
    n = unique(c(data$ID1,data$ID2))
    m = matrix(1,nrow=length(n),ncol=length(n))
    
    colnames(m) = n
    rownames(m) = n
    
    m[cbind(data$ID1,data$ID2)] = values
    m[cbind(data$ID2,data$ID1)] = values
    
    m[cbind(n,n)] = diagonal
    
    return(m)
}

wgs_mt_matrix <- makeClusterMatrix(data = wgs_mt, values = )
wgs_both_matrix <- makeClusterMatrix(data = wgs_both, values = )
