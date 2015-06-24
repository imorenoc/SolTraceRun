#!/bin/bash
#
# SCRIPT: 	SolTracePos
# AUTHOR: 	ISAIAS MORENO
# DATE: 	17-Jun-2015
# REV:		0.0.-
# 
# PLATFORM: Unix (MAC)
#
# PURPOSE: El proposito de este este scrip es realizar el pos-procesamiento de
# los datos obtenidos mediante `_SolTraceRun.sh` (data.dat). El archivo
# data.dat contine en la primera fila el valor de potencia por foton (W/m2), y
# a partir de la segunda fila contine los datos de la simulaci'on ordenados
# de la siguiente manera, en coordenadas globales:
# x, y, z, cosx, cosy, cosz, element, stage, raynum
#
# Para ejecutar:
# ./SolTracePos.sh element stage nBins
#
#######################################################################

stage=`basename $1`
element=`basename $2`
nBins=`basename $3`
rut=`pwd`


echo '#!/usr/bin/env Rscript' > run.R
echo '##--------------------------------------------------' >> run.R
echo '## Lectura del file.dat' >> run.R
echo '##--------------------------------------------------' >> run.R
echo 'rm(list=ls())' >> run.R
echo 'ppf <- read.table("data.dat", nrows = 1) ## potencia por foton (ppf)' >> run.R
echo 'ppf <- as.numeric(ppf)' >> run.R
echo 'data <- read.table("data.dat", header = TRUE, sep = ",", skip = 1)' >> run.R
echo '' >> run.R
echo 'st <- '$stage' # stage' >> run.R
echo 'el <- '$element' # element' >> run.R
echo '' >> run.R
echo 'library(dplyr)' >> run.R
echo 'rec <- data %>%' >> run.R
echo 'filter(stage == st , element == el) %>%' >> run.R
echo 'select(x,z)' >> run.R
echo '' >> run.R
echo 'nBins <- '$nBins'' >> run.R
echo 'library(gplots)' >> run.R
echo 'library(colorRamps)' >> run.R
echo 'h2d <- hist2d(rec,show=FALSE, nbins=c(nBins,nBins), col = matlab.like(100))' >> run.R
echo '' >> run.R
echo 'binSize.x <- with(rec, max(x) - min(x))/nBins' >> run.R
echo 'binSize.z <- with(rec, max(z) - min(z))/nBins' >> run.R
echo 'bin.area <- binSize.x * binSize.z' >> run.R
echo '' >> run.R
echo 'conversionFactor <- ppf/(bin.area*1000) ## kW/m^2' >> run.R
echo 'fluxMatrix <- h2d$counts * conversionFactor' >> run.R
echo '' >> run.R
echo '## Vectorizacion de una matrix' >> run.R
echo 'XY <- expand.grid(h2d$x, h2d$y)' >> run.R
echo 'data <- data.frame(XY[1], XY[2], c(fluxMatrix))' >> run.R
echo 'names(data) <- c("x", "y", "z")' >> run.R
echo '## head(data)' >> run.R
echo '' >> run.R
echo 'library(lattice)' >> run.R
echo 'p.wire <- wireframe(z ~ x*y, data = data, scales = list(arrows = FALSE), lwd=0.5)' >> run.R
echo '' >> run.R
echo 'p.wireCol <- wireframe(z ~ x*y, data = data, scales = list(arrows = FALSE),' >> run.R
echo ' drape = TRUE, colorkey = TRUE, lwd=0.5,' >> run.R
echo ' col.regions = matlab.like(100))' >> run.R
echo '' >> run.R
echo 'p.con <- contourplot(z ~ x*y,data = data, cuts = 10,' >> run.R
echo 'panel = function(...){' >> run.R
echo 'panel.grid(h=-1, v=-1)' >> run.R
echo 'panel.contourplot(...)},' >> run.R
echo 'xlab = "x", ylab = "y")' >> run.R
echo '' >> run.R
echo 'p.level <- levelplot(z ~ x*y, data = data, cuts = 5,' >> run.R
echo 'col.regions = matlab.like(1000),' >> run.R
echo 'xlab="x", ylab="y")' >> run.R
echo '' >> run.R
echo 'mx <- min(abs(data$x))' >> run.R
echo 'my <- min(abs(data$y))' >> run.R
echo 'p.zx <- xyplot(z ~ x, data[abs(data$y) == my, ], type = "l", grid = TRUE)' >> run.R
echo 'p.zy <- xyplot(z ~ y, data[abs(data$x) == mx, ], type = "l", grid = TRUE)' >> run.R
echo '' >> run.R
echo 'if(!file.exists("fig")) dir.create("fig")' >> run.R
echo 'pdf(file = "./fig/SolT3dgray.pdf", width = 5, height = 5); p.wire; dev.off()' >> run.R
echo 'pdf(file = "./fig/SolT3d.pdf", width = 5, height = 5); p.wireCol; dev.off()' >> run.R
echo 'pdf(file = "./fig/SolTContour.pdf", width = 5, height = 5); p.con; dev.off()' >> run.R
echo 'pdf(file = "./fig/SolTLevel.pdf", width = 5, height = 5); p.level; dev.off()' >> run.R
echo 'pdf(file = "./fig/SolTZX.pdf", width = 5, height = 5); p.zx; dev.off()' >> run.R
echo 'pdf(file = "./fig/SolTZY.pdf", width = 5, height = 5); p.zy; dev.off()' >> run.R
echo '' >> run.R
echo '## Opcional porque puede ser tardado' >> run.R
echo 'dx <- binSize.x' >> run.R
echo 'dy <- binSize.z' >> run.R
echo 'rcp <- data$z' >> run.R
echo 'xr <- h2d$x' >> run.R
echo 'yr <- h2d$y' >> run.R
echo '' >> run.R
echo 'save(data, dx, dy, rcp, xr, yr, file = "SolTraceData.RData")' >> run.R

## Run R script
chmod +x run.R
./run.R
## rm run.R
