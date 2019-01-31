********************************************************************************
*			    Summary Table Attempt     							  		   *
********************************************************************************
* HELLO WORLD!! copied and pasted from run_project
* make sure to delete after integrating

clear all
clear mata
set more off
set emptycells drop // If the interaction term is empty, don't report it in the table, reduces memory and variable necessity 

set matsize 11000
set maxvar 32000


**********************IMPORTANT****************************
* Change the paths to match path on your computer locally *
***********************************************************

* MAKE SURE TO SET WD TO 'BA-DRAFT' LEVEL OF FILE ORGANIZATION
global repository `c(pwd)' //returns current working directory

* Set OS
global os `c(os)'

cd "$repository/data"
import delimited using done_combined_full_listings.csv

* --- start of table here --- *

preserve
// keep if sample == 1

// open .tex file
cap file close f
file open f using "$repository/code/tables/output/summary_table.tex", write replace

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
local ncat price number_of_reviews accommodates bedrooms bathrooms beds amenities cleaning_fee extra_people minimum_nights 
local cat property_type room_type instant_bookable cancellation_policy first_review

	foreach i in ncat{ //loops over noncategorical variables
			levelsof race
			foreach f in `r(levels)' {
				sum `i' if race == "`f'"
				loc `f'_mean_`i' = `r(mean)'
			}
			//write means
			//write label
			file write f " `: var label `i'' & " %4.3f (`White_mean_`i'') " & " %4.3f (`Black_mean_`i'') " & " %4.3f (`Hispanic_mean_`i'') " & " %4.3f (`Asian_mean_`i'') " "
			file write f "\\" _n
	}


	foreach i in cat{ //loops over categorical variables
			local var_label : variable label `i'
			file write f "/textbf{`var_label'} \\" _n _n
			
			levelsof `i'
			foreach c in `r(levels)'{ //loops over each category of var
				levelsof race
				foreach f in `r(levels)'{ //loops over each race per category
					count if !mi(`i') & race == "`f'" //counts if not missing the categorical variable
					loc denominator = `r(N)'
					count if `i' == `c' & race == "`f'" //count up if the cat variable equals its subcategories
					loc numerator = `r(N)'
					loc `f'_prop_`c'_`i' = `numerator'/`denominator'
				}
				local row_label : label `i' `c'
				file write f " `row_label' & " %4.3f (`White_prop_`c'_`i'') " & " %4.3f (`Black_prop_`c'_`i'') " & " %4.3f (`Hispanic_prop_`c'_`i'') " & " %4.3f (`Asian_prop_`c'_`i'') " "
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







