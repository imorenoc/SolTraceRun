#!/bin/bash
#
# SCRIPT: 	SolTracePos
# AUTHOR: 	ISAIAS MORENO
# DATE: 	17-Jun-2015
# REV:		0.0.-
# 
# PLATFORM: Unix (MAC)
#
# PURPOSE: este script obtiene la potencia Vs 'area del spot. Toma como
# entrada la base de datos de SolTraceData.RData. Para ejecutarlo:
#
# ./_potencia.sh
#######################################################################

## Funci'on potencia.R
echo '## Potencia' > potencia.R
echo '## dx,dy - es la malla del area' >> potencia.R
echo '' >> potencia.R
echo '## Potencia total [kW]' >> potencia.R
echo 'potTotal <- function(rcp, xr, yr, dx, dy){' >> potencia.R
echo 'da <- dx*dy # diferencial de area' >> potencia.R
echo 'A <- (length(xr)-1)*(length(yr)-1)*da' >> potencia.R
echo 'da <- A/length(rcp)' >> potencia.R
echo 'sum(rcp)*da # potencia total [kW]' >> potencia.R
echo '' >> potencia.R
echo '}' >> potencia.R
echo '' >> potencia.R
echo '' >> potencia.R
echo 'potencia <- function(rcp, xr, yr, dx, dy, p = 0.95){' >> potencia.R
echo 'da <- dx*dy # diferencial de area' >> potencia.R
echo 'A <- (length(xr)-1)*(length(yr)-1)*da' >> potencia.R
echo 'da <- A/length(rcp)' >> potencia.R
echo 'pt <- sum(rcp)*da # potencia total [kW]' >> potencia.R
echo 'od <- sort(rcp, decreasing = T)' >> potencia.R
echo '' >> potencia.R
echo 'dat <- c()' >> potencia.R
echo 'i <- 1' >> potencia.R
echo 'pp <- od[i]*da' >> potencia.R
echo 'aux <- data.frame(porc= pp/pt, area = da, potencia=pp)' >> potencia.R
echo 'dat <- rbind(dat,aux)' >> potencia.R
echo '' >> potencia.R
echo 'for(i in 2:length(od)){' >> potencia.R
echo 'pp <- sum(pp+od[i]*da)' >> potencia.R
echo 'aux <- data.frame(porc= pp/pt, area = i*da,' >> potencia.R
echo 'potencia=pp)' >> potencia.R
echo 'dat <- rbind(dat,aux)' >> potencia.R
echo 'if( trunc(pp/pt, prec = 2) == p) break' >> potencia.R
echo '}' >> potencia.R
echo 'dat' >> potencia.R
echo '}' >> potencia.R
echo '' >> potencia.R

## script de R, 
echo '#!/usr/bin/env Rscript' > runPot.R
echo 'load("SolTraceData.RData")' >> runPot.R
echo 'source("potencia.R")'  >> runPot.R
echo 'library(lattice)' >> runPot.R

echo 'potenciaT <- potTotal(rcp, xr, yr, dx, dy)' >> runPot.R
echo 'pot <- potencia(rcp, xr, yr, dx, dy, p=0.95)' >> runPot.R
echo ''
echo 'if(!file.exists("fig")) dir.create("fig")' >> runPot.R
echo 'pP1 <- xyplot(potencia ~ area, pot, type = "l", grid=TRUE,'  >> runPot.R
echo '                xlab = "Area [m2]",'  >> runPot.R
echo '                ylab = "Potencia [kW]")' >> runPot.R
echo '' >> runPot.R
echo 'pP2 <- xyplot(potencia ~ porc, pot, type = "l", grid=TRUE,' >> runPot.R
echo '                xlab = "Potencia / Potencia Total",' >> runPot.R
echo '                ylab = "Potencia [kW]")' >> runPot.R

echo 'pdf("./fig/SolTPotenciaArea.pdf", width = 5, height = 5); pP1; dev.off()' >> runPot.R
echo 'pdf("./fig/SolTPotencia.pdf", width = 5, height = 5); pP2; dev.off()' >> runPot.R

echo 'save(data, pot, potenciaT, file = "SolTraceData.RData")' >> runPot.R

## Ejecutar runPot.R
chmod +x runPot.R
./runPot.R
