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
"\small\begin{tabular}{l c c c c c c}" _n

// write column headers
file write f " & Full data & All & White & Black & Hispanic & Asian" _n
file write f "\\" _n ///
"\hline\hline\noalign{\smallskip} " _n

// write in stats
local ncat price number_of_reviews accommodates bedrooms bathrooms beds cleaning_fee extra_people minimum_nights availability_30 num_amenities
// local cat  room_type 
// room_type property_type instant_bookable cancellation_policy first_review_year 

	foreach i in `ncat'{ //loops over noncategorical variables
			sum `i' //Full data column
			local full_mean_`i' = `r(mean)'
			local full_sd_`i' = `r(sd)'
			preserve
			keep if sample == 1 //restricts regression sample
			sum `i' //All column
			local all_mean_`i' = `r(mean)'
			local all_sd_`i' = `r(sd)'
			local var_label : variable label `i'
			levelsof race_res
			foreach f in `r(levels)'{
				sum `i' if race_res == `f'
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

// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
	"{\it Note:} \begin{center}DUMMY NOTE" _n ///
"\end{center}" _n ///	
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f







