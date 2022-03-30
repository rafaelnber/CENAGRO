
***Consolidado del módulo 229 REC01***
***Censo Agropecuario 2012  
/*Variables de interés: tipo_rec p001  p002  p003	p007x p008  nprin 	wregion long_deci 	lat_deci p016 p017
p018	wpiso	wredhi	wp112	wp111	wp114	wp109	waltitud	wp115	p019
	p019_01	p020_01	p022	p022_01	resultado 	wsup01	wsup02	wsup02a	wsup08*/
	
***Pertenece: Bach. Andrés Talavera Cuya - Ciencias Económicas en Universidad Nacional Federico Villarreal
***Correo: atalaveracuya@gmail.com wsap : 947209660
***Espero que se refiera a mí de alguna manera cuando use estos programas si cree que lo han ayudado.
**********************************************************************************************************************
clear all
set more off
local censoagp "H:\proyecto2\censoagp\"
cd "`censoagp'"

use 01_IVCENAGRO_REC01.dta,clear

rename wp112 edad
rename wp111 sexo
rename wp114 edu
rename waltitud altitud
rename wp109 th
rename wp115 idioma

la var tipo_rec	"Tipo de registro"
la var 	p001	"Departamento"
la var 	p002	"Provincia"
la var 	p003	"Distrito"
la var 	p007x	"Sector de Enumeración Agropecuario (SEA)"
la var 	p008 	"Unidad Agropecuaria"
la var 	nprin 	"Número de cédula principal"
la var long_deci "Longitud de la coordenada geográfica del centroide de la SEA (grados decimales)"
la var lat_deci	"Latitud de la coordenada geográfica del centroide de la SEA (grados decimales)"
la var p017	"¿Sabe leer y escribir?"
la var p018	"Profesión: Código"
la var wpiso "Piso Altitudinal"
la var wredhi "Región Hidográfica"
la var wregion "Región natural"
la var edad	"Edad del Productor"
la var sexo	"Sexo del Productor"
la var edu "Nivel Educativo del Productor"
la var th "Tamaño del hogar del Productor"
la var altitud	"Altitud MSNM"
la var idioma	"Idioma o Lengua que aprendió hablar el Productor"
la var p019	"¿Cuántas parcelas o chacras trabaja o conduce en este distrito?"
la var p019_01	"Unidad Agropecuaria sin tierras"
la var p020_01	"¿Cuál es la superficie total de todas las parcelas o chacras que trabaja o conduce en este distrito?"
la var p022	"¿Trabaja o conduce parcelas en otros distritos?"
la var p022_01	"¿Cuántas parcelas conduce en otros distritos?"
la var resultado 	"Resultado final"
la var wsup01	"Superficie total de las parcelas o chacras que conduce o trabaja en el distrito (has) - WSup01"
la var wsup02	 " Superficie total de las parcelas(6 rangos)"
la var wsup02a	" Superficie total de las parcelas (8 rangos)"
la var wsup08	"Superficie cultivada (has) - WSup18"
la var p016	"Condición Jurídica"

*Departamentos del país
*http://www2.congreso.gob.pe/sicr/cendocbib/con4_uibd.nsf/82A7FAF59FF6C0ED05257F7E00711483/$FILE/LIBROGRADE_CENAGRO.pdf
*Procesamiento de GRADE
gen dpto= real(p001)
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" 7"Callao" 8"Cusco" ///
9"Huancavelica" 10"Huanuco" 11"Ica" 12"Junin" 13"La Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre de Dios" ///
18"Moquegua" 19"Pasco" 20"Piura" 21"Puno" 22"San Martin" 23"Tacna" 24"Tumbes" 25"Ucayali"	 
lab val dpto dpto 
la var dpto "Departamento"
tab p002 if dpto==21


*condición jurídica
fre p016
la var p016	"Su condición jurídica como productor/a es:"
la define cjuridica 1 "Persona natural" 2 "SAC" 3 "SAA" 4 "SRL" 5 "EIRL" 6 "Cooperativa agraria" 7 "Comunidad campesina" 8 "Comunidad nativa" 9 "Otra"
la val p016 cjuridica
fre p016

*lectura y escritura
la var p017 "¿Sabe leer y escribir?"
la define p017 1 "Si" 2 "No"
la val p017 p017
fre p017

*pisos altitudinales
la define wpiso 1 "Costa o Chala" 2"Yunga Fluvial" 3"Quechua"  4"Suni" 5 "Puna" 6"Janca" 7"Rupa Rupa (Selva alta)" 8"Omagua (Selva baja)" 9"Yunga Maritima"
la val wpiso wpiso 
fre wpiso

*Region natural
la define wregion 1"Costa" 2"Sierra" 3"Selva"
la val wregion wregion
fre wregion 


*región hidrográfica
la define wredhi 0 "Región Hidrográfica del Titicaca" 1"Región Hidrográfica del Pacifico" 4 "Región Hidrográfica del Amazonas"
la val wredhi wredhi
fre wredhi 

*resultado final de la encuesta
la define result 1 "Completa" 2 "Incompleta" 3 "Rechazo" 4 "Ausente"
la val resultado result 
fre resultado 

*tramos etarios
gen t_edad=.
replace t_edad=1 if edad<=18
replace t_edad=2 if edad>18 & edad<35
replace t_edad=3 if edad>34 & edad<65
replace t_edad=4 if edad>64
label define t_edad 1 "12 a 18 años" 2 "19 a 34 años" 3 "35 a 65 años" 4 "65 años o más"
label value t_edad t_edad
label variable t_edad "Tramos etarios"
fre t_edad

