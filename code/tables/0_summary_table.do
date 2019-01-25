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

* --- start of table here --- *

// what does this do?
preserve
// keep if sample == 1

// open .tex file
cap file close f
file open f using "$repository/code/tables/output/summary_table.tex", write replace

// write the beginning of the table
file write f "\begin{table}[htbp]" _n ///
"\caption{Title Me Here}" _n ///
"\begin{center}%" _n ///
"\small\begin{tabular}{l c c}" _n

// write column headers
file write f " &  & All" _n
file write f "\\" _n ///
"\hline\hline\noalign{\smallskip} " _n

// write in stats
// hi pick up here




// write end of table
file write f "\hline\hline\noalign{\smallskip} \end{tabular} " _n ///
"\begin{minipage}{6in}" _n ///
	"{\it Note:} \begin{center}DUMMY NOTE" _n ///
"\end{center}" _n ///	
"\end{minipage}" _n ///
"\end{center}" _n ///
"\end{table}" _n	
		
file close f

