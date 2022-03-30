
************************************Censo Agropecuario 2012****************************************************  
***Resultados - Verificación con documentos oficiales
	*caracteristicas socioeconomicas del productor agropecuario
		*https://www.inei.gob.pe/media/MenuRecursivo/publicaciones_digitales/Est/Lib1177/libro.pdf
	*jm20131114_conferencia viceministro MINAGRI
		*http://www.iimp.org.pe/pptjm/jm20131114_conferencia.pdf
		
***Pertenece: Bach. Andrés Talavera Cuya - Ciencias Económicas en Universidad Nacional Federico Villarreal
***Correo: atalaveracuya@gmail.com wsap : 923732307
***Espero que se refiera a mí de alguna manera cuando use estos programas si cree que lo han ayudado.
***************************************************************************************************************
clear all
set more off 
cd "D:\Indicadoressocioeconomicos\clase6\BASES CONSOLIDADAS"
use 01_IVCENAGRO_REC01_etiquetado, clear
*ssc install asdoc, replace



*DEPARTAMENTOS
drop dpto 
gen dpto=real(P001)
label define dpto1 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" 7"Callao" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" /*
*/12"Junin" 13"La_Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre_de_Dios" 18"Moquegua" 19"Pasco" 20"Piura" 21"Puno" 22"San_Martin" /*
*/23"Tacna" 24"Tumbes" 25"Ucayali" 
lab val dpto dpto1 
la var dpto "Departamento"


***
*PROVINCIA IV CENAGRO 2012 
import excel "D:\Indicadoressocioeconomicos\clase6\BIBLIOGRAFIA\correon43212019ineiotdcdigoubigeoytablasdecu\IV CENAGRO - Tabla_Provincias.xlsx", sheet("Prov") cellrange(B4:D199) firstrow clear

rename CÓDIGODEPARTAMENTO P001 
rename CÓDIGO P002 
rename TÍTULO NOMBRE_PROV
save PROVINCIAS_IVCENAGRO,replace 


***
*DISTRITOS IV CENAGRO 2012  

import excel "D:\Indicadoressocioeconomicos\clase6\BIBLIOGRAFIA\correon43212019ineiotdcdigoubigeoytablasdecu\IV CENAGRO - Tabla_Distritos.xlsx", sheet("Distritos") cellrange(B4:E1841) firstrow clear

rename CÓDIGODEPARTAMENTO P001 
rename CÓDIGOPROVINCIA P002
rename CÓDIGO P003 
rename TÍTULO NOMBRE_DIST 

save DISTRITOS_IVCENAGRO,replace 


*MERGE CON LISTA DE PROVINCIAS Y DISTRITOS 
use 01_IVCENAGRO_REC01_etiquetado
merge m:1 P001 P002 using PROVINCIAS_IVCENAGRO
drop _merge  
merge m:1 P001 P002 P003 using DISTRITOS_IVCENAGRO
drop _merge 


********************************************
*UNIDADES AGROPECUARIAS 
*Conferencia viceministro minagri 2012
*pág. 7   
tab dpto if (RESULTAD==1 | RESULTAD==2)
tab WREGION if (RESULTAD==1 | RESULTAD==2)
********************************************



***************************************************************************
*PERÚ:UNIDADES AGROPECUARIAS CON TIERRA 2012 página 9
tab P016 if (RESULTAD==1 | RESULTAD==2) & P019_01!=1
*a/ La información excluye a las unidades agropecuarias abandonadas e información no especificada.
*Nota: La información para ambos Censos considera a las unidades agropecuarias con tierra.
**************************************************************************

*Superficie agropecuaria total por condición jurídica *unidades agricolas con tierra (PÁGINA 09) 
table P016 if ((RESULTAD==1 | RESULTAD==2) & P019_01!=1) , c(sum P020_01) format(%9.0f) center row col

**************************************************************************
*** Unidades agropecuarias a nivel de distritos*************************** 
*DEPARTAMENTO: LIMA
*PROVINCIA: CAÑETE     
tab NOMBRE_DIST if (RESULTAD==1 | RESULTAD==2) & dpto==15 & P002=="05" /*Provincia de cañete */ 
tab WREGION if (RESULTAD==1 | RESULTAD==2) & dpto==15 & P002=="05" /*Provincia de cañete */ 

*Unidades con tierra 
tab P016 if (RESULTAD==1 | RESULTAD==2) & P019_01!=1 & dpto==15 & P002=="05" /*Provincia de cañete */ 

*Superficie agropecuaria total unidades agricolas con tierra 
table NOMBRE_DIST if ((RESULTAD==1 | RESULTAD==2) & P019_01!=1) & dpto==15 & P002=="05" , c(sum P020_01) format(%9.0f) center row col

