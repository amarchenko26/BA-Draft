********************************************************************************
*					  City Robustness 				    					   *
********************************************************************************
preserve
keep if sample == 1
** State robustness checks do-file
set more off
set emptycells drop 



****** Price
#delimit ;
quietly reg log_price i.race_res 
			i.group_neighbourhood_cleansed i.cleaned_city
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable require_guest_profile_picture 
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if state == "CA", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo LA
	
#delimit ;
quietly reg log_price i.race_res 
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60
			len_desc short_words len_desc2 short_words2 len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost
				if state == "NY", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo NYC

#delimit ;
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost
				if state == "TX", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo Austin


#delimit ;
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost
				if state == "IL", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo Chicago
		 
#delimit ;	
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture 
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost
				if state == "LA",  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;	
#delimit cr
eststo New_Orleans

#delimit ;
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year  miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 len_desc3 
			short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost
				if state == "DC",  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo DC
	
#delimit ;
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city
			i.group_property_type i.group_room_type
			accommodates bathrooms bedrooms beds i.group_bed_type
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost
				if state == "TN", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo Nashville

// Table Output

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : LA NYC Austin Chicago New_Orleans DC Nashville
estadd local controlgroup2 "Yes" : LA NYC Austin Chicago New_Orleans DC Nashville
estadd local controlgroup3 "Yes" : LA NYC Austin Chicago New_Orleans DC Nashville


#delimit ;
esttab LA NYC Austin Chicago New_Orleans DC Nashville
	using "$repository/code/tables/tex_output/individual_tables/robustness_city.tex",
	keep(*.race_res) drop(1.race_res)
	se ar2 replace label 
	mtitles("LA" "NYC" "Austin" "Chicago" "New Orleans" "DC" "Nashville")
	stats(linehere controlgroup1 controlgroup2 controlgroup3 linehere N r2,
	labels( "\textit{Fixed Effects:}" "Location Controls" "Property Controls" 
		   "Host Controls" "\hline \vspace{-1.25em}"
		   "Observations" "Adjusted R2"))
	fragment
;
#delimit cr
restore
