********************************************************************************
*		Table 4: Summary Statistics by Race: Reviewer Characteristics
********************************************************************************

/*sum rev_race_res if rev_race_res == 1 | rev_race_res == 2 | rev_race_res == 3 | rev_race_res == 4
sum race_res if race_res == 1 | race_res == 2 | race_res == 3 | race_res == 4
tab rev_race_res race_res

tab  rev_race_res if rev_race_res == 1 | rev_race_res == 2 | rev_race_res == 3 | rev_race_res == 4
tab race_res if race_res == 1 | race_res == 2 | race_res == 3 | race_res == 4
*/

//forvalues i = 1/4{
// sum race_res if rev_race_res == `i'
// }


// open .tex file
cap file close f
file open f using "$repository/code/tables/tex_output/individual_tables/summary_reviewer_char.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Summary Statistics By Race: Reviewer Characteristics}" _n ///
"\begin{center}%" _n ///
"\small\begin{tabular}{l c | c | c c c c}" _n ///

// write column headers
file write f "& \multicolumn{1}{c}{} & \multicolumn{5}{c}{Reviewer Race in Chicago data} " _n ///
"\\" _n ///
" \cmidrule(r){3-7}" _n ///
"\\" _n ///
" & \multicolumn{1}{c}{Full data} & \multicolumn{1}{c}{All} & White & Black & Hispanic & Asian" _n ///
"\\" _n ///
"\hline\hline\noalign{\smallskip} " _n 

********************************************************************************
********************************************************************************
		
local cat1 rev_race_res		

	foreach i in `cat1'{ //loops over Reviewer race
		sum `i' //Full Data
		local full_N = `r(N)' //
		local full_prop = `r(N)' / `full_N'
		
		preserve 
		keep if sample == 1 
		
		sum `i' //all Data
		local all_N = `r(N)' //
		local all_prop = `r(N)' / `all_N'
		
		
		levelsof rev_race_res
		foreach r in `r(levels)'{
			sum `i' if rev_race_res == `r'
			local `r'_race_N = `r(N)' // reviewer race count
			local `r'_race_prop = ``r'_race_N' / `all_N'
		
		
		
		}
		restore
		
		
		file write f " Reviewer Race  & " %4.2f (`full_prop') " & " %4.2f (`all_prop') " & " %4.2f (`1_race_prop') " & " %4.2f (`2_race_prop') " & " %4.2f (`3_race_prop') " & " %4.2f (`4_race_prop') " \\"
		file write f "\\" _n
}

		file write f " Host race & & & & & & \\"

		
local cat2 race_res
	foreach i in `cat2'{ //loops over Host race
		sum `i' //Full Data
		local full_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
		
		
		sum `i' if sample == 1 //All Data
		local all_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
		
		levelsof `i'
			foreach k in `r(levels)'{ //levels of race_res
				sum `i' if `i' == `k' //Full Data
				local `k'_full_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
				local `k'_full_mean_`i' = ``k'_full_N_`i''/`full_N_`i''
				
				sum `i' if `i' == `k' & sample == 1 //All Data
				local `k'_all_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
				local `k'_all_mean_`i' = ``k'_all_N_`i''/`all_N_`i''				
				
				
				//keep if sample == 1 //restricts regression sample

				levelsof rev_race_res //
					foreach r in `r(levels)' {
						sum `i' if rev_race_res == `r' & sample == 1
						local `r'_race_N_`i' = `r(N)'
							sum `i' if `i' == `k' & rev_race_res == `r' & sample == 1
							local `r'_`k'_race_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
							local `r'_`k'_race_mean_`i' = ``r'_`k'_race_N_`i''/``r'_race_N_`i''
						
						}
				

				levelsof rev_race_res  
					foreach r in `r(levels)' {
						sum `i' if rev_race_res == `r' 
						local `r'_race_N_`i' = `r(N)'
							//sum `i' if `i' == 5 & rev_race_res == `r'
							//local `r'_5_race_N_`i' = `r(N)' //saves 'i' N e.g townhouse, etc
							//local `r'_5_race_mean_`i' = ``r'_5_race_N_`i''/``r'_race_N_`i''
							local `r'_5_race_mean_`i' = 0
						}
					}

		file write f " \hspace{10bp}White & 	" %4.2f (`1_full_mean_`i'') " & " %4.2f (`1_all_mean_`i'') " & " %4.2f (`1_1_race_mean_`i'') " & " %4.2f (`2_1_race_mean_`i'') " & " %4.2f (`3_1_race_mean_`i'') " & " %4.2f (`4_1_race_mean_`i'') " \\"
		file write f " \hspace{10bp}Black & 	" %4.2f (`2_full_mean_`i'') " & " %4.2f (`2_all_mean_`i'') "& " %4.2f (`1_2_race_mean_`i'') " & " %4.2f (`2_2_race_mean_`i'') " & " %4.2f (`3_2_race_mean_`i'') " & " %4.2f (`4_2_race_mean_`i'') " \\"		
		file write f " \hspace{10bp}Hispanic & 	" %4.2f (`3_full_mean_`i'') " & " %4.2f (`3_all_mean_`i'') "& " %4.2f (`1_3_race_mean_`i'') " & " %4.2f (`2_3_race_mean_`i'') " & " %4.2f (`3_3_race_mean_`i'') " & " %4.2f (`4_3_race_mean_`i'') " \\"
		file write f " \hspace{10bp}Asian & 	" %4.2f (`4_full_mean_`i'') " & " %4.2f (`4_all_mean_`i'') "& " %4.2f (`1_4_race_mean_`i'') " & " %4.2f (`2_4_race_mean_`i'') " & " %4.2f (`3_4_race_mean_`i'') " & " %4.2f (`4_4_race_mean_`i'') " \\"		
		file write f " \hspace{10bp}Unknown & 	" %4.2f (`5_full_mean_`i'') " & " %4.2f (`5_all_mean_`i'') "& " %4.2f (`1_5_race_mean_`i'') " & " %4.2f (`2_5_race_mean_`i'') " & " %4.2f (`3_5_race_mean_`i'') " & " %4.2f (`4_5_race_mean_`i'') " \\"		
		file write f "\\" _n
		}


