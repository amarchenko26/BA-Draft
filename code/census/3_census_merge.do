/* 
* TODO: 1. Place the .txt data file and the dictionary file you downloaded in the work folder, or enter the full path to these files!
*       2. You may have to increase memory using the 'set mem' statement. It is commented out in the code bellow.
*
* If you have any questions or need assistance contact info@socialexplorer.com.
*/

********************************************************************************
/*						Explaining Thiago's work
STEP 1: Loads the data, destrings zipcode and renames it in preparation for merge

STEP 2: Calculates racial percentages & Normalizes  per zipcode. This is done because 
there are 8 variables for race: 001 [TOTAL], 002 [White], 003 [Black], 004 [Native American], 
005 [Asian], 006 [Hawaiian], 007 [Some Other], 008 [Two or More Races]
		NOTE: We do NOT have Hispanics
		NOTE: Some Other Race is shortened as sor 
		NOTE: 008, 006 and 004 are grouped as hnom [Hawaiian, Native, or More]
		NOTE: For ease of use, this is the format I use for variable names:
				`variable'_`category'_`area'_`metric' e.g. `race_white'_`zip/city'_`norm/percentage'
				
STEP 3: In order to group variables by city, I created a dta file with the cleaned 
version of our data [e.g. once it passes through the main cleaning do files], 
merged it with the census data and kept unique zipcodes only. 
		I only kept merge == 3.

STEP 4: Using this new data set, we can now create all of the variables needed. I already 
created a few which can act as a template for creating the remainder. 


                           Melody cleaning:
a) Dropped extra variables we don't need


STEP 6: Once we create all of the variables, we can merge this dataset to the main cleaned data. 

*/
********************************************************************************
*STEP 1: LOADING & SAVING DATA


///set mem 512m
clear all
set more off

infile using "$repository/code/census/R12122734.dct", using("$repository/code/census/R12122734_SL860.txt")

rename ZCTA5 zipcode 

destring zipcode, replace

save "$repository/code/census/census.dta", replace


********************************************************************************
*STEP 2: PRELIMINATY CLEAN [only useful for races which all have unique varaibles]

**Generating Variables BY ZIPCODE
*We only need to generate race varaibles by zipcode
*RACE
gen race_white_zip_percent =  A03001_002 / A03001_001 
gen race_black_zip_percent =  A03001_003 / A03001_001 
gen race_asian_zip_percent =  A03001_005 / A03001_001 
gen race_sor_zip_percent =  A03001_007 / A03001_001 
gen race_hnom_zip_percent = ( A03001_004 +   A03001_006 +   A03001_008) / A03001_001 


local race white black asian sor hnom
foreach race in `race'{
sum race_`race'_zip_percent
gen race_`race'_zip_norm = (race_`race'_zip_percent - `r(mean)')/`r(sd)'
}


********************************************************************************
* STEP 3: MERGE WITH CLEANED DATA FROM 'MAIN' TO RETRIEVE CITY SPECIFIC INFO

***Merging Cities into cleaned data frame 

use "$repository/data/cleaned.dta", clear

keep cleaned_city zipcode

sort zipcode
by zipcode: gen dup = cond(_N==1,0,_n)
sort zipcode dup
drop if dup > 1
drop dup

merge 1:1 zipcode using "$repository/code/census/census.dta"


drop if _merge == 2 //No corresponding city
drop if _merge == 1 //No corresponding data

replace cleaned_city = 5 if zipcode == 11416

********************************************************************************
* STEP 4: GENERATING CITY SPECIFIC VARIABLES


*****INCOME by CITY
gen med_income_city_norm = 0
forvalues city = 1/7{
	sum A14006_001 if cleaned_city == `city'
	replace med_income_city_norm = (A14006_001 - `r(mean)') / `r(sd)' 
}


*****RACE by CITY
gen race_white_city_norm = 0
forvalues city = 1/7{
	sum A03001_002  if cleaned_city == `city'
	replace race_white_city_norm = (A03001_002 - `r(mean)') / `r(sd)' 
}


gen race_black_city_norm = 0
forvalues city = 1/7{
	sum A03001_003  if cleaned_city == `city'
	replace race_black_city_norm = (A03001_003 - `r(mean)') / `r(sd)' 
}


