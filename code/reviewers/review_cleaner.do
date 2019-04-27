
// Amenities
egen num_amenities = nss(amenities), find(",")

** Host Characteristics
egen group_host_response_time = group(host_response_time), label  //, lname("Host Response Time")

replace host_response_rate = subinstr(host_response_rate, "%", "",.) //deletes $ sign
destring host_response_rate, replace force
replace host_response_rate = host_response_rate/100

replace host_acceptance_rate = subinstr(host_acceptance_rate, "%", "",.) //deletes $ sign
destring host_acceptance_rate, replace force
replace host_acceptance_rate = host_acceptance_rate/100 //now as a decimal ".89" 

destring host_is_superhost, replace //not enough variation
gen host_is_superhost_2 = 0
replace host_is_superhost_2 = 1 if host_is_superhost == "t"
la var host_is_superhost_2 "1 if TRUE, 0 if FALSE"
drop host_is_superhost
rename host_is_superhost_2 host_is_superhost

destring host_identity_verified, replace
gen host_identity_verified_2 = 0
replace host_identity_verified_2 = 1 if host_identity_verified == "t"
la var host_identity_verified_2 "1 if TRUE, 0 if FALSE"
drop host_identity_verified
rename host_identity_verified_2 host_identity_verified

destring require_guest_profile_picture, replace
gen require_guest_profile_picture_2 = 0
replace require_guest_profile_picture_2 = 1 if require_guest_profile_picture == "t"
la var require_guest_profile_picture_2 "1 if TRUE, 0 if FALSE"
drop require_guest_profile_picture
rename require_guest_profile_picture_2 require_guest_profile_picture

destring require_guest_phone_verification, replace
gen guest_phone_verification_2 = 0
replace guest_phone_verification_2 = 1 if require_guest_phone_verification == "t"
la var guest_phone_verification_2 "1 if TRUE, 0 if FALSE"
drop require_guest_phone_verification
rename guest_phone_verification_2 require_guest_phone_verification

** Location
egen group_neighbourhood_cleansed = group(neighbourhood_cleansed), lname("Neighbourhood")

** Property Type
egen group_property_type = group(property_type), label //, lname("Property Type")
egen group_room_type = group(room_type), label  //, lname("Room Type")
replace group_property_type = 100 if group_property_type == .
gen miss_group_property_type = 0
replace miss_group_property_type = 1 if group_property_type == 100
egen group_bed_type = group(bed_type), label

destring accommodates, replace force
destring bathrooms, replace force
destring bedrooms, replace force
destring beds, replace force

** Misc.
destring instant_bookable, replace
gen instant_bookable_2 = 0
replace instant_bookable_2 = 1 if instant_bookable == "t"
la var instant_bookable_2 "1 if TRUE, 0 if FALSE"
drop instant_bookable
rename instant_bookable_2 instant_bookable

egen group_cancellation_policy = group(cancellation_policy)  //, lname("Cancellation Policy")


** Destringing string variables
replace price = subinstr(price, "$", "",.) //deletes $ sign
replace price = subinstr(price, ",", "",.) //deletes "," sign in price>1000
destring price, replace force

destring number_of_reviews, replace force

replace weekly_price = subinstr(weekly_price, "$", "",.) //deletes $ sign
replace weekly_price = subinstr(weekly_price, ",", "",.) //deletes "," sign in price>1000
destring weekly_price, replace force

replace monthly_price = subinstr(monthly_price, "$", "",.) //deletes $ sign
replace monthly_price = subinstr(monthly_price, ",", "",.) //deletes "," sign in price>1000
destring monthly_price, replace force

replace security_deposit = subinstr(security_deposit, "$", "",.) //deletes $ sign
replace security_deposit = subinstr(security_deposit, ",", "",.) //deletes "," sign in price>1000
destring security_deposit, replace force

replace cleaning_fee = subinstr(cleaning_fee, "$", "",.) //deletes $ sign
replace cleaning_fee = subinstr(cleaning_fee, ",", "",.) //deletes "," sign in price>1000
destring cleaning_fee, replace force

replace extra_people = subinstr(extra_people, "$", "",.) //deletes $ sign
replace extra_people = subinstr(extra_people, ",", "",.) //deletes "," sign in price>1000
destring extra_people, replace force

destring sex, replace force
destring age, replace force
destring race, replace force
destring id, replace force

destring zipcode, replace force
destring review_scores_value, replace force
destring review_scores_rating, replace force
/*
** Missing Data
** Create indicator variables for missing variables 
quietly misstable summarize, generate(miss_) //creating miss_X indicator variable, 1 if X missing
*/

** Renaming just for creating missing dummies
rename group_neighbourhood_cleansed group_nhood_clean
rename require_guest_profile_picture req_guest_pro_pic
rename require_guest_phone_verification req_guest_phone

** Create indicator variables for missing variables 
local varlist group_nhood_clean group_room_type accommodates bathrooms bedrooms beds group_bed_type cleaning_fee extra_people num_amenities group_cancellation_policy instant_bookable req_guest_pro_pic req_guest_phone minimum_nights availability_30 availability_60 host_acceptance_rate host_response_rate host_is_superhost group_host_response_time host_identity_verified

foreach var in `varlist'{
	gen miss_`var' = 0
	replace miss_`var' = 1 if `var'== .
	replace `var' = 0 if `var'== .
}

rename group_nhood_clean group_neighbourhood_cleansed
rename req_guest_pro_pic require_guest_profile_picture
rename req_guest_phone require_guest_phone_verification

