********************************************************************************
*	        Summary Statistics by Host Race: Listing Characteristics	       *
********************************************************************************


// open .tex file
cap file close f
file open f using "$repository/code/tables/tex_output/individual_tables/summary_table.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Summary Statistics By Host Race: Listing Characteristics}" _n ///
"\begin{center}%" _n ///
"\small\begin{tabular}{l c | c | c c c c}" _n ///

// write column headers
file write f "& \multicolumn{1}{c}{} & \multicolumn{5}{c}{Regression Sample}" _n ///
"\\" _n ///
" \cmidrule(r){3-7}" _n ///
"\\" _n ///
" & \multicolumn{1}{c}{Full data} & \multicolumn{1}{c}{All} & White & Black & Hispanic & Asian" _n ///
"\\" _n ///
"\hline\hline\noalign{\smallskip} " _n 

****************************************
* OUTCOME VARIABLES
****************************************
			file write f " \textit{\textit{Outcome Variables}} & & & & & & \\"
			
local ncat log_price log_number_of_reviews

	foreach i in `ncat'{ //loops over noncategorical variables
			sum `i' //Full data column
			local full_observations = `r(N)' //saves full data N
			local full_mean_`i' = `r(mean)'
			local full_sd_`i' = `r(sd)'
			preserve
			keep if sample == 1 //restricts regression sample
			sum `i' //All column
			local all_observations = `r(N)' //saves all N 
			local all_mean_`i' = `r(mean)'
			local all_sd_`i' = `r(sd)'
			local var_label : variable label `i'
			levelsof race_res
			foreach f in `r(levels)'{
				sum `i' if race_res == `f'
				local `f'_race_observations = `r(N)' //saves race N
				local `f'_mean_`i' = `r(mean)'
				local `f'_sd_`i' = `r(sd)'
			}
			restore
			//write means
			//write label
			file write f " `: var label `i'' & " %4.2f (`full_mean_`i'') " & " %4.2f (`all_mean_`i'') " & " %4.2f (`1_mean_`i'') " & " %4.2f (`2_mean_`i'') " & " %4.2f (`3_mean_`i'') " & " %4.2f (`4_mean_`i'') " "
			file write f "\\" _n
			file write f " & " "(" %4.2f (`full_sd_`i'') ")" " & " "(" %4.2f (`all_sd_`i'') ")" " & " "(" %4.2f (`1_sd_`i'') ")" " & " "(" %4.2f (`2_sd_`i'') ")" " & " "(" %4.2f (`3_sd_`i'') ")" " & " "(" %4.2f (`4_sd_`i'') ")" " "
			file write f "\\" _n
			
	}


************************************
* Categorical Data
************************************

//Cleaning Categorical Data
	//Property type
	//Checking if variable property_type_2 already exists
	capture confirm variable property_type_2
	if !_rc{
		drop property_type_2
	}
	
	egen property_type_2 = group(property_type), label

	replace property_type_2 = 1 if property_type_2 == 20 //Setting Lofts = Apts
	replace property_type_2 = 11 if property_type_2 == 27 //Setting Townhouses =  Condos
	replace property_type_2 = 4 if property_type_2 != 1 & property_type_2 != 11 &  property_type_2 != 16 //Set everything which isn't house, condos/townhouses, apts/lofts to Others
	replace property_type_2 = 2 if property_type_2 == 11
	replace property_type_2 = 3 if property_type_2 == 16


	#delimit; 
	label define property_type_2 
			1 "Apartment/Lofts" 2 "Townhouses/Condos" 3 "Houses" 4 "Others", replace
	;
	#delimit cr

	//Cleaning Roomtypes
	//Checking if variable room_type_2 already exists
	capture confirm variable room_type_2
	if !_rc{
		drop room_type_2
	}
	
	egen room_type_2 = group(room_type), label


//Generating Table Output
		file write f " \textit{Covariates} & & & & & & \\"
		file write f " \hline"
		file write f " Property Type & & & & & & \\"

