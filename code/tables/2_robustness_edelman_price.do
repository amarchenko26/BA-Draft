********************************************************************************
*			    Edelman Price Robustness 							  		   *
********************************************************************************


** State robustness checks do-file
set more off
set emptycells drop 

destring review_scores*, replace force
gen rev_loc_2 = review_scores_location^2
gen test1 = bedrooms * group_room_type
	
#delimit ;
quietly reg price i.race_res
			accommodates bedrooms 
			review_scores_location rev_loc_2 review_scores_checkin review_scores_communication 
			review_scores_cleanliness review_scores_accuracy
			host_identity_verified  //Host-specific charac.
			i.group_room_type 
				if state == "NY"
;
#delimit cr
eststo edelman
	
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
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if availability_30 > 10 & availability_30 < 20,  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo medium_avail

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
			len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot //Q of listing
			i.group_host_response_time miss_group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
				if availability_30 > 20, //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo high_avail	

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

estadd local controlgroup1 "Yes" : edelman medium_avail high_avail
estadd local controlgroup2 "Yes" : edelman medium_avail high_avail
estadd local controlgroup3 "Yes" : edelman medium_avail high_avail

#delimit ;
esttab edelman using
	"$repository/code/tables/output/edelman_price.tex",
		se ar2 replace label 
		keep(*.race_res)
		mtitles("Edelman" "Medium Avail." "High Availibility")
		stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
		labels("Location Fixed Effects" "Property Fixed Effects" 
				"Host Fixed Effects" "\hline \vspace{-1.25em}" "Observations" 
				"Adjusted R2"))
		fragment
;
#delimit cr
	
///WILL BE DELETED

#delimit ;
esttab edelman using
	"$repository/code/tables/output/edelman_price_full.tex",
		se ar2 replace label 
		keep(*.race_res)
		title("Edelman")
		mtitles("Edelman" "Medium Avail." "High Availibility")
		stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
		labels("Location Fixed Effects" "Property Fixed Effects" 
				"Host Fixed Effects" "\hline \vspace{-1.25em}" "Observations" 
				"Adjusted R2"))
		addnotes("...")
;
#delimit cr
	
	

