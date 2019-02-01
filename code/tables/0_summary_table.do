********************************************************************************
*			    Summary Table Attempt     							  		   *
********************************************************************************
* HELLO WORLD!! 
* --- start of table here --- *

preserve
// keep if sample == 1

// open .tex file
cap file close f
file open f using "$repository/output/summary_table.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Summary Statistics By Host Race: Listing Characteristics}" _n ///
"\begin{center}%" _n ///
"\small\begin{tabular}{l c c c c c c}" _n

// write column headers
file write f " &  & All" _n
file write f "\\" _n ///
"\hline\hline\noalign{\smallskip} " _n

// write in stats
local ncat price number_of_reviews accommodates bedrooms bathrooms beds cleaning_fee extra_people minimum_nights availability_30
local cat property_type room_type instant_bookable cancellation_policy first_review_year amenities

	foreach i in `ncat'{ //loops over noncategorical variables
			levelsof race_res
			foreach f in `r(levels)' {
				sum `i' if race_res == `f'
				local `f'_mean_`i' = `r(mean)'
			}
			//write means
			//write label
			file write f " `: var label `i'' & " %4.3f (`1_mean_`i'') " & " %4.3f (`2_mean_`i'') " & " %4.3f (`3_mean_`i'') " & " %4.3f (`4_mean_`i'') " "
			file write f "\\" _n
	}


	foreach i in `cat'{ //loops over categorical variables
			local var_label : variable label `i'
			file write f "/textbf{`var_label'} \\" _n _n
			levelsof `i'
			foreach c in `r(levels)'{ //loops over each category of var
				levelsof race_res
				foreach f in `r(levels)'{ //loops over each race per category
					count if !mi(`i') & race_res == `f' //counts if not missing the categorical variable
					loc denominator = `r(N)'
					count if `i' == "`c'" & race_res == `f' //count up if the cat variable equals its subcategories
					loc numerator = `r(N)'
					loc `f'_prop_`c'_`i' = `numerator'/`denominator'
				}
				// Anya this line of code is driving me crazy
				local row_label : label `i' `c'
				file write f " `row_label' & " %4.3f (`1_prop_`c'_`i'') " & " %4.3f (`2_prop_`c'_`i'') " & " %4.3f (`3_prop_`c'_`i'') " & " %4.3f (`4_prop_`c'_`i'') " "
				file write f "\\" _n
			}
	}


// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
	"{\it Note:} \begin{center}DUMMY NOTE" _n ///
"\end{center}" _n ///	
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f







