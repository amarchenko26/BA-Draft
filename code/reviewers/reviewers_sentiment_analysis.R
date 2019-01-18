pacman::p_load(sentimentr)
require(data.table)
require(readr)
require(ggplot2)
require(xlsx)

reviews <- read_csv("/Users/AnyaM/Dropbox/UC/4th Year/Econ BA/Airbnb Cities/Chicago/done_Chi_reviewers_17000_incomplete.csv")
listings <- read_csv("/Users/AnyaM/Dropbox/UC/4th Year/Econ BA/Airbnb Cities/Chicago/done_Chi_full_listings.csv")
reviews.DT <- data.table(reviews)
listings.DT <- data.table(listings)
reviews.DT[, comments_clean := iconv(comments, "ASCII", "ASCII",sub='')]
reviews.sentiment <- sentiment_by(reviews.DT[, comments_clean])
reviews.DT[, sentiment_mean := reviews.sentiment$ave_sentiment]
reviews.DT[, sentiment_sd := reviews.sentiment$sd]
reviews.DT[, sentiment_listing := mean(sentiment_mean), by = listing_id]
sentiment_check <- listings.DT[, .(id, review_scores_rating)]
sentiment_check <- merge(sentiment_check, unique(reviews.DT[, .(listing_id, sentiment_listing)]), by.x = "id", by.y = "listing_id")
ggplot(sentiment_check, aes(review_scores_rating, sentiment_listing)) + geom_point() + geom_smooth(method = "lm")