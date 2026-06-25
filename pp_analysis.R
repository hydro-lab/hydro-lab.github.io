# Load required libraries for data handling and plotting
library(readr)     # for reading CSV/text files
library(dplyr)     # for data manipulation (filter, mutate, etc.)
library(tidyr)     # for reshaping data
library(ggplot2)   # for creating plots

fn <- read_csv("pp_spectra.csv") # should be organized with filename, sample name
fn <- read_csv("pp_filtered_spectra.csv")

exct <- 270
emit <- 324

sa <- array(NA, dim = nrow(fn))
pp <- array(NA, dim = nrow(fn))

for (i in 1:nrow(fn)) {
  #print(paste0("Processing: ", fn$sample[i]))
  
  x <- read_csv(fn$filename[i], skip = 38) # reads spectra file in one-by-one with name
  
  x <- x %>%                  # rearranges spectral data
    rename(EM = `EM Wavelength/EX Wavelength`) %>%
    pivot_longer(!EM, names_to = 'EX_raw', values_to                                       = 'Intensity') %>% # Convert wide-format data into long format: All columns except EM become rows (EX_raw = excitation wavelength)
    mutate(EX = as.numeric(EX_raw)) %>% # Convert EX values from text to numeric
    select(EM, EX, Intensity) %>%
    filter(is.na(Intensity) == FALSE) %>% # Remove rows where intensity is missing
    filter(EX >= 250) %>%
    filter(EX <= 400) %>%
    filter(EM >= 300) %>%
    filter(EM <= 450)
  
  upper <- 1e3  # 5000 # Set an upper limit for the color scale in the plot
  
  gg <- ggplot(x) +
    geom_tile(aes(x = EX, y = EM, fill = Intensity)) +
    scale_fill_viridis_c(
      limits = c(0, upper),              # restrict color range
      oob = scales::squish,              # values above limit get "squished" to max color
      breaks = c(0, upper),              # only show min/max labels
      labels = c("Low", "High"),         # label them as Low/High
      name = "Intensity",                # legend title
      guide = guide_colorbar(
        barheight = unit(5, "cm"),    # height of colorbar
        barwidth = unit(0.5, "cm"),   # width of colorbar
        title.position = "bottom"     # place title below colorbar
      )
    ) +
    geom_vline(xintercept = exct) + # this is where we are looking for pp intensity
    geom_hline(yintercept = emit) +
    labs(x = "Excitation (nm)", y = "Emission (nm)") +
    ggtitle(fn$sample[i]) +
    
    theme(panel.background = element_rect(fill = "white", colour = "black")) +
    theme(aspect.ratio = 1) +
    theme(plot.title = element_text(face = "bold", size = 16)) +
    theme(axis.text = element_text(face = "plain", size = 14)) +
    theme(axis.title = element_text(face = "plain", size = 14)) +
    theme(legend.title = element_text(face = "plain", size = 14)) +
    theme(legend.text = element_text(face = "plain", size = 14))
  
  ggsave(paste0(fn$sample[i], ".png"), gg, device = "png")
  #print("Figure created")
  
  y <- x %>%
    filter(EX==exct) %>%
    filter(EM==emit)
  
  sa[i] <- fn$sample[i]
  pp[i] <- y$Intensity[1]
  
}

sv <- c(1, 1/2, 1/4, 1/8, 1/16, 1/32)
pp_intensity <- data.frame(sa, sv, pp)
ggplot(pp_intensity, aes(x = sv, y = pp)) +
  geom_line() +
  geom_point()








