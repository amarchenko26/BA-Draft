*********************************************************
*					  Reviewers Regression 			    *
*********************************************************
#delimit ; 
global full_controls_reviewer i.age i.group_ra_name
			i.group_neighbourhood_cleansed // Location dummies
			miss_rev_age  // Location missing dummies
			miss_group_nhood_clean 
				popdensity med_value med_gross_rent med_income_city_norm race_white_city_norm // Census variables
				race_black_city_norm race_asian_city_norm race_sor_city_norm race_hnom_city_norm
				unemployed_city_percent HHSSI_city_percent occupied_city_percent commute_city_percent_under
				commute_city_percent_over 
				miss_popdensity 
				miss_med_value miss_med_gross_rent miss_med_income_city_norm miss_race_white_city_norm 
				miss_race_black_city_norm miss_race_asian_city_norm miss_race_sor_city_norm miss_race_hnom_city_norm
				miss_unemployed_city_percent miss_HHSSI_city_percent miss_occupied_city_percent miss_commute_city_percent_under
				miss_commute_city_percent_over 
					i.group_property_type i.group_room_type // Listing FEs
					accommodates bathrooms bedrooms beds i.group_bed_type  
					cleaning_fee extra_people num_amenities
					i.first_review_month i.first_review_year
					i.group_cancellation_policy instant_bookable 
					require_guest_profile_picture
					require_guest_phone_verification minimum_nights
					availability_30 availability_60
					miss_group_property_type miss_group_room_type // Listing missing dummies
					miss_accommodates miss_bathrooms miss_bedrooms miss_beds miss_group_bed_type 
					miss_cleaning_fee miss_extra_people miss_num_amenities 
					miss_first_review_month miss_first_review_year 
					miss_group_cancellation_policy miss_instant_bookable 	
					miss_req_guest_pro_pic
					miss_req_guest_phone miss_minimum_nights 
					miss_availability_30 miss_availability_60
						summary_polarity summary_subjectivity // NLP controls
						space_polarity space_subjectivity description_polarity description_subjectivity 
						neighborhood_polarity neighborhood_subjectivity
						miss_summary_polarity miss_summary_subjectivity // NLP missing dummies 
						miss_space_polarity miss_space_subjectivity miss_description_polarity 
						miss_description_subjectivity miss_neighborhood_polarity miss_neighborhood_subjectivity 
						i.group_host_response_time host_response_rate // Host listing FEs
						host_identity_verified host_is_superhost 
						miss_group_host_response_time miss_host_response_rate // Host missing dummies
						miss_host_identity_verified miss_host_is_superhost
;
#delimit cr

sum sentiment_mean
gen sentiment_mean_zscore =  (sentiment_mean -`r(mean)')/`r(sd)'

preserve
keep if reviewer_sample == 1

** Regressions

// ALL reviewers
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo mod0

// White Male reviewers
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer if rev_race_sex_res == 1, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo mod1 

// White female reviewers
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer  if rev_race_sex_res == 2, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
	eststo mod2 

// Black Male reviewers
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer if rev_race_sex_res == 3, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
	eststo mod3  
	
// Black Female reviewers
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer if rev_race_sex_res == 4, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
	eststo mod4 
	
// Hispanic Male reviewers
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer if rev_race_sex_res == 5, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
	eststo mod5 
	
// Hispanic Female reviewers
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer if rev_race_sex_res == 6, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo mod6 
	
// Asian Male reviewers	
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer if rev_race_sex_res == 7, ///
	vce(cluster group_neighbourhood_cleansed) 	
;
#delimit cr
eststo mod7 
	
// Asian Female reviewers	
#delimit ;
quietly reg sentiment_mean_zscore i.race_sex_res ///
	$full_controls_reviewer if rev_race_sex_res == 8, ///
	vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo mod8 

****************************************
*Output
****************************************

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : mod0 mod1  mod2  mod3  mod4  mod5  mod6  mod7  mod8
estadd local controlgroup2 "Yes" : mod0 mod1  mod2  mod3  mod4  mod5  mod6  mod7  mod8
estadd local controlgroup3 "Yes" : mod0 mod1  mod2  mod3  mod4  mod5  mod6  mod7  mod8


#delimit ;
esttab  mod0  mod1  mod2  mod3  mod4  mod5  mod6  mod7  mod8  using 
	"$repository/code/tables/tex_output/individual_tables/reviewer_mean_reg.tex",
	keep(*.race_sex_res) drop(1.race_sex_res)
	se ar2 replace label nogap
	mtitles("Full sample" "White M" "White F" "Black M"
			"Black F" "Hispanic M" "Hispanic F"
			"Asian M" "Asian F")
	title("Estimates of effect of host demographics on review sentiment, by reviewer demographics" ) 
	stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
	labels("Location Controls" "Property Controls" 
		   "Host Controls" "\hline \vspace{-1.25em}"
		   "Observations" "Adjusted R2"))
	fragment
		   ;
#delimit cr

restore
