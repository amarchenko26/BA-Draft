

** Regressions

// White Male reviewers
eststo, title("White Male Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 1, ///
	vce(cluster group_neighbourhood_cleansed) 


// White female reviewers
eststo, title("White Female Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 2, ///
	vce(cluster group_neighbourhood_cleansed) 
	

// Black Male reviewers
eststo, title("Black Male Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 3, ///
	vce(cluster group_neighbourhood_cleansed) 
	
	
// Black Female reviewers
eststo, title("Black Female Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 4, ///
	vce(cluster group_neighbourhood_cleansed) 
	
// Hispanic Male reviewers
eststo, title("Hispanic Male Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 5, ///
	vce(cluster group_neighbourhood_cleansed) 
	
	
// Hispanic Female reviewers
eststo, title("Hispanic Female Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 6, ///
	vce(cluster group_neighbourhood_cleansed) 

	
	
// Asian Male reviewers	
eststo, title("Asian Male Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 7, ///
	vce(cluster group_neighbourhood_cleansed) 	
	
// Asian Female reviewers	
eststo, title("Asian Female Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 8, ///
	vce(cluster group_neighbourhood_cleansed) 



esttab est9 est10 est11 est12 est13 est14 est15 est16 using reviewer_mean_reg_5_10.tex, se ar2 replace label mtitles title("Estimates of effect of host demographics on review sentiment, by reviewer demographics") longtable page(longtable)


