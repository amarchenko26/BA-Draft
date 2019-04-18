********************************************************************************
*		  Property Characteristics Robustness 		    					   *
********************************************************************************
preserve
keep if sample == 1
** State robustness checks do-file
set more off
set emptycells drop 

** Predicted price in LA
#delimit ; 
quietly reg log_price
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
			len_desc4 short_words4 len_desc5 short_words5 
			len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if state == "CA",  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
predict predict_price_LA

** Predicted price in NYC
#delimit ; 
quietly reg log_price
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
			len_desc3 short_words3  //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost
				if state == "NY",   //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
predict predict_price_NY

** Predicted price in Chicago
#delimit ; 
quietly reg log_price
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities  
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 len_desc3 
			short_words3  //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot  // listing
			i.group_host_response_time miss_group_host_response_time
			host_response_rate  //Host-specific charac.
			host_identity_verified host_is_superhost 
				if state == "IL",   //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
predict predict_price_chi
*/

****** Low/high price robustness 
#delimit ; 
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities  
			i.first_review_month i.first_review_year miss_first_review_year 
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture 
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3  //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 
			len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if predict_price_LA < 171 & state=="CA",  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model1

#delimit ;
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed 
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
			len_desc4 short_words4 len_desc5 short_words5 
			len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if predict_price_LA > 171 & state=="CA",   //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model2 

#delimit ;
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture 
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3  //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot /// //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate  //Host-specific charac.
			host_identity_verified host_is_superhost 
				if predict_price_NY < 132 & state=="NY", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model3 

#delimit ; 
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed 
			i.group_property_type i.group_room_type
			accommodates bathrooms bedrooms beds i.group_bed_type
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3  //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if predict_price_NY > 132 & state=="NY", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model4

#delimit ; 		
quietly reg log_price i.race_res
			i.group_neighbourhood_cleansed 
			i.group_property_type i.group_room_type
			accommodates bathrooms bedrooms beds i.group_bed_type
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3  //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if predict_price_chi < 124 & state=="IL", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model5 

#delimit ; 
 quietly reg log_price i.race_res
	i.group_neighbourhood_cleansed
	i.group_property_type i.group_room_type
	accommodates bathrooms bedrooms beds i.group_bed_type 
	cleaning_fee extra_people num_amenities  
	i.first_review_month i.first_review_year miss_first_review_year
	i.group_cancellation_policy instant_bookable require_guest_profile_picture
	require_guest_phone_verification minimum_nights
	availability_30 availability_60
	len_desc short_words len_desc2 short_words2 len_desc3 
	short_words3 //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 
	short_words6 good_word_tot //Quality of listing
	i.group_host_response_time miss_group_host_response_time 
	host_response_rate //Host-specific charac.
	host_identity_verified host_is_superhost 
		if predict_price_chi > 124 & state=="IL",  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model6

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
			len_desc short_words len_desc2 short_words2 
			len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if first_review_year < 15, //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model7 

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
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if first_review_year < 99 & first_review_year > 14, 
					//Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model8 

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
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if property_type == "Apartment" | property_type == "Loft", 
					//Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model9 

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
			len_desc short_words len_desc2 short_words2 len_desc3 
			short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if property_type == "Townhouse" | property_type == "Condominium"
				, //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model10 

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
			len_desc short_words len_desc2 short_words2 len_desc3 
			short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if property_type == "House" | property_type == "Guesthouse" 
				,  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr

eststo model11 




local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : model1 model2 model3 model4 model7 model8 model9 model10 model11
estadd local controlgroup2 "Yes" : model1 model2 model3 model4 model7 model8 model9 model10 model11
estadd local controlgroup3 "Yes" : model1 model2 model3 model4 model7 model8 model9 model10 model11


// Esttab the table 
#delimit ;
esttab model1 model2 model3 model4 model7 model8 model9 model10 model11 
		using "$repository/code/tables/tex_output/individual_tables/robustness_listing_char.tex", 
	se ar2 replace label 
	keep(*.race_res) drop(1.race_res)
	mtitles("Low \\$ LA" 
			"High \\$ LA" "Low \\$ NY" "High \\$ NY" "Older Listings" 
			"Newer Listings" "Apartments" "Condos" "Houses") //Did not inlude m5 and m6
	stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
	labels("Location Controls" "Property Controls" 
		   "Host Controls" "\hline \vspace{-1.25em}"
		   "Observations" "Adjusted R2"))
	fragment 
;
#delimit cr
restore
