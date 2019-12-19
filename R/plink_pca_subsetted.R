library(tidyverse)
library(gglabeller)
library(ggrepel)
library(ggpubr)

# Import eigen vectors and values from plink
eigenvecs <- read.table("data/plink_pca/all_nprcs_wgs_subsetted_pca.eigenvec")
eigenvals <- read.table("data/plink_pca/all_nprcs_wgs_subsetted_pca.eigenval")

# Import metadata
metadata <- read.table("data/metadata/all_nprcs_wgs_subsetted.csv", sep = ",", header = TRUE)
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

# Plot the eigenvectors
p_c_g <- ggplot(data = eigenvecs, aes(x = V3, y = V4, color = center, shape = gender)) + geom_point() +
  geom_hline(yintercept = 0, lty = 2) + geom_vline(xintercept = 0, lty = 2) + geom_point(alpha = 0.8, size = 3) +
  xlab("PC 1 (4.5%)") + ylab("PC 2 (3.6%)") + theme_minimal() + theme(
    panel.grid = element_blank(), panel.border = element_rect(fill = "transparent")
  ) + guides(fill = guide_legend(title = "Legend Title", override.aes = aes(label = "")))

# Use gglabeller to interactively label points
pcg_gglab <- gglabeller(p_c_g, aes(label = rownames(eigenvecs)))

# Add shaded polygons around projected clusters
p_c_g_e <- pcg_gglab$plot + stat_ellipse(
  geom = "polygon", aes(fill = center),

  alpha = 0.2,

  show.legend = FALSE,

  level = 0.95
)

# Create a final plot of the 2 plots
final_plot <- ggarrange(p_c_g_e, pcg_gglab$plot, ncol = 2, nrow = 1, widths = c(2, 2))
final_plot_annotated <- annotate_figure(final_plot, 
                                        top = text_grob("Plink Principal Components Analysis",
                                                        size = 14))

ggsave("data/plink_pca/plink_pca_subsetted.png", plot = final_plot_annotated, dpi = 450, width = 16, height = 9)
