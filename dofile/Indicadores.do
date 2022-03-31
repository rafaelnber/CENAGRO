
***============================================================
***          Cálculo de Indicadores de CENAGRO
***          Fecha ultima actualización:   30/03/2022
***          Versión: Stata 16
***          Autor: Andrés Talavera Cuya 
***============================================================

version 16
clear all
set more off

*** ==================================================================
***		Rutas donde se encuentran las bases
*** ==================================================================
	
global DIR_ROOT   "D:\ANDRES\Documentos\GitHub\IndicadoresStata\Cenagro\"

global DIR_DATA_INIT	"D:\Dropbox\BASES\CENAGRO\Inicial" 
global DIR_DATA_INTERM	"D:\Dropbox\BASES\CENAGRO\Intermedio" 
global DIR_DATA_FINAL   "D:\Dropbox\BASES\CENAGRO\Final" 

global rec01  "${DIR_DATA_INIT}\rec01" 
global rec02  "${DIR_DATA_INIT}\rec02" 
global rec01a "${DIR_DATA_INIT}\rec01a" 
global rec04  "${DIR_DATA_INIT}\rec04" 
global rec04b "${DIR_DATA_INIT}\rec04b" 

*** ==================================================================
***		Rutas donde se encuentran los dofile
*** ==================================================================

global dofile   "${DIR_ROOT}\dofile"

*** ==================================================================
***		Rutas donde se encuentran los shapefile 
*** ==================================================================

global shapefile "${DIR_ROOT}\shapefile"


*** ==================================================================
***		Rutas donde se encuentran las plantillas excel 
*** ==================================================================

global excel  "${DIR_ROOT}\excel"

display "$excel" 
	
*** ==================================================================
***		              Superficie agropecuaria (has)
*** ==================================================================

*** ==================================================================
***		Superficie sembrada (has)
*** ==================================================================


cd "$rec02" 
use rec02.dta ,clear 
recode   p025 (.= 0)
gen sup_semb=p025 if p024_01<=18
collapse (sum) sup_semb, by(p001 p002 p003 p007x p008 nprin) 
table p001 , c(sum sup_semb) format(%12.2f) center row col

gen P001=real(p001)

label define rDpto  1 "Amazonas" 2 "Áncash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Prov Const del Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San Martín" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"

label values P001 rDpto



table P001 , c(sum sup_semb) format(%12.2f) center row col

drop P001
save "${DIR_DATA_INTERM}\sup_cultivos.dta" ,replace 

*** ==================================================================
***		           Superficie con otros usos 
*** ==================================================================


cd "$rec01" 
use rec01,clear 
recode   wsup* (.= 0)

*** ==================================================================
***     Superficie en barbecho (has)
*** ==================================================================

gen sup_barb=wsup08a
table wregion if ((resultado==1 | resultado==2)), c(sum sup_barb) format(%12.2f) center row col


*** ==================================================================
***     Superficie en descanso (has)
*** ==================================================================

gen sup_des=wsup09
table wregion if ((resultado==1 | resultado==2)), c(sum sup_des) format(%12.2f) center row col

*** ==================================================================
***     Superficie agrícola sin uso (no trabajada) has 
*** ==================================================================

gen sup_agr_sin=wsup08b
table wregion if ((resultado==1 | resultado==2)), c(sum sup_agr_sin) format(%12.2f) center row col


*** ==================================================================
***     Superficie con pastos naturales manejados (has)
*** ==================================================================

gen sup_past_manej=wsup15

*** ==================================================================
***     Superficie con pastos naturales no manejados (has)
*** ==================================================================

gen sup_past_nmanej=wsup16

*** ==================================================================
***     Superficie con montes y bosques (has)
*** ==================================================================

gen sup_mont_bos=wsup17

*** ==================================================================
***     Superficie con otros usos (has)
*** ==================================================================

gen sup_otros=wsup05

recode  sup_barb sup_agr_sin sup_des sup_past_manej sup_past_nmanej sup_mont_bos sup_otros (.=0)

collapse (sum) sup_barb sup_agr_sin sup_des sup_past_manej sup_past_nmanej sup_mont_bos sup_otros , by(p001 p002 p003 p007x p008 nprin)

