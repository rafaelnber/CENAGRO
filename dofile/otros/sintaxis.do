
*PRODUCCIÓN DE CAFE - CENAGRO 2012 a nivel distrital 
*26/03/2021

****REC 01 ****

clear all
set more off 

global base "D:\Indicadoressocioeconomicos\clase6\BASES CONSOLIDADAS\REC01"
cd "$base"
!rmdir "$base"  /s /q

forvalues i=337/361 {
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS/`i'-Modulo229.zip" `i'-Modulo229.zip,replace 
unzipfile  `i'-Modulo229.zip,replace 

import spss using `i'-Modulo229/01_IVCENAGRO_REC01.sav,clear 
save REC01_`i',replace 
erase `i'-Modulo229.zip
shell rd "`i'-Modulo229" /s /q
}

use REC01_337,clear 
forvalues i=337/361 { 
append using REC01_`i' 
}
br 


*¿NUMERO DE UNIDADES AGROPECUARIAS? 
keep if P019!=.
tab P016,m  
keep if WP112>=18 & P016 == 1
*histogram  WSUP01
tab P001 if (RESULTADO==1 | RESULTADO==2)
tab WREGION if (RESULTADO==1 | RESULTADO==2)
********************************************

*P022 Trabaja parcelas ubicadas en otros distritos
*1 si
*2 no 

tab P022,m

*P022_01 Número de parcelas que trabaja o conduce en otros distritos (Si P22 = 1)
sum P022_01 if   P022==1 
keep if P022_01==0 &  P022==1



histogram P019
keep if P019<=25
histogram P019
tab WSUP01,m 
exit 


********ME DOY ***


****REC 02 ****

clear all
set more off 

global base "D:\Indicadoressocioeconomicos\clase6\BASES CONSOLIDADAS\REC02"
cd "$base"
!rmdir "$base"  /s /q

forvalues i=337/361 {

copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS/`i'-Modulo231.zip" `i'-Modulo231.zip,replace 
unzipfile  `i'-Modulo231.zip,replace 

import spss using `i'-Modulo231/03_IVCENAGRO_REC02.sav,clear 
save REC02_`i',replace 
erase `i'-Modulo231.zip
shell rd "`i'-Modulo231" /s /q
}

*https://www.statalist.org/forums/forum/general-stata-discussion/general/1310900-deleting-a-folder 

use REC02_337,clear 
forvalues i=337/361 { 
append using REC02_`i' 
}
br 

******************

**Superficie de Principales Cultivos 
   *Cultivos Transitorios
    *PAPA

*2610 PAPA AMARGA
*2611 PAPA AMARILLA
*2612 PAPA BLANCA
*2613 PAPA COLOR
*2614 PAPA HUAYRO
*2615 PAPA NATIVA

*P025: cultivo: Superficie sembrada en ha.

*Superficie sembrada de papa  

gen WSUP07=0
forvalues i=2610/2615 { 
replace WSUP07=P025 if P024_03==`i'
}

table P001 , c(sum WSUP07)  format(%9.0f) center row col

global rec01 "D:\Indicadoressocioeconomicos\clase6\BASES CONSOLIDADAS"
merge m:1 P001 P002 P003 P007X P008 NPRIN using "$rec01\01_IVCENAGRO_REC01_etiquetado" 
keep if RESULTAD==1 | RESULTAD==2 

table P001 , c(sum WSUP07)  format(%9.0f) center row col

. tempfile f

. di "`f'"
C:\Users\hpeng\AppData\Local\Temp\ST_47a8_000001.tmp

* https://www.statalist.org/forums/forum/general-stata-discussion/general/1533808-error-message-i-o-error-writing-dta-file

 *CODIGO DE PRINCIPALES CULTIVOS 
*CAFE 1203

*PAPA
*2610 PAPA AMARGA
*2611 PAPA AMARILLA
*2612 PAPA BLANCA
*2613 PAPA COLOR
*2614 PAPA HUAYRO
*2615 PAPA NATIVA

*MAIZ 

*2107 MAIZ AMARILLO DURO
*2108 MAIZ AMILACEO
*2109 MAIZ CHOCLO
*2110 MAIZ MORADO
*2706 MAIZ CHALA

*2101 ARROZ


*P028 ¿Cuál es el destino de la mayor parte de la producción?

tab P028

*************
br P025 P024_01

*Superficie agricola 
*WSUP03= Σ P25 para P24_01= Nro. de orden(01-89),30,31,324

gen WSUP03=0
forvalues i=1/89 { 
replace WSUP03=P025 if P024_01==`i'
}

table P001 if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum P020_01 sum WSUP03 sum WSUP03B sum WSUP03A )  format(%9.0f) center row col

/*
copy "http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS/351-Modulo232.zip" 351-Modulo232.zip
unzipfile  351-Modulo232.zip,replace 
import spss using 351-Modulo232/04_IVCENAGRO_REC02A.sav,clear 
*/

clear 