/*
// Replace missing data with zeros
destring reviews_per_month, replace force
replace reviews_per_month = 0 if reviews_per_month ==  . 
replace host_acceptance_rate = 0 if host_acceptance_rate == .
replace host_response_rate = 0 if host_response_rate == .
replace cleaning_fee = 0 if cleaning_fee == . 
replace bedrooms = 0 if bedrooms == . 
replace beds = 0 if beds == .
replace bathrooms = 0 if bathrooms == .
*/
** Creating labels
la var race "Race"
la var sex "Sex"
la var age "Age"
la var number_of_reviews "Number of Reviews"
la var price "Price"
la var review_scores_value "Review Scores Value"
la var property_type "Property Type"
la var room_type "Room Type"
la var accommodates "Max Num. Guests"
la var bedrooms "Bedrooms"
la var bathrooms "Bathrooms"
la var beds "Beds"
la var availability_30 "Availability (out of 30 days)"
la var num_amenities "Number of Amenities"
la var cleaning_fee "Cleaning Fee"
la var extra_people "Extra Guests Charge"
la var instant_bookable "Instantly Bookable?"
la var minimum_nights "Minimum Nights"
la var cancellation_policy "Strict Cancellation Policy"
la var host_listings_count "Host Listings Count"
la var review_scores_value "Review value out of 100"
la var host_is_superhost "Host is a Superhost"
la var host_response_rate "Response rate"
la var host_response_time "Response time"
la var host_acceptance_rate "Acceptance rate"
*la var good_word_tot "Total good words" //commenting out while above len_desc is commented out
//la var len_desc "Length of description"
//la var short_words "Short words"
la var host_identity_verified "Host's Identity Verified"
la var require_guest_profile_picture "Guest Pic Required"
la var require_guest_phone_verification "Guest Phone Required"

** RA analysis
replace ra_name = "Fong" if ra_name== "FONG"
replace ra_name = "Joe" if ra_name== "Joseph"
egen group_ra_name = group(ra_name)
gen miss_group_ra_name = 0
replace miss_group_ra_name = 1 if group_ra_name == .

********************************************************************************
* Chicago City Specific
********************************************************************************

** Create first review variables
split first_review, p("/") //splits variable by /
rename first_review1 first_review_day
rename first_review2 first_review_month
rename first_review3 first_review_year
replace first_review_year = substr(first_review_year, -2, .) //deletes decimals from string

destring first_review_day, replace force 
destring first_review_month, replace force
destring first_review_year, replace force

replace first_review_month = 99 if first_review_month == . //create fake month for people w/ no reviews
replace first_review_year = 99 if first_review_year == .  //create fake year for people w/ no reviews to boost observations
gen miss_first_review_month = 0
replace miss_first_review_month = 1 if first_review_month == 99
gen miss_first_review_year = 0
replace miss_first_review_year = 1 if first_review_year == 99

** Collapsing demographic cat.
gen sex_res = sex if sex < 3 
replace sex_res = 3 if sex == 3 | sex == 4 | sex == 5 | sex == 6 | sex == 0

gen race_res = race if race != 5 | race!= 6
replace race_res = 5 if race == 5 | race == 6 | race == 0

label define sex_res 1 "Male" 2 "Female" 3 "Two people or Unknown"
label values sex_res sex_res
label define race_res 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial or Unknown"
label values race_res race_res
la var race_res "Race"
la var sex_res "Sex"

** Create interaction for race and sex
egen race_sex_res = group(race_res sex_res), label


** Create sample variable to restrict data set
destring host_listings_count, replace force
replace age = 5 if age == 6
gen reviewer_sample = 1
replace reviewer_sample = 0 if host_listings_count > 20 | host_has_profile_pic == "f" | price > 800 | sex == 0 | age == 7 | age == 11 | age == 12 | age == 0
replace reviewer_sample = 0 if sex_res > 2 	
replace reviewer_sample = 0 if race_res > 4


** Merging NLP analysis columns

#delimit ;
merge m:m listing_id using "$repository/data/full_listings_all_sentiments_updated6.dta", 
keepusing(listing_id reviews_polarity reviews_subjectivity summary_polarity summary_subjectivity 
space_polarity space_subjectivity description_polarity description_subjectivity 
experiences_offered_polarity experiences_offered_subjectivity neighborhood_overview_polarity 
neighborhood_overview_subject)
;
#delimit cr

drop if _merge == 2 // drop if not reviewer data
rename _merge nlp_merge

rename neighborhood_overview_polarity neighborhood_polarity
rename neighborhood_overview_subject neighborhood_subjectivity

** Creating missing dummies for NLP
local NLP summary_polarity summary_subjectivity description_polarity description_subjectivity space_polarity space_subjectivity reviews_polarity reviews_subjectivity neighborhood_polarity neighborhood_subjectivity

foreach var in `NLP'{
	gen miss_`var' = 0
	replace miss_`var' = 1 if `var'== .
	sum `var'
	replace `var' = `r(mean)' if `var'== .
}

** Merging census analysis columns
merge m:1 zipcode using "$repository/code/census/census.dta"
rename _merge census_merge
drop if census_merge == 2 // drop if obs only in census data

*** Creating missing census indicators
local ncat popdensity med_value med_gross_rent med_income_city_norm race_white_city_norm race_black_city_norm race_asian_city_norm race_sor_city_norm race_hnom_city_norm unemployed_city_percent HHSSI_city_percent occupied_city_percent commute_city_percent_under commute_city_percent_over

foreach var in `ncat'{
	gen miss_`var' = 0
	replace miss_`var' = 1 if `var'== .
	sum `var'
	replace `var' = `r(mean)' if `var'== .
}

** Log price, number of reviews
local log_me price number_of_reviews

foreach i in `log_me'{
	gen log_`i' = ln(`i')
	gen miss_log_`i' = 0
	replace miss_log_`i' = 1 if mi(`i')
}

la var log_price "Log Price"
la var log_number_of_reviews "Log Number of Reviews"