saveold "${DIR_DATA_INTERM}\sup_usos.dta",replace 

*** ==================================================================
***		Superficies
*** ==================================================================

cd "${rec01}"
use rec01,clear 
keep if resultado==1|resultado==2
merge 1:1 p001 p002 p003 p007x p008 nprin using    "${DIR_DATA_INTERM}\sup_cultivos.dta" , nogen 
merge 1:1 p001 p002 p003 p007x p008 nprin using    "${DIR_DATA_INTERM}\sup_usos.dta" , nogen 

cd "${DIR_DATA_INTERM}"
save rec01_usos,replace 
 
*** ==================================================================
***		Superficie agrícola  
*** ==================================================================

egen sup_agri=rowtotal(sup_semb sup_barb sup_des sup_agr_sin) 

table wregion if ((resultado==1 | resultado==2)), c(sum sup_agri) format(%12.2f) center row col
*****************************************************************


*** ==================================================================
***		Superficie agrícola bajo riego y bajo secano  
*** ==================================================================

gen sup_riego=wsup03a
gen sup_secano=wsup03b

table wregion if ((resultado==1 | resultado==2)), c(sum sup_riego sum sup_secano ) format(%12.2f) center row col


*****************************************************************

*** ==================================================================
***		Superficie no agrícola  
*** ==================================================================
br sup_past_manej sup_past_nmanej sup_mont_bos  sup_otros
egen sup_no_agri=rowtotal(sup_past_manej sup_past_nmanej sup_mont_bos  sup_otros) 

table wregion if ((resultado==1 | resultado==2)), c(sum sup_no_agri) format(%12.2f) center row col
*****************************************************************

*** ==================================================================
***		Superficie total 
*** ==================================================================

egen sup_ua=rowtotal(sup_semb sup_barb sup_des sup_agr_sin sup_past_manej sup_past_nmanej sup_mont_bos  sup_otros) 

table wregion if ((resultado==1 | resultado==2)), c(sum sup_ua) format(%12.2f) center row col
*****************************************************************



*** ==================================================================
***		tostring y destring para solucionar problemas de colas 
*** ==================================================================
br sup_agri sup_semb sup_barb sup_agr_sin sup_des sup_no_agri sup_past_manej sup_past_nmanej sup_mont_bos  sup_otros sup_riego sup_secano

tostring sup_agri sup_semb sup_barb sup_agr_sin sup_des sup_no_agri sup_past_manej sup_past_nmanej sup_mont_bos  sup_otros sup_riego sup_secano, replace usedisplayformat force 
destring sup_agri sup_semb sup_barb sup_agr_sin sup_des sup_no_agri sup_past_manej sup_past_nmanej sup_mont_bos  sup_otros sup_riego sup_secano,replace 
*****************************************************************


preserve  
collapse (sum) sup_riego (sum) sup_secano 
export excel using "${excel}\reporte.xlsx",sheet("c01" , modify) cell(s27) keepcellfmt  
restore 


*** ==================================================================
***		rename de superficies 
*** ==================================================================

br sup_ua sup_agri sup_semb sup_barb sup_des sup_agr_sin sup_no_agri sup_past_manej sup_past_nmanej sup_mont_bos  sup_otros

rename (sup_ua sup_agri sup_semb sup_barb sup_des sup_agr_sin sup_no_agri sup_past_manej sup_past_nmanej sup_mont_bos  sup_otros) (sup_1 sup_2 sup_3 sup_4 sup_5 sup_6 sup_7 sup_8 sup_9 sup_10 sup_11) 

order p001 p002 p003 p007x p008 nprin sup_1 sup_2 sup_3 sup_4 sup_5 sup_6 sup_7 sup_8 sup_9 sup_10 sup_11

la var sup_1 "superficie total de la unidad agropecuaria (ha)"
la var sup_2 "superficie agrícola (ha)"
la var sup_3 "superficie sembrada (ha)" 
la var sup_4 "superficie barbecho (ha)"
la var sup_5 "superficie en descanso (ha)"
la var sup_6 "superficie agrícola sin uso (no trabajada) ha"
la var sup_7 "superficie no agrícola (ha) " 
la var sup_8 "superficie con pastos naturales manejados (ha)"
la var sup_9 "superficie con pastos naturales no manejados (ha)"
la var sup_10 "superficie con montes y bosques (ha)"
la var sup_11 "superficie con otros usos (ha)"