local ncat sentiment_mean sentiment_listing		

	foreach i in `ncat'{ //loops over outcome variable
			sum `i' //Full data column
			local full_observations = `r(N)' //saves full data N
			local full_mean_`i' = `r(mean)'
			local full_sd_`i' = `r(sd)'
			//preserve
			//keep if sample == 1 //restricts regression sample
			
			sum `i'  if sample == 1 //All column
			local all_observations = `r(N)' //saves all N 
			local all_mean_`i' = `r(mean)'
			local all_sd_`i' = `r(sd)'
			
			local var_label : variable label `i'
			
			levelsof rev_race_res
			foreach f in `r(levels)'{
				sum `i' if rev_race_res == `f' & sample == 1
				local `f'_race_observations = `r(N)' //saves race N
				local `f'_mean_`i' = `r(mean)'
				local `f'_sd_`i' = `r(sd)'
			}
			
			//restore
			//write means
			//write label
			file write f " `: var label `i'' & " %4.2f (`full_mean_`i'') " & " %4.2f (`all_mean_`i'') " & " %4.2f (`1_mean_`i'') " & " %4.2f (`2_mean_`i'') " & " %4.2f (`3_mean_`i'') " & " %4.2f (`4_mean_`i'') " "
			file write f "\\" _n
			file write f " & " "(" %4.2f (`full_sd_`i'') ")" " & " "(" %4.2f (`all_sd_`i'') ")" " & " "(" %4.2f (`1_sd_`i'') ")" " & " "(" %4.2f (`2_sd_`i'') ")" " & " "(" %4.2f (`3_sd_`i'') ")" " & " "(" %4.2f (`4_sd_`i'') ")" " "
			file write f "\\" _n
			file write f "\\" _n
			
	}


********************************************************************************
********************************************************************************


// number of observations
file write f "\hline" _n ///
"Observations & \numprint{`full_observations'} &  \numprint{`all_observations'} & \numprint{`1_race_observations'} & \numprint{`2_race_observations'} & \numprint{`3_race_observations'} & \numprint{`4_race_observations'}" _n ///
"\\" _n

// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
"\label{table:reviewer_demographics}" _n ///
	"{\it Note:} " ///
	"The values in this table are means and standard deviations of reviewer-level data who left reviews for a randomly chosen set of hosts in Chicago. Column 1 has the means for the entire data. Column 2 has the means of the sample used in Table 11. Columns 3 - 6 partition Column 2 by reviewer race. Row 1, Reviewer race: indicates the proportion of the different reviewer races in the data coded. Row 2, Host race: indicates the marginal probability of a host race given a reviewer race. The review sentiment is the sentiment of each review, the listing sentiment is the average sentiment per listing. Observations in columns 2 - 5 do not add up to 17,050 because multiracial or unidentifiable reviewer pictures are excluded. White refers only to non-Hispanic whites." _n ///
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f
