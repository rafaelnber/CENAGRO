
***Consolidado del módulo 229 REC01***
***Censo Agropecuario 2012  
/*Variables de interés: tipo_rec p001  p002  p003	p007x p008  nprin 	wregion long_deci 	lat_deci p016 p017
p018	wpiso	wredhi	wp112	wp111	wp114	wp109	waltitud	wp115	p019
	p019_01	p020_01	p022	p022_01	resultado 	wsup01	wsup02	wsup02a	wsup08*/
	
***Pertenece: Bach. Andrés Talavera Cuya - Ciencias Económicas en Universidad Nacional Federico Villarreal
***Correo: atalaveracuya@gmail.com wsap : 947209660
***Espero que se refiera a mí de alguna manera cuando use estos programas si cree que lo han ayudado.

*********************************************************************************
*Paso 1: Descargando de la web del INEI, archivos zipeados y descomprimiéndolos
*https://blog.stata.com/2010/12/01/automating-web-downloads-and-file-unzipping/ 
clear all
local carptempo "H:\proyecto2\carptempo\"
local censoagp "H:\proyecto2\censoagp\"
cd "`carptempo'"	

*Nota i --->modulos
*	  j---->departamentos



*Del módulo 229 al 232
forvalues i = 229/232 {
	
    forvalues j=337/361 {
    copy http://iinei.inei.gob.pe/iinei/srienaho/descarga/DBF/`j'-Modulo`i'.zip `j'-Modulo`i'.zip
    unzipfile `j'-Modulo`i'.zip 
	erase `j'-Modulo`i'.zip
	}
}

*Del módulo 237 al 239
forvalues i = 237/239 {
	
    forvalues j=337/361 {
    copy http://iinei.inei.gob.pe/iinei/srienaho/descarga/DBF/`j'-Modulo`i'.zip `j'-Modulo`i'.zip
    unzipfile `j'-Modulo`i'.zip 
	erase `j'-Modulo`i'.zip
	}
}

************************************************************************************

*Paso 2: Convertir .dbf a .dta (Para Todos los departamentos y sólo para el primer módulo (modulo 229))

*https://www.statalist.org/forums/forum/general-stata-discussion/general/1347287-how-to-open-multiple-dbf-files-in-stata-or-how-to-convert-multpile-dbf-files-using-the-stat-transfer-command-lop
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1356879-working-with-macros-to-change-directory
*https://www.statalist.org/forums/forum/general-stata-discussion/general/1409950-loop-using-forvalues
*Robert Picard: https://www.statalist.org/forums/forum/general-stata-discussion/general/14244-how-to-append-all-excel-files-from-a-directory-plus-problem-with-local-macros

*El ejercicio sólo es para el módulo 229

clear all
local obs = 361
forvalues i=337/`obs' {

    local ouput "H:\proyecto2\censoagp" 
	global path "H:\proyecto2\carptempo"
	foreach topic in "`i'-Modulo229" {
    cd "$path/`topic'"
	inputst 01_IVCENAGRO_REC01.dbf
	save `ouput'/`i'_01_IVCENAGRO_REC01.dta, replace
	}
}

*************************************************************************************

*Paso 3: *Agregamos a una sola base de datos sólo variables de interés 
		 *y borramos archivos que no son de nuestro interés

*REVISADO:
*https://stackoverflow.com/questions/29414538/in-stata-how-can-i-append-to-a-local-varlist-during-a-loop
*h append

clear all

clear all
local carptempo "H:\proyecto2\carptempo\"
local censoagp "H:\proyecto2\censoagp\"
cd "`carptempo'"	


local vlist0  tipo_rec p001  p002  p003	p007x p008  nprin 	wregion long_deci 	lat_deci p016 p017	///
p018	wpiso	wredhi	wp112	wp111	wp114	wp109	waltitud	wp115	p019 ///
	p019_01	p020_01	p022	p022_01	resultado 	wsup01	wsup02	wsup02a	wsup08
use H:\proyecto2\censoagp\337_01_IVCENAGRO_REC01,clear
keep `vlist0'
forvalues i = 338(1)361 {
local vlist0 tipo_rec p001  p002  p003	p007x p008  nprin 	wregion long_deci 	lat_deci p016 p017	///
p018	wpiso	wredhi	wp112	wp111	wp114	wp109	waltitud	wp115	p019 ///
	p019_01	p020_01	p022	p022_01	resultado 	wsup01	wsup02	wsup02a	wsup08
append using "H:\proyecto2\censoagp/`i'_01_IVCENAGRO_REC01"  , keep(`vlist0')
}

save "H:\proyecto2\censoagp\01_IVCENAGRO_REC01.dta", replace


*Borramos los archivos que no son de nuestro interés. 
cd "H:\proyecto2\censoagp"
forvalues i = 337(1)361 {
erase `i'_01_IVCENAGRO_REC01.dta 
}
*************************************************************************************
	
