SELECT * FROM walmartsales.walmartsalesdata;

-- changing column names 



 ALTER TABLE walmartsales.walmartsalesdata 
RENAME COLUMN `Invoice ID` TO Invoice_ID,
RENAME COLUMN `Customer type` TO Customer_type,
RENAME COLUMN `Product line` TO Product_line,
RENAME COLUMN `Unit price` TO Unit_price,
RENAME COLUMN `Tax 5%` TO `Tax_5%`,
RENAME COLUMN `gross margin percentage` TO gross_margin_percentage,
RENAME COLUMN `gross income` TO gross_income
;

-- checking for nulls 
SHOW COlUMNS
FROM  walmartsales.walmartsalesdata
WHERE Field IS NULL OR ' '  ;

--  FEATURE ENGINEERING --

SELECT `Time`,
(CASE
		WHEN `Time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `Time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) 
    AS time_of_day
FROM walmartsales.walmartsalesdata;


ALTER TABLE walmartsales.walmartsalesdata ADD COLUMN time_of_day VARCHAR(30);

SELECT * FROM walmartsales.walmartsalesdata;

UPDATE walmartsales.walmartsalesdata
SET time_of_day = (CASE
		WHEN `Time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `Time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);


SELECT `Date`,
	DAYNAME(`Date`) AS day_name
FROM  walmartsales.walmartsalesdata;

ALTER TABLE walmartsales.walmartsalesdata ADD COLUMN day_name VARCHAR(20);

UPDATE walmartsales.walmartsalesdata
SET day_name = DAYNAME(`Date`);

SELECT `Date`,
	MONTHNAME(`Date`) AS month_name
FROM  walmartsales.walmartsalesdata;


ALTER TABLE walmartsales.walmartsalesdata ADD COLUMN month_name VARCHAR(20);

UPDATE walmartsales.walmartsalesdata
SET month_name = MONTHNAME(`Date`);

SELECT * FROM walmartsales.walmartsalesdata;


-- Exploratory Data Analysis
-- 1. Generic Questions 

SELECT DISTINCT(City)
FROM walmartsales.walmartsalesdata;

SELECT COUNT( DISTINCT(City)) AS count_of_unique_city
FROM walmartsales.walmartsalesdata;

SELECT DISTINCT(Branch)
FROM walmartsales.walmartsalesdata;

-- In which city is each branch?

SELECT DISTINCT(City),(Branch)
FROM walmartsales.walmartsalesdata;

-- Product Question 
-- 1.	How many unique product lines does the data have?
SELECT DISTINCT(Product_line)
FROM walmartsales.walmartsalesdata;

SELECT COUNT(DISTINCT(Product_line))
FROM walmartsales.walmartsalesdata;

-- 2.	What is the most common payment method?
SELECT * FROM walmartsales.walmartsalesdata;


SELECT Payment, COUNT(Payment) AS payment_count
FROM walmartsales.walmartsalesdata
GROUP BY Payment
ORDER BY payment_count DESC;

-- 3.	What is the most selling product line?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT Product_line, COUNT(Product_line) AS count
FROM walmartsales.walmartsalesdata
GROUP BY Product_line
ORDER BY count DESC;

-- 4.	What is the total revenue by month?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT month_name, ROUND(SUM(Total),2) AS total_revenue
FROM walmartsales.walmartsalesdata
GROUP BY month_name
ORDER by SUM(Total) DESC;

-- 5.	What month had the largest COGS?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT month_name, ROUND(SUM(cogs),2)
FROM walmartsales.walmartsalesdata
GROUP BY month_name
ORDER BY SUM(cogs) DESC;

-- 6.	What product line had the largest revenue?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT product_line, ROUND(SUM(Total),2)
FROM walmartsales.walmartsalesdata
GROUP BY product_line
ORDER BY SUM(Total) DESC
;

-- 7.	What is the city with the largest revenue?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT Branch, City, ROUND(SUM(Total),2)
FROM walmartsales.walmartsalesdata
GROUP BY Branch, City
ORDER BY SUM(Total) DESC
;

-- 8.	What product line had the largest VAT?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT product_line, AVG(`Tax_5%`)
FROM walmartsales.walmartsalesdata
GROUP BY product_line
ORDER BY AVG(`Tax_5%`) DESC
;

-- 9.	Fetch each product line and add a column to those product line showing "Good", "Bad".
--       Good if its greater than average sales

SELECT AVG(Total)
FROM walmartsales.walmartsalesdata;

SELECT Total
	(CASE 
		WHEN Total >  AVG(Total) THEN "Good"
        ELSE "Bad"
	END
    )
FROM walmartsales.walmartsalesdata;


ALTER TABLE  walmartsales.walmartsalesdata ADD COLUMN product_line_rating DOUBLE;






-- 10.	Which branch sold more products than average product sold?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT Branch, SUM(Quantity)
FROM walmartsales.walmartsalesdata
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity)FROM walmartsales.walmartsalesdata)
;

-- 11.	What is the most common product line by gender?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT DISTINCT Product_line, Gender,COUNT(Gender) AS total_cnt
FROM walmartsales.walmartsalesdata
GROUP BY Product_line, Gender
ORDER BY total_cnt DESC ;

