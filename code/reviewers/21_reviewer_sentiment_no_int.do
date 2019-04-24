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

// White reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race == 1, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo mod1 

// Black reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race == 2, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
	eststo mod2 

// Hispanic reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race == 3, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
	eststo mod3  
	
// Asian reviewers
#delimit ;
quietly reg sentiment_mean_stan i.race_res $full_controls_reviewer if rev_race == 4, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
	eststo mod4 


****************************************
*Output
****************************************

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : mod1  mod2  mod3  mod4  
estadd local controlgroup2 "Yes" : mod1  mod2  mod3  mod4  
estadd local controlgroup3 "Yes" : mod1  mod2  mod3  mod4  


#delimit ;
esttab  mod1  mod2  mod3  mod4  using 
	"$repository/code/tables/tex_output/individual_tables/reviewer_mean_reg_no_int.tex",
	keep(*.race_res) drop(1.race_res)
	se ar2 replace label nogap
	mtitles("White" "Black" "Hispanic" "Asian")
	title("Estimates of effect of host demographics on review sentiment, by reviewer race" ) 
	stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
	labels("Location Controls" "Property Controls" 
		   "Host Controls" "\hline \vspace{-1.25em}"
		   "Observations" "Adjusted R2"))
	fragment
		   ;
#delimit cr
