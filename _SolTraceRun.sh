#!/bin/bash
#
# SCRIPT: 	SolTraceRun
# AUTHOR: 	ISAIAS MORENO
# DATE: 	17-Jun-2015
# REV:		0.0.-
# 
# PLATFORM: Unix (MAC)
#
# PURPOSE: El objetivo de este script es ejecutar el trazado de rayos de un
# modelo ".stinput"(SolTrace), previamente realizado. La ventaja al ejecutar
# este script es poder hacer modificaciones en varios parametros son abrir
# el programa SolTrace, es decir, estos son:
#
# archivo	- archivo de SolTrace
# #rayos	- numero de rayos a utilizar en la simulación
# etapa		- etapa de interés 
# elemento	- elemento de interés
# nBins		- mallado del elemento
# DNI		- irradiancia solar
#
# ./_SolTraceRun.sh file.stinput #rayos stage element nBins DNI
# ./_SolTraceRun.sh OneHelio.stinput 1e6 2 1 30 1000
#
# La salida son dos archivo, uno de estadisticas (stat.dat) y otro de datos
# (data.dat). 
#
# Nota: es necesario tener instalado SolTrace y ejecutarlo desde la consola
# con el nombre de:
# $ SolTrace
#######################################################################

name=`basename $1`
name=${name%.stinput}

rays=`basename $2`
stage=`basename $3`
element=`basename $4`
nBins=`basename $5`
DNI=`basename $6`
rut=`pwd`

stage=$((stage - 1))
element=$((element - 1))

echo '// Ruta' > run.lk
echo 'rut = "'$rut'/";' >> run.lk
echo '' >> run.lk
echo '// Primero abre el modelo '$name'.stinput' >> run.lk
echo 'open_project(rut + "'$name'.stinput");' >> run.lk
echo '' >> run.lk
echo '// Archivo de ' >> run.lk
echo 'fs = rut + "stats.dat";' >> run.lk
echo 'file = open(fs, "w");' >> run.lk

# echo '// Vector Solar' >> run.lk
# echo 's[0] = 0.0;' >> run.lk
# echo 's[1] = 0.0;' >> run.lk
# echo 's[2] = 1.0;' >> run.lk
# echo '' >> run.lk
# echo '// Forma solar' >> run.lk
# echo 'Sun.x = s[0];' >> run.lk
# echo 'Sun.y = s[1];' >> run.lk
# echo 'Sun.z = s[2];' >> run.lk
# echo 'sunopt(Sun);' >> run.lk

echo '' >> run.lk
echo 'n = '$rays';' >> run.lk
echo "traceopt({ 'rays' = n } );" >> run.lk
echo 'trace();' >> run.lk
echo '' >> run.lk
echo 'stage = '$stage';' >> run.lk
echo 'element = '$element';' >> run.lk
echo 'nBin = '$nBins';' >> run.lk
echo 'DNI = '$DNI';' >> run.lk
echo '' >> run.lk
echo '// returns a table of statistics on the target' >> run.lk
echo 'stat = elementstats( stage, element, nBin, nBin, DNI, false );' >> run.lk
echo '' >> run.lk
echo 'write_line(file, "# Muestra el numero de rayos que golpean cada bin");' >> run.lk
echo 'flux ="";' >> run.lk
echo 'for (r=0;r<#stat.flux;r++)' >> run.lk
echo '{' >> run.lk
echo 'for (c=0;c<#stat.flux[r];c++)' >> run.lk
echo 'flux = flux + stat.flux[r][c] + "\t";' >> run.lk
echo '' >> run.lk
echo 'write_line(file, flux);' >> run.lk
echo 'flux = "";' >> run.lk
echo '}' >> run.lk
echo '' >> run.lk
echo '// nullify the flux grid and the x,y arrays to show the various names of table fields' >> run.lk
echo 'stat.flux = null; ' >> run.lk
echo 'stat.xvalues = null;' >> run.lk
echo 'stat.yvalues = null;' >> run.lk
echo 'keys = @stat; // obtain an array of all the non-null keys in the stat structure' >> run.lk
echo '' >> run.lk
echo 'write_line(file, "## Todas las estadisticas:");' >> run.lk
echo 'for (i=0;i<#keys;i++)' >> run.lk
echo 'write_line( file, "# " + keys[i] + " = " + stat{keys[i]} );' >> run.lk
echo '' >> run.lk
echo '' >> run.lk
echo 'write_line(file, "# ray hits on target: " + rayhits('$stage', '$element'));' >> run.lk
echo '' >> run.lk
echo 'close(file);' >> run.lk
echo '' >> run.lk
echo '//---------------------------------------------------------------' >> run.lk
echo 'fp = rut + "data.dat";' >> run.lk
echo 'file = open(fp, "w");' >> run.lk
echo 'write_line( file, stat{keys[4]} + " ## " + keys[4]);' >> run.lk
echo 'write_line(file, "x, y, z, cosx, cosy, cosz, element, stage, raynum");' >> run.lk
echo 'i = 0.0;' >> run.lk
echo 'while(raydata(i) != null){' >> run.lk
echo 'write_line( file, raydata(i));' >> run.lk
echo 'i = i + 1;' >> run.lk
echo '}' >> run.lk
echo '' >> run.lk
echo 'close(file);' >> run.lk

## Ejecuta el archivo run.lk generado por SolTrace
SolTrace -s run.lk
