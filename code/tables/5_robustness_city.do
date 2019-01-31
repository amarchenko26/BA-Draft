********************************************************************************
*					  City Robustness 				    					   *
********************************************************************************


** State robustness checks do-file
set more off
set emptycells drop 



****** Price
#delimit ;
quietly reg price i.race_res 
			i.group_neighbourhood_cleansed i.cleaned_city
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year 
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
quietly reg price i.race_res 
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year  
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
quietly reg price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year  
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
quietly reg price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities
			i.first_review_month i.first_review_year 
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
quietly reg price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year 
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
quietly reg price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year  
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
quietly reg price i.race_res
			i.group_neighbourhood_cleansed i.cleaned_city
			i.group_property_type i.group_room_type
			accommodates bathrooms bedrooms beds i.group_bed_type
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year 
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



// hi pick back up here
#delimit ;
esttab LA NYC Austin Chicago New_Orleans DC Nashville
	using "$repository/code/tables/output/robustness_city.tex",
	se ar2 replace label 
	keep(*.cleaned_city)
	mtitles("LA" "NYC" "Austin" "Chicago" "New Orleans" "DC" "Nashville")
	fragment
;
#delimit cr


///DELETE LATER
#delimit ;
esttab LA NYC Austin Chicago New_Orleans DC Nashville using "$repository/code/tables/output/robustness_city_full.tex",
	se ar2 replace label 
	mtitles()
	title("Robustness City")
	addnotes("...")
;
#delimit cr
