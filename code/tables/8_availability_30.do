********************************************************************************
* 						30 Day Availability Supply Side Analysis			   *
********************************************************************************
preserve
keep if sample == 1
* Availability supply-side analysis
#delimit ; 
reg availability_30 i.race_sex_res
			i.group_neighbourhood_cleansed i.cleaned_city
			i.group_property_type i.group_room_type
			accommodates bathrooms bedrooms beds i.group_bed_type
			cleaning_fee extra_people num_amenities  
			i.first_review_month i.first_review_year
			i.group_cancellation_policy instant_bookable 
			require_guest_profile_picture
			require_guest_phone_verification minimum_nights
			len_desc short_words len_desc2 short_words2 len_desc3 
			short_words3 //Quality of listing/effort of host
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 
			short_words6 good_word_tot //Quality of listing
			i.group_host_response_time miss_group_host_response_time 
			host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost,  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model1

// Table Output

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : model1
estadd local controlgroup2 "Yes" : model1
estadd local controlgroup3 "Yes" : model1

// Esttab the table
#delimit ;
esttab model1 using "$repository/code/tables/tex_output/individual_tables/availability_30_days.tex", 
	se ar2 replace label 
	keep(*.race_sex_res) drop(1.race_sex_res)
	mtitles("Number of vacant days out of 30")
	stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
	labels("Location Controls" "Property-Specific Controls" 
		   "Host-Specific Controls" "\hline \vspace{-1.25em}"
		   "Observations" "Adjusted R2"))
	fragment 
;
#delimit cr
restore