gen race_asian_city_norm = 0
forvalues city = 1/7{
	sum A03001_005  if cleaned_city == `city'
	replace race_asian_city_norm = (A03001_005 - `r(mean)') / `r(sd)' 
}


gen race_sor_city_norm = 0
forvalues city = 1/7{
	sum A03001_007  if cleaned_city == `city'
	replace race_sor_city_norm = (A03001_007 - `r(mean)') / `r(sd)' 
}


gen A03001_NEW = A03001_004 + A03001_006 + A03001_008
rename A03001_NEW hnom
gen race_hnom_city_norm = 0
forvalues city = 1/7{
	sum hnom if cleaned_city == `city'
	replace race_hnom_city_norm = (hnom - `r(mean)') / `r(sd)' 
}


*****DROP EXTRA/BLANK LOCATION VARIABLES
local drop_me FIPS GEOID US NAME QName STUSAB SUMLEV GEOCOMP FILEID LOGRECNO REGION DIVISION STATECE STATE COUNTY COUSUB PLACE PLACESE TRACT BLKGRP CONCIT AIANHH AIANHHFP AIHHTLI AITSCE AITS ANRC CBSA CSA METDIV MACC MEMI NECTA CNECTA NECTADIV UA UACP CDCURR SLDU SLDL VTD ZCTA3 SUBMCD SDELM SDSEC SDUNI UR PCI TAZ UGA BTTR BTBG PUMA5 PUMA1 _merge

foreach var in `drop_me'{
	drop `var'
}


***RENAMING KEY VARIABLES
rename A00002_002 popdensity
rename A10036_001 med_value
rename A18009_001 med_gross_rent


***UNEMPLOYMENT PERCENTAGE, NORMALIZED
gen unemployed_city_percent = 0
gen unemployed_zip_percent = A17002_006 / A17002_002 
forvalues city = 1/7{
	sum unemployed_zip_percent if cleaned_city == `city'
	replace unemployed_city_percent = (unemployed_zip_percent - `r(mean)') / `r(sd)'
}
drop unemployed_zip_percent


***HH on SSI PERCENTAGE, NORMALIZED
gen HHSSI_city_percent = 0
gen HHSSI_zip_percent = A10018_002 / A10018_001
forvalues city = 1/7{
	sum HHSSI_zip_percent if cleaned_city == `city'
	replace HHSSI_city_percent = (HHSSI_zip_percent - `r(mean)') / `r(sd)'
}
drop HHSSI_zip_percent


***OCCUPANCY PERCENTAGE, NORMALIZED
gen occupied_city_percent = 0
gen occupied_zip_percent = A10044_002 / A10044_001
forvalues city = 1/7{
	sum occupied_zip_percent if cleaned_city == `city'
	replace occupied_city_percent = (occupied_zip_percent - `r(mean)') / `r(sd)'
}
drop occupied_zip_percent


***COMMUTE TIME PERCENTAGE, NORMALIZED
gen commuters = B09001_002 + B09001_003 + B09001_004 + B09001_005 + B09001_006 + B09001_007 + B09001_008
gen commuters_zip_percent_under = (B09001_002 + B09001_003 + B09001_004 + B09001_005) / commuters // PERCENTAGE UNDER 40 MIN
gen commuters_zip_percent_over = (B09001_006 + B09001_007 + B09001_008) / commuters // PERCENTAGE OVER 40 MIN

gen commute_time_city_percent_under = 0 
forvalues city = 1/7{
	sum commuters_zip_percent_under if cleaned_city == `city'
	replace commute_time_city_percent_under = (commuters_zip_percent_under - `r(mean)') / `r(sd)' 
}

gen commute_time_city_percent_over = 0 
forvalues city = 1/7{
	sum commuters_zip_percent_over if cleaned_city == `city'
	replace commute_time_city_percent_over = (commuters_zip_percent_over - `r(mean)') / `r(sd)' 
}


********************************************************************************
* STEP 5: GENERAL MERGE

keep zipcode cleaned_city popdensity med_value med_gross_rent med_income_city_norm race_white_city_norm race_black_city_norm race_asian_city_norm race_sor_city_norm race_hnom_city_norm unemployed_city_percent HHSSI_city_percent occupied_city_percent commute_time_city_percent_under commute_time_city_percent_over

save "$repository/code/census/census.dta", replace

merge 1:m zipcode using "$repository/data/cleaned.dta", nogen





