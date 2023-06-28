## -----------------------------------------------------------------------------
##
##' [PROJ: ttalVlatt.github.io]
##' [FILE: Spatial Analysis Graphs]
##' [INIT: 2023-06-27]
##' [AUTH: Matt Capaldi] @ttalVlatt
##
## -----------------------------------------------------------------------------

## ---------------------------
##' [Libraries]
## ---------------------------

library(tidyverse)
library(sf)
library(sfdep)
library(patchwork)
library(spgwr)
library(gstat)

## ---------------------------
##' [Data Input]
## ---------------------------

schools <- read_sf(file.path("data-viz-examples",
                             "chicago-public-schools",
                             "chicago-public-schools.shp"))

boundary <- read_sf(file.path("data-viz-examples",
                              "chicago-district-boundary",
                              "chicago-district-boundary.shp"))

## ---------------------------
##' [Create Base Map & Palette]
## ---------------------------

base_map <- ggplot() +
  geom_sf(data = boundary,
          aes(),
          size = .1,
          alpha = .5) +
  theme_void()

# base_point_map <- base_map +
#   geom_sf(data = schools,
#           aes(),
#           size = 1,
#           alpha = .5)

matts_palette <- c("white", "pink2", "skyblue2", "red4", "blue4")

## ---------------------------
##' [Create Neighbors & Spatial Weights Matrix]
## ---------------------------

neighbors <- st_dist_band(schools,
                          upper = 2554) # From https://doi.org/10.1016/j.jpubeco.2004.05.001

weights <- st_weights(neighbors,
                      style = "W") # Row Standardized

## ---------------------------
##' [LocalHotSpot: Local Getis Ord G*]
## ---------------------------

##' [Free/Reduced Lunch]
l_hot_lunch <- local_gstar_perm(x = schools$lunch,
                                nb = neighbors,
                                wt = weights,
                                nsim = 999) %>%
  mutate(sig_hot_spots = case_when(
    gi_star > 0 & p_value < 0.01 ~ "Hot-Spot 99%",
    gi_star > 0 & p_value < 0.05 ~ "Hot-Spot 95%",
    gi_star > 0 & p_value < 0.1 ~ "Hot-Spot 90%",
    gi_star < 0 & p_value < 0.01 ~ "Cold-Spot 99%",
    gi_star < 0 & p_value < 0.05 ~ "Cold-Spot 95%",
    gi_star < 0 & p_value < 0.1 ~ "Cold-Spot 90%",
    p_value >= 0.1 ~ "Not Significant") %>%
      as_factor() %>%
      fct_relevel("Cold-Spot 99%", "Cold-Spot 95%",
                  "Cold-Spot 90%", "Not Significant",
                  "Hot-Spot 90%", "Hot-Spot 95%",
                  "Hot-Spot 99%"))

schools$hot_lun <- l_hot_lunch$sig_hot_spots

map_hot_lunch <- base_map +
  geom_sf(data = schools,
          aes(fill = hot_lun,
              size = hot_lun),
          shape = 21,
          color = "black",
          alpha = .8) +
  scale_fill_brewer(palette = "RdBu", direction = -1) +
  scale_size_manual(values = c(3,3,3,1,3,3,3)) +
  labs(title = "Free/Reduced Lunch",
       fill = "G* Hot-Spot",
       size = "G* Hot-Spot")


##'[Math Achievement]
l_hot_math <- local_gstar_perm(x = schools$math,
                               nb = neighbors,
                               wt = weights,
                               nsim = 999) %>%
  mutate(sig_hot_spots = case_when(
    gi_star > 0 & p_value < 0.01 ~ "Hot-Spot 99%",
    gi_star > 0 & p_value < 0.05 ~ "Hot-Spot 95%",
    gi_star > 0 & p_value < 0.1 ~ "Hot-Spot 90%",
    gi_star < 0 & p_value < 0.01 ~ "Cold-Spot 99%",
    gi_star < 0 & p_value < 0.05 ~ "Cold-Spot 95%",
    gi_star < 0 & p_value < 0.1 ~ "Cold-Spot 90%",
    p_value >= 0.1 ~ "Not Significant") %>%
      as_factor() %>%
      fct_relevel("Cold-Spot 99%", "Cold-Spot 95%",
                  "Cold-Spot 90%", "Not Significant",
                  "Hot-Spot 90%", "Hot-Spot 95%",
                  "Hot-Spot 99%"))

schools$hot_mat <- l_hot_math$sig_hot_spots

map_hot_math <- base_map +
  geom_sf(data = schools,
          aes(fill = hot_mat,
              size = hot_mat),
          shape = 21,
          color = "black",
          alpha = .8) +
  scale_fill_brewer(palette = "RdBu", direction = -1) +
  scale_size_manual(values = c(3,3,3,1,3,3,3)) +
  labs(title = "Math Achievement",
       fill = "G* Hot-Spot",
       size = "G* Hot-Spot")

## ---------------------------
##' [SpatialOutliers: Local Moran's I]
## ---------------------------

