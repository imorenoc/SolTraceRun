#!/usr/bin/env Rscript
load("SolTraceData.RData")
source("potencia.R")
library(lattice)
potenciaT <- potTotal(rcp, xr, yr, dx, dy)
pot <- potencia(rcp, xr, yr, dx, dy, p=0.95)
if(!file.exists("fig")) dir.create("fig")
pP1 <- xyplot(potencia ~ area, pot, type = "l", grid=TRUE,
                xlab = "Area [m2]",
                ylab = "Potencia [kW]")

pP2 <- xyplot(potencia ~ porc, pot, type = "l", grid=TRUE,
                xlab = "Potencia / Potencia Total",
                ylab = "Potencia [kW]")
pdf("./fig/SolTPotenciaArea.pdf", width = 5, height = 5); pP1; dev.off()
pdf("./fig/SolTPotencia.pdf", width = 5, height = 5); pP2; dev.off()
save(data, pot, potenciaT, file = "SolTraceData.RData")