*sexo
la define sexo 1 "Hombre" 2"Mujer"
la val sexo sexo
fre sexo 

*educación
la define edu 1 "Sin nivel" 2"Inicial" 3"Primaria incompleta" 4"Primaria completa" ///
5"Secundaria incompleta" 6"Secundaria completa" 7"Superior no univ. incompleta" ///
8 "Superior no univ. completa" 9"Superior univ. incompleta" 10 "Superior univ. completa"  
la val edu edu 
fre edu 


*Tamaño del hogar
gen t_hogar=.
replace t_hogar=1 if th==1
replace t_hogar=2 if th==2
replace t_hogar=3 if th==3
replace t_hogar=4 if th==4
replace t_hogar=5 if th>4
label define t_hogar 1 "Hogar Unipersonal" 2 "2 intregrantes" 3 "3 integrantes" 4 "4 integrantes" 5 "5 o más integrantes del hogar"
label value t_hogar t_hogar
label variable t_hogar "Tamaño del Hogar"

*Idioma
la var idioma "¿El idioma o lengua con el que aprendió hablar fue?"
la define idioma 1 "Quechua" 2"Aymara" 3"Ashaninka" 4"Otra lengua nativa" 5"Castellano" 6"Idioma extranjero"
la val idioma idioma
fre idioma 


*Superficie total de las parcelas o chacras que conduce o trabaja en el distrito (has) (23 rangos)
la define wsup01 1 "Menos de 0.5 has" 2"De 0.5 a 0.9 has" 3"De 1.0 a 1.9 has" 4"De 2.0 a 2.9 has" ///
5"De 3.0 a 3.9 has" 6"De 4.0 a 4.9 has" 7"De 5.0 a 5.9 has" 8"De 6.0 a 9.9 has" ///
9"De 6.0 a 9.9 has" 10"De 15.0 a 19.9 has" 11"De 20.0 a 24.9 has" 12"De 25.0 a 29.9 has" ///
13"De 30.0 a 34.9 has" 14"De 35.0 a 39.9 has" 15"De 40.0 a 49.9 has" 16"De 50.0 a 99.9 has" ///
17"De 100.0 a 199.9 has" 18"De 200.0 a 299.9 has" 19"De 300.0 a 499.9 has" 20"De 500.0 a 999.9 has" ///
21"De 1000.0 a 2499.9 has" 22"De 2500.0 a 2999.9 has" 23"De 3000.0 a más has." 
la val wsup01 wsup01
fre wsup01 


*Superficie total de las parcelas o chacras que conduce o trabaja en el distrito (has) (6 rangos)
la define wsup02 1 "Menos de 0.5 has" 2"De 0.5 a 4.9 has" 3"De 5.0 a 9.9 has" ///
4"De 10.0 a 19.9 has" 5"De 20.0 a 49.9 has" 6"De 50.0 a Mas"  
la val wsup02 wsup02
fre wsup02 

*Superficie total de las parcelas o chacras que conduce o trabaja en el distrito (has) (8 rangos)
la define wsup02a 1"Menos de 0.5 has" 2"De 0.5 a 2.9 has" 3"De 3.0 a 4.9 has" ///
4"De 5.0 a 9.9 has" 5"De 10.0 a 19.9 has" 6"De 20.0 a 49.9 has" 7"De 50.0 a 99.9 has" ///
8"De 100.0 a Mas" 
la val wsup02a wsup02a
fre wsup02a 

*¿Trabaja o conduce parcelas en otros distritos?
la define p022 1"Si" 2"No"
la val p022 p022
fre p022

*COMPROBACIÓN. TOTAL DE PRODUCTORES
*-----------> https://www.inei.gob.pe/media/MenuRecursivo/publicaciones_digitales/Est/Lib1177/libro.pdf
*				"CARACTERÍSTICAS SOCIOECONÓMICAS DEL PRODUCTOR AGROPECUARIO EN EL PERÚ"

*TOTAL DE PRODUCTORES POR SEXO, SEGUN REGION NATURAL (PÁGINA 15)
use 01_IVCENAGRO_REC01.dta,clear 
keep if resultado==1 | resultado==2
rename wp111 sexo
tab sexo wregion if p016==1,m
tab sexo wregion if p016==1,col nofreq

*TOTAL DE PRODUCTORES AGROPECUARIOS POR SUPERFICIE QUE CONDUCE Y SEXO (PÁGINA 354)
use 01_IVCENAGRO_REC01.dta,clear 
keep if resultado==1 | resultado==2

gen Wsup02a=.
replace Wsup02a=1 if wsup02a==1 | wsup02a==2 | wsup02a==3 
replace Wsup02a=2 if wsup02a==4
replace Wsup02a=3 if wsup02a==5
replace Wsup02a=4 if wsup02a==6
replace Wsup02a=5 if wsup02a==7
replace Wsup02a=6 if wsup02a==8
la define Wsup02a 1"Menos de 5 has" ///
2"De 5.0 a 9.9 has" 3"De 10.0 a 19.9 has" 4"De 20.0 a 49.9 has" 5"De 50.0 a 99.9 has" ///
6"De 100.0 a Mas" 
la val Wsup02a Wsup02a
tab Wsup02a sexo if p016==1
tab Wsup02a sexo if p016==1,col nofreq


**revisar diccionario de variables:
*-----------> https://webinei.inei.gob.pe/anda_inei/index.php/catalog/235/data_dictionary



