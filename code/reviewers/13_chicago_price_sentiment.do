********************************************************************************
*						PRICE w Review Sentiment Control 					   *
********************************************************************************

preserve
keep if reviewer_sample == 1

// Base
quietly reg log_price i.race_sex_res, ///
			vce(cluster group_neighbourhood_cleansed) 
eststo model1
			
			
// Add location FEs		
#delimit ; 
quietly reg log_price i.race_sex_res $full_controls_reviewer, 
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model2


// Add listing FEs
#delimit ;
quietly reg log_price i.race_sex_res i.age $full_controls_reviewer,
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo model3
			
			
// Add host FEs
#delimit ;
quietly reg log_price i.race_sex_res $full_controls_reviewer,
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
	using "$repository/code/tables/tex_output/individual_tables/chicago_price_sentiment.tex", 
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
