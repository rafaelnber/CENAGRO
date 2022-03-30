
***Número de agricultores, 2012***
clear all
use "D:\DATA\Trabajos_Stata\CENAGRO\IVCENAGRO\02 Base de Datos\IV CENAGRO - STATA\Departamentos\09\rec01.dta" 
keep if p002=="02" | p002=="03"
keep if resultado==1
keep if p016==1
gen id=p001+p002+p003
gen temp=1
bysort id: egen agropecuario=total(temp)

**Agrícolas 2012**

tab p019_01, miss
gen agrario=(p019_01==.)
tab agrario
tab agrario p019_01, miss

label def agrario 1 "Tiene tierras " 0 "No tiene tierras"
label val agrario agrario
bysort id: egen prod=total(agrario)  
label var prod "productor"
table id, c(mean prod)

***Agropecuarios***
bysort id: egen prod1=count(p019) 
table id, c(mean agropecuario)

***Agrícolas 1994***

clear all
use "D:\DATA\Trabajos_Stata\CENAGRO\IIICENAGRO\Stata\9\uac94.dta", clear
keep if g02==2 | g02==3
egen id=group(g01-g10)
order id
tab a25
tab a25, nol

*Total de productores agrícolas*

keep if a17==1

gen str2 g01_1=string(g01, "%02.0f")
gen str2 g02_1=string(g02, "%02.0f")
gen str2 g03_1=string(g03, "%02.0f")

drop g01 g02 g03

rename g01_1 g01
rename g02_1 g02
rename g03_1 g03

gen ubigeo=g01+g02+g03

bysort ubigeo: gen agricola=1 if a25==1 | a25==2 | a25==3 | a25==4 | a25==5 ///
| a25==6 | a25==7 | a25==8 | a25==9 | a25==10 | a25==11| a25==12 | a25==13 ///
| a25==14 | a25==15 | a25==16 | a25==17 | a25==18 | a25==20 | a25==21 | a25==24
tab g02 agricola
bysort ubigeo: egen agri=total(agricola)
label var agri "productor agrario"

table ubigeo, c(mean agri)

***Prácticas agrícolas***

***Año 94***
clear all
use "D:\DATA\Trabajos_Stata\CENAGRO\IIICENAGRO\Stata\9\uac94.dta", clear
tostring g01 g02 g03 g04 g05 g06 g07 g08 g09 g10, replace
codebook g01 g02 g03 g04 g05 g06 g07 g08 g09 g10
/* g01=1 g02=1 g03=2 g04=2 g05=2 g06=1 g07=2 g08=2 g09=2 g10=3 */
destring g01 g02 g03 g04 g05 g06 g07 g08 g09 g10, replace

gen str1 g01_1=string(g01, "%01.0f")
gen str1 g02_1=string(g02, "%01.0f")
gen str2 g03_1=string(g03, "%02.0f")
gen str2 g04_1=string(g04, "%02.0f")
gen str2 g05_1=string(g05, "%02.0f")
gen str1 g06_1=string(g06, "%01.0f")
gen str2 g07_1=string(g07, "%02.0f")
gen str2 g08_1=string(g08, "%02.0f")
gen str2 g09_1=string(g09, "%02.0f")
gen str3 g10_1=string(g10, "%03.0f")
order g01 g02 g03
drop g01-g10

rename g01_1 g01
rename g02_1 g02
rename g03_1 g03
rename g04_1 g04
rename g05_1 g05
rename g06_1 g06
rename g07_1 g07
rename g08_1 g08
rename g09_1 g09
rename g10_1 g10

gen id1=g01+g02+g03+g04+g05+g06+g07+g08+g09+g10
order g01-g10 id1
duplicates report id1
save "D:\Sumiko\Acombamba y Angaraes\merge_ag.dta", replace

clear all
use "D:\DATA\Trabajos_Stata\CENAGRO\IIICENAGRO\Stata\9\uaoc94.dta" 
tostring g01 g02 g03 g04 g05 g06 g07 g08 g09 g10, replace
codebook g01 g02 g03 g04 g05 g06 g07 g08 g09 g10
/* g01=1 g02=1 g03=2 g04=2 g05=2 g06=1 g07=2 g08=2 g09=2 g10=3 */
destring g01 g02 g03 g04 g05 g06 g07 g08 g09 g10, replace

gen str1 g01_1=string(g01, "%01.0f")
gen str1 g02_1=string(g02, "%01.0f")
gen str2 g03_1=string(g03, "%02.0f")
gen str2 g04_1=string(g04, "%02.0f")
gen str2 g05_1=string(g05, "%02.0f")
gen str1 g06_1=string(g06, "%01.0f")
gen str2 g07_1=string(g07, "%02.0f")
gen str2 g08_1=string(g08, "%02.0f")
gen str2 g09_1=string(g09, "%02.0f")
gen str3 g10_1=string(g10, "%03.0f")
order g01 g02 g03
drop g01-g10

