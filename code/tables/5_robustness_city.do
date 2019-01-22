*********************************************************
*					  City Robustness 				    *
*********************************************************


cd "~/Desktop/Combined Data/Robustness"

** State robustness checks do-file
set more off
set emptycells drop // If the interaction term is empty, don't report it in the table, reduces memory and variable necessity 
set matsize 11000 //make matrix bigger so Stata can handle all the regressors


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
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost if state == "CA", //Host-specific charac.
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
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost if state == "NY", //Host-specific charac.
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
			i.group_cancellation_policy instant_bookable require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60
			len_desc short_words len_desc2 short_words2 len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost if state == "TX", //Host-specific charac.
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
			i.group_cancellation_policy instant_bookable require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60
			len_desc short_words len_desc2 short_words2 len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost if state == "IL", //Host-specific charac.
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
			i.group_cancellation_policy instant_bookable require_guest_profile_picture 
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost if state == "LA",  //Host-specific charac.
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
			i.group_cancellation_policy instant_bookable require_guest_profile_picture
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost if state == "DC",  //Host-specific charac.
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
			i.group_cancellation_policy instant_bookable require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60 
			len_desc short_words len_desc2 short_words2 len_desc3 short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost if state == "TN", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo Nashville


// hi pick back up here
#delimit ;
esttab LA NYC Austin Chicago New_Orleans DC Nashville
using "$repository/code/tables/output/robustness_city.tex",
	se ar2 replace label 
	mtitles()
	fragment
;
#delimit cr

/*
****** Revenue
gen p_reviews = price*number_of_reviews //highly significant

eststo, title("Model 1"): quietly reg p_reviews i.race_sex_res i.age, /// 
vce(cluster group_neighbourhood_cleansed)

eststo, title("Model 2"): quietly reg p_reviews i.race_sex_res i.age ///
i.group_neighbourhood_cleansed i.cleaned_city, ///
vce(cluster group_neighbourhood_cleansed)

// Add listing specification
eststo, title("Model 3"): quietly reg p_reviews i.race_sex_res i.age ///
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
eststo, title("Model 4"): quietly reg p_reviews i.race_sex_res i.age ///
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
		
esttab est5 est6 est7 est8 using revenue_reg_4_14.tex, se ar2 replace label mtitles title("Estimates of effect of host's race and gender on revenue") longtable page(longtable)


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
		
esttab est9 est10 est11 est12 using numrev_reg_4_14.tex, se ar2 replace label mtitles title("Estimates of effect of host's race and gender on number of reviews") longtable page(longtable)








