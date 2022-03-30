
*Prof. Andrés Talavera 
*30/03/2021 

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

* Papa nativa 
table P001 if P024_03==2615 , c(sum P025) center row col

*Superficie sembrada de papa  

gen WSUP07_26=0
forvalues i=2610/2615 { 
replace WSUP07_26=P025 if P024_03==`i'
}

table P001 , c(sum WSUP07_26) center row col

****Resumen a nivel de unidades agropecuarias

collapse (sum) WSUP07_26 , ///
by( P001 P002 P003 P007X P008 NPRIN )
sort P001 P002 P003 P007X P008 NPRIN
save superficie_papa,replace 


*merge con REC 01 
global rec01 "D:\Indicadoressocioeconomicos\clase6\BASES CONSOLIDADAS"
merge 1:1 P001 P002 P003 P007X P008 NPRIN using "$rec01\01_IVCENAGRO_REC01_etiquetado"

table P001 if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum  WSUP07_26 )  format(%9.0f) center row col













*WSUP18 Superficie cultivada (has)
*Definición: Tierras bajo riego o secano con cultivos transitorios, permanentes o en barbecho.
*WSUP18= Σ P25 para P24_01= Nro. de orden (01-89),30, 31

gen WSUP18_26=0
forvalues i=01/89 { 
replace WSUP18_26=P025 if (P024_01==`i' & P024_03==2610 | P024_03==2611 |P024_03==2612 | P024_03==2613 | P024_03==2614 | P024_03==2615) 
}

tab P026,m

table P001 , c(sum WSUP07_26)  format(%9.0f) center row col
table P001 if P026!=., c(sum WSUP18_26)  format(%9.0f) center row col


****Resumen a nivel de unidades agropecuarias

collapse (sum) WSUP07_26 , ///
by( P001 P002 P003 P007X P008 NPRIN )
sort P001 P002 P003 P007X P008 NPRIN
save superficie_papa,replace 


global rec01 "D:\Indicadoressocioeconomicos\clase6\BASES CONSOLIDADAS"
merge 1:1 P001 P002 P003 P007X P008 NPRIN using "$rec01\01_IVCENAGRO_REC01_etiquetado"

table P001 if ((RESULTAD==1 | RESULTAD==2) & P019_01==.) , c(sum  WSUP07_26 )  format(%9.0f) center row col