**************************************************************************
**************************************************************************

exit 


*Superficie agropecuaria total por condición jurídica *unidades agricolas con tierra (PÁGINA 09) 
table P016 if ((RESULTAD==1 | RESULTAD==2) & P019_01!=1) , c(sum P020_01) format(%9.0f) center row col


****************************************************************************
****************************************************************************












*PERÚ:PRODUCTORES/AS AGROPECUARIOS POR GRUPOS DE EDAD, 2012 página 15
tab t_edad if P016==1 
*Nota: Productor agropecuario registrado como persona natural

*Total de productores por sexo y region página 85
tab sexo WREGION if P016==1, col 


*


*Superficie total de las parcelas y sexo del productor PÁGINA 354
tab Wsup02a sexo if (RESULTAD==1 | RESULTAD==2) & P016==1
tab Wsup02a sexo if (RESULTAD==1 | RESULTAD==2) & P016==1, row nofreq 
tab Wsup02a sexo if (RESULTAD==1 | RESULTAD==2) & P016==1, col nofreq 


tab Wsup02a if (RESULTAD==1 | RESULTAD==2)


*Identificar cuantos productores agrarios habían y qué porcentaje se encontraba en la SELVA 
*(selva significa TODOS AQUELLOS DISTRITOS QUE ESTÉN EN SELVA ALTA, SELVA BAJA O YUNGA FLUVIAL)
/*fre WPISO
gen selva=.
replace selva=1 if WPISO==2 | WPISO==7 | WPISO==8
replace selva=0 if WPISO==1 | WPISO==3 | WPISO==4 | WPISO==5 | WPISO==6 | WPISO==9
la define selva 1 "Selva: Yunga Fluvial, Selva Baja, Selva Alta" 0 "Otra región del país"
la val selva selva*/
tab P016 selva  if (RESULTAD==1 | RESULTAD==2) & P019_01!=1, row 

*-Cuantos productores asociados a cooperativas agrarias/agricolas/agroindustriales habian. Y cuántos están en la SELVA (página 9)
tab P016 selva if (RESULTAD==1 | RESULTAD==2) & P019_01!=1, col 

***********
*UNIDADES AGROPECUARIAS Conferencia Viceministro MINAGRI (página 7)
*por región natural
tab WREGION if (RESULTAD==1 | RESULTAD==2)
*por departamento Conferencia Viceministro MINAGRI (página 7)
tab dpto if (RESULTAD==1 | RESULTAD==2)

*Unidades agropecuarias con tierra (página 9, INEI)
tab dpto if ((RESULTAD==1 | RESULTAD==2) & P019_01==.)

*Unidad agropecuaria con tierra y registrado como persona natural (PÁGINA 293, inei)
tab dpto if ((RESULTAD==1 | RESULTAD==2) & P016==1 & P019_01!=1)

*Superficie agropecuaria total por region natural *unidades agricolas con tierra y registrados como persona natural (PÁGINA 293, inei)
table WREGION if ((RESULTAD==1 | RESULTAD==2) & P016==1 & P019_01!=1) , c(sum P020_01)  format(%9.0f) center row col

*Superficie agropecuaria total por region natural *unidades agricolas con tierra
table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum P020_01)  format(%9.0f) center row col

*Superficie agropecuaria total por departamentos **unidades agricolas con tierra
table dpto if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum P020_01)  format(%9.0f) center row col


*Superficie agropecuaria total, superficie agricola: secano y bajo riego   

table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum P020_01 sum WSUP03 sum WSUP03B sum WSUP03A )  format(%9.0f) center row col


*Superficie agropecuaria total, superficie agricola: secano y bajo riego   

* Superficie agropecuaria total: sum P020_01 ok
	*Superficie agricola:  WSUP03 ok
		*Superficie con cultivo: WSUP03 - (WSUP08 + WSUP09) ok
					
		*Superficie sin cultivo: WSUP08 WSUP09 ok
			*Tierras en barbecho WSUP08 OK
				*Superficie sin cultivo y va a ser sembrada hasta Julio 2013 WSUP08A    OK
				*Superficie sin cultivo y NO va a ser sembrada hasta Julio 2013 WSUP08B OK
			*Tierras en descanso WSUP09 OK
			
	*Superficie no agricola: (WSUP04 + WSUP05) ok
		*Pastos naturales WSUP14 ok
		*Montes y bosques WSUP17 ok
		*Otro uso: (WSUP04 + WSUP05) - (WSUP14 + WSUP17)
