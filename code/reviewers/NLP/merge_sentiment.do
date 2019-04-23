* Merging Sentiment Data with clean data


preserve 
use "$repository/code/reviewers/NLP/sentiment.dta", clear
rename id2 id
save "$repository/code/reviewers/NLP/sentiment.dta", replace
restore


merge 1:1 id using "$repository/code/reviewers/NLP/sentiment.dta"
