********************************************************************************
*						PRICE 												   *
********************************************************************************
preserve
keep if sample == 1
// Base
quietly reg log_price i.race_sex_res i.age, vce(cluster group_neighbourhood_cleansed) 
eststo model1
			
			
// Add location FEs		
#delimit ; 
quietly reg log_price i.race_sex_res i.age
				  i.group_neighbourhood_cleansed i.cleaned_city, 
				  vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model2

// Add listing FEs

#delimit ;
quietly reg log_price i.race_sex_res i.age
			i.group_neighbourhood_cleansed i.cleaned_city  
			i.group_property_type i.group_room_type
			accommodates bathrooms bedrooms beds i.group_bed_type  
			cleaning_fee extra_people num_amenities
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60,
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model3
				
// Add host FEs
#delimit ;
quietly reg log_price i.race_sex_res i.age i.group_ra_name
			i.group_neighbourhood_cleansed i.cleaned_city 
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type 
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			availability_30 availability_60 
			reviews_polarity reviews_subjectivity summary_polarity summary_subjectivity 
			space_polarity space_subjectivity description_polarity description_subjectivity 
			neighborhood_polarity 
			neighborhood_subjectivity  //Quality of listing/effort of host
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost
			miss_age miss_race_sex_res miss_group_ra_name // Missing indicators
			miss_cleaned_city miss_group_property_type 
			miss_group_room_type miss_accommodates miss_bathrooms miss_bedrooms 
			miss_beds miss_group_bed_type miss_cleaning_fee miss_extra_people 
			miss_num_amenities miss_group_cancellation_policy 
			miss_instant_bookable miss_req_guest_pro_pic
			miss_req_guest_phone miss_minimum_nights miss_availability_30 
			miss_availability_60 
			miss_group_nhood_clean
			popdensity med_value med_gross_rent med_income_city_norm race_white_city_norm // Census variables
			race_black_city_norm race_asian_city_norm race_sor_city_norm race_hnom_city_norm
			unemployed_city_percent HHSSI_city_percent occupied_city_percent commute_city_percent_under
			commute_city_percent_over 
			miss_popdensity // Census missing dummies
			miss_med_value miss_med_gross_rent miss_med_income_city_norm miss_race_white_city_norm 
			miss_race_black_city_norm miss_race_asian_city_norm miss_race_sor_city_norm miss_race_hnom_city_norm
			miss_unemployed_city_percent miss_HHSSI_city_percent miss_occupied_city_percent miss_commute_city_percent_under
			miss_commute_city_percent_over 
			miss_reviews_polarity miss_reviews_subjectivity miss_summary_polarity // NLP missing dummies
			miss_summary_subjectivity miss_space_polarity miss_space_subjectivity miss_description_polarity 
			miss_description_subjectivity miss_neighborhood_polarity miss_neighborhood_subjectivity 
			,
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model4	
	

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : model2 model3 model4 
estadd local controlgroup2 "Yes" : model3 model4
estadd local controlgroup3 "Yes" : model4

// Esttab the table
#delimit ;
esttab model1 model2 model3 model4 
	using "$repository/code/tables/tex_output/individual_tables/price.tex", 
		se ar2 replace label
		keep(_cons *.race_sex_res) drop(1.race_sex_res)
		mtitles("Model 1" "Model 2" "Model 3" "Model 4")
		stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
		labels("Location Controls" "Property Controls" 
			   "Host Controls" "\hline \vspace{-1.25em}"
			   "Observations" "Adjusted R2"))
		fragment 
;
#delimit cr
restore
