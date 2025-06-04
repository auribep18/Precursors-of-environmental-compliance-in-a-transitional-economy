
* 07.01.2025

* Replication file for manuscript: "Precursors of Environmental Compliance in a Transitional Economy: An Empirical Investigation of Monitoring and Enforcement in Chile"

* Create your directory. The files "BDPanel.dta", "BDfines.dta", "BDCompliancePrograms.dta"  and "maincode_0701205.do need to be located in your directory:
* cd "C:..\ReplicationFolder\data"

cls
clear all

cd "C:..\ReplicationFolder\data"
global datetime_string : display %tc_CCYYNNDD_HHMMSS clock(c(current_date) + "_" + c(current_time), "DMYhms")
display "Date: $datetime_string"

use BDPanel.dta, clear

global controls_Charact b2.SizesN b4.Sectors Age 
global controls_Loc PrioritizedArea b5.Macrozone logPercentagePovertyCity LogDensity
global controls_SMA logSMABudgetperFacilityRE
gen lagFIS_IA= l.FIS_IA
gen lagPDCactiv = L1.PDCactiv

bysort ID: egen mean_lagFIS_IA = mean(lagFIS_IA)
bysort ID: egen mean_Fined3year = mean(Fined3year)
bysort ID: egen mean_PDCactiv = mean(PDCactiv)
bysort ID: egen mean_logPercentagePovertyCity = mean(logPercentagePovertyCity)
bysort ID: egen mean_logSMABudgetperFacilityRE = mean(logSMABudgetperFacilityRE)
bysort ID: egen mean_S1 = mean(Fined_SpillComuna3year)
bysort ID: egen mean_S2 = mean(Fined_SpillSector3year)
bysort ID: egen mean_S3 = mean(Fined_SpillComunaSector3year)
bysort ID: egen mean_S4 = mean(Fined_Spill3year)

xtset ID Year

*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***  
* Table 5. Coefficient Estimates for Inspections, xtlogit CRE Model
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 

xtlogit FIS_IA lagFIS_IA Fined3year PDCactiv  ///
 mean_lagFIS_IA mean_Fined3year mean_PDCactiv ///
 i.Year, re vce(cluster ID)
outreg2 using "FIS_$datetime_string.doc", append ctitle(FIS 1)

xtlogit FIS_IA lagFIS_IA Fined3year PDCactiv $controls_Charact ///
 mean_lagFIS_IA mean_Fined3year mean_PDCactiv ///
 i.Year, re vce(cluster ID)
outreg2 using "FIS_$datetime_string.doc", append ctitle(FIS 2)

xtlogit FIS_IA lagFIS_IA Fined3year PDCactiv $controls_Charact $controls_Loc  ///
 mean_lagFIS_IA mean_Fined3year mean_PDCactiv ///
 i.Year, re vce(cluster ID)
outreg2 using "FIS_$datetime_string.doc", append ctitle(FIS 3)

xtlogit FIS_IA lagFIS_IA Fined3year PDCactiv $controls_Charact $controls_Loc $controls_SMA ///
 mean_lagFIS_IA mean_Fined3year mean_PDCactiv ///
 i.Year, re vce(cluster ID)
outreg2 using "FIS_$datetime_string.doc", append ctitle(FIS 4)


margins, predict(pr)
margins, dydx(lagFIS_IA)
margins, dydx(Fined3year)
margins, dydx(PDCactiv) 
margins, dydx(ib2.SizesN) 
margins, dydx(ib4.Sectors) 
margins, dydx(Age)
margins, dydx(PrioritizedArea) 
margins, dydx(ib5.Macrozone) 
margins, dydx(logPercentagePovertyCity) 
margins, dydx(LogDensity) 
margins, dydx(logSMABudgetperFacilityRE) 
margins, dydx(mean_lagFIS_IA) 
margins, dydx(mean_Fined3year) 
margins, dydx(mean_PDCactiv) 
margins, dydx(ib1.Year) 



*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***  
* Table 7. Coefficient Estimates for Compliance, xtlogit CRE Model
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 

xtlogit FIS_IA l.FIS_IA Fined3year PDCactiv  $controls_SMA, fe
predict FIS_IAhhh, xb
gen lagFIS_IAhhh = L1.FIS_IAhhh
replace lagFIS_IAhhh = lagFIS_IA if missing(lagFIS_IAhhh)
bysort ID: egen mean_lagFIS_IAhhh = mean(lagFIS_IAhhh)
bysort ID: egen mean_FIS_IAhhh = mean(FIS_IAhhh)

 xtlogit Cump lagFIS_IAhhh Fined3year PDCactiv ///
 mean_lagFIS_IAhhh mean_Fined3year  mean_PDCactiv ///
 i.Year, re 
 outreg2 using "Cumptt_$datetime_string.doc", append ctitle(Cump 1)
 
 xtlogit Cump lagFIS_IAhhh Fined3year PDCactiv $controls_Charact ///
 mean_lagFIS_IAhhh mean_Fined3year  mean_PDCactiv ///
 i.Year, re 
 outreg2 using "Cumptt_$datetime_string.doc", append ctitle(Cump 2)
 
 xtlogit Cump lagFIS_IAhhh Fined3year PDCactiv $controls_Charact $controls_Loc  ///
 mean_lagFIS_IAhhh mean_Fined3year  mean_PDCactiv ///
 i.Year, re 
 outreg2 using "Cumptt_$datetime_string.doc", append ctitle(Cump 3)

 xtlogit Cump lagFIS_IAhhh Fined3year PDCactiv $controls_Charact $controls_Loc ///
 Fined_SpillComuna3year Fined_SpillSector3year Fined_SpillComunaSector3year Fined_Spill3year ///
 mean_lagFIS_IAhhh mean_Fined3year  mean_PDCactiv ///
  mean_S1 mean_S2 mean_S3 mean_S4 i.Year, re 
 outreg2 using "Cumptt_$datetime_string.doc", append ctitle(Cump 4)