rename g01_1 g01
rename g02_1 g02
rename g03_1 g03
rename g04_1 g04
rename g05_1 g05
rename g06_1 g06
rename g07_1 g07
rename g08_1 g08
rename g09_1 g09
rename g10_1 g10

gen id1=g01+g02+g03+g04+g05+g06+g07+g08+g09+g10
order g01-g10 id1
duplicates report id1

merge m:m id1 using "D:\Sumiko\Acombamba y Angaraes\merge_ag.dta"
drop _merge
destring g01 g02, replace
gen str2 g01_1=string(g01, "%02.0f")
gen str2 g02_1=string(g02, "%02.0f")
drop g01 g02
rename g01_1 g01
rename g02_ g02
order g01 g02
gen ubigeo=g01+g02+g03

keep if g02=="02" | g02=="03"
keep if a17==1

*Usa semilla cartificada*
tab c50, nol /*si=1 no=2*/

*Aplica guano, estiercol u otro abono*
tab c51, nol /*si=1 si=2 no=3*/

*Fertilizantes Químicos*
tab c52, nol /*si=1 si=2 no=3*/

*Insecticidas*
tab c53_1, nol /*Sí usa=1*/
tab c53_2, nol /*Sí usa=2*/
tab c53_3, nol /*No usa=3*/

*Usa Herbicidas*
tab c54, nol /*si=1 no=2*/

*Usa fungicidas*
tab c55, nol /*si=1 no=2*/

gen semilla=1 if c50==1
gen abono=1 if c51==1 | c51==2
gen ferti=1 if c52==1 | c52==2
gen insec=1 if c53_1==1 | c53_2==2 
gen herbi=1 if c54==1
gen fungi=1 if c55==1

bysort ubigeo: egen semilla1=total(semilla)
bysort ubigeo: egen abono1=total(abono)
bysort ubigeo: egen ferti1=total(ferti)
bysort ubigeo: egen insec1=total(insec)
bysort ubigeo: egen herbi1=total(herbi)
bysort ubigeo: egen fungi1=total(fungi)

table ubigeo, c(mean semilla1)
table ubigeo, c(mean abono1)
table ubigeo, c(mean ferti1)
table ubigeo, c(mean insec1)
table ubigeo, c(mean herbi1)
table ubigeo, c(mean fungi1)


***Año 2012***
clear all
use "D:\DATA\Trabajos_Stata\CENAGRO\IVCENAGRO\02 Base de Datos\IV CENAGRO - STATA\Departamentos\09\rec01.dta"
/*count=79050*/
rename NPRIN nprin
merge m:m nprin using "D:\DATA\Trabajos_Stata\CENAGRO\IVCENAGRO\02 Base de Datos\IV CENAGRO - STATA\Departamentos\09\rec04.dta" 
/*count=74922*/

keep if p002=="02" | p002=="03"
keep if resultado==1
keep if p016==1

*Semilla Certificada
tab p051, nol /*si=1 no=2*/

*Aplica guano
tab p052, nol /*si=1 si=2 si=3*/

*Fertilizantes químicos
tab p053, nol /*si=1 si=2 si=3*/

*Insecticidas
tab p054_01, nol /*si=1 no=2*/
tab p054_02, nol /*zi=1 no=2*/

*Herbicidas

tab p054_03, nol /*si=1 no=2*/

*Fungicidas

tab p054_04, nol /*si=1 no=2*/

destring p001 p002 p003, replace

gen str2 g01_1=string(p001, "%02.0f")
gen str2 g02_1=string(p002, "%02.0f")
gen str2 g03_1=string(p003, "%02.0f")

drop p001 p002 p003

rename g01_1 p001
rename g02_1 p002
rename g03_1 p003
order p001 p002 p003

gen ubigeo=p001+p002+p003

gen semilla=1 if p051==1
gen abono=1 if p052==1 | p052==2
gen ferti=1 if p053==1 | p053==2
gen insec=1 if p054_01==1 | p054_02==1 
gen herbi=1 if p054_03==1
gen fungi=1 if p054_04==1

bysort ubigeo: egen semilla1=total(semilla)
bysort ubigeo: egen abono1=total(abono)
bysort ubigeo: egen ferti1=total(ferti)
bysort ubigeo: egen insec1=total(insec)
bysort ubigeo: egen herbi1=total(herbi)
bysort ubigeo: egen fungi1=total(fungi)

table ubigeo, c(mean semilla1)
table ubigeo, c(mean abono1)
table ubigeo, c(mean ferti1)
table ubigeo, c(mean insec1)
table ubigeo, c(mean herbi1)
table ubigeo, c(mean fungi1)


br ubigeo p051 semilla semilla1

save "D:\Sumiko\Acombamba y Angaraes\agricultores.dta", replace
