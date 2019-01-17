
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

la var sentiment_listing "Mean Sentiment per Listing"
la var sentiment_mean "Mean Sentiment per Review"
rename v1 word_count
destring sentiment_sd, replace force
replace sentiment_sd = -1 if sentiment_sd == . //replace missing values of sentiment_sd --> EZRA, is dis okay? 

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
replace rev_sex_res = 3 if rev_sex == 3 | rev_sex == 4 | rev_sex == 5 | rev_sex == 6
drop if rev_sex_res == 0 | rev_sex_res > 2 // drop missing observations

gen rev_race_res = rev_race if rev_race != 5 | rev_race!= 6 | rev_race!= 0
replace rev_race_res = 5 if rev_race == 5 | rev_race == 6
drop if rev_race_res == 0 | rev_race_res > 4


label define rev_sex_res 1 "Male" 2 "Female" 3 "Two people or Unknown"
label values rev_sex_res rev_sex_res
label define rev_race_res 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian" 5 "Multiracial or Unknown"
label values rev_race_res rev_race_res
la var rev_race_res "Race"
la var rev_sex_res "Sex"

** Create interaction for race and sex
egen rev_race_sex_res = group(rev_race_res rev_sex_res), label



*******************
** Join w/ host data

joinby listing_id using "$repository/data/done_Chi_full_listings_renamed.dta"

do "$repository/code/clean.do"

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

gen race_res = race if race != 5 | race!= 6
replace race_res = 5 if race == 5 | race == 6

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


/*

** Regressions

// White Male reviewers
eststo, title("White Male Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 1, ///
	vce(cluster group_neighbourhood_cleansed) 


// White female reviewers
eststo, title("White Female Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 2, ///
	vce(cluster group_neighbourhood_cleansed) 
	

// Black Male reviewers
eststo, title("Black Male Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 3, ///
	vce(cluster group_neighbourhood_cleansed) 
	
	
// Black Female reviewers
eststo, title("Black Female Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 4, ///
	vce(cluster group_neighbourhood_cleansed) 
	
// Hispanic Male reviewers
eststo, title("Hispanic Male Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 5, ///
	vce(cluster group_neighbourhood_cleansed) 
	
	
// Hispanic Female reviewers
eststo, title("Hispanic Female Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 6, ///
	vce(cluster group_neighbourhood_cleansed) 

	
	
// Asian Male reviewers	
eststo, title("Asian Male Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 7, ///
	vce(cluster group_neighbourhood_cleansed) 	
	
// Asian Female reviewers	
eststo, title("Asian Female Reviewers"): quietly reg sentiment_mean_stan i.race_sex_res ///
	i.group_neighbourhood_cleansed /// 
	i.group_property_type i.group_room_type /// 
	accommodates bathrooms bedrooms beds i.group_bed_type /// 
	cleaning_fee extra_people num_amenities /// 
	i.first_review_month i.first_review_year  /// 
	i.group_cancellation_policy instant_bookable require_guest_profile_picture ///
	require_guest_phone_verification minimum_nights /// 
	availability_30 availability_60 ///
	len_desc short_words len_desc2 short_words2 len_desc3 short_words3 /// //Quality of listing/effort of host
	len_desc4 short_words4 len_desc5 short_words5 len_desc6 short_words6 good_word_tot /// //Quality of listing
	i.group_host_response_time host_response_rate /// //Host-specific charac.
	host_identity_verified host_is_superhost if rev_race_sex_res == 8, ///
	vce(cluster group_neighbourhood_cleansed) 



esttab est9 est10 est11 est12 est13 est14 est15 est16 using reviewer_mean_reg_5_10.tex, se ar2 replace label mtitles title("Estimates of effect of host demographics on review sentiment, by reviewer demographics") longtable page(longtable)









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
