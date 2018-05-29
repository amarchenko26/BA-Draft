clear all
set more off
set maxvar 32000

* Full data w/ race 
cd "~/Desktop/Combined Data"
insheet using "done_combined_full_listings.csv", clear
sort id

do clean

** Clean-up that's combined data-specific


** Creating cities
replace state = "CA" if state == "Ca" | state == "ca" | state == "Ca "
replace state = "IL" if state == "Il" | state == "il" 
replace state = "NY" if state == "New York" | state == "Ny" | state == "ny" | state == "NJ"
replace state = "DC" if state == "VA" | state == "Washington DC" | state == "MD"
drop if state == "MP" | state == "IA" | state == "Asturias" 

egen cleaned_city = group(state) // create new variable of cities by their state location
label define _city 1 "Los Angeles" 2 "Washington DC" 3 "Chicago" 4 "New Orleans" 5 "New York City" 6 "Nashville" 7 "Austin"
label values cleaned_city _city // label them city names


** Restricting data set
destring host_listings_count, replace force
drop if host_listings_count > 20


drop if host_has_profile_pic == "f"
drop if price > 800

replace age = 5 if age == 6
drop if age == 7 | age == 11 | age == 12 | age == 0 

drop if sex == 0

** Fixing LA codes
replace race = 1 if race == 2 & state == "CA"
replace race = 2 if race == 3 & state == "CA"
replace race = 3 if race == 4 & state == "CA"
replace race = 4 if race == 5 & state == "CA"
replace race = 5 if race == 7 & state == "CA"
replace race = 6 if race == 8 & state == "CA"


** Creating labels for non-Chicago cities --> *still need to change for Chicago*
label define _sex 1 "Male" 2 "Female" 3 "Two males" 4 "Two females" 5 "Two people of different sex" 6 "Unknown"
label values sex _sex
label define _race 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial (Groups of 2)" 6 "Unknown"
label values race _race
label define _age 1 "Young" 2 "Middle-aged" 3 "Old" 4 "Two people of different age" 5 "Unknown"
label values age _age
label variable neighbourhood "Neighbourhood"


** Collapsing demographic cat.
gen age_res = age if age < 4 
replace age_res = 4 if age == 4 | age == 5

gen sex_res = sex if sex < 3 
replace sex_res = 3 if sex == 3 | sex == 4 | sex == 5 | sex == 6

gen race_res = race if race != 5 | race!= 6
replace race_res = 5 if race == 5 | race == 6

label define sex_res 1 "Male" 2 "Female" 3 "Two people or Unknown"
label values sex_res sex_res
label define race_res 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial or Unknown"
label values race_res race_res
la var race_res "Race"
la var sex_res "Sex"

drop if sex_res > 2
drop if race_res > 4


** Create interaction for race and sex
egen race_sex_res = group(race_res sex_res), label


** Creating first_review times
// states where month is first
split first_review, p("/"), if state != "IL" //splits variable by /
rename first_review1 first_review_month1
rename first_review2 first_review_day1
rename first_review3 first_review_year1

// states where day is first
split first_review, p("/"), if state == "IL" //splits variable by /
rename first_review1 first_review_day_chi
rename first_review2 first_review_month_chi
rename first_review3 first_review_year_chi
replace first_review_year_chi = substr(first_review_year_chi, -2, .) //deletes decimals from string

destring first_review_day1, replace force 
destring first_review_month1, replace force
destring first_review_year1, replace force
destring first_review_day_chi, replace force 
destring first_review_month_chi, replace force
destring first_review_year_chi, replace force

egen first_review_day = rowmax(first_review_day1 first_review_day_chi)
egen first_review_month = rowmax(first_review_month1 first_review_month_chi)
egen first_review_year = rowmax(first_review_year1 first_review_year_chi)

replace first_review_month = 99 if first_review_month == . //create fake month for people w/ no reviews
replace first_review_year = 99 if first_review_year == .  //create fake year for people w/ no reviews to boost observations

// cd "~/Desktop/Combined Data/Robustness"
// do robustness_property_chars

//do regressions


/*
tabout race_sex_res cleaned_city using SummaryTable2.tex, c(freq col row) ///
replace //**these are the rows
cells(count race) sum ///
style(tex) topf(top.tex) botf(bot.tex)







/*

******* Tables *****************************************************************
** Create City-Level Summary Statistics Table, want counts



** Race Summary Statistics Table, want means & SD
latabstat price, by(race)

estpost tabstat price number_of_reviews review_scores_value bedrooms, by(race) ///
statistics(mean n sd) columns(statistics) //listwise //column(stat) shows variables in rows 
esttab using summary_table_race.tex, replace main(mean) aux(sd) unstack booktabs ///
label nonote 


******* Summary Stats **********************************************************
set graphics off

preserve
** See how price distributed
histogram price 
replace price = 800 if price >800
histogram price if price <= 800  
sort host_id
by host_id:  gen dup_host = cond(_N==1,0,_n)
histogram price if price < 800 & dup_host>1
restore

preserve
replace host_listings_count = 20 if host_listings_count > 20
histogram host_listings_count if host_listings_count < 10
tab host_listings_count
restore

tabout sex using sex_table.tex, replace // Want: Table of # of observartions in each category of variable, and their percentage of total
tabout race using race_table.tex, replace
tabout age using age_table.tex, replace

preserve
sum price if race==1
sum price if race==2
twoway histogram price if price <800, by(race)
restore

preserve
twoway histogram price if price<800, by(sex)
mean(price) if sex<2
restore


/*
GARBAGE:

** Give up and make this in R - table w/ city-level description
la var id "Listings"
estpost tabstat race sex age id, by(cleaned_city) ///
statistics(mean) columns(statistics) //listwise //column(stat) shows variables in rows 
esttab using summary_table_city.tex, replace main(mean n) unstack booktabs ///
label nonote 

** Failed tabout code - race only as a row variables
tabout price race using SummaryTable2.tex, ///
replace /// **these are the rows
cells(mean race) sum ///
style(tex) topf(top.tex) botf(bot.tex)

// cl2(2-4 5-6) cltr2(.75em 1.5em)
// sum /// **using summary mode of tabout
//f(0c 1) /// **the first number is the format of the first horizontal variable

//clab(Table 1: My first table) ///
** cells(mean price se) --if you want SE, can only use mean

sort host_id
by host_id:  gen dup = cond(_N==1,0,_n)
drop if dup>1 //dup>0 deletes all duplicate entries, >1 keeps first instance

replace price = substr(price, 1, length(price)-3) //deletes decimals from string
