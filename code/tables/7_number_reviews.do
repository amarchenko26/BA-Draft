********************************************************************************
*								Number of reviews							   *
********************************************************************************
preserve
keep if sample == 1
#delimit ;
quietly reg log_number_of_reviews i.race_sex_res i.age,  
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model1

#delimit ;
quietly reg log_number_of_reviews i.race_sex_res i.age
			i.group_neighbourhood_cleansed i.cleaned_city,
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model2

// Add listing specification
#delimit ;
quietly reg log_number_of_reviews i.race_sex_res i.age 
			i.group_neighbourhood_cleansed i.cleaned_city // Location
			i.group_property_type i.group_room_type //Listing-type
			accommodates bathrooms bedrooms beds 
			i.group_bed_type //Airbnb charac.
			cleaning_fee extra_people num_amenities
			i.first_review_month i.first_review_year miss_first_review_year //Time on market
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture //Policies
			require_guest_phone_verification minimum_nights //Misc.
			availability_30 availability_60,
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model3
				
// Add host specification
#delimit ;
quietly reg log_number_of_reviews i.race_sex_res i.age 
			i.group_neighbourhood_cleansed i.cleaned_city  
			i.group_property_type i.group_room_type 
			accommodates bathrooms bedrooms beds i.group_bed_type  
			cleaning_fee extra_people num_amenities 
			i.first_review_month i.first_review_year miss_first_review_year 
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture 
			require_guest_phone_verification minimum_nights 
			availability_30 availability_60 reviews_polarity reviews_subjectivity 
			summary_polarity summary_subjectivity 
			space_polarity space_subjectivity description_polarity description_subjectivity 
			neighborhood_polarity 
			neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost, //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model4

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

estadd local controlgroup1 "Yes" : model2 model3 model4
estadd local controlgroup2 "Yes" : model3 model4
estadd local controlgroup3 "Yes" : model4

#delimit ;
esttab model1 model2 model3 model4 using
	"$repository/code/tables/tex_output/individual_tables/number_reviews.tex", 
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