*** ==================================================================
***		transponiendo la base 
*** ==================================================================
keep p001 p002 p003 p007x p008 nprin sup_1 sup_2 sup_3 sup_4 sup_5 sup_6 sup_7 sup_8 sup_9 sup_10 sup_11 
reshape long sup_, i(p001 p002 p003 p007x p008 nprin) j(usos) 


recode   sup_ (.= 0)

gen ubigeo=p001+p002+p003

*** ==================================================================
***		Variable rDpto
*** ==================================================================

gen rDpto=real(substr(ubigeo,1,2))
gen rprov=(substr(ubigeo,1,4))
label var rDpto "Departamento"

label define rDpto /*
*/ 1 "Amazonas" 2 "Áncash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Prov Const del Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" /*
*/ 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" /* 
*/ 21 "Puno" 22 "San Martín" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"

label values rDpto rDpto

*** ==================================================================
***		 Variable rDpto2
*** ==================================================================


gen LimMetro=.
replace LimMetro=1 if rDpto==7
replace LimMetro=1 if rprov=="1501"

gen rDpto2=rDpto if rDpto<16
replace rDpto2=16 if rDpto==15 & LimMetro!=1
replace rDpto2=rDpto+1 if rDpto>=16

label var rDpto2 "Departamento"

label define rDpto2 /*
*/ 1 "Amazonas" 2 "Áncash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Prov Const del Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" /*
*/ 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Provincia de Lima" 16 "Lima Provincias" 17 "Loreto" 18 "Madre de Dios" 19 "Moquegua" 20 "Pasco" 21 "Piura" /* 
*/ 22 "Puno" 23 "San Martín" 24 "Tacna" 25 "Tumbes" 26 "Ucayali"

label values rDpto2 rDpto2


table rDpto2 usos , c(sum sup_) format(%12.2f) center row col

*Podria programar rutina para resultados por departamentos. 

*Nacional: 
preserve  
collapse (sum) sup_ , by(usos )
export excel using "${excel}\reporte.xlsx",sheet("c01" , modify) cell(o8) keepcellfmt   
restore 


preserve  
collapse (sum) sup_ , by(usos rDpto2)
reshape wide sup_, i(rDpto2) j(usos)
*reshape long sup_, i(rDpto2) j(usos)
export excel using "${excel}\reporte.xlsx",sheet("c02" , modify) cell(b7) keepcellfmt   
restore 


*** ==================================================================
***	 Superficie agrícola con cultivo de café , a nivel distrital
*** ==================================================================

cd "$rec02" 
use rec02.dta ,clear 
recode   p025 (.= 0)
gen sup_semb=p025 if p024_01<=18
br p024_03 sup_semb 
gen cafe=(p024_03==1203) /*dummy 1: si la sup. sembrada es café. 0= no*/ 
gen sup_semb_cafe=sup_semb if cafe==1

collapse (sum) sup_semb_cafe, by(p001 p002 p003) 

gen ubigeo =p001 + p002 + p003 
gen P001=real(p001)
label define rDpto  1 "Amazonas" 2 "Áncash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Prov Const del Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" 21 "Puno" 22 "San Martín" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"
label values P001 rDpto


table P001 , c(sum sup_semb_cafe) format(%12.2f) center row col

save "${DIR_DATA_INTERM}\cafe_ivcenagro.dta",replace 

**mapa distrital de café 
*** ==================================================================
***	 mapa de Superficie agrícola con cultivo de café, a nivel distrito 
*** ==================================================================

**PARTE 1: PREPARAR LOS SHAPEFILE 

*Descarga shape file distrital 
cd "${DIR_DATA_INTERM}"
copy "https://account.geodir.co/resources/file/recursos/geodir-ubigeo-inei.xlsx" geodir-ubigeo-inei.xlsx

copy "https://account.geodir.co/resources/file/recursos/geodir-ubigeo-inei.zip" geodir-ubigeo-inei.zip

