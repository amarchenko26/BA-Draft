*********************************************************
*					  Reviewers Regression 			    *
*********************************************************


preserve
keep if sample == 1

***What is sentiment_mean_stan? I tried standardizing, but I don't think that worked
** Creating sentiment_mean_stan
*drop sentiment_mean_min  sentiment_mean_temp  sentiment_mean_temp_max  sentiment_mean_stan

sum sentiment_mean
gen sentiment_mean_stan =  (sentiment_mean-`r(mean)')/`r(sd)'


** Regressions

// White Male reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_sex_res ///
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
;
#delimit cr
eststo mod1 // title("White Male Reviewers"): 

// White female reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_sex_res ///
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
;
#delimit cr
	eststo mod2 //, title("White Female Reviewers"): 

// Black Male reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_sex_res ///
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
;
#delimit cr
	eststo mod3 //, title("Black Male Reviewers"): 
	
// Black Female reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_sex_res ///
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
;
#delimit cr
	eststo mod4 //, title("Black Female Reviewers"): 
	
// Hispanic Male reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_sex_res ///
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
;
#delimit cr
	eststo mod5 //, title("Hispanic Male Reviewers"): 
	
// Hispanic Female reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_sex_res ///
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
;
#delimit cr
eststo mod6 //, title("Hispanic Female Reviewers"): 
	
// Asian Male reviewers	
#delimit ;
quietly reg sentiment_mean_stan i.race_sex_res ///
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
;
#delimit cr
eststo mod7 //, title("Asian Male Reviewers"): 	
	
// Asian Female reviewers	
#delimit ;
reg sentiment_mean_stan i.race_sex_res ///
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
;
#delimit cr
eststo mod8 //, title("Asian Female Reviewers"):  

****************************************
*Output
****************************************

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : mod1  mod2  mod3  mod4  mod5  mod6  mod7  mod8
estadd local controlgroup2 "Yes" : mod1  mod2  mod3  mod4  mod5  mod6  mod7  mod8
estadd local controlgroup3 "Yes" : mod1  mod2  mod3  mod4  mod5  mod6  mod7  mod8


#delimit ;
esttab  mod1  mod2  mod3  mod4  mod5  mod6  mod7  mod8  using 
	"$repository/code/tables/tex_output/individual_tables/reviewer_mean_reg.tex",
	keep(*.race_sex_res) drop(1.race_sex_res)
	se ar2 replace label
	mtitles("White M" "White F" "Black M"
			"Black F" "Hispanic M" "Hispanic F"
			"Asian M" "Asian F")
	title("Estimates of effect of host demographics on review sentiment, by reviewer demographics" ) 
	stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
	labels("Location Fixed Effects" "Property Fixed Effects" 
		   "Host Fixed Effects" "\hline \vspace{-1.25em}"
		   "Observations" "Adjusted R2"))
	fragment
		   ;
#delimit cr
