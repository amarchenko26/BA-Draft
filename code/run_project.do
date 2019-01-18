clear all
clear mata
set more off
set emptycells drop // If the interaction term is empty, don't report it in the table, reduces memory and variable necessity 

set matsize 11000 
set maxvar 32000


**********************IMPORTANT**************************
* Change the paths to match path on your computer locally*
*********************************************************

* MAKE SURE TO SET WD TO 'BA-DRAFT' LEVEL OF FILE ORGANIZATION
global repository `c(pwd)' //returns current working directory

* Set OS
global os `c(os)'

****************************
* Refreshing output folder*
****************************

//Remove output folder if exists. Do NOT remove "code" folder.
foreach folder in output {
	capture {
		cd "$repository/code/`folder'/"
	}
	if _rc == 0 { //0 is return code if nothing wrong
		cd "$repository/code/"
 		if "$os" == "Windows" {
			!rmdir `folder' /s /q //remove directory you're in to refresh on every re-run
		}
		if "$os" == "MacOSX" {
			!rm -rf `folder'
		}
	}

	cd "$repository/code/"
	mkdir `folder'
}

***********************************************
* Run all code in all folders in correct order*
***********************************************

//Run code in main analysis
cd "$repository/code/main/"
foreach file in 1_general_clean 2_city_specific_clean 3_regressions{
	do "`file'".do
}

//Run code in reviewers analysis
cd "$repository/code/reviewers/"
foreach file in reviewers reviewers_regressions{
	do "`file'".do
}

//Run code in robustness analysis
cd "$repository/code/robustness/"
foreach file in robustness_property_chars robustness_state robustness_host edelman_price{
	do "`file'".do
}


di "Good job!"

