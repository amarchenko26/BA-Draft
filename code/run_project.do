clear all
clear mata
set more off

**********************IMPORTANT**************************
*Change the paths to match path on your computer locally*
*********************************************************
//Path of repository
global repository `c(pwd)' //returns current working directory

***********************
//set operating system*
***********************
global os `c(os)'

***********************************************
//Run all code in all folders in correct order*
***********************************************

//Run code in main analysis
cd "$repository/main/"
foreach file in clean combined regressions{
	do "`file".do
}

//Run code in reviewers analysis
cd "$repository/reviewers/"
foreach file in reviewers{
	do "`file".do
}

//Run code in robustness analysis
cd "$repository/robustness/"
foreach file in robustness_property_chars robustness_state robustness_host edelman_price{
	do "`file".do
}

di "Good job!"