local cat property_type_2
	foreach i in `cat'{ //loops over noncategorical variables
		sum `i' //Full Data
				local full_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
			
		sum `i' if sample == 1 //Regression Data
				local all_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
			
		levelsof `i'
				foreach k in `r(levels)'{
					sum `i' if `i' == `k' //Full Data
					local `k'_full_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
					local `k'_full_mean_`i' = ``k'_full_N_`i''/`full_N_`i''
					preserve
					keep if sample == 1 //restricts regression sample
					sum `i' if `i' == `k' //Full Data
					local `k'_all_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
					local `k'_all_mean_`i' = ``k'_all_N_`i''/`all_N_`i''
					
					levelsof race_res
						foreach r in `r(levels)' {
							sum `i' if race_res == `r' 
							local `r'_race_N_`i' = `r(N)'
								sum `i' if `i' == `k' & race_res == `r'
								local `r'_`k'_race_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
								local `r'_`k'_race_mean_`i' = ``r'_`k'_race_N_`i''/``r'_race_N_`i''
						
						}
					restore
					
					}
		file write f " \hspace{10bp}Apartments/Lofts  	& " %4.2f (`1_full_mean_`i'') " & " %4.2f (`1_all_mean_`i'') " & " %4.2f (`1_1_race_mean_`i'') " & " %4.2f (`2_1_race_mean_`i'') " & " %4.2f (`3_1_race_mean_`i'') " & " %4.2f (`4_1_race_mean_`i'') " \\"
		file write f " \hspace{10bp}Townhouses/Condos  	& " %4.2f (`2_full_mean_`i'') " & " %4.2f (`2_all_mean_`i'') " & " %4.2f (`1_2_race_mean_`i'') " & " %4.2f (`2_2_race_mean_`i'') " & " %4.2f (`3_2_race_mean_`i'') " & " %4.2f (`4_2_race_mean_`i'') " \\"		
		file write f " \hspace{10bp}Houses 			& " %4.2f (`3_full_mean_`i'') " & " %4.2f (`3_all_mean_`i'') " & " %4.2f (`1_3_race_mean_`i'') " & " %4.2f (`2_3_race_mean_`i'') " & " %4.2f (`3_3_race_mean_`i'') " & " %4.2f (`4_3_race_mean_`i'') " \\"
		file write f " \hspace{10bp}Others 				& " %4.2f (`4_full_mean_`i'') " & " %4.2f (`4_all_mean_`i'') " & " %4.2f (`1_4_race_mean_`i'') " & " %4.2f (`2_4_race_mean_`i'') " & " %4.2f (`3_4_race_mean_`i'') " & " %4.2f (`4_4_race_mean_`i'') " \\"
}
	
	

		
		file write f "Room Type &&&&&& \\"
local cat2 room_type_2 
	foreach i in `cat2'{ //loops over noncategorical variables
		sum `i' //Full Data
				local full_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
		preserve
		keep if sample == 1
		sum `i' //Regression Data
				local all_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
		restore
		levelsof `i'
				foreach k in `r(levels)'{
					sum `i' if `i' == `k' //Full Data
					local `k'_full_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
					local `k'_full_mean_`i' = ``k'_full_N_`i''/`full_N_`i''
					preserve
					keep if sample == 1 //restricts regression sample
					sum `i' if `i' == `k' //All Data
					local `k'_all_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
					local `k'_all_mean_`i' = ``k'_all_N_`i''/`all_N_`i''
					
					levelsof race_res
						foreach r in `r(levels)' {
							sum `i' if race_res == `r' 
							local `r'_race_N_`i' = `r(N)'
								sum `i' if `i' == `k' & race_res == `r'
								local `r'_`k'_race_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
								local `r'_`k'_race_mean_`i' = ``r'_`k'_race_N_`i''/``r'_race_N_`i''
						
						}
					restore
					
					}
		file write f " \hspace{10bp}Entire House/Apartment  	& " %4.2f (`1_full_mean_`i'') " & " %4.2f (`1_all_mean_`i'') " & " %4.2f (`1_1_race_mean_`i'') " & " %4.2f (`2_1_race_mean_`i'') " & " %4.2f (`3_1_race_mean_`i'') " & " %4.2f (`4_1_race_mean_`i'') " \\"
		file write f " \hspace{10bp}Private Room  			& " %4.2f (`2_full_mean_`i'') " & " %4.2f (`2_all_mean_`i'') " & " %4.2f (`1_2_race_mean_`i'') " & " %4.2f (`2_2_race_mean_`i'') " & " %4.2f (`3_2_race_mean_`i'') " & " %4.2f (`4_2_race_mean_`i'') " \\"		
		file write f " \hspace{10bp}Shared Room  			& " %4.2f (`3_full_mean_`i'') " & " %4.2f (`3_all_mean_`i'') " & " %4.2f (`1_3_race_mean_`i'') " & " %4.2f (`2_3_race_mean_`i'') " & " %4.2f (`3_3_race_mean_`i'') " & " %4.2f (`4_3_race_mean_`i'') " \\"
}
	


****************************************
*Non-Categorical Variables
****************************************	

