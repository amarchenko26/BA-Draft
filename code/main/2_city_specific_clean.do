*********************************************************
*				   City-Specific Clean 	    	        *
*********************************************************


** Clean-up that's combined data-specific

** Creating cities
replace state = "CA" if state == "Ca" | state == "ca" | state == "Ca "
replace state = "IL" if state == "Il" | state == "il" 
replace state = "NY" if state == "New York" | state == "Ny" | state == "ny" | state == "NJ"
replace state = "DC" if state == "VA" | state == "Washington DC" | state == "MD"
drop if state == "MP" | state == "IA" | state == "Asturias" 

egen cleaned_city = group(state) // create new variable of cities by their state location
label define _city 1 "Los Angeles" 2 "Washington DC" 3 "Chicago" 4 "New Orleans" 5 "New York City" 6 "Nashville" 7 "Austin"
label values cleaned_city _city 


** Restricting data set
destring host_listings_count, replace force
replace age = 5 if age == 6
gen sample = 1
replace sample = 0 if host_listings_count > 20 | host_has_profile_pic == "f" | price > 800 | sex == 0 | age == 7 | age == 11 | age == 12 | age == 0


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
gen age_res = age if age < 4 &  age > 0
replace age_res = 4 if age >= 4 | age == 0

gen sex_res = sex if sex < 3 & sex > 0 
replace sex_res = 3 if sex == 3 | sex == 4 | sex == 5 | sex == 6 | sex == 0

gen race_res = race if race != 5 | race!= 6 | race != 0
replace race_res = 5 if race == 5 | race == 6  | race == 0

label define sex_res 1 "Male" 2 "Female" 3 "Two people or Unknown"
label values sex_res sex_res
label define race_res 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial or Unknown"
label values race_res race_res
la var race_res "Race"
la var sex_res "Sex"

replace sample = 0 if sex_res > 2 	//Responsible for dropping ~20k vars
replace sample = 0 if race_res > 4	//Responsible for dropping ~20k vars

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

drop first_review_day1
drop first_review_day_chi
drop first_review_month1
drop first_review_month_chi
drop first_review_year1
drop first_review_year_chi

replace first_review_month = 99 if first_review_month == . //create fake month for people w/ no reviews
replace first_review_year = 99 if first_review_year == .  //create fake year for people w/ no reviews to boost observations

gen miss_first_review_month = 0
replace miss_first_review_month = 1 if first_review_month == 99
gen miss_first_review_year = 0
replace miss_first_review_year = 1 if first_review_year == 99


** Creating last scraped times
// month is first
split last_scraped, p("/") //splits variable by /
rename last_scraped1 last_scraped_month
rename last_scraped2 last_scraped_day
rename last_scraped3 last_scraped_year

destring last_scraped_year, replace force
replace last_scraped_year = 15 if last_scraped_year == 2015

** Creating time on market and reviews per years active metric
gen time_on_market = last_scraped_year - first_review_year if first_review_year
gen reviews_per_year = number_of_reviews / time_on_market

la var first_review_year "Year of first review"

** Merging NLP analysis columns
rename id id2
rename v1 id // v1 corresponds to id column in final_cleaned_all_sentiments

#delimit ;
merge m:m id using "$repository/data/full_listings_all_sentiments_updated6.dta", nogen 
keepusing(id reviews_polarity reviews_subjectivity summary_polarity summary_subjectivity 
space_polarity space_subjectivity description_polarity description_subjectivity 
experiences_offered_polarity experiences_offered_subjectivity neighborhood_overview_polarity 
neighborhood_overview_subject)
;
#delimit cr

rename neighborhood_overview_polarity neighborhood_polarity
rename neighborhood_overview_subject neighborhood_subjectivity

** Renaming just for creating missing dummies
rename group_neighbourhood_cleansed group_nhood_clean
rename require_guest_profile_picture req_guest_pro_pic
rename require_guest_phone_verification req_guest_phone

** Create more indicator variables for missing variables 
local varlist race_sex_res group_ra_name cleaned_city group_nhood_clean group_property_type group_room_type accommodates bathrooms bedrooms beds group_bed_type cleaning_fee extra_people num_amenities group_cancellation_policy instant_bookable req_guest_pro_pic req_guest_phone minimum_nights availability_30 availability_60 

foreach var in `varlist'{
	gen miss_`var' = 0
	replace miss_`var' = 1 if `var'== .
	replace `var' = 0 if `var'== .
}

rename group_nhood_clean group_neighbourhood_cleansed
rename req_guest_pro_pic require_guest_profile_picture
rename req_guest_phone require_guest_phone_verification


** Creating missing dummies for NLP
local NLP summary_polarity summary_subjectivity description_polarity description_subjectivity space_polarity space_subjectivity reviews_polarity reviews_subjectivity neighborhood_polarity neighborhood_subjectivity

foreach var in `NLP'{
	gen miss_`var' = 0
	replace miss_`var' = 1 if `var'== .
	sum `var'
	replace `var' = `r(mean)' if `var'== .
}

** Exporting for census merging
save "$repository/code/census/cleaned.dta", replace
