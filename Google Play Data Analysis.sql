SELECT * FROM googleplaystore
SELECT * FROM googleplaystore_user_reviews

--Identifying Nulls in each dataset
SELECT * FROM googleplaystore
WHERE APP IS NULL OR
Category IS NULL OR
Rating IS NULL OR
Reviews IS NULL OR
Size IS NULL OR
Installs IS NULL OR
Type IS NULL OR
Price IS NULL OR
Content_Rating IS NULL OR
Genres IS NULL OR
Last_Updated IS NULL OR
Current_Ver IS NULL OR
Android_Ver IS NULL

-- Deciding to keep the NaN data below in, as it seems only the Ratings are missing for the most part but these apps have much more information to delve into

SELECT * FROM googleplaystore
WHERE APP IS NULL OR APP = 'NaN' OR
Category IS NULL OR Category = 'NaN' OR
Rating IS NULL OR Rating = 'NaN' OR
Reviews IS NULL OR Reviews = 'NaN' OR
Size IS NULL OR Size = 'NaN' OR
Installs IS NULL OR Installs = 'NaN' OR
Type IS NULL OR Type = 'NaN' OR
Price IS NULL OR Price = 'NaN' OR
Content_Rating IS NULL OR Content_Rating = 'NaN' OR
Genres IS NULL OR Genres = 'NaN' OR
Last_Updated IS NULL OR Last_Updated = 'NaN' OR
Current_Ver IS NULL OR Current_Ver = 'NaN' OR
Android_Ver IS NULL OR Android_Ver = 'NaN'


SELECT * FROM googleplaystore_user_reviews
WHERE App IS NULL OR
Translated_Review IS NULL OR
Sentiment IS NULL OR
Sentiment_Polarity IS NULL OR
Sentiment_Subjectivity IS NULL

-- Removing Nulls from each Dataset
DELETE FROM googleplaystore
WHERE APP IS NULL OR
Category IS NULL OR
Rating IS NULL OR
Reviews IS NULL OR
Size IS NULL OR
Installs IS NULL OR
Type IS NULL OR
Price IS NULL OR
Content_Rating IS NULL OR
Genres IS NULL OR
Last_Updated IS NULL OR
Current_Ver IS NULL OR
Android_Ver IS NULL

DELETE FROM googleplaystore_user_reviews
WHERE App IS NULL OR
Translated_Review IS NULL OR
Sentiment IS NULL OR
Sentiment_Polarity IS NULL OR
Sentiment_Subjectivity IS NULL

-- Question 1 (Overview of Google Play Dataset... # of Unique Apps and Categories)
SELECT COUNT(DISTINCT(App)) as Number_of_apps,
COUNT(DISTINCT(Category)) as Number_of_categories
FROM googleplaystore

-- Question 2: Number of Apps per Category in Alphabetical Order
SELECT Category, COUNT(App) as Number_of_Apps
FROM googleplaystore
GROUP BY Category
ORDER BY Category



-- Question 3: Top 10 Rated Free Apps
SELECT Top 10 App, Category, Rating, Reviews
FROM googleplaystore
WHERE Type = 'Free' AND Rating <> 'NaN'
ORDER BY Rating DESC
-- Seems Dating and Event Apps are the highest rated Free-Apps (people may be more enticed to download such apps but it can also mean a lot of saturity in the market)

-- Question 4: Top 10 Apps with Most Reviews
SELECT Top 10 App, MAX(Category) as Category, AVG(Rating) as Rating, AVG(Reviews) as Reviews
FROM googleplaystore
GROUP BY APP
ORDER BY Reviews DESC

-- Data Modification for Q4
ALTER TABLE googleplaystore
ALTER COLUMN Rating FLOAT

UPDATE googleplaystore
SET Rating = NULL
WHERE Rating = 'NaN';

ALTER TABLE googleplaystore
ALTER COLUMN Reviews INT
-- 

-- Question 5: TOP 10 Categories by Average Rating
SELECT TOP 10 Category, ROUND(AVG(Rating),2) as Average_Rating
FROM googleplaystore
GROUP BY Category
ORDER BY Average_Rating DESC

--Bottom 10 Apps by Average Rating (Potential for Entering Market) 
SELECT TOP 10 Category, ROUND(AVG(Rating),2) as Average_Rating
FROM googleplaystore
GROUP BY Category
ORDER BY Average_Rating ASC
--Sidenote: Dating is the most poorly rated category despite being one of the Top 10 Categories among Free Users
-- Best Rated Apps in Dating for possible Reverse Engineering Ideas
SELECT App, AVG(Rating) as Rating, AVG(Reviews) as Review
FROM googleplaystore
WHERE Category = 'DATING'
GROUP BY App
ORDER BY Review DESC

-- Question 6: Top 10 Categories by Number of Installs
SELECT Category, SUM(CAST(REPLACE(SUBSTRING(Installs, 1, PATINDEX('%[^0-9]%',Installs + ' ')-1),',',' ') as int)) AS Number_of_Installs
FROM googleplaystore
GROUP BY Category
ORDER BY Number_of_Installs DESC

-- Question 7: TOP 10 Average Sentiment Polarity by Category
SELECT TOP 10 Category, ROUND(AVG(TRY_CAST(Sentiment_Polarity as FLOAT)),2) as Sentiment_Polarity
FROM googleplaystore
JOIN googleplaystore_user_reviews
ON googleplaystore.App = googleplaystore_user_reviews.App
GROUP BY Category
ORDER BY Sentiment_Polarity DESC

-- QUESTION 8: TOP 10 Sentiment Reviews by App Category
SELECT TOP 10 Category,Sentiment,Count(*) as total_sentiment
FROM googleplaystore
JOIN googleplaystore_user_reviews
ON googleplaystore.App = googleplaystore_user_reviews.App
WHERE Sentiment <> 'nan'
GROUP BY Category, Sentiment
ORDER BY total_sentiment DESC
-- We notice that in the Top 10 only 2 Categories contain primarily negative sentiments 



