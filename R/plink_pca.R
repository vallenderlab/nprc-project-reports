# This analysis script uses data generated from vcf file while running plink.
#
library(tidyverse)
library(gglabeller)
library(ggrepel)
library(ggpubr)

# Import eigen vectors and values from plink
eigenvecs <- read.table("data/plink_pca/all_auto_wgs_all_biallelic_maf05.eigenvec")
eigenvals <- read.table("data/plink_pca/all_auto_wgs_all_biallelic_maf05.eigenval")

# Import metadata
metadata <- read.table("data/metadata/all_nprcs_wgs.csv", sep = ",", header = TRUE)
metadata <- metadata[order(metadata$mgap_id), ]

# Add ids as rownames
eigenvecs <- eigenvecs %>%
  remove_rownames() %>%
  column_to_rownames(var = "V1") %>%
  select(-one_of("V2"))

eigenvecs <- eigenvecs[order(row.names(eigenvecs)), ]
mutate_all(eigenvecs, funs(na_if(., "")))

# Add center, origin, and gender to eigenvecs matrix columns
eigenvecs$center <- metadata$primate_center
eigenvecs$gender <- metadata$gender
eigenvecs$geographic_origin <- metadata$geographic_origin
eigenvecs$total_reads <- metadata$total_reads


p_go <- ggplot(data = eigenvecs, aes(x = V3, y = V4, color = geographic_origin)) + geom_point() +
  geom_hline(yintercept = 0, lty = 2) + geom_vline(xintercept = 0, lty = 2) + geom_point(alpha = 0.8, size = 3) +
  xlab("PC 1 (12.7%)") + ylab("PC 2 (5.82%)") + theme_minimal() + theme(
    panel.grid = element_blank(), panel.border = element_rect(fill = "transparent")
  ) + guides(fill = guide_legend(title = "Legend Title", override.aes = aes(label = "")))

pgo_gglab <- gglabeller(p_go, aes(label = rownames(eigenvecs)))

p_go_c <- ggplot(data = eigenvecs, aes(x = V3, y = V4, color = center, shape = geographic_origin)) + geom_point() +
  geom_hline(yintercept = 0, lty = 2) + geom_vline(xintercept = 0, lty = 2) + geom_point(alpha = 0.8, size = 3) +
  xlab("PC 1 (12.7%)") + ylab("PC 2 (5.82%)") + theme_minimal() + theme(
    panel.grid = element_blank(), panel.border = element_rect(fill = "transparent")
  ) + guides(fill = guide_legend(title = "Legend Title", override.aes = aes(label = "")))

pgoc_gglab <- gglabeller(p_go_c, aes(label = rownames(eigenvecs)))

p_c_g <- ggplot(data = eigenvecs, aes(x = V3, y = V4, color = center, shape = gender)) + geom_point() +
  geom_hline(yintercept = 0, lty = 2) + geom_vline(xintercept = 0, lty = 2) + geom_point(alpha = 0.8, size = 3) +
  xlab("PC 1 (12.7%)") + ylab("PC 2 (5.82%)") + theme_minimal() + theme(
    panel.grid = element_blank(), panel.border = element_rect(fill = "transparent")
  ) + guides(fill = guide_legend(title = "Legend Title", override.aes = aes(label = "")))

pcg_gglab <- gglabeller(p_c_g, aes(label = rownames(eigenvecs)))

p_go_c_e <- pgoc_gglab$plot + stat_ellipse(
  geom = "polygon", aes(fill = geographic_origin),

  alpha = 0.2,

  show.legend = FALSE,

  level = 0.95
)

final_plot <- ggarrange(pgoc_gglab$plot, pcg_gglab$plot, ncol = 2, nrow = 1, widths = c(1.25, 1.1))
final_plot_annotated <- annotate_figure(final_plot, 
                                        top = text_grob("Plink Principal Components Analysis",
                                                        size = 14))

ggsave("data/plink_pca/plink_pca_all_auto_wgs_all_biallelic_maf05_ellipses.png", plot = final_plot_annotated, dpi = 450, width = 16, height = 9)