unzipfile geodir-ubigeo-inei.zip
erase geodir-ubigeo-inei.zip

*ssc install shp2dta 
*convertir shp a dta:  
shp2dta using "geodir_ubigeo_inei.shp", ///
    data("${DIR_DATA_INTERM}\dbasedist.dta") coor("${DIR_DATA_INTERM}\coordist.dta") genid(id) gencentroids(c) replace

	
shp2dta using "LIMITE_DEP.shp", ///
    data("${DIR_DATA_INTERM}\dbasedep.dta") coor("${DIR_DATA_INTERM}\coordep.dta") genid(id) gencentroids(c) replace

	
dir*dta

cd ${DIR_DATA_INTERM}
use dbasedist.dta,clear 


**Distritos iv cenagro 2012 

import excel "D:\Dropbox\BASES\CENAGRO\Intermedio\IV CENAGRO - Tabla_Distritos.xlsx", sheet("Distritos") cellrange(B4:E1841) firstrow clear
rename CÓDIGODEPARTAMENTO ccdep 
rename CÓDIGOPROVINCIA ccprov 
rename CÓDIGO ccdd 
rename TÍTULO distrito_ivcen 
gen ubigeo =ccdep + ccprov + ccdd 
save distrito,replace 

import excel "D:\Dropbox\BASES\CENAGRO\Intermedio\IV CENAGRO - Tabla_Provincias.xlsx", sheet("Prov") cellrange(B4:D199) firstrow clear
rename CÓDIGODEPARTAMENTO ccdep 
rename CÓDIGO ccprov 
rename TÍTULO provincia_ivcen 
save provincia,replace 
  
import excel "D:\Dropbox\BASES\CENAGRO\Intermedio\IV CENAGRO - Tabla_Departamentos.xlsx", sheet("Dpto") cellrange(B4:C29) firstrow clear
rename CODIGO ccdep
rename TÍTULO departamento_ivcen 
save dep,replace 


use distrito,clear 
merge m:1 ccdep ccprov using provincia.dta, nogen 
merge m:1 ccdep using dep.dta, nogen 
save ubigeo-ivcenagro.dta,replace 


**Union 
cd ${DIR_DATA_INTERM}
use cafe_ivcenagro.dta,clear 
merge 1:1 ubigeo using ubigeo-ivcenagro.dta , nogen 
merge 1:1 ubigeo using dbasedist.dta
gsort +_merge

*putumayo/maynas : 160801 (inei 2019)
*putumayo/maynas : 160109 (iv cenagro 2012) 

*mazamari/satipo: 120604 (inei 2019)
*pangoa  /satipo: 120606 (inei 2019)
*mazamari-pangoa satipo: 120699 (iv cenagro 2012) 

*Teniente Manuel Clavero/maynas: 160803 (inei 2019)
*Teniente Manuel Clavero/maynas: 160114 (iv cenagro 2012) 


use cafe_ivcenagro.dta,clear 
replace ubigeo="160801" if ubigeo=="160109"
replace ubigeo="160803" if ubigeo=="160114"
save,replace 


**PARTE 2: MAPA 
** Falta considerar la superficie sembrada de mazamari-pangoa satipo
cd ${DIR_DATA_INTERM}
use cafe_ivcenagro.dta,clear 
merge 1:1 ubigeo using dbasedist.dta
	#delimit ;	
    . spmap sup_semb_cafe if sup_semb_cafe >0 using "coordist.dta", id(id)
        clnumber(7) fcolor(Reds2) ocolor(none ..)    
        title("Superficie cultivada de café, segun distritos", size(*0.8))
        subtitle("Perú, iv Cenagro 2012" " ", size(*0.8))                       
        legstyle(3) 
		line(data("coordep.dta") size(0.2) color(black))
		label(data("dbasedep.dta") xcoord(x_c) ycoord(y_c) by(id) label(NOMBDEP) color(black) size(*0.6 ..) pos(0 6) length(25));
#delimit cr
	  
	  
	  
*** ==================================================================
***	 Superficie agrícola con cultivo de café, a nivel unidad agropec.
*** ==================================================================

  cd ${DIR_DATA_INTERM}