-- 12.	What is the average rating of each product line?
SELECT AVG(Rating), Product_line
FROM walmartsales.walmartsalesdata
GROUP BY Product_line
ORDER BY AVG(Rating) DESC;

-- SALES QUESTIONS 
-- 1.	Number of sales made in each time of the day per weekday 

SELECT time_of_day, COUNT(*) AS total_sales 
FROM walmartsales.walmartsalesdata
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- 2.	Which of the customer types brings the most revenue?
SELECT Customer_type, ROUND(SUM(Total),2) AS total_revenue
FROM walmartsales.walmartsalesdata
GROUP BY Customer_type
ORDER BY SUM(Total) DESC;

-- 3.	Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT City, ROUND(AVG(`Tax_5%`),2)
FROM walmartsales.walmartsalesdata
GROUP BY City
ORDER BY AVG(`Tax_5%`) DESC;


-- 4.	Which customer type pays the most in VAT?

SELECT Customer_type, ROUND(AVG(`Tax_5%`),2)
FROM walmartsales.walmartsalesdata
GROUP BY Customer_type
ORDER BY AVG(`Tax_5%`) DESC;

-- CUSTOMER QUESTIONS 
-- 1.	How many unique customer types does the data have?

SELECT DISTINCT(Customer_type)
FROM walmartsales.walmartsalesdata;

-- 2.	How many unique payment methods does the data have?
SELECT DISTINCT Payment
FROM walmartsales.walmartsalesdata;


-- 3.	What is the most common customer type?
SELECT * FROM walmartsales.walmartsalesdata;

SELECT Customer_type,COUNT(*)
FROM walmartsales.walmartsalesdata
GROUP BY Customer_type;

-- 4.	Which customer type buys the most?
SELECT Customer_type,COUNT(Quantity)
FROM walmartsales.walmartsalesdata
GROUP BY Customer_type
ORDER BY COUNT(Quantity) DESC ;


-- 5.	What is the gender of most of the customers?
SELECT Gender, COUNT(Customer_type)
FROM walmartsales.walmartsalesdata
GROUP BY Gender
ORDER BY COUNT(Customer_type) DESC ;

-- 6.	What is the gender distribution per branch?
SELECT Gender,COUNT(Gender)
FROM walmartsales.walmartsalesdata
WHERE Branch = "A"
GROUP BY Gender
ORDER BY Gender DESC;
 
 
 
 
 SELECT Gender,COUNT(Gender)
FROM walmartsales.walmartsalesdata
WHERE Branch = "B"
GROUP BY Gender
ORDER BY Gender DESC;
 
 
 SELECT Gender,COUNT(Gender)
FROM walmartsales.walmartsalesdata
WHERE Branch = "C"
GROUP BY Gender
ORDER BY Gender DESC;
 
 
 
-- 7.	Which time of the day do customers give most ratings?
 SELECT time_of_day, ROUND(AVG(Rating),1)
 FROM walmartsales.walmartsalesdata
 GROUP BY time_of_day
 ORDER BY AVG(Rating) DESC ;
 
 
 -- 8.	Which time of the day do customers give most ratings per branch?
 
  SELECT time_of_day, ROUND(AVG(Rating),1)
 FROM walmartsales.walmartsalesdata
 WHERE Branch = "A"
 GROUP BY time_of_day
 ORDER BY AVG(Rating) DESC ;
 
 
  SELECT time_of_day, ROUND(AVG(Rating),1)
 FROM walmartsales.walmartsalesdata
 WHERE Branch = "B"
 GROUP BY time_of_day
 ORDER BY AVG(Rating) DESC ;
 
 
 
  SELECT time_of_day, ROUND(AVG(Rating),1)
 FROM walmartsales.walmartsalesdata
 WHERE Branch = "C"
 GROUP BY time_of_day
 ORDER BY AVG(Rating) DESC ;
 
 
 
 
 -- 9.	Which day of the week has the best avg ratings?
 
 SELECT * FROM walmartsales.walmartsalesdata;
 
 SELECT day_name, ROUND(AVG(Rating),2)
  FROM walmartsales.walmartsalesdata
 GROUP BY day_name
 ORDER BY AVG(Rating) DESC
;
 
 
 
 -- 10.	Which day of the week has the best average ratings per branch?
  SELECT day_name, ROUND(AVG(Rating),2)
  FROM walmartsales.walmartsalesdata
  WHERE Branch LIKE "A%"
 GROUP BY day_name
 ORDER BY AVG(Rating) DESC
;
 
   SELECT day_name, ROUND(AVG(Rating),2)
  FROM walmartsales.walmartsalesdata
  WHERE Branch LIKE "B%"
 GROUP BY day_name
 ORDER BY AVG(Rating) DESC
;
 
 
   SELECT day_name, ROUND(AVG(Rating),2)
  FROM walmartsales.walmartsalesdata
  WHERE Branch LIKE "C%"
 GROUP BY day_name
 ORDER BY AVG(Rating) DESC
;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 