##' [Free/Reduced Lunch]
l_moran_lunch <- local_moran(x = schools$lunch,
                             nb = neighbors,
                             wt = weights,
                             nsim = 999) %>%
  mutate(chr_mean = as.character(case_when(mean == "High-High" ~ "High-High Cluster",
                                           mean == "Low-Low" ~ "Low-Low Cluster",
                                           mean == "High-Low" ~ "High-Low Outlier",
                                           mean == "Low-High" ~ "Low-High Outlier")),
         sig_mean_cluster = ifelse(p_ii < 0.1, chr_mean, "Not Significant") %>%
           as_factor() %>%
           fct_relevel("Not Significant", "High-High Cluster", "Low-Low Cluster",
                       "High-Low Outlier", "Low-High Outlier"))

schools$lm_lun <- l_moran_lunch$sig_mean_cluster

map_lm_lunch <- base_map +
  geom_sf(data = schools,
          aes(fill = lm_lun,
              size = lm_lun),
          shape = 21,
          color = "black",
          alpha = .8) +
  scale_fill_manual(values = matts_palette) +
  scale_size_manual(values = c(1,3,3,3,3)) +
  labs(title = "Free/Reduced Lunch",
       fill = "Local Moran's I Result",
       size = "Local Moran's I Result")

##'[Math Achievement]
l_moran_math <- local_moran(x = schools$math,
                            nb = neighbors,
                            wt = weights,
                            nsim = 999) %>%
  mutate(chr_mean = as.character(case_when(mean == "High-High" ~ "High-High Cluster",
                                           mean == "Low-Low" ~ "Low-Low Cluster",
                                           mean == "High-Low" ~ "High-Low Outlier",
                                           mean == "Low-High" ~ "Low-High Outlier")),
         sig_mean_cluster = ifelse(p_ii < 0.1, chr_mean, "Not Significant") %>%
           as_factor() %>%
           fct_relevel("Not Significant", "High-High Cluster", "Low-Low Cluster",
                       "High-Low Outlier", "Low-High Outlier"))

schools$lm_mat <- l_moran_math$sig_mean_cluster

map_lm_math <- base_map +
  geom_sf(data = schools,
          aes(fill = lm_mat,
              size = lm_mat),
          shape = 21,
          color = "black",
          alpha = .8) +
  scale_fill_manual(values = matts_palette) +
  scale_size_manual(values = c(1,3,3,3,3)) +
  labs(title = "Math Achievement",
       fill = "Local Moran's I Result",
       size = "Local Moran's I Result")

## ---------------------------
##' [GWR: Geographically Weighted Regression]
## ---------------------------

## https://rstudio-pubs-static.s3.amazonaws.com/44975_0342ec49f925426fa16ebcdc28210118.html

##' [Calculate Best Kernal Bandwidth (regions for local consideration)]
kernal_band <- gwr.sel(formula = math ~ lunch + as.factor(chart),
                       data = schools,
                       coords = st_coordinates(schools),
                       gweight = gwr.Gauss,
                       #gweight = gwr.bisquare,
                       adapt = T,
                       show.error.messages = T)

##' [Run GWR model]
reg_gwr <- gwr(formula = math ~ lunch + as.factor(chart),
               data = schools,
               coords = st_coordinates(schools),
               adapt = kernal_band,
               hatmatrix = T,
               se.fit = T)

gwr_results <- as_tibble(reg_gwr$SDF)

##' [Map Local Coefficients]
schools$local_coef_lunch <- gwr_results$lunch
schools$local_coef_chart <- gwr_results$as.factor.chart.Yes

map_gwr_lunch <- base_map +
  geom_sf(data = schools,
          aes(fill = local_coef_lunch),
          shape = 21,
          color = "black",
          size = 2,
          alpha = .8) +
  scale_fill_viridis_c(option = "magma") +
  labs(title = "Local β for Free/Reduced School Lunch",
       fill = "Local β Coefficient")

map_gwr_chart <- base_map +
  geom_sf(data = schools,
          aes(fill = local_coef_chart),
          shape = 21,
          color = "black",
          size = 2,
          alpha = .8) +
  scale_fill_viridis_c(option = "magma") +
  labs(title = "Local β for Charter School Status",
       fill = "Local β Coefficient")

## ---------------------------
##' [Interpolation: Predict Hypothetical Values]
## ---------------------------

# ## Create variogram point estimates over distance
# var_gram <- variogram(math ~ 1,
#                       data = schools)
# 
# ## Fit exponential curve to var_gram
# var_gram_fit <- fit.variogram(var_gram,
#                               model = vgm("Exp"))
# 
# grid_for_interpol <- st_make_grid(boundary,
#                                   cellsize = 500) %>%
#   #what = "centers") %>%
#   st_as_sf()
# 
# grid_for_interpol <- st_filter(grid_for_interpol,
#                                boundary,
#                                .predicate = st_intersects)
# 
# schools_krig <- st_difference(schools)
# 
# ord_krig <- krige(math ~ 1,
#                   schools_krig,
#                   grid_for_interpol,
#                   var_gram_fit)
# 
# map_ord_krig <- ggplot() +
#   geom_sf(data = ord_krig,
#           aes(fill = var1.pred,
#               color = var1.pred)) +
#   labs(title = "Interpolation of Math Achievement Rate Using Ordinary Kriging",
#        fill = str_wrap("Interpolated Math Achievement for Hypothetical School Located Here", 20),
#        color = str_wrap("Interpolated Math Achievement for Hypothetical School Located Here", 20)) +
#   scale_fill_viridis_c(option = "magma") +
#   scale_color_viridis_c(option = "magma") +
#   theme_void()


## -----------------------------------------------------------------------------
##' *END SCRIPT*
## -----------------------------------------------------------------------------