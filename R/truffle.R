library(gplots)
library(RColorBrewer)
library(cluster)
library(truffle)

wgs_mt <- truffle::import_truffle(path = "data/truffle_runs/all_nprcs_rminfo_autosomal_wgs_biallelic_mt.ibd")
wgs_both <- truffle::import_truffle(path = "data/truffle_runs/all_nprcs_rminfo_autosomal_wgs_biallelic_mt.ibd")
                                
snpgdsTRUFFLE2GDS <- function() {

}


#wgs_mt_matrix <- makeClusterMatrix(data = wgs_mt, values = )
#wgs_both_matrix <- makeClusterMatrix(data = wgs_both, values = )
