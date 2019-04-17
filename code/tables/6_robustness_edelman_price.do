********************************************************************************
*			    Edelman Price Robustness 							  		   *
********************************************************************************
preserve
keep if sample==1
** State robustness checks do-file
set more off
set emptycells drop 

destring review_scores*, replace force
gen rev_loc_2 = review_scores_location^2
gen test1 = bedrooms * group_room_type

la var accommodates "Accommodates"
la var review_scores_location "Review Scores Location"
la var rev_loc_2 "Review Scores Location Squared"
la var review_scores_checkin "Review Scores Checkin"
la var review_scores_communication "Review Scores Communication"
la var review_scores_cleanliness "Review Scores Cleanliness"
la var review_scores_accuracy "Review Scores Accuracy"
	
#delimit ;
quietly reg log_price i.race_res
			accommodates bedrooms 
			review_scores_location rev_loc_2 review_scores_checkin review_scores_communication 
			review_scores_cleanliness review_scores_accuracy
			host_identity_verified  //Host-specific charac.
			i.group_room_type 
				if state == "NY"
;
#delimit cr
eststo edelman

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

estadd local controlgroup1 "Yes" 
estadd local controlgroup2 "Yes" 
estadd local controlgroup3 "Yes"

#delimit ;
esttab edelman using
	"$repository/code/tables/tex_output/individual_tables/edelman_price.tex",
		se ar2 replace label nogaps
		mtitles("Price per night")
		drop(_cons 1.race_res 3.race_res 4.race_res 1.group_room_type)
		stats(controlgroup1 controlgroup2 controlgroup3 linehere N r2,
		labels("Location Controls" "Property Controls" 
				"Host Controls" "\hline \vspace{-1.25em}" "Observations" 
				"Adjusted R2"))
		fragment
;
#delimit cr
restore
