
	  *CENAGRO 2012 LIMITES DISTRITALES

	  *ANCASH 
clear all
cd "D:\Indicadoressocioeconomicos\clase6\SHAPE\0201_SEAS_CENAGRO_2012"
 
shp2dta using 0201_SEAS_CENAGRO_2012.shp, database(dbase) coordinates(coord) genid(id) genc(c)


use "dbase.dta", clear
spmap  using "coord.dta", id(id)


*centros poblados
clear all
set more off 
cd "D:\Indicadoressocioeconomicos\clase6\SHAPE\ccpp_cenagro_2012\CCPP_CENAGRO_2012"

shp2dta using CENAGRO_2012.shp , database(dbase) coordinates(coord) genid(id) genc(c)


use dbase ,clear

use coord,clear

version 15.0 
use "dbase.dta", clear
spmap  using "coord.dta", id(id)
      


      


