library(devtools)
install_github("LimpopoLab/hydrostats")
library(hydrostats)
library(ggplot2)
library(latex2exp)

t <- c(-5:20)
r <- waterrho(t)
plot(t,r)
water <- data.frame(t,r)
ggplot(water) +
     geom_line(aes(x=t,y=r)) +
     xlab(TeX(r'(Temperature $(^o C)$)')) +
     ylab(TeX(r'(Density $(\frac{kg}{m^3})$)')) +
     theme(panel.background = element_rect(fill = "white", colour = "black")) +
     theme(aspect.ratio = 1) +
     theme(axis.text = element_text(face = "plain", size = 12))
