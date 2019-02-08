*********************************************************
*					  General Clean 					*
*********************************************************


** Cleaning up variables for all cities

insheet using "$repository/data/done_combined_full_listings.csv", clear
sort id

** Creating quality of listing controls

// Description
gen len_desc = length(description) // length of description 
la var len_desc "Length of Description"
egen num_words = nss(description), find(" ") //count number of words by counting spaces
gen short_words = num_words/len_desc //low short_words --> high quality of review, (since there's a lot of long words)
la var short_words "Quality of review as measured by proportion of long words"

// Summary
gen len_desc2 = length(summary) // length of description 
egen num_words2 = nss(summary), find(" ") //count number of words by counting spaces
gen short_words2 = num_words2/len_desc2 //low short_words --> high quality of review, (since there's a lot of long words)

// Space
gen len_desc3 = length(space) // length of descripiton 
egen num_words3 = nss(space), find(" ") //count number of words by counting spaces
gen short_words3 = num_words3/len_desc3 //low short_words --> high quality of review, (since there's a lot of long words)
// Experiences offered is always "none"

// Neighborhood Overview
gen len_desc4 = length(neighborhood_overview)
egen num_words4 = nss(space), find(" ") //count number of words by counting spaces
gen short_words4 = num_words4/len_desc4 //low short_words --> high quality of review, (since there's a lot of long words)

// Notes
gen len_desc5 = length(notes)
egen num_words5 = nss(space), find(" ") //count number of words by counting spaces
gen short_words5 = num_words5/len_desc5 //low short_words --> high quality of review, (since there's a lot of long words)

// Transit
gen len_desc6 = length(transit)
egen num_words6 = nss(space), find(" ") //count number of words by counting spaces
gen short_words6 = num_words6/len_desc6 //low short_words --> high quality of review, (since there's a lot of long words)

// Amenities
egen num_amenities = nss(amenities), find(",")

replace short_words = 0 if short_words == . 
replace short_words2 = 0 if short_words2 == . 
replace short_words3 = 0 if short_words3 == . 
replace short_words4 = 0 if short_words4 == . 
replace short_words5 = 0 if short_words5 == . 
replace short_words6 = 0 if short_words6 == . 

replace num_words = 0 if num_words == . 
replace num_words2 = 0 if num_words2 == . 
replace num_words3 = 0 if num_words3 == .
replace num_words4 = 0 if num_words4 == .
replace num_words5 = 0 if num_words5 == .
replace num_words6 = 0 if num_words6 == .
 
egen good_word1 = noccur(description), string("spacious")
egen good_word2 = noccur(description), string("beautiful")
egen good_word3 = noccur(description), string("clean")
egen good_word4 = noccur(description), string("comfort")
egen good_word5 = noccur(description), string("great")
egen good_word6 = noccur(description), string("love")
egen good_word7 = noccur(description), string("quiet")

gen good_word_tot = good_word1 + good_word2 + good_word3 + good_word4 + good_word5 + good_word6 + good_word7


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

** Missing Data
// Replace missing data with zeros
destring reviews_per_month, replace force
replace reviews_per_month = 0 if reviews_per_month ==  . 
replace host_acceptance_rate = 0 if host_acceptance_rate == .
replace host_response_rate = 0 if host_response_rate == .
replace cleaning_fee = 0 if cleaning_fee == . 
replace bedrooms = 0 if bedrooms == . 
replace beds = 0 if beds == .
replace bathrooms = 0 if bathrooms == .

** Create indicator variables for missing variables 
quietly misstable summarize, generate(miss_) //creating miss_X indicator variable, 1 if X missing

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

** RA analysis
replace ra_name = "Fong" if ra_name== "FONG"
replace ra_name = "Joe" if ra_name== "Joseph"
egen group_ra_name = group(ra_name)