ssc install spgrid /*Genera cuadrículas bidimensionales para el análisis de datos espaciales*/
ssc install spkde /*estimación kernel de las funciones de densidad e intensidad para patrones de puntos espaciales bidimensionales*/


cd "$rec02" 
use rec02.dta ,clear 
recode   p025 (.= 0)
gen sup_semb=p025 if p024_01<=18

gen cafe=(p024_03==1203)
gen sup_semb_cafe=sup_semb if cafe==1
collapse (sum) sup_semb_cafe, by(p001 p002 p003 p007x p008 nprin) 

cd ${DIR_DATA_INTERM}	  
save cafe_ivcenagro_ua.dta	,replace   

***Uniendo base de sup sembrada con unidades agropecuarias 
use cafe_ivcenagro_ua.dta,clear 	  
merge 1:1 p001 p002 p003 p007x p008 nprin using "$rec01\rec01" , nogen 
gen ubigeo=p001+p002+p003 
merge m:1 ubigeo using ubigeo-ivcenagro.dta, nogen 

replace sup_semb_cafe=0 if sup_semb_cafe==. 

*¿En que departamento/provincia/distrito se encontró la mayor superficie sembrada de café a nivel de unidad agropecuaria?

list departamento_ivcen provincia_ivcen distrito_ivcen  sup_semb_cafe if sup_semb_cafe>1400 

*Sabias que en el distrito de Apata/Jauja/Junin se encontró a la unidad agropecuaria con mayor superficie sembrada de café (iv cenagro 2012)

*UNID. AGROP. mayores a 500 hectareas de sup. sembrada de café. 
list departamento_ivcen provincia_ivcen distrito_ivcen  sup_semb_cafe if sup_semb_cafe>500
 

*usamos sprid para generar una cuadrícula que cubra el área de Perú. Elegimos una resolución de cuadrícula relativamente fina (ancho de celda de cuadrícula == 0.1 kilometros o lo que es lo mismo 100 metros)


spgrid using "coordist.dta",   ///
        resolution(w0.1) unit(kilometers)             ///
        cells("ctemp.dta")                 ///
        points("ptemp.dta")               ///
        replace compress dots
    . use "ptemp.dta", clear
    . spmap using "ctemp.dta", id(spgrid_id)   ///
        polygon(data("coordist.dta")     ///
        ocolor(red) osize(thick))


*usamos spkde para generar estimaciones kernel de la distribución de probabilidad de unidades agropecuarias que tienen superficie sembrada de café superior a 700 hectareas. Elegimos una función kernel quartic con ancho de banda fijo igual a 100 metros y corrección de borde (edge correction). Spmap se utiliza para mostrar los resultados
		
use cafe_ivcenagro_ua.dta,clear 	  
merge m:1 p001 p002 p003 p007x p008 nprin using "$rec01\rec01"
replace sup_semb_cafe=0 if sup_semb_cafe==. 
sum  sup_semb_cafe
keep if sup_semb_cafe>700
spkde using "ptemp.dta" ,x(long_deci) y(lat_deci)	///
kernel(quartic) bandwidth(fbw) fbw(100) ///
edgecorrect dots saving("kde.dta", replace)	


use "kde.dta",clear 
spmap p using "ctemp.dta" , id(spgrid_id) clmethod(quantile) ///
clnumber(100) fcolor(Rainbow) ocolor(none ..) legend(off)  


*** ==================================================================
***	            Caracteristicas del productor agropecuario
*** ==================================================================

cd "$rec01"
use rec01,clear 

gen ubigeo=p001+p002+p003

*** ==================================================================
***		Variable rDpto
*** ==================================================================

gen rDpto=real(substr(ubigeo,1,2))
gen rprov=(substr(ubigeo,1,4))
label var rDpto "Departamento"

label define rDpto /*
*/ 1 "Amazonas" 2 "Áncash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Prov Const del Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" /*
*/ 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" /* 
*/ 21 "Puno" 22 "San Martín" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"

label values rDpto rDpto

*** ==================================================================
***		 Variable rDpto2
*** ==================================================================


