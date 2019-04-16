
********************************************************************************
* Saving full_listings_all_sentiments as csv
********************************************************************************


*import delimited "$repository/data/full_listings_all_sentiments.csv", clear 

*save "/Users/thiagoresende/Documents/GitHub/BA-Draft/data/full_listings_all_sentiments.dta"


********************************************************************************

********************************************************************************


use "/Users/thiagoresende/Documents/GitHub/BA-Draft/code/reviewers/NLP/sentiment.dta", clear

*Note: experiences_offered == 0


local pre summary description space neighborhood_overview
foreach name in `pre'{
	foreach name2 in `pre'{
		cor `name'_polarity `name2'_subjectivi
	}
}

/*
summary_polarity summary_subjectivity  				.69
summary_polarity description_subjectivity 			.46

description_polarity summary_subjectivity 			.42
description_polarity description_subjectivity 		.65

space_polarity description_subjectivity 			.22
space_polarity space_subjectivity 					.81
space_polarity space_subjectivity 					.36

neighborhood_overview_polarity space_subjectivity 	.37
neighborhood_overview_polarity neighborhood_overview_subjectivi .80
*/


use "/Users/thiagoresende/Documents/GitHub/BA-Draft/data/cleaned.dta", clear
keep age_res race_res sex_res id

merge 1:1 id using "/Users/thiagoresende/Documents/GitHub/BA-Draft/code/reviewers/NLP/sentiment.dta"

local pre summary description space neighborhood_overview
local ras race_res age_res sex_res

foreach name in `pre'{
	foreach name2 in `ras'{
		reg `name'_s i.`name2'
	}
}

foreach name in `pre'{
	foreach name2 in `ras'{
		reg `name'_pol i.`name2'
	}
}



/*
Simple regressins indicate statistically significant results with the following conclusions:
RACE
(1) The polarity of all race desc's is statically significantly less than whites
(2) As is subjectivity


AGE
(3) For summary and description _subjectivity, youth have a higher avergage score
(4)	For space and neighborhoo _subjectivity, youth have the lowest avg score [apart from missing]
(5) The associations are the same for _polarity

SEX
(6) The Female polarity and subjectivity in desc's is statically significantly more than males, for all categories.

















