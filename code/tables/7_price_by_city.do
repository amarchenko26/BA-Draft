********************************************************************************
*					  City Robustness 				    					   *
********************************************************************************

preserve
keep if sample == 1

set more off
set emptycells drop 



****** Price
#delimit ;
quietly reg log_price i.race_sex_res 
			$prop_controls
			summary_polarity summary_subjectivity miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost
				if state == "CA", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo LA
	
#delimit ;
quietly reg log_price i.race_sex_res 
			$prop_controls
			summary_polarity summary_subjectivity miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost
				if state == "NY", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo NYC

#delimit ;
quietly reg log_price i.race_sex_res
			$prop_controls
			summary_polarity summary_subjectivity miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost
				if state == "TX", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed)
;
#delimit cr
eststo Austin


#delimit ;
quietly reg log_price i.race_sex_res $full_controls
				if state == "IL", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo Chicago
		 
#delimit ;	
quietly reg log_price i.race_sex_res
			$prop_controls
			summary_polarity summary_subjectivity miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost
				if state == "LA",  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;	
#delimit cr
eststo New_Orleans

#delimit ;
quietly reg log_price i.race_sex_res
			$prop_controls
			summary_polarity summary_subjectivity miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost
				if state == "DC",  //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo DC
	
#delimit ;
quietly reg log_price i.race_sex_res
			$prop_controls
			summary_polarity summary_subjectivity miss_summary_polarity miss_summary_subjectivity
			space_polarity space_subjectivity description_polarity description_subjectivity 
			miss_space_polarity miss_space_subjectivity miss_description_polarity miss_description_subjectivity
			neighborhood_polarity miss_neighborhood_polarity 
			neighborhood_subjectivity miss_neighborhood_subjectivity //Quality of listing/effort of host
			i.group_host_response_time host_response_rate //Host-specific charac.
			host_identity_verified host_is_superhost 
			miss_group_host_response_time miss_host_response_rate 
			miss_host_identity_verified miss_host_is_superhost
				if state == "TN", //Host-specific charac.
			vce(cluster group_neighbourhood_cleansed) 
;
#delimit cr
eststo Nashville

// Table Output

local controlgroup1 // Location
local controlgroup2 // Property
local controlgroup3 // Host

// Add locals which will serve as indicators for which FEs are included in the models
estadd local controlgroup1 "Yes" : LA NYC Austin Chicago New_Orleans DC Nashville
estadd local controlgroup2 "Yes" : LA NYC Austin Chicago New_Orleans DC Nashville
estadd local controlgroup3 "Yes" : LA NYC Austin Chicago New_Orleans DC Nashville


#delimit ;
esttab LA NYC Austin Chicago New_Orleans DC Nashville
	using "$repository/code/tables/tex_output/individual_tables/price_by_city.tex",
	keep(*.race_sex_res) drop(1.race_sex_res)
	se ar2 replace label 
	mtitles("LA" "NYC" "Austin" "Chicago" "New Orleans" "DC" "Nashville")
	stats(linehere controlgroup1 controlgroup2 controlgroup3 linehere N r2,
	labels( "\textit{Fixed Effects:}" "Location Controls" "Property Controls" 
		   "Host Controls" "\hline \vspace{-1.25em}"
		   "Observations" "Adjusted R2"))
	fragment
;
#delimit cr
restore