gen LimMetro=.
replace LimMetro=1 if rDpto==7
replace LimMetro=1 if rprov=="1501"

gen rDpto2=rDpto if rDpto<16
replace rDpto2=16 if rDpto==15 & LimMetro!=1
replace rDpto2=rDpto+1 if rDpto>=16

label var rDpto2 "Departamento"

label define rDpto2 /*
*/ 1 "Amazonas" 2 "Áncash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Prov Const del Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" /*
*/ 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Provincia de Lima" 16 "Lima Provincias" 17 "Loreto" 18 "Madre de Dios" 19 "Moquegua" 20 "Pasco" 21 "Piura" /* 
*/ 22 "Puno" 23 "San Martín" 24 "Tacna" 25 "Tumbes" 26 "Ucayali"

label values rDpto2 rDpto2


*Productores agropecuarios (unidades agropecuarias)
keep if resultado==1|resultado==2
*gen ubigeo=p001+p002+p003
gen temp=1
bysort ubigeo: egen agropecuario=total(temp)

tab rDpto2
tab wregion 


*Unidades agropecuarias segun condición jurídica
tab  p016
tab rDpto2 p016


*Unidades agropecuarias con tierra y sin tierra 

tab p019_01, miss
gen contierras=(p019_01==.)
tab contierras
tab contierras p019_01, miss

label def contierras 1 "Tiene tierras " 0 "No tiene tierras"
label val contierras contierras

tab contierras 

*** ==================================================================
***       Unidades agropecuarias por region (costa,sierra,selva)
*** ==================================================================

tab wregion 

*** ==================================================================
***      Edad del conductor de la unidad agropecuaria
*** ==================================================================

gen edad=wp112
mean edad
ereturn list

*** ==================================================================
***      Si el conductor de la unidad agropecuaria es hombre
*** ==================================================================

*Si el conductor de la unidad agropecuaria es hombre o mujer.
recode wp111 (1=1 "Hombre") (2=0 "Mujer"), gen(hombre) 

tab hombre 

*** ==================================================================
***      Si la lengua materna del conductor de la unidad agropecuaria es indígena.
*** ==================================================================

/*
*
1 Quechua?
2 Aymara?
3 Ashaninka?
4 Otra lengua nativa?
5 Castellano?
6 Idioma extranjero?
*/
tab wp115
recode wp115 (1/4=1)  (5/max=0),gen(lengua)

la var lengua "lengua materna del conductor es nativa"
tab lengua

*
*Educación del conductor de la unidad agropecuaria
gen educ=wp114


/*
1 Sin nivel
2 Inicial
3 Primaria incompleta
4 Primaria completa
5 Secundaria incompleta
6 Secundaria completa
7 Superior no univ. incompleta
8 Superior no univ. completa
9 Superior univ. incompleta
10 Superior univ. completa
*/

 
*Porcentaje de conductores de UA que cuentan con educación primaria incompleta o menos
recode wp114 (1/3=1) (4/max=0), gen(primaria)
la var primaria "conductores de UA que cuentan con educación primaria incompleta o menos"
tab primaria

*Porcentaje de conductores que cuentan con educación secundaria completa o más
recode wp114 (6/max=1) (1/5=0), gen(secundaria)
tab secundaria 

*Porcentaje de conductores que cuentan con educación superior incompleta o más
recode wp114 (7/max=1) (1/6=0), gen(superior)
tab superior


*Usos de fertilizantes 
clear all
use "$rec01\rec01.dta"
keep if resultado==1|resultado==2
count 
use "$rec04\rec04.dta",clear 
count 

use "$rec01\rec01.dta",clear 
keep if resultado==1|resultado==2
merge 1:1 p001 p002 p003 p007x p008 nprin using "$rec04\rec04.dta"

*semilla certificada
tab p051, nol /*si=1 no=2*/

*Uso de abono orgánico 
tab p052, nol /*si=1 si=2 no=3*/

*Uso de fertilizantes químicos
tab p053, nol /*si=1 si=2 no=3*/

*Insecticidas:

	*Insecticidas químicos 
	tab p054_01 wregion, nol nofreq col /*si=1 no=2*/

	*Insecticidas biológicos (orgánicos)  
	tab p054_02 wregion, nol nofreq col /*si=1 no=2*/

