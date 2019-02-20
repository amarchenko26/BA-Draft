********************************************************************************
*				 Summary Statistics by Host Race: Host Demographics
********************************************************************************

 cd "$repository/code/tables"
 

///Defining Labels
label define age_lbl 1 "Young" 2 "Middle-Aged" 3 "Old" 4 "Unkown/Multiple People"
label values  age_res age_lbl


// open .tex file
cap file close f
file open f using "$repository/code/tables/tex_output/individual_tables/summary_table_host_demo.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Summary Statistics By Host Race: Host Demographics}" _n ///
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



local cat race_res sex age_res 
foreach i in `cat'{

sum `i'				
	local `i'_N_full = `r(N)' //FULL Observations

	levelsof `i'
		foreach f in `r(levels)' { 
			sum `i' if `i' == `f'	//FULL Categories
			local `i'_N_`f' = `r(N)'
			local `i'_mean_`f' = ``i'_N_`f''/``i'_N_full'
		}

preserve
keep if sample == 1


	sum `i'
	local `i'_all = `r(N)'
	levelsof `i'
		foreach f in `r(levels)'{
		
			sum `i' if `i' == `f'
			local `i'_N_all_`f' = `r(N)'
			local `i'_mean_all_`f' = `r(N)'/`race_res_all'
			

			levelsof race_res
			foreach r in `r(levels)'{
			
				sum `i' if race_res == `r'
				local `i'_N_`r' = `r(N)'
				sum `i'  if race_res == `r' & `i' == `f'
				local `i' _N_`r'_`f' = `r(N)'
				local `i'_mean_`r'_`f' = `r(N)' /``i'_N_`r''
			}
		}
restore
}
file write f " Race &&&&&& \\" _n
file write f " \hspace{10bp}White & " 	%4.3f (`race_res_mean_1') " & " %4.3f (`race_res_mean_all_1') " &  " %4.2f (`race_res_mean_1_1') " & " %4.3f (`race_res_mean_2_1') " &  " %4.3f (`race_res_mean_3_1') " & " %4.3f (`race_res_mean_4_1') " \\ " 
file write f " \hspace{10bp}Black & " 	%4.3f (`race_res_mean_2') " & " %4.3f (`race_res_mean_all_2') " &  " %4.2f (`race_res_mean_1_2') " & " %4.3f (`race_res_mean_2_2') " &  " %4.3f (`race_res_mean_3_2') " & " %4.3f (`race_res_mean_4_2') " \\ " 
file write f " \hspace{10bp}Hispanic & "%4.3f (`race_res_mean_3') " & " %4.f (`race_res_mean_all_3') " &  " %4.2f (`race_res_mean_1_3') " & " %4.3f (`race_res_mean_2_3') " &  " %4.3f (`race_res_mean_3_3') " & " %4.3f (`race_res_mean_4_3') " \\ " 
file write f " \hspace{10bp}Asian & " 	%4.3f (`race_res_mean_4') " & " %4.3f (`race_res_mean_all_4') " &  " %4.2f (`race_res_mean_1_4') " & " %4.3f (`race_res_mean_2_4') " &  " %4.3f (`race_res_mean_3_4') " & " %4.3f (`race_res_mean_4_4') " \\ " 
file write f " \hspace{10bp}Unknown & " %4.3f (`race_res_mean_0') " & {0.000} & {0.000} &  {0.000}  & {0.000}  & {0.000} \\ " 	

file write f " Sex &&&&&& \\" _n
file write f " \hspace{10bp}Male & " 	%4.3f (`sex_mean_1') " & " %4.3f (`sex_mean_all_1') " &  " %4.3f (`sex_mean_1_1') " & " %4.3f (`sex_mean_2_1') " &  " %4.3f (`sex_mean_3_1') " & " %4.3f (`sex_mean_4_1') " \\ " 
file write f " \hspace{10bp}Female & " 	%4.3f (`sex_mean_2') " & " %4.3f (`sex_mean_all_2') " &  " %4.3f (`sex_mean_1_2') " & " %4.3f (`sex_mean_2_2') " &  " %4.3f (`sex_mean_3_2') " & " %4.3f (`sex_mean_4_2') " \\ " 
file write f " \hspace{10bp}Unknown & "	%4.3f (`sex_mean_0') " & {0.000} & {0.000} &  {0.000}  & {0.000}  & {0.000} \\ "

file write f " Age &&&&&& \\" _n
file write f " \hspace{10bp}Young($\<30$) & " 	%4.3f (`age_res_mean_1') " & " %4.3f (`age_res_mean_all_1') " &  " %4.3f (`age_res_mean_1_1') " & " %4.3f (`age_res_mean_2_1') " &  " %4.3f (`age_res_mean_3_1') " & " %4.3f (`age_res_mean_4_1') " \\ " 
file write f " \hspace{10bp}Middle-aged & " 	%4.3f (`age_res_mean_2') " & " %4.3f (`age_res_mean_all_2') " &  " %4.3f (`age_res_mean_1_2') " & " %4.3f (`age_res_mean_2_2') " &  " %4.3f (`age_res_mean_3_2') " & " %4.3f (`age_res_mean_4_2') " \\ " 
file write f " \hspace{10bp}Old ($/>65$) & 		"%4.3f (`age_res_mean_3') " & " %4.3f (`age_res_mean_all_3') " &  " %4.3f (`age_res_mean_1_3') " & " %4.3f (`age_res_mean_2_3') " &  " %4.3f (`age_res_mean_3_3') " & " %4.3f (`age_res_mean_4_3') " \\ " 
file write f " \hspace{10bp}Unknown & " 	%4.3f (`age_res_mean_0') " & {0} & {0} &  {0}  & {0}  & {0} \\ " 	
	

// number of observations
file write f "\hline" _n ///
"Observations & `race_res_N_full' & `race_res_N_all' & `race_res_N_1' & `race_res_N_2' & `race_res_N_3' & `race_res_N_4' " _n ///
"\\" _n


// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
	"{\it Note:} The values in the table are summaries of host demographics in" ///
	"the host-level data. Column 1 is the summary statistics for the full," ///
	"unrestricted data set across 7 cities. Columns 2 $-$ 6 are the restricted" ///
	"data used in the analysis. Column 2 is the full regression sample, and" ///
	"columns 3 $-$ 6 break down the regression sample by host race. The" ///
	"“Unknown” category was dropped from the regression and is therefore zero" ///
	"throughout columns 2 $-$ 6. White refers only to Non-Hispanic Whites." ///
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f
