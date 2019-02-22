
**TRASH CODE FROM REVIEWERS.DO





/*
save "$repository/code/reviewers/reviewer_data.dta", replace


do "$repository/code/main/1_general_clean.do"

** Create first review variables
split first_review, p("/") //splits variable by /
rename first_review1 first_review_day
rename first_review2 first_review_month
rename first_review3 first_review_year
replace first_review_year = substr(first_review_year, -2, .) //deletes decimals from string

destring first_review_day, replace force 
destring first_review_month, replace force
destring first_review_year, replace force

replace first_review_month = 99 if first_review_month == . //create fake month for people w/ no reviews
replace first_review_year = 99 if first_review_year == .  //create fake year for people w/ no reviews to boost observations


** Collapsing demographic cat.
gen sex_res = sex if sex < 3 
replace sex_res = 3 if sex == 3 | sex == 4 | sex == 5 | sex == 6 
**[NOTE: what about 0?]

gen race_res = race if race != 5 | race!= 6
replace race_res = 5 if race == 5 | race == 6
**[NOTE: what about 0?]

label define sex_res 1 "Male" 2 "Female" 3 "Two people or Unknown"
label values sex_res sex_res
label define race_res 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial or Unknown"
label values race_res race_res
la var race_res "Race"
la var sex_res "Sex"

drop if sex_res > 2
drop if race_res > 4


** Create interaction for race and sex
egen race_sex_res = group(race_res sex_res), label








** Garbage Sentiment Analysis Attempt
/*

** Apply labels
label define chicago_sex 1 "Male" 2 "Female" 3 "Two people of same sex" 4 "Two people of different sex" 5 "Unknown"
label values sex chicago_sex
label define chicago_race 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial (Groups of 2)" 6 "Unknown"
label values race chicago_race
label define chicago_age 1 "Young" 2 "Middle-aged" 3 "Old" 4 "Unknown"
label values age _age

** Counts instances of positive words 
egen test = noccur(rev_comments), string("!")

gen good_word1 = strpos(rev_comments, "!") //33% have !
gen good_word2 = strpos(rev_comments, "love") //10% said love
gen good_word3 = strpos(rev_comments, "wonderful") //8% said wonderful
gen good_word4 = strpos(rev_comments, "spacious") //6% said spacious
gen good_word5 = strpos(rev_comments, "fantastic") //4% said fantastic
gen good_word6 = strpos(rev_comments, "beautiful") //7% said beautiful
gen good_word7 = strpos(rev_comments, "friendly") //8% said friendly
gen good_word8 = strpos(rev_comments, "clean") //22% said clean
gen good_word9 = strpos(rev_comments, "comfort") //17% said comfort
gen good_word10 = strpos(rev_comments, "enjoy") //8% said enjoy
gen good_word11 = strpos(rev_comments, "excellent") //4% said excelled
gen good_word12 = strpos(rev_comments, "good") //7.5% said good
gen good_word13 = strpos(rev_comments, "nice") //17% said nice
gen good_word14 = strpos(rev_comments, "quiet") //5% said quiet

gen contains_good = 0 
replace contains_good = 1 if good_word1 > 0 | good_word2 > 0 | good_word3 > 0 | good_word4 > 0 | good_word5 > 0| ///
good_word6 > 0| good_word7 > 0| good_word8 > 0|good_word9 > 0|good_word10 > 0|good_word11 > 0|good_word11 > 0| ///
good_word12 > 0|good_word13 > 0|good_word14 > 0
 

//Tried: abysmal, abuse, afraid, anger, sad, bad, awful, badly, late, bother, broke
// chaotic, cheat, clog, bug, not working,crash, creak, creepy, crisis, rude, dead
// dick, drunk, dumb, dusty, dungeon, embarrasing, overpriced, expensive, foul, freez, 
// gross, hate, incompetent, inexperience, issue, loud, mess, nasty, regret, rude
// terrible, trash, ugly, unhelpful
** Problem, little variation in bad words, those that occur more than 10 times occur <1% of the time
gen bad_word1 = strpos(rev_comments, "late") //3 % said late
gen bad_word2 = strpos(rev_comments, "issue") //1.2% said issue
gen bad_word3 = strpos(rev_comments, "regret") //.2% said regret
gen bad_word4 = strpos(rev_comments, "loud") //.2% said loud
gen bad_word5 = strpos(rev_comments, "bad") //.2% said bad

** Creating indices to measure sentiment
// Frequency of good words over total words 
// Frequency of bad words over total words 
// #Good words/length of review
