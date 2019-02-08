********************************************************************************
*				 Summary Statistics by Host Race: Host Demographics
********************************************************************************

 cd "$repository/code/tables"
 
 preserve
// keep if sample == 1

///Defining Labels
label define age_lbl 1 "Young" 2 "Middle-Aged" 3 "Old" 4 "Unkown/Multiple People"
label values  age_res age_lbl

/*
// open .tex file
cap file close f
file open f using "$repository/code/tables/tex_output/individual_tables/summary_host_demograhics.tex", write replace

// write the beginning of the table
file write f //All we need is this in the tex file,
			///We are only adding the core part of the table
    "&\multicolumn{1}{c}{Full Data}&\multicolumn{1}{c}{All}&\multicolumn{1}{c}{White}&\multicolumn{1}{c}{Black}&\multicolumn{1}{c}{Hispanic}&\multicolumn{1}{c}{Asian}" _n///
	"\hline"_n
*/


// write in stats
local ncat race_res sex age_res

	foreach i in `ncat'{ //loops over noncategorical variables
			levelsof race_res
			foreach f in `r(levels)' {
				sum `i if race_res == `f'
				local `f'_mean_`i' = `r(mean)'
			}
			//write means
			//write label
			file write f " `: var label `i'' & " %4.3f (`1_mean_`i'') " & " %4.3f (`2_mean_`i'') " & " %4.3f (`3_mean_`i'') " & " %4.3f (`4_mean_`i'') " "
			file write f "\\" _n
	}

