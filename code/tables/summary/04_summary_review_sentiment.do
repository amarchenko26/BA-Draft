********************************************************************************
*		Table 4: Summary Statistics by Race: Reviewer Characteristics
********************************************************************************



// open .tex file
cap file close f
file open f using "$repository/code/tables/tex_output/individual_tables/summary_reviewer_char.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Summary Statistics By Race: Reviewer Characteristics}" _n ///
"\begin{center}%" _n ///
"\small\begin{tabular}{l c c c c c}" _n ///

// write column headers
file write f "& \multicolumn{5}{c}{Regression Sample}" _n ///
"\\" _n ///
" \cmidrule(r){2-6}" _n ///
"\\" _n ///
" & \multicolumn{1}{c}{Full Sample} & White & Black & Hispanic & Asian" _n ///
"\\" _n ///
"\hline\hline\noalign{\smallskip} " _n 

********************************************************************************
********************************************************************************



local cat rev_race_res race_res 
local ncat sentiment_mean sentiment_listing

/*
foreach i in `cat'{



}
levelsof race_res
	foreach r in `r(levels)'{
		sum race_res if race_res == `r'
			local race_res_`r' = `r(N)' 
			local p_race_res_`r' = race_res_`r' / `r'
	}
	*/

	foreach i in `ncat'{ //loops over outcome variable
			sum `i' //Full data column
			local full_observations = `r(N)' //saves full data N
			local full_mean_`i' = `r(mean)'
			local full_sd_`i' = `r(sd)'
			preserve
			// keep if sample == 1 //restricts regression sample
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
			file write f " `: var label `i'' & " %4.2f (`full_mean_`i'') " & " %4.2f (`1_mean_`i'') " & " %4.2f (`2_mean_`i'') " & " %4.2f (`3_mean_`i'') " & " %4.2f (`4_mean_`i'') " "
			file write f "\\" _n
			file write f " & " "(" %4.2f (`full_sd_`i'') ")" " & " "(" %4.2f (`1_sd_`i'') ")" " & " "(" %4.2f (`2_sd_`i'') ")" " & " "(" %4.2f (`3_sd_`i'') ")" " & " "(" %4.2f (`4_sd_`i'') ")" " "
			file write f "\\" _n
			
	}


********************************************************************************
********************************************************************************


// number of observations
file write f "\hline" _n ///
"Observations & `all_observations' & `1_race_observations' & `2_race_observations' & `3_race_observations' & `4_race_observations'" _n ///
"\\" _n

// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
	"{\it Note:} The values in the table are means and standard deviations" ///
	" of reviewer-level data who left reviews for a randomly chosen set of hosts in Chicago." ///
	" The review sentiment is the sentiment of each review, the listing sentiment is the average" ///
	" sentiment per listing. Observations in columns 2 - 5 do not add up to 17,050 because multiracial or" ///
	" unidentifiable reviewer pictures are excluded. White refers only to non-Hispanic whites." _n ///
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f
