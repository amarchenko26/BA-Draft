*********************************************************
*					 Host Robustnesss			        *
*********************************************************


cd "~/Desktop/Combined Data/Robustness"

** State robustness checks do-file
set more off
set emptycells drop // If the interaction term is empty, don't report it in the table, reduces memory and variable necessity 
set matsize 11000 //make matrix bigger so Stata can handle all the regressors


eststo, title("Low avail."): quietly reg price i.race_res ///
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
	host_identity_verified host_is_superhost if availability_30 < 10, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed) 
		
eststo, title("Medium avail."): quietly reg price i.race_res ///
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
	host_identity_verified host_is_superhost if availability_30 > 10 & availability_30 < 20, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed) 
			
eststo, title("High availability"): quietly reg price i.race_res ///
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
	host_identity_verified host_is_superhost if availability_30 > 20, ///  //Host-specific charac.
	vce(cluster group_neighbourhood_cleansed) 
	
	
	
esttab est43 est44 est45 est46 est47 est48 est49 using prop_price_reg_4_15.tex, ///
se ar2 replace label mtitles title("Table 8: Robustness checks by listing characteristics") longtable page(longtable) ///
addnotes("I break down my combined data by price, time on market, and property type. The categories, from left to right, are: listings whose price is below vs. above the mean price of \$147, listings who have have been on the market for no more than 2 years vs. no more than 8 years, and listings of different property types, including apartments (includes apartments and lofts), condos (includes condos and townhouse), and houses. I control for my preferred specification throughout. The outcome variable is price of the listing.")
	
	
	

