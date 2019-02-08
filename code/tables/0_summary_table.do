********************************************************************************
*			    Summary Table Attempt     							  		   *
********************************************************************************
* HELLO WORLD!! 
* --- start of table here --- *

//preserve

// open .tex file
cap file close f
file open f using "$repository/code/tables/output/summary_table.tex", write replace

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


// write in stats
local ncat price number_of_reviews accommodates bedrooms bathrooms beds cleaning_fee extra_people minimum_nights availability_30 num_amenities instant_bookable 
// local cat room_type 
// room_type property_type cancellation_policy

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

// first review year summary stats
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
		local `f'_race_observations = `r(N)' //saves race N
		local `f'_mean_first_review_year = `r(mean)'
		local `f'_sd_first_review_year = `r(sd)'
	}
restore
file write f " `: var label first_review_year' & " %4.2f (`full_mean_first_review_year') " & " %4.2f (`all_mean_first_review_year') " & " %4.2f (`1_mean_first_review_year') " & " %4.2f (`2_mean_first_review_year') " & " %4.2f (`3_mean_first_review_year') " & " %4.2f (`4_mean_first_review_year') " "
file write f "\\" _n
file write f " & " "(" %4.2f (`full_sd_first_review_year') ")" " & " "(" %4.2f (`all_sd_first_review_year') ")" " & " "(" %4.2f (`1_sd_first_review_year') ")" " & " "(" %4.2f (`2_sd_first_review_year') ")" " & " "(" %4.2f (`3_sd_first_review_year') ")" " & " "(" %4.2f (`4_sd_first_review_year') ")" " "
file write f "\\" _n

	
	foreach i in `cat'{ //loops over categorical variables
			local var_label : variable label `i'
			file write f "\textbf{`var_label'} \\" _n _n
			levelsof `i'
			foreach c in `r(levels)'{ //loops over each category of var
				levelsof race_res
				foreach f in `r(levels)'{ //loops over each race per category
					count if !mi(`i') & race_res == `f' //counts if not missing the categorical variable
					loc denominator = `r(N)'
					count if `i' == "`c'" & race_res == `f' //count up if the cat variable equals its subcategories
					loc numerator = `r(N)'
					loc `f'_prop_`c'_`i' = `numerator'/`denominator' // "Condominium" is failing here
					di `numerator'/`denominator'
				}
				local row_label : var label room_type
				di "hello" // print statement to test code
				file write f " `row_label' & "  %4.2f (`1_prop_"`c'"_`i'') " & " %4.2f (`2_prop_"`c'"_`i'') " & " %4.2f (`3_prop_"`c'"_`i'') " & " %4.2f (`4_prop_"`c'"_`i'') " "
				file write f "\\" _n
			}
	}

// number of observations
file write f "\hline" _n ///
"Observations & \numprint{`full_observations'} & \numprint{`all_observations'} & \numprint{`1_race_observations'} & \numprint{`2_race_observations'} & \numprint{`3_race_observations'} & \numprint{`4_race_observations'}" _n ///
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