*Herbicidas
tab p054_03 wregion , nol nofreq col /*si=1 no=2*/

gen semilla=(p051==1)
gen abono=(p052==1 | p052==2)
gen ferti=(p053==1 | p053==2)
gen insec=(p054_01==1 | p054_02==1) 
gen herbi=(p054_03==1)
gen fungi=(p054_04==1)

la var semilla "Uso de Semilla Certificada"
la var abono   "Uso de abono orgánico "
la var ferti   "Uso de fertilizantes químicos"
la var insec   "Uso de insecticidas"
la var herbi   "Uso de herbicidas"
la var fungi   "Uso de fungicidas"

tab semilla
tab abono
tab ferti


*Innovación agraria 

use "$rec01\rec01.dta",clear 
keep if resultado==1|resultado==2
merge 1:1 p001 p002 p003 p007x p008 nprin using "$rec04b\rec04b.dta"


*capacitación 
tab p086_01 /*si=1 no=2*/
*asistencia técnica 
tab p086_02 /*si=1 no=2*/
*asesoría empresarial  
tab p086_03 /*si=1 no=2*/
br 
gen AB=1 if p016==1
bys AB: gen total=_N
*keep if AB==1
 
*"Sólo capacitación"
gen caas=1 if p086_01==1 & p086_02==2 & p086_03==2
*"Sólo Asistencia Técnica"
replace caas=2 if p086_02==1 & p086_01==2 & p086_03==2 
*"Sólo Asesoría Empresarial"
replace caas=3 if p086_03==1 & p086_01==2 & p086_02==2 
*"Capacitación y Asistencia Técnica"
replace caas=4 if p086_01==1 & p086_02==1 & p086_03==2 & caas==.
*"Capacitación y Asesoría Empresarial"
replace caas=5 if p086_01==1 & p086_02==2 & p086_03==1 & caas==. 
*"Asistencia Técnica y Asesoría Empresarial"
replace caas=6 if p086_01==2 & p086_02==1 & p086_03==1 & caas==.
*"Capacitación, Asistencia Técnica y Asesoría Empresarial"
replace caas=7 if p086_01==1 & p086_02==1 & p086_03==1 & caas==.
*"No recibieron" 
replace caas=8 if p086_01==2 & p086_02==2 & p086_03==2 & caas==.

la def caas 1 "Sólo capacitación" 2 "Sólo Asistencia Técnica" 3 "Sólo Asesoría Empresarial" 4 "Capacitación y Asistencia Técnica" 5 "Capacitación y Asesoría Empresarial" 6 "Asistencia Técnica y Asesoría Empresarial" 7 "Capacitación, Asistencia Técnica y Asesoría Empresarial" 8 "No recibieron" 
la val caas caas 

tab caas if AB==1

*>>> 10% de los productores agropecuarios recibieron asistencia técnica, asesoría empresarial o capacitación.


*Recibió capacitación, asistencia o asesoría en tema:
	*Cultivos agrícolas 
	tab p087_01,m nolab /*si=1 no=.*/
	*Ganadería
	tab p087_02
 
	
	*Manejo, conservación y procesamiento
	tab p087_03
 
	*Producción y comercialización
	tab p087_05
 
 
gen capa_cultivos=(p087_01==1)
gen capa_ganaderia=(p087_02==1)   
gen capa_proces=(p087_03==1)
gen capa_produc=(p087_05==1)	

la var capa_cultivos  "Capacitación en cultivos agrícolas"
la var capa_ganaderia "Capacitación en ganadería"
la var capa_proces    "Capacitación en conservación y procesamiento"
la var capa_produc    "Capacitación en producción y comercialización"

**Financiamiento 	
	
*¿Realizó gestiones para obtener un préstamo o crédito?	
	
tab p090
*¿Obtuvo el préstamo o crédito que gestionó?
tab p092

gen credito=(p092==1) if p090==1
la def si 1 "si" 0 "no"
la val credito  si
fre credito

*¿Cuál es la razón principal por la que no solicitó el crédito?
tab p096
	
	