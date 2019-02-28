********************************************************************************
*	         Summary Statistics by Host Race: Host Characteristics	           *
********************************************************************************
* HELLO WORLD!! 
* --- start of table here --- *

//preserve

// open .tex file
cap file close f
file open f using "$repository/code/tables/tex_output/individual_tables/summary_table_host_chars.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Summary Statistics By Host Race: Host Characteristics}" _n ///
"\begin{center}%" _n ///
"\small\begin{tabular}{l c | c | c c c c}" _n ///

// write column headers
file write f "& \multicolumn{1}{c}{Full data} & \multicolumn{5}{c}{Regression Sample}" _n ///
"\\" _n ///
" \cmidrule(r){3-7}" _n ///
"\\" _n ///
" & \multicolumn{1}{c}{} & \multicolumn{1}{c}{All} & White & Black & Hispanic & Asian" _n ///
"\\" _n ///
"\hline\hline\noalign{\smallskip} " _n 

****************************************
*          OUTCOME VARIABLE            *
****************************************
file write f " \textit{\textit{Outcome Variables}} & & & & & & \\"

local ncat host_listings_count

	foreach i in `ncat'{ //loops over outcome variable
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


****************************************
*              COVARIATES              *
****************************************
file write f " \textit{Covariates} & & & & & & \\"
file write f " \hline"

* Non-categorical covariates
local ncat2 review_scores_rating host_is_superhost host_response_rate host_acceptance_rate sum_good_word_tot len_desc2 short_words2

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

* Categorical covariates

//Checking if variable host_response_time_2 already exists
	capture confirm variable host_response_time_2
	if !_rc{
		drop host_response_time_2
	}
	
	egen host_response_time_2 = group(host_response_time), label
	
local cat host_response_time_2

	foreach i in `cat'{ //loops over noncategorical variables
		sum `i' // Full Data
		local full_N = `r(N)' // total observations in Full Data
		sum `i' if `i' == 5
		local full_hour_N = `r(N)' // total "within an hour" responses in Full Data
		local full_hour_mean = `full_hour_N'/`full_N' 
		preserve
		keep if sample == 1
		sum `i' // Regression Data
		local all_N = `r(N)' // total observations in All Data
		sum `i' if `i' == 5
		local all_hour_N = `r(N)' // total "within an hour" in All Data
		local all_hour_mean = `all_hour_N'/`all_N' 
	
		levelsof race_res
		foreach f in `r(levels)'{
				sum `i' if race_res == `f'
				local `f'_race_N = `r(N)'
				sum `i' if `i' == 5 & race_res == `f'
				local `f'_hour_race_N = `r(N)' 
				local `f'_hour_race_mean = ``f'_hour_race_N'/``f'_race_N'	
				}
		restore
		file write f " Response time $<$ 1 hour & " %4.2f (`full_hour_mean') " & " %4.2f (`all_hour_mean') " & " %4.2f (`1_hour_race_mean') " & " %4.2f (`2_hour_race_mean') " & " %4.2f (`3_hour_race_mean') " & " %4.2f (`4_hour_race_mean') " \\"
		file write f "  &  &  &  &  &  &  \\"
		}


local cat2 host_identity_verified require_guest_profile_picture require_guest_phone_verification

	foreach i in `cat2'{
		sum `i' // Full Data
		local full_N = `r(N)' // total observations in Full Data
		local full_sd = `r(sd)'
		sum `i' if `i' == 1 // 1 == True
		local full_true_N = `r(N)' // total "True" in Full Data
		local full_true_mean = `full_true_N'/`full_N' 
		preserve
		keep if sample == 1
		sum `i' // Regression Data
		local all_N = `r(N)' // total observations in All Data
		local all_sd = `r(sd)'
		sum `i' if `i' == 1
		local all_true_N = `r(N)' // total "True" in All Data
		local all_true_mean = `all_true_N'/`all_N' 
		local var_label : variable label `i'
	
		levelsof race_res
		foreach f in `r(levels)'{
				sum `i' if race_res == `f'
				local `f'_race_N = `r(N)'
				local `f'_sd = `r(sd)'
				sum `i' if `i' == 1 & race_res == `f'
				local `f'_true_race_N = `r(N)' 
				local `f'_true_race_mean = ``f'_true_race_N'/``f'_race_N'	
				}
		restore
		
		file write f " `: var label `i'' & " %4.2f (`full_true_mean') " & " %4.2f (`all_true_mean') " & " %4.2f (`1_true_race_mean') " & " %4.2f (`2_true_race_mean') " & " %4.2f (`3_true_race_mean') " & " %4.2f (`4_true_race_mean') " "
		file write f "\\" _n
		file write f " & " "(" %4.2f (`full_sd') ")" " & " "(" %4.2f (`all_sd') ")" " & " "(" %4.2f (`1_sd') ")" " & " "(" %4.2f (`2_sd') ")" " & " "(" %4.2f (`3_sd') ")" " & " "(" %4.2f (`4_sd') ")" " "
		file write f "\\" _n
		
		}

	

// number of observations
file write f "\hline" _n ///
"Observations & `full_observations' & `all_observations' & `1_race_observations' & `2_race_observations' & `3_race_observations' & `4_race_observations'" _n ///
"\\" _n

// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
	"{\it Note:} The values in the table are means and standard deviations" ///
	" of host-level data in the full sample. Summary statistics for selected covariates" ///
	" are listed in the table. Categorical variables such as response time do not have" ///
	" standard deviations. Statistics for only the most frequent response time (within an hour)" ///
	" are included. White refers only to non-Hispanic whites. Length of Summary" ///
	" and proportion of short words in the Summary refer to my constructed" ///
	" measures of host quality. These two measures were also calculated for the description," ///
	" space, neighborhood overview, notes, and transit fields, but were not included in the" ///
	" table for the sake of clarity and because they follow a similar pattern as the" ///
	" table for the sake of clarity and because they follow a similar pattern as the" ///
	" Summary field." _n ///
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f