table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum P020_01 sum WSUP03 sum WSUP04 sum WSUP05 )  format(%9.0f) center row col

*table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum WSUP06 sum WSUP07 sum WSUP08 sum WSUP08A sum WSUP08B sum WSUP09 sum WSUP10 )  format(%9.0f) center row col

table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum WSUP14 sum WSUP17)  format(%9.0f) center row col

table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==. ) , c(sum WSUP07 sum WSUP10 sum WSUP13)  format(%9.0f) center row col
		
*Superficie sin cultivo: WSUP08 WSUP09		
table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum WSUP08 sum WSUP09)  format(%9.0f) center row col
	
*Superficie Tierras en barbecho VA SER SEMBRADA Y NO VA SER SEMBRADA WSUP08A Y WSUP08B 	
table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum WSUP08A sum WSUP08B)  format(%9.0f) center row col
			
			
*superficie agricola BAJO RIEGO   
table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum WSUP03B sum WSUP03A )  format(%9.0f) center row col

*SUPERFICIE AGRICOLA CON CULTIVO 
gen WSUP08negat=-1*WSUP08
gen WSUP09negat=-1*WSUP09
egen ccultivo=rowtotal(WSUP03 WSUP08negat WSUP09negat)

table WREGION if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum ccultivo )  format(%9.0f) center row col
table dpto if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum ccultivo )  format(%9.0f) center row col

*SUPERFICIE AGRICOLA CON CULTIVO, POR DEPARTAMENTO
bysort dpto:egen total=total(ccultivo) if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) 
bysort dpto leeyescri: egen leeyescri_total=total(ccultivo) if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) 
bysort dpto:gen pc_total= (leeyescri_total/ total)*100
*table
bysort dpto: table leeyescri, cont(sum ccultivo mean pc_total ) format(%-13.0fc)
drop total leeyescri_total pc_total


*********************************************************************************************
*Crear una base de datos con información AGREGADA a nivel de distritos 
*********************************************************************************************

clear all
cd "D:\Indicadoressocioeconomicos\clase6\BASES CONSOLIDADAS"
use 01_IVCENAGRO_REC01_etiquetado, clear
keep if (RESULTAD==1 | RESULTAD==2)

gen productores=.
replace productores=1 if P016>=1 & P016<=9
replace productores=0 if P016==. & P016>9
tab productores
tab P016

gen mujer=.
replace mujer=1 if sexo==2
replace mujer=0 if sexo==1
tab mujer

gen hombre=.
replace hombre=1 if sexo==1
replace hombre=0 if sexo==2
tab hombre
tab sexo

gen leeyescri=.
replace leeyescri=1 if P017==1
replace leeyescri=0 if P017==2
tab leeyescri
tab P017  

**persona natural y juridica
gen persn=.
replace persn=1 if P016==1
replace persn=0 if (P016==. & (P016>1 & P016<=9))
tab persn
fre P016
la var persn "Persona natural"
 
gen sac=.
replace sac=1 if P016==2
replace sac=0 if (P016==. & (P016>2 & P016<=9))
tab sac
fre P016
la var sac "Sociedad Anónima Cerrada"

gen saa=.
replace saa=1 if P016==3
replace saa=0 if (P016==. & (P016>3 & P016<=9))
tab saa
fre P016
la var saa "Sociedad Anónima Abierta"

gen srl=.
replace srl=1 if P016==4
replace srl=0 if (P016==. & (P016>4 & P016<=9))
tab srl
fre P016
la var srl "Sociedad de responsabilidad limitada (SRL)"

gen eirl=.
replace eirl=1 if P016==5
replace eirl=0 if (P016==. & (P016>5 & P016<=9))
tab eirl
fre P016
la var eirl "Empresa individual de responsabilidad limitada (EIRL)"

gen coopagra=.
replace coopagra=1 if P016==6	
replace coopagra=0 if (P016==. & (P016>6 & P016<=9))
tab coopagra
fre P016
la var coopagra "Cooperativa agraria"

gen comcamp=.
replace comcamp=1 if P016==7	
replace comcamp=0 if (P016==. & (P016>7 & P016<=9))
tab comcamp
fre P016
la var comcamp "Comunidad campesina"

gen comnat=.
replace comnat=1 if P016==8	
replace comnat=0 if (P016==. & (P016>8 & P016<=9))
tab comnat
fre P016
la var comnat "Comunidad nativa"

gen otra=.
replace otra=1 if P016==9	
replace otra=0 if (P016==. & P016>9)
tab otra
fre P016
la var otra "Otra"


***tramos de superficie agricola

fre Wsup02a if (RESULTAD==1 | RESULTAD==2)
*Los missing son productores sin tierra agricola (UNIDADES AGROPECUARIAS)