margins, predict(pr) 
margins, dydx(lagFIS_IAhhh) 
margins, dydx(Fined3year) 
margins, dydx(PDCactiv) 
margins, dydx(ib2.SizesN) 
margins, dydx(ib4.Sectors) 
margins, dydx(Age) 
margins, dydx(PrioritizedArea) 
margins, dydx(ib5.Macrozone) 
margins, dydx(logPercentagePovertyCity) 
margins, dydx(LogDensity) 
margins, dydx(Fined_SpillComuna3year) 
margins, dydx(Fined_SpillSector3year) 
margins, dydx(Fined_SpillComunaSector3year)
margins, dydx(Fined_Spill3year) 
margins, dydx(mean_lagFIS_IAhhh) 
margins, dydx(mean_Fined3year) 
margins, dydx(mean_PDCactiv) 
margins, dydx(mean_S1)
margins, dydx(mean_S2)
margins, dydx(mean_S3)
margins, dydx(mean_S4)
margins, dydx(ib1.Year)     

*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***  
* Table 6. Coefficient Estimates for the (log) Size of Fine for Tobit Models
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
cls
clear all
cd "C:..\ReplicationFolder\data"
global datetime_string : display %tc_CCYYNNDD_HHMMSS clock(c(current_date) + "_" + c(current_time), "DMYhms")
display "Date: $datetime_string"
use BDfines.dta, clear
gen logFine_1000USD = ln(Fine_1000USD)

tobit logFine_1000USD Num_Infractions Rel $controls_Charact i.Year, ll(0)
outreg2 using "FINE$datetime_string.doc", append ctitle(logFine tobit)

tobit logFine_1000USD Num_LowInfraction Num_MiddleInfraction Num_HighInfraction Rel $controls_Charact i.Year, ll(0)
outreg2 using "FINE$datetime_string.doc", append ctitle(logFine tobit)

gen ImpactIndex = 1*Num_LowInfraction + 2*Num_MiddleInfraction + 3*Num_HighInfracti

tobit logFine_1000USD ImpactIndex Rel $controls_Charact i.Year, ll(0)
outreg2 using "FINE$datetime_string.doc", append ctitle(logFine tobit)

sum Num_Infractions Num_LowInfraction Num_MiddleInfraction Num_HighInfraction ImpactIndex Rel $controls_Charact i.Year


*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***  
* Appendix. Coefficient Estimates for Compliance Program (PDC) 
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
cls
clear all
use BDCompliancePrograms.dta, clear
       
global datetime_string : display %tc_CCYYNNDD_HHMMSS clock(c(current_date) + "_" + c(current_time), "DMYhms")
display "Date: $datetime_string"
 
probit PDC b4.Sectors b2.SizesN b5.Macrozones Age logPercentagePovertyCity LogDensity  Num_LowInfraction	Num_MiddleInfraction Num_HighInfraction Relapse Complaint i.Year, vce(cluster ID)
outreg2 using "test1$datetime_string.doc", append ctitle(Compliance Program)

margins, predict(pr) 


 *** FE xtlogit *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** 
 
cls
clear all

cd "C:..\ReplicationFolder\data"
global datetime_string : display %tc_CCYYNNDD_HHMMSS clock(c(current_date) + "_" + c(current_time), "DMYhms")
display "Date: $datetime_string"

use BDPanel.dta, clear

global controls_Charact b2.SizesN b4.Sectors Age 
global controls_Loc PrioritizedArea b5.Macrozone logPercentagePovertyCity LogDensity
global controls_SMA logSMABudgetperFacilityRE
gen lagFIS_IA= l.FIS_IA
gen lagPDCactiv = L1.PDCactiv

bysort ID: egen mean_lagFIS_IA = mean(lagFIS_IA)
bysort ID: egen mean_Fined3year = mean(Fined3year)
bysort ID: egen mean_PDCactiv = mean(PDCactiv)
bysort ID: egen mean_logPercentagePovertyCity = mean(logPercentagePovertyCity)
bysort ID: egen mean_logSMABudgetperFacilityRE = mean(logSMABudgetperFacilityRE)
bysort ID: egen mean_S1 = mean(Fined_SpillComuna3year)
bysort ID: egen mean_S2 = mean(Fined_SpillSector3year)
bysort ID: egen mean_S3 = mean(Fined_SpillComunaSector3year)
bysort ID: egen mean_S4 = mean(Fined_Spill3year)

xtset ID Year
 
 xtlogit FIS_IA lagFIS_IA Fined3year PDCactiv $controls_Charact $controls_Loc $controls_SMA ///
 i.Year, fe
outreg2 using "FISt_$datetime_string.doc", append ctitle(FIS FE)

  xtlogit Cump lagFIS_IAhhh Fined3year PDCactiv $controls_Charact $controls_Loc ///
 Fined_SpillComuna3year Fined_SpillSector3year Fined_SpillComunaSector3year Fined_Spill3year ///
 i.Year, fe 
 outreg2 using "Cumpt_$datetime_string.doc", append ctitle(Cump FE)
