
************************************Censo Agropecuario 2012****************************************************  
***Agregados a nivel de distrito y piso altitudinal
***Pertenece: Bach. Andrés Talavera Cuya - Ciencias Económicas en Universidad Nacional Federico Villarreal
***Correo: atalaveracuya@gmail.com wsap : 923732307
***Espero que se refiera a mí de alguna manera cuando use estos programas si cree que lo han ayudado.
***************************************************************************************************************

cd "D:\Indicadoressocioeconomicos\clase6\BASES CONSOLIDADAS\"

***
***merge 
***

use 01_IVCENAGRO_REC01_etiquetado, clear

keep if (RESULTAD==1 | RESULTAD==2)
tab P101 sexo , col row
tab P016 P101

*Personas naturales asociados a cooperativas agrarias (asoc3003)
gen asoc3003=.
replace asoc3003=1 if (P102_01==1 & P016==1 & P101==1 & P102_01_==3003)
replace asoc3003=1 if (P102_02==2 & P016==1 & P101==1 & P102_02_==3003 & P102_01_~=3003)
replace asoc3003=1 if (P102_03==3 & P016==1 & P101==1 & P102_03_==3003 & P102_02_~=3003 & P102_01_~=3003)
tab asoc3003
*Personas naturales asociados a cooperativa agraria cafetalera (asoc3002)
gen asoc3002=.
replace asoc3002=1 if (P102_01==1 & P016==1 & P101==1 & P102_01_==3002)
replace asoc3002=1 if (P102_02==2 & P016==1 & P101==1 & P102_02_==3002 & P102_01_~=3002)
replace asoc3002=1 if (P102_03==3 & P016==1 & P101==1 & P102_03==3002 & P102_02_~=3002 & P102_01_~=3002)
tab asoc3002
*Personas naturales asociados a cooperativa alpaquera (asoc3001)
gen asoc3001=.
replace asoc3001=1 if (P102_01==1 & P016==1 & P101==1 & P102_01_==3001)
replace asoc3001=1 if (P102_02==2 & P016==1 & P101==1 & P102_02_==3001 & P102_01_~=3001)
replace asoc3001=1 if (P102_03==3 & P016==1 & P101==1 & P102_03==3001 & P102_02_~=3001 & P102_01_~=3001)
tab asoc3001

*Personas naturales asociados a OTRAS cooperativas (asoc3004)
gen asoc3004=.
replace asoc3004=1 if (P102_01==1 & P016==1 & P101==1 & P102_01_==3004)
replace asoc3004=1 if (P102_02==2 & P016==1 & P101==1 & P102_02_==3004 & P102_01_~=3004)
replace asoc3004=1 if (P102_03==3 & P016==1 & P101==1 & P102_03_==3004 & P102_02_~=3004 & P102_01_~=3004)
tab asoc3004

la var asoc3001 "Personas naturales asociados a cooperativa alpaquera"
la var asoc3002 "Personas naturales asociados a cooperativa agraria cafetalera"
la var asoc3003 "Personas naturales asociados a cooperativas agrarias"
la var asoc3004 "Personas naturales asociados a otras cooperativas"


*****
*****
*****
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

*Menos de 5ha
gen Wsup02a_1=.
replace Wsup02a_1=1 if Wsup02a==1
replace Wsup02a_1=0 if (Wsup02a>1 & Wsup02a<=6)
tab Wsup02a_1,m
fre Wsup02a
*De 5.0 a 9.9 has
gen Wsup02a_2=.
replace Wsup02a_2=1 if Wsup02a==2
replace Wsup02a_2=0 if (Wsup02a==1 | Wsup02a>=3 & Wsup02a<=6) 
tab Wsup02a_2,m
fre Wsup02a
*De 10.0 a 19.9 has
gen Wsup02a_3=.
replace Wsup02a_3=1 if Wsup02a==3
replace Wsup02a_3=0 if (Wsup02a==1 | Wsup02a==2 | (Wsup02a>=4 & Wsup02a<=6)) 
tab Wsup02a_3,m
fre Wsup02a
*De 20.0 a 49.9 has
gen Wsup02a_4=.
replace Wsup02a_4=1 if Wsup02a==4
replace Wsup02a_4=0 if (Wsup02a==1 | Wsup02a==2 | Wsup02a==3 | (Wsup02a>4 & Wsup02a<=6)) 
tab Wsup02a_4,m
fre Wsup02a
*De 50.0 a 99.9 has
gen Wsup02a_5=.
replace Wsup02a_5=1 if Wsup02a==5
replace Wsup02a_5=0 if (Wsup02a==1 | Wsup02a==2 | Wsup02a==3 | Wsup02a==4 | Wsup02a==6)  
tab Wsup02a_5,m
fre Wsup02a
*De 100.0 a Mas
gen Wsup02a_6=.
replace Wsup02a_6=1 if Wsup02a==6
replace Wsup02a_6=0 if (Wsup02a>=1 & Wsup02a<=5)  
tab Wsup02a_6,m
fre Wsup02a
*Unidad Agropecuaria sin tierra
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

*****Agregados
gen provincia=P001+P002
gen distrito=P001+P002+P003
collapse (sum) productores (sum) mujer (sum) hombre (sum) leeyescri ///
(sum) persn (sum) sac (sum) saa (sum) srl (sum) eirl  (sum) coopagra ///
(sum) comcamp (sum) comnat (sum) otra (sum) Wsup02a_1 (sum) Wsup02a_2 ///
(sum) Wsup02a_3 (sum) Wsup02a_4 (sum) Wsup02a_5 (sum) Wsup02a_6 ///
(sum) sintierra (sum) sagrope (sum) sagri (sum) snoagri (sum) asoc3001 ///
(sum) asoc3002 (sum) asoc3003 (sum) asoc3004 , ///
by(dpto provincia distrito WPISO)
order dpto provincia distrito WPISO productores mujer hombre leeyescri
sort dpto provincia distrito


