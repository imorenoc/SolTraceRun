#!/usr/bin/env Rscript
##--------------------------------------------------
## Lectura del file.dat
##--------------------------------------------------
rm(list=ls())
ppf <- read.table("data.dat", nrows = 1) ## potencia por foton (ppf)
ppf <- as.numeric(ppf)
data <- read.table("data.dat", header = TRUE, sep = ",", skip = 1)

st <- 2 # stage
el <- 1 # element

library(dplyr)
rec <- data %>%
filter(stage == st , element == el) %>%
select(x,z)

nBins <- 30
library(gplots)
library(colorRamps)
h2d <- hist2d(rec,show=FALSE, nbins=c(nBins,nBins), col = matlab.like(100))

binSize.x <- with(rec, max(x) - min(x))/nBins
binSize.z <- with(rec, max(z) - min(z))/nBins
bin.area <- binSize.x * binSize.z

conversionFactor <- ppf/(bin.area*1000) ## kW/m^2
fluxMatrix <- h2d$counts * conversionFactor

## Vectorizacion de una matrix
XY <- expand.grid(h2d$x, h2d$y)
data <- data.frame(XY[1], XY[2], c(fluxMatrix))
names(data) <- c("x", "y", "z")
## head(data)

library(lattice)
p.wire <- wireframe(z ~ x*y, data = data, scales = list(arrows = FALSE), lwd=0.5)

p.wireCol <- wireframe(z ~ x*y, data = data, scales = list(arrows = FALSE),
 drape = TRUE, colorkey = TRUE, lwd=0.5,
 col.regions = matlab.like(100))

p.con <- contourplot(z ~ x*y,data = data, cuts = 10,
panel = function(...){
panel.grid(h=-1, v=-1)
panel.contourplot(...)},
xlab = "x", ylab = "y")

p.level <- levelplot(z ~ x*y, data = data, cuts = 5,
col.regions = matlab.like(1000),
xlab="x", ylab="y")

mx <- min(abs(data$x))
my <- min(abs(data$y))
p.zx <- xyplot(z ~ x, data[abs(data$y) == my, ], type = "l", grid = TRUE)
p.zy <- xyplot(z ~ y, data[abs(data$x) == mx, ], type = "l", grid = TRUE)

if(!file.exists("fig")) dir.create("fig")
pdf(file = "./fig/SolT3dgray.pdf", width = 5, height = 5); p.wire; dev.off()
pdf(file = "./fig/SolT3d.pdf", width = 5, height = 5); p.wireCol; dev.off()
pdf(file = "./fig/SolTContour.pdf", width = 5, height = 5); p.con; dev.off()
pdf(file = "./fig/SolTLevel.pdf", width = 5, height = 5); p.level; dev.off()
pdf(file = "./fig/SolTZX.pdf", width = 5, height = 5); p.zx; dev.off()
pdf(file = "./fig/SolTZY.pdf", width = 5, height = 5); p.zy; dev.off()

## Opcional porque puede ser tardado
dx <- binSize.x
dy <- binSize.z
rcp <- data$z
xr <- h2d$x
yr <- h2d$y

save(data, dx, dy, rcp, xr, yr, file = "SolTraceData.RData")
save(data, pot, potenciaT, file = "SolTraceData.RData")
