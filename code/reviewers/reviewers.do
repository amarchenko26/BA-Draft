*********************************************************
*					  Reviewers 					    *
*********************************************************


clear all
set more off

** Use Chicago Reviewers data w/ race & sentiment
insheet using "$repository/data/done_Chi_joined_sentiment.csv", clear
sort listing_id

** Clean-up of Reviewer variable names
rename sex rev_sex
rename age rev_age
rename race rev_race
rename ra_name rev_ra_name
rename link rev_link
rename indicator rev_indicator
rename date rev_date
rename comments rev_comments

label var sentiment_listing "Mean Sentiment per Listing"
label var sentiment_mean "Mean Sentiment per Review"
rename v1 word_count

destring sentiment_sd, replace force
replace sentiment_sd = -1 if sentiment_sd == . //replace missing values of sentiment_sd --> EZRA, is dis okay? 
**[QUESTION: Why do this?]

destring rev_race, replace force
destring rev_sex, replace force
destring rev_age, replace force
replace rev_race = 0 if rev_race == .
replace rev_sex = 0 if rev_sex == .
replace rev_age = 0 if rev_age == .

** Apply reviewer labels
label define _sex_rev 0 "Missing" 1 "Male" 2 "Female" 3 "Two males" 4 "Two females" 5 "Two people of different sex" 6 "Unknown"
label values rev_sex _sex_rev
label define _race_rev 0 "Missing" 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial (Groups of 2)" 6 "Unknown"
label values rev_race _race_rev
label define _age_rev 0 "Missing" 1 "Young" 2 "Middle-aged" 3 "Old" 4 "Two people of different age" 5 "Unknown"
label values rev_age _age_rev

** Collapsing demographic cat.
gen rev_sex_res = rev_sex if rev_sex == 1 | rev_sex == 2
replace rev_sex_res = 3 if rev_sex == 3 | rev_sex == 4 | rev_sex == 5 | rev_sex == 6 //we could remove this
drop if rev_sex_res == 0 | rev_sex_res > 2 // drop missing observations  //we could remove this

gen rev_race_res = rev_race if rev_race != 5 | rev_race!= 6 | rev_race!= 0
replace rev_race_res = 5 if rev_race == 5 | rev_race == 6  //we could remove this
drop if rev_race_res == 0 | rev_race_res > 4  //we could remove this


label define rev_sex_res 1 "Male" 2 "Female" 3 "Two people or Unknown"
label values rev_sex_res rev_sex_res
label define rev_race_res 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial or Unknown"
label values rev_race_res rev_race_res
label var rev_race_res "Race"
label var rev_sex_res "Sex"

** Create interaction for race and sex
egen rev_race_sex_res = group(rev_race_res rev_sex_res), label



*******************
** Join w/ host data

merge m:1 listing_id using "$repository/data/done_Chi_full_listings_renamed.dta"
keep if _merge == 3

do "$repository/code/reviewers/review_cleaner"

