********************************************************************************
*				 Summary Statistics by Host Race: Host Demographics
********************************************************************************

 cd "$repository/code/tables"
 

///Defining Labels
label drop age_lbl
label define age_lbl 1 "Young" 2 "Middle-Aged" 3 "Old" 4 "Unkown/Multiple People"
label values  age_res age_lbl



// open .tex file
cap file close f
file open f using "$repository/code/tables/output/summary_table_host_demo.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\hline" _n ///
"\caption{Summary Statistics By Host Race: Host Demographics}" _n ///
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



/*
local ncat race_res sex age_res

	foreach i in `ncat'{ //loops over noncategorical variables

		levelsof `i'
		foreach f in `r(levels)' {
			sum `i'
			local `i'_N = `r(N)'
			
			sum `i' if `i' == `f'	//FULL DATA
			local `i'_N_`f' = `r(N)'
			local `i'_mean_`f' = ``i'_N_`f''/``i'_N'
		
			keep if sample == 1 //Restrict to ALL DATA
			
			sum `i'
			local `i'_N_all = `r(N)'
			
			sum `i' if `i' == `f'	
			local `i'_N_all_`f' = `r(N)'
			local `i'_mean_all_`f' = ``i'_N_all_`f''/``i'_N_all'
			
		
*	 		levelsof race_res
*				foreach r in `r(levels)' {
*					sum `i' if `i' == `f' & race_res == `r'
*					local `i'_N_race_`f' = `r(N)'
*					local `i'_mean_race_`f' = ``i'_N_race_`f''/``i'_N_race'		
*				}
			
file write f " & " "(" %4.2f (``i'_mean_`f'') ")" " & " "(" %4.2f (``i'_mean_all_`f'') ")" " & " "(" %4.2f () ")" " & " "(" %4.2f () ")" " & " "(" %4.2f () ")" " & " "(" %4.2f () ")" " "

			
			}
	}

*/



// number of observations
file write f "\hline" _n ///
"Observations & `full_observations' & `all_observations' & `1_race_observations' & `2_race_observations' & `3_race_observations' & \numprint{`4_race_observations'}" _n ///
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
