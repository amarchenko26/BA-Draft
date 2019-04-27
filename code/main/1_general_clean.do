*********************************************************
*					  General Clean 					*
*********************************************************


** Cleaning up variables for all cities

insheet using "$repository/data/done_combined_full_listings.csv", clear
sort id

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
destring host_listings_count, replace force

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

destring reviews_per_month, replace force


** Creating labels
la var race "Race"
la var sex "Sex"
la var age "Age"
la var number_of_reviews "Number of Reviews"
la var price "Price"
la var review_scores_rating "Review scores rating"
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
la var host_is_superhost "Host is a Superhost"
la var host_response_rate "Response rate"
la var host_response_time "Response time"
la var host_acceptance_rate "Acceptance rate"
la var host_identity_verified "Host's Identity Verified?"
la var require_guest_profile_picture "Guest Pic Required?"
la var require_guest_phone_verification "Guest Phone Required?"


** RA analysis
replace ra_name = "Fong" if ra_name== "FONG"
replace ra_name = "Joe" if ra_name== "Joseph"
egen group_ra_name = group(ra_name)

** Log price, number of reviews
local log_me price number_of_reviews

foreach i in `log_me'{
	gen log_`i' = ln(`i')
	gen miss_log_`i' = 0
	replace miss_log_`i' = 1 if mi(`i')
}

la var log_price "Log Price"
la var log_number_of_reviews "Log Number of Reviews"
