# Find percentiles and z-scores

# install.packages("anthro") # WHO Standards
# install.packages("childsds") # Package with lots of standards
library(anthro)
library(childsds)

# Date of birth
dob <- as.Date("2020/11/24", "%Y/%m/%d", origin = "1970/01/01") # All dates in year/month/day

# length and weight data
date <- as.Date(c("2021/01/29"), "%Y/%m/%d", origin = "1970/01/01")
wght <- c(4.90)
hght <- c(61)

# computations
age <- as.numeric(date - dob)
z <- anthro::anthro_zscores(1,age,FALSE,wght,hght,"L") # first term: 1 male, 2 female
# check zwei and zlen