gen Wsup02a_1=.
replace Wsup02a_1=1 if Wsup02a==1
replace Wsup02a_1=0 if (Wsup02a>1 & Wsup02a<=6)
tab Wsup02a_1,m
fre Wsup02a

gen Wsup02a_2=.
replace Wsup02a_2=1 if Wsup02a==2
replace Wsup02a_2=0 if (Wsup02a==1 | Wsup02a>=3 & Wsup02a<=6) 
tab Wsup02a_2,m
fre Wsup02a

gen Wsup02a_3=.
replace Wsup02a_3=1 if Wsup02a==3
replace Wsup02a_3=0 if (Wsup02a==1 | Wsup02a==2 | (Wsup02a>=4 & Wsup02a<=6)) 
tab Wsup02a_3,m
fre Wsup02a

gen Wsup02a_4=.
replace Wsup02a_4=1 if Wsup02a==4
replace Wsup02a_4=0 if (Wsup02a==1 | Wsup02a==2 | Wsup02a==3 | (Wsup02a>4 & Wsup02a<=6)) 
tab Wsup02a_4,m
fre Wsup02a

gen Wsup02a_5=.
replace Wsup02a_5=1 if Wsup02a==5
replace Wsup02a_5=0 if (Wsup02a==1 | Wsup02a==2 | Wsup02a==3 | Wsup02a==4 | Wsup02a==6)  
tab Wsup02a_5,m
fre Wsup02a

gen Wsup02a_6=.
replace Wsup02a_6=1 if Wsup02a==6
replace Wsup02a_6=0 if (Wsup02a>=1 & Wsup02a<=5)  
tab Wsup02a_6,m
fre Wsup02a

gen sintierra=.
replace sintierra=1 if P019_01==1
replace sintierra=0 if (Wsup02a>=1 & Wsup02a<=6)
tab sintierra,m
fre P019_01
fre Wsup02a

*Superficie (has)
egen sagri=rowtotal(WSUP03) if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) 		//Superficie agricola 
egen snoagri=rowtotal(WSUP04 WSUP05) if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) //Superficie no agricola
egen sagrope=rowtotal(sagri snoagri) //Superficie agropecuaria total

/*
****Resumen a nivel de pisos altitudinales
gen provincia=P001+P002
gen distrito=P001+P002+P003
collapse (sum) productores (sum) mujer (sum) hombre (sum) leeyescri ///
(sum) persn (sum) sac (sum) saa (sum) srl (sum) eirl  (sum) coopagra ///
(sum) comcamp (sum) comnat (sum) otra (sum) Wsup02a_1 (sum) Wsup02a_2 ///
(sum) Wsup02a_3 (sum) Wsup02a_4 (sum) Wsup02a_5 (sum) Wsup02a_6 (sum) sintierra ///
(sum) sagrope (sum) sagri (sum) snoagri , ///
by(dpto provincia distrito WPISO)
order dpto provincia distrito WPISO productores mujer hombre leeyescri
sort dpto provincia distrito

sort dpto provincia distrito 
save consolidado,replace 

*/


****Resumen a nivel de distritos 
gen provincia=P001+P002
gen distrito=P001+P002+P003
collapse (sum) productores (sum) mujer (sum) hombre (sum) leeyescri ///
(sum) persn (sum) sac (sum) saa (sum) srl (sum) eirl  (sum) coopagra ///
(sum) comcamp (sum) comnat (sum) otra (sum) Wsup02a_1 (sum) Wsup02a_2 ///
(sum) Wsup02a_3 (sum) Wsup02a_4 (sum) Wsup02a_5 (sum) Wsup02a_6 (sum) sintierra ///
(sum) sagrope (sum) sagri (sum) snoagri , ///
by(dpto provincia distrito)
order dpto provincia distrito productores mujer hombre leeyescri
sort dpto provincia distrito

sort dpto provincia distrito 
save consolidado,replace 


import excel "D:\Indicadoressocioeconomicos\clase6\BIBLIOGRAFIA\correon43212019ineiotdcdigoubigeoytablasdecu\IV CENAGRO - Tabla_Distritos.xlsx", sheet("Distritos") cellrange(B4:E1841) firstrow clear

rename CÓDIGODEPARTAMENTO dep
rename CÓDIGOPROVINCIA prov
rename CÓDIGO dist 
rename TÍTULO nombr_dist 

gen distrito=dep+prov+dist 

sort distrito 
save ubigeo2012,replace 


use consolidado 
merge 1:1 distrito using ubigeo2012
keep if _merge==3 


***grafico 

