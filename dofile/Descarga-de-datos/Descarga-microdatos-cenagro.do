*DESCARGA DE DATOS CENAGRO. 
*Autor: Andrés Talavera Cuya 
*21/02/2022
*-------------------------------------------*

** Descarga **
*Ejecute con Stata versión 13.

clear all
set more off 
global ubicac   "D:\Dropbox\BASES\CENAGRO\"
global dataset  "$ubicac\dataset" 
global dofile   "$ubicac\dofile"

*codigo de departamentos
clear 
input int codenc str20 departamento
337	"Amazonas"
338	"Ancash"
339	"Apurimac"
340	"Arequipa"
341 "Ayacucho"
342	"Cajamarca"
343	"Callao"
344	"Cusco"
345	"Huancavelica"
346	"Huanuco"
347	"Ica"
348	"Junin"
349	"La Libertad"
350	"Lambayeque"
351	"Lima"
352	"Loreto"
353	"Madre de Dios"
354	"Moquegua"
355 "Pasco"
356 "Piura"
357 "Puno"
358 "San Martin"
359 "Tacna"
360 "Tumbes"
361 "Ucayali"
end

**matrix codigo de CENAGRO 
mkmat codenc, mat(CENAGRO)
mat list CENAGRO
 exit 

if 1==1{
	mat MCENAGRO=J(25,11,0)
	forvalues i=1/25 {
	mat MCENAGRO[`i',1]=(229,230,231,232,233,234,235,236,237,238,239)
	}

}
mat list CENAGRO
mat list MCENAGRO 
 


global url http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS/


forvalues i=1/25{

	cd "$dataset"
	cap mkdir `i'
	cd `i'

	cap mkdir "Download"
	cd "Download"

	scalar r_cenagro=CENAGRO[`i',1]
		
		forvalue j=1/11{
		scalar r_mcenagro=MCENAGRO[`i',`j']
		local dep=r_cenagro
		local mod=r_mcenagro		   
		display "`dep'"  " " "`mod'"			   
		
		cap copy "$url/`dep'-Modulo`mod'.zip" `dep'-Modulo`mod'.zip 
		cap unzipfile `dep'-Modulo`mod'.zip, replace
		cap erase `dep'-Modulo`mod'.zip
		
					   }
		
		} 
 

exit 
*Colocar data en files 		
global Inicial "$dataset\Inicial"
cap mkdir "$Inicial"
cd "$Inicial"
global spss "$dataset\Inicial\\spss"
cap mkdir "$spss"


forvalues i=337/361{


	local i = `i'+1-337
	
	cd "$dataset"

	cd `i'

	cd "Download"


	scalar r_cenagro=CENAGRO[`i',1]
	forvalue j=1/11{
		scalar r_mcenagro=MCENAGRO[`i',`j']
		local dep=r_cenagro
		local mod=r_mcenagro		   
		display "`dep'"  " " "`mod'"	
		display "`dep'"  " " "`mod'"	
		
		cap copy "`dep'-Modulo`mod'\\01_IVCENAGRO_REC01.sav" "$spss\\rec01_`dep'.sav"
		cap copy "`dep'-Modulo`mod'\\02_IVCENAGRO_REC01A.sav" "$spss\\rec01a_`dep'.sav"
		cap copy "`dep'-Modulo`mod'\\03_IVCENAGRO_REC02.sav" "$spss\\rec02_`dep'.sav"	
		cap copy "`dep'-Modulo`mod'\\07_IVCENAGRO_REC04.sav" "$spss\\rec04_`dep'.sav"
		cap copy "`dep'-Modulo`mod'\\09_IVCENAGRO_REC04B.sav" "$spss\\rec04b_`dep'.sav"		
			
		
		            }
		} 
 
*Ejecute con Stata versión 16 a más 
*---------------------------------------------------------------
*Transformar REC 01 
*---------------------------------------------------------------
global rec01 "$dataset\Inicial\\rec01"
cap mkdir "$rec01"

forvalue i =337/361{


cd "$spss"


	local allfiles : dir "." files "rec01_`i'.sav"  
	foreach f of local allfiles {
		local g0=subinstr("`f'","rec01_", "",.)
		local g1=subinstr("`g0'",".sav", "",.)
		local g2=subinstr("`g1'","  ", "",.)
		local g3=subinstr("`g2'"," `i'", "",.)
		display " ------------------Año: `g3' -----------------"			
		import spss using "`f'",case(lower) clear
		saveold "$rec01\\`g3'.dta", replace
	}

}

cd "$rec01"
use 337,clear 
forvalues dep=338/361 {
append using  `dep'.dta
}
save rec01,replace 

forvalues dep=337/361 {
erase `dep'.dta
}
 

***
*---------------------------------------------------------------
*Transformar REC 04
*---------------------------------------------------------------
global rec04 "$dataset\Inicial\\rec04"
cap mkdir "$rec04"

forvalue i =337/361{


cd "$spss"


	local allfiles : dir "." files "rec04_`i'.sav"  
	foreach f of local allfiles {
		local g0=subinstr("`f'","rec04_", "",.)
		local g1=subinstr("`g0'",".sav", "",.)
		local g2=subinstr("`g1'","  ", "",.)
		local g3=subinstr("`g2'"," `i'", "",.)
		display " ------------------Año: `g3' -----------------"			
		import spss using "`f'",case(lower) clear
		saveold "$rec04\\`g3'.dta", replace
	}

}

cd "$rec04"
use 337,clear 
forvalues dep=338/361 {
append using  `dep'.dta
}
save rec04,replace 

forvalues dep=337/361 {
erase `dep'.dta
}




***
*---------------------------------------------------------------
*Transformar REC 04 B
*---------------------------------------------------------------
global rec04b "$dataset\Inicial\\rec04b"
cap mkdir "$rec04b"

forvalue i =337/361{


cd "$spss"


	local allfiles : dir "." files "rec04b_`i'.sav"  
	foreach f of local allfiles {
		local g0=subinstr("`f'","rec04b_", "",.)
		local g1=subinstr("`g0'",".sav", "",.)
		local g2=subinstr("`g1'","  ", "",.)
		local g3=subinstr("`g2'"," `i'", "",.)
		display " ------------------Año: `g3' -----------------"			
		import spss using "`f'",case(lower) clear
		saveold "$rec04b\\`g3'.dta", replace
	}

}

cd "$rec04b"
use 337,clear 
forvalues dep=338/361 {
append using  `dep'.dta
}
save rec04b,replace 

forvalues dep=337/361 {
erase `dep'.dta
}


*---------------------------------------------------------------
*Transformar REC 01A 
*---------------------------------------------------------------
global rec01a "$dataset\Inicial\\rec01a"
cap mkdir "$rec01a"

forvalue i =337/361{


cd "$spss"


	local allfiles : dir "." files "*`i'.sav"  
	foreach f of local allfiles {
		local g0=subinstr("`f'","rec01a_", "",.)
		local g1=subinstr("`g0'",".sav", "",.)
		local g2=subinstr("`g1'","  ", "",.)
		local g3=subinstr("`g2'"," `i'", "",.)
		display " ------------------Año: `g3' -----------------"			
		import spss using "`f'",case(lower) clear
		saveold "$rec01\\`g3'.dta", replace
	}

}

cd "$rec01a"
use 337,clear 
forvalues dep=338/361 {
append using  `dep'.dta
}
save rec01a,replace 

forvalues dep=337/361 {
erase `dep'.dta
}

*---------------------------------------------------------------
*Transformar REC 02 
*---------------------------------------------------------------
global rec02 "$dataset\Inicial\\rec02"
cap mkdir "$rec02"

forvalue i =337/361{


cd "$spss"


	local allfiles : dir "." files "rec02_`i'.sav"  
	foreach f of local allfiles {
		local g0=subinstr("`f'","rec02_", "",.)
		local g1=subinstr("`g0'",".sav", "",.)
		local g2=subinstr("`g1'","  ", "",.)
		local g3=subinstr("`g2'"," `i'", "",.)
		display " ------------------Año: `g3' -----------------"			
		import spss using "`f'",case(lower) clear
		saveold "$rec02\\`g3'.dta", replace
	}

}

cd "$rec02"
use 337,clear 
forvalues dep=338/361 {
append using  `dep'.dta
}
save rec02,replace 

forvalues dep=337/361 {
erase `dep'.dta
}
 
