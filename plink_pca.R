library(tidyverse)

# Import eigen vectors and values from plink
eigenvecs <- read.table("plink_pca/all_nprcs_no_exome_pca.eigenvec")
eigenvals <- read.table("plink_pca/all_nprcs_no_exome_pca.eigenval")

# Import metadata
#metadata <- read.table("metadata/all_nprcs_wgs.csv", sep = ",", header = TRUE)

# Add ids as rownames
eigenvecs <- eigenvecs %>%
  remove_rownames() %>%
  column_to_rownames(var = "V1") %>%
  select(-one_of("V2"))

# Add center, origin, and gender to eigenvecs matrix columns
ids <- sort(rownames(eigenvecs))

eigenscale <- scale(eigenvecs)

p <- ggplot(data = eigenvecs, aes(x = eigenvecs$V3, y = eigenvecs$V4)) + geom_point() +
  geom_hline(yintercept = 0, lty = 2) + geom_vline(xintercept = 0, lty = 2) + geom_point(alpha = 0.8) +
  xlab("PC 1 (22.4%)") + ylab("PC 2 (7.24%)") + theme_minimal() + theme(
    panel.grid = element_blank(), panel.border = element_rect(fill = "transparent")
  )
print(p)
