********************************************************************************
*					PRICE by LISTING CHARACTERISTICS	 				   *
********************************************************************************

// Price > 800
#delimit ;
quietly reg log_price i.race_sex_res $full_controls if price > 800 & sample_all_price,
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model1

// All prices
#delimit ;
quietly reg log_price i.race_sex_res $full_controls if sample_all_price,
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model2


preserve
keep if sample == 1

// Number of reviews >= 5
#delimit ;
quietly reg log_price i.race_sex_res $full_controls if number_of_reviews >= 5,
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model3

#delimit ; 
quietly reg log_price i.race_sex_res $full_controls
				if first_review_year < 15,
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model4

#delimit ; 
quietly reg log_price i.race_sex_res $full_controls
				if first_review_year < 99 & first_review_year > 14,
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model5

#delimit ; 			
quietly reg log_price i.race_sex_res $full_controls
				if (property_type == "Apartment" | property_type == "Loft"),
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model6

#delimit ; 
quietly reg log_price i.race_sex_res $full_controls
				if (property_type == "Townhouse" | property_type == "Condominium"),
				vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo model7

#delimit ; 			
quietly reg log_price i.race_sex_res $full_controls
				if (property_type == "House" | property_type == "Guesthouse"),
				vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr

eststo model8


// Esttab the table
#delimit ;
esttab model1 model2 model3 model4 model5 model6 model7 model8  
	using "$repository/code/tables/tex_output/individual_tables/price_by_listing_type.tex", 
		se ar2 replace label nonumbers
		keep(_cons *.race_sex_res) drop(1.race_sex_res)
		mtitles("$>$ \\$800/night" "All prices" "$\geq$ 5 reviews" "Older Listings" 
			"Newer Listings" "Apartments" "Condos" "Houses")
		stats(cumpct linehere N r2,
		labels("Percentage" "\hline \vspace{-1.25em}"
			   "Observations" "Adjusted R2"))
		fragment 
;
#delimit cr
restore
