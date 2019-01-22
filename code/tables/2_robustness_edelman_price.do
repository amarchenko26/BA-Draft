*********************************************************
*			    Edelman Price Robustness 			    *
*********************************************************


cd "~/Desktop/Combined Data/Robustness"

** State robustness checks do-file
set more off
set emptycells drop // If the interaction term is empty, don't report it in the table, reduces memory and variable necessity 
set matsize 11000 //make matrix bigger so Stata can handle all the regressors

destring review_scores*, replace force
gen rev_loc_2 = review_scores_location^2
gen test1 = bedrooms * group_room_type

eststo, title("Edelman"): quietly reg price i.race_res ///
	accommodates bedrooms /// 
	review_scores_location rev_loc_2 review_scores_checkin review_scores_communication ///
	review_scores_cleanliness review_scores_accuracy /// 
	host_identity_verified ///  //Host-specific charac.
	i.group_room_type if state == "NY"

		
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
	
	
	
esttab est3 using edelman_price_reg_5_8.tex, ///
se ar2 replace label mtitles title("Table 8: Robustness checks with Edelman & Luca controls") longtable page(longtable) ///
addnotes("This table presents the effect on price of controlling for Edelman \& Luca's (2014) full specification using my NYC data. My results are nearly identical to theirs (their coefficient on Black hosts was -17.8) when controlling for similar covariates in the same city. The omitted category for race is White hosts. The omitted category for room type is Entire Apartment. I could not control for host social media accounts as a proxy for host reliability like Edelman \& Luca did, because Airbnb no longer provides this information. Instead, I controlled for ``host verified", a boolean for whether Airbnb has the host's phone number and email. I was not able to control for ``picture quality" either, but picture quality did not significantly influence price in Edelman \& Luca's regression.")
	
	
	

