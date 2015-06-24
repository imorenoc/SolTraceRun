Run SolTrace
============

Este conjunto de scripts son para realizar la simulación de un modelo de [SolTrace](http://www.nrel.gov/csp/soltrace/download.html ), `file.stinput`,  así como el posporcesamiento desde la terminal.

	_SolTraceRun.sh
	_SolTracePos.sh
	_potencia.sh

Necesidades
-----------

Se requiere tener instalado [SolTrace](http://www.nrel.gov/csp/soltrace/download.html ) 
, y poder ejecutarlo desde la terminal. Lo cual se logra al agregar `/Applications/SolTrace.app/Contents/MacOS/SolTrace` al `$PATH`.

Además, es necesario tener instalado [R](http://cran.r-project.org/ ), con los siguientes paquetes:

	library(lattice)
	library(dplyr)
	library(gplots)
	library(colorRamps)

_SolTraceRun.sh
---------------

El objetivo de este script es ejecutar el trazado de rayos de un
modelo ".stinput"(SolTrace), previamente realizado. La ventaja al ejecutar
este script es poder hacer modificaciones en varios parametros son abrir
el programa SolTrace, estos son:

 archivo	- archivo de SolTrace
 #rayos	    - numero de rayos a utilizar en la simulación
 etapa		- etapa de interés 
 elemento	- elemento de interés
 nBins		- mallado del elemento
 DNI		- irradiancia solar

Para ejecutarlo,

	./_SolTraceRun.sh file.stinput #rayos stage element nBins DNI
	./_SolTraceRun.sh OneHelio.stinput 1e5 2 1 30 1000

 La salida son dos archivo, uno de estadisticas (stat.dat) y otro de datos
 (data.dat). 

SolTracePos.sh
--------------

El proposito de este este scrip es realizar el pos-procesamiento de
los datos obtenidos mediante `_SolTraceRun.sh` (data.dat). El archivo
data.dat contine en la primera fila el valor de potencia por foton (W/m2), y
a partir de la segunda fila contine los datos de la simulaci'on ordenados
de la siguiente manera, en coordenadas globales:

    x, y, z, cosx, cosy, cosz, element, stage, raynum

Para ejecutarlo,

	./_SolTracePos.sh element stage nBins
	./_SolTracePos.sh 2 1 20

Genera un archivo "SolTraceData.RData" y, si no existe, una carpeta "fig" en donde se guardan varias gráficas de interés.

_potencia.sh
------------

El script 

este script obtiene la potencia Vs 'area del spot. Toma como
entrada la base de datos de SolTraceData.RData. Para ejecutarlo:

    ./_potencia.sh
