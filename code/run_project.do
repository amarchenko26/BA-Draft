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
do "combined".do
do "clean".do
do "regressions".do
foreach file in main analysis{
	do "`file".do
}

//Run code in reviewers analysis
cd "$repository/reviewers/"
foreach file in reviewers analysis{
	do "`file".do
}

//Run code in robustness analysis
cd "$repository/robustness/"
foreach file in robustness analysis{
	do "`file".do
}

di "Good job!"

