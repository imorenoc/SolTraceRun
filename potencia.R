## Potencia
## dx,dy - es la malla del area

## Potencia total [kW]
potTotal <- function(rcp, xr, yr, dx, dy){
da <- dx*dy # diferencial de area
A <- (length(xr)-1)*(length(yr)-1)*da
da <- A/length(rcp)
sum(rcp)*da # potencia total [kW]

}


potencia <- function(rcp, xr, yr, dx, dy, p = 0.95){
da <- dx*dy # diferencial de area
A <- (length(xr)-1)*(length(yr)-1)*da
da <- A/length(rcp)
pt <- sum(rcp)*da # potencia total [kW]
od <- sort(rcp, decreasing = T)

dat <- c()
i <- 1
pp <- od[i]*da
aux <- data.frame(porc= pp/pt, area = da, potencia=pp)
dat <- rbind(dat,aux)

for(i in 2:length(od)){
pp <- sum(pp+od[i]*da)
aux <- data.frame(porc= pp/pt, area = i*da,
potencia=pp)
dat <- rbind(dat,aux)
if( trunc(pp/pt, prec = 2) == p) break
}
dat
}

