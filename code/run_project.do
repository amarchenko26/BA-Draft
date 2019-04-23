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

************************************************
* Run all code in all folders in correct order *
************************************************

//Run code in main analysis
cd "$repository/code/main/"
foreach file in 1_general_clean 2_city_specific_clean{
	do "`file'".do
}

//Run code in census cleaning 
cd "$repository/code/census/"
foreach file in 3_census_merge.do{
	do "`file'".do
}

save "$repository/data/cleaned.dta", replace

//Run code to import NLP variables
cd "$repository/code/reviewers/"
foreach file in {
	do "`file'".do
}


//Run code in robustness analysis
cd "$repository/code/tables/"
foreach file in 1_summary_table 2_summary_host_demographics 3_summary_host_characteristics 5_price 6_robustness_edelman_price 7_number_reviews 8_availability_30 9_robustness_city 10_robustness_listing_chars 12_revenue{
	do "`file'".do
}

/*

//Run code in reviewers analysis
cd "$repository/code/reviewers/"
foreach file in reviewers 11_reviewers_sentiment 4_summary_review_sentiment{
	do "`file'".do
}


di "Good job!"
