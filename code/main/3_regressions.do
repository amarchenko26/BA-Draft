*********************************************************
*					  Regression 					    *
*********************************************************


/*
** Availability supply-side analysis
eststo, title("x"): reg availability_60 i.race_sex_res ///
	i.group_neighbourhood_cleansed i.cleaned_city /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time miss_group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed) 
*/


****** Price
eststo, title("Model 1"): quietly reg price i.race_sex_res i.age, /// 
vce(cluster group_neighbourhood_cleansed) 

eststo, title("Model 2"): quietly reg price i.race_sex_res i.age ///
i.group_neighbourhood_cleansed i.cleaned_city, ///
vce(cluster group_neighbourhood_cleansed) 

// Add listing specification
//eststo, title("Model 3"): quietly 

reg price i.race_sex_res i.age ///
	i.group_neighbourhood_cleansed i.cleaned_city /// // Location
	i.group_property_type i.group_room_type /// //Listing-type
	accommodates bathrooms bedrooms beds i.group_bed_type /// //Airbnb charac.
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// //Time on market
	i.group_cancellation_policy instant_bookable require_guest_profile_picture /// Policies
	require_guest_phone_verification minimum_nights /// //Misc.
	availability_30 availability_60, ///
	vce(cluster group_neighbourhood_cleansed) 
				
// Add host specification
eststo, title("Model 4"): quietly reg price i.race_sex_res i.age ///
	i.group_neighbourhood_cleansed i.cleaned_city /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time miss_group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost
	
	, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed) 
		
//Add RAs		
eststo, title("Model 5: RA FEs"): quietly reg price i.race_sex_res i.age i.group_ra_name ///
	i.group_neighbourhood_cleansed i.cleaned_city /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time miss_group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed) 
		
		
delimit ;
esttab est1 est2 est3 est4 est5 using "$repository/code/output/price.tex", se ar2 replace
	label mtitles title("Robustness check with RA fixed effects") 
	longtable page(longtable)

;

****** Revenue
gen p_year_reviews = price*reviews_per_month*12 //highly significant

eststo, title("Model 1"): quietly reg p_year_reviews i.race_sex_res i.age, /// 
vce(cluster group_neighbourhood_cleansed)

eststo, title("Model 2"): quietly reg p_year_reviews i.race_sex_res i.age ///
i.group_neighbourhood_cleansed i.cleaned_city, ///
vce(cluster group_neighbourhood_cleansed)

// Add listing specification
eststo, title("Model 3"): quietly reg p_year_reviews i.race_sex_res i.age ///
	i.group_neighbourhood_cleansed i.cleaned_city /// // Location
	i.group_property_type i.group_room_type /// //Listing-type
	accommodates bathrooms bedrooms beds i.group_bed_type /// //Airbnb charac.
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// //Time on market
	i.group_cancellation_policy instant_bookable require_guest_profile_picture /// Policies
	require_guest_phone_verification minimum_nights /// //Misc.
	availability_30 availability_60, ///
	vce(cluster group_neighbourhood_cleansed)
				
// Add host specification
eststo, title("Model 4"): quietly reg p_year_reviews i.race_sex_res i.age ///
	i.group_neighbourhood_cleansed i.cleaned_city /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time miss_group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed)

delimit ;		
esttab est8 est9 est10 est11 using "$repository/code/output/yearly_revenue.tex", se ar2 replace 
	label mtitles title("Estimates of effect of host's race and gender on yearly revenue") 
	longtable page(longtable)
;

****** Number of reviews

eststo, title("Model 1"): quietly reg number_of_reviews i.race_sex_res i.age, /// 
vce(cluster group_neighbourhood_cleansed)

eststo, title("Model 2"): quietly reg number_of_reviews i.race_sex_res i.age ///
i.group_neighbourhood_cleansed i.cleaned_city, ///
vce(cluster group_neighbourhood_cleansed)

// Add listing specification
eststo, title("Model 3"): quietly reg number_of_reviews i.race_sex_res i.age ///
	i.group_neighbourhood_cleansed i.cleaned_city /// // Location
	i.group_property_type i.group_room_type /// //Listing-type
	accommodates bathrooms bedrooms beds i.group_bed_type /// //Airbnb charac.
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// //Time on market
	i.group_cancellation_policy instant_bookable require_guest_profile_picture /// Policies
	require_guest_phone_verification minimum_nights /// //Misc.
	availability_30 availability_60, ///
	vce(cluster group_neighbourhood_cleansed)
				
// Add host specification
eststo, title("Model 4"): quietly reg number_of_reviews i.race_sex_res i.age ///
	i.group_neighbourhood_cleansed i.cleaned_city /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time miss_group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed)

delimit ;		
esttab est9 est10 est11 est12 using "$repository/code/output/number_reviews.tex", se ar2 replace 
	label mtitles title("Estimates of effect of host's race and gender on number of reviews") 
	longtable page(longtable)
;


****** Testing

****** Number of reviews

eststo, title("Model 1"): quietly reg reviews_per_year i.race_sex_res i.age, /// 
vce(cluster group_neighbourhood_cleansed)

eststo, title("Model 2"): quietly reg reviews_per_year i.race_sex_res i.age ///
i.group_neighbourhood_cleansed i.cleaned_city, ///
vce(cluster group_neighbourhood_cleansed)

// Add listing specification
eststo, title("Model 3"): quietly reg reviews_per_year i.race_sex_res i.age ///
	i.group_neighbourhood_cleansed i.cleaned_city /// // Location
	i.group_property_type i.group_room_type /// //Listing-type
	accommodates bathrooms bedrooms beds i.group_bed_type /// //Airbnb charac.
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month  /// //Time on market
	i.group_cancellation_policy instant_bookable require_guest_profile_picture /// Policies
	require_guest_phone_verification minimum_nights /// //Misc.
	availability_30 availability_60, ///
	vce(cluster group_neighbourhood_cleansed)
				
// Add host specification
eststo, title("Model 4"): quietly reg reviews_per_year i.race_sex_res i.age ///
	i.group_neighbourhood_cleansed i.cleaned_city /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time miss_group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed)

delimit ; 		
esttab est6 est7 est8 est9 using "$repository/code/output/reviews_per_year.tex", 
	se ar2 replace label mtitles 
	title("Estimates of effect of host's race and gender on number of reviews per year on market") 
	alongtable page(longtable)
;





