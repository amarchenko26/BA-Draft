********************************************************************************
*		Table 4: Summary Statistics by Race: Reviewer Characteristics
********************************************************************************



// open .tex file
cap file close f
file open f using "$repository/code/tables/tex_output/individual_tables/reviewer_char.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Summary Statistics By Host Race: Listing Characteristics}" _n ///
"\begin{center}%" _n ///
"\small\begin{tabular}{l c c c c c}" _n ///

// write column headers
file write f "& \multicolumn{5}{c}{Regression Sample}" _n ///
"\\" _n ///
" \cmidrule(r){2-6}" _n ///
"\\" _n ///
" & \multicolumn{1}{c}{Total Sample} & White & Black & Hispanic & Asian" _n ///
"\\" _n ///
"\hline\hline\noalign{\smallskip} " _n 

********************************************************************************
********************************************************************************



sum  rev_race_res race_res sentiment_mean  sentiment_listing 

levelsof race_res
	for r in `r(levels)'{
		sum race_res 
			gen	race_res_`r' = `r(N)' if race_res == `r'
			gen	p_race_res_`r' = race_res_`r' / `r'
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