// write in stats
local ncat2 accommodates bedrooms bathrooms beds cleaning_fee extra_people minimum_nights availability_30 num_amenities instant_bookable 

	foreach i in `ncat2'{ //loops over noncategorical variables
			sum `i' //Full data column
			local full_observations = `r(N)' //saves full data N
			local full_mean_`i' = `r(mean)'
			local full_sd_`i' = `r(sd)'
			preserve
			keep if sample == 1 //restricts regression sample
			sum `i' //All column
			local all_observations = `r(N)' //saves all N 
			local all_mean_`i' = `r(mean)'
			local all_sd_`i' = `r(sd)'
			local var_label : variable label `i'
			levelsof race_res
			foreach f in `r(levels)'{
				sum `i' if race_res == `f'
				local `f'_race_observations = `r(N)' //saves race N
				local `f'_mean_`i' = `r(mean)'
				local `f'_sd_`i' = `r(sd)'
			}
			restore
			//write means
			//write label
			file write f " `: var label `i'' & " %4.2f (`full_mean_`i'') " & " %4.2f (`all_mean_`i'') " & " %4.2f (`1_mean_`i'') " & " %4.2f (`2_mean_`i'') " & " %4.2f (`3_mean_`i'') " & " %4.2f (`4_mean_`i'') " "
			file write f "\\" _n
			file write f " & " "(" %4.2f (`full_sd_`i'') ")" " & " "(" %4.2f (`all_sd_`i'') ")" " & " "(" %4.2f (`1_sd_`i'') ")" " & " "(" %4.2f (`2_sd_`i'') ")" " & " "(" %4.2f (`3_sd_`i'') ")" " & " "(" %4.2f (`4_sd_`i'') ")" " "
			file write f "\\" _n
			
	}

// first review year 
			preserve
			keep if first_review_year != 99
			sum first_review_year
			local full_mean_first_review_year = `r(mean)'
			local full_sd_first_review_year = `r(sd)'
			keep if sample == 1
			sum first_review_year
			local all_mean_first_review_year = `r(mean)'
			local all_sd_first_review_year = `r(sd)'
			local var_label : variable label first_review_year
			levelsof race_res
				foreach f in `r(levels)'{
					sum first_review_year if race_res == `f'
					local `f'_mean_first_review_year = `r(mean)'
					local `f'_sd_first_review_year = `r(sd)'
				}
			restore
			file write f " `: var label first_review_year' & " %4.2f (`full_mean_first_review_year') " & " %4.2f (`all_mean_first_review_year') " & " %4.2f (`1_mean_first_review_year') " & " %4.2f (`2_mean_first_review_year') " & " %4.2f (`3_mean_first_review_year') " & " %4.2f (`4_mean_first_review_year') " "
			file write f "\\" _n
			file write f " & " "(" %4.2f (`full_sd_first_review_year') ")" " & " "(" %4.2f (`all_sd_first_review_year') ")" " & " "(" %4.2f (`1_sd_first_review_year') ")" " & " "(" %4.2f (`2_sd_first_review_year') ")" " & " "(" %4.2f (`3_sd_first_review_year') ")" " & " "(" %4.2f (`4_sd_first_review_year') ")" " "
			file write f "\\" _n

// cancellation policy 
capture confirm variable cancellation_policy_2
if !_rc{
	drop cancellation_policy_2
	}
egen cancellation_policy_2 = group(cancellation_policy), label

local cat3 cancellation_policy_2
	foreach i in `cat3'{ //loops over noncategorical variables
		sum `i' // Full Data
		local full_N = `r(N)' // total observations in Full Data
		sum `i' if `i' == 5
		local full_strict_N = `r(N)' // total "strict" in Full Data
		local full_strict_mean = `full_strict_N'/`full_N' 
		preserve
		keep if sample == 1
		sum `i' // Regression Data
		local all_N = `r(N)' // total observations in All Data
		sum `i' if `i' == 5
		local all_strict_N = `r(N)' // total "strict" in All Data
		local all_strict_mean = `all_strict_N'/`all_N' 
		restore
		levelsof race_res
		foreach f in `r(levels)'{
				sum `i' if race_res == `f'
				local `f'_race_N = `r(N)'
				sum `i' if `i' == 5 & race_res == `f'
				local `f'_strict_race_N = `r(N)' 
				local `f'_strict_race_mean = ``f'_strict_race_N'/``f'_race_N'	
				}
		file write f " Strict Cancellation Policy & " %4.2f (`full_strict_mean') " & " %4.2f (`all_strict_mean') " & " %4.2f (`1_strict_race_mean') " & " %4.2f (`2_strict_race_mean') " & " %4.2f (`3_strict_race_mean') " & " %4.2f (`4_strict_race_mean') " \\"
		}


// number of observations
file write f "\hline" _n ///
"Observations & \numprint{`full_observations'} & \numprint{`all_observations'} & \numprint{`1_race_observations'} & \numprint{`2_race_observations'} & \numprint{`3_race_observations'} & \numprint{`4_race_observations'} " _n ///
"\\" _n

// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
	"{\it Note:} The values in the table are means and standard deviations" ///
	" of listing-level data in my full sample. Summary statistics for selected covariates" ///
	" are listed in the table. Categorical variables such as room type do not have standard" ///
	" deviations. Property types are explicitly listed if more than 1.5\% of listings are that" ///
	" type. Only the most popular cancellation policy type is listed - in the full sample," ///
	" 99\% of listings have strict (43\%), flexible (31\%) or moderate (25\%) cancellation policies." ///
	" Year of first review is a proxy for the time on the market - 14.86 indicates that the" ///
	" first review of the mean listing in the full sample occurred in October of 2014." _n ///
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f
