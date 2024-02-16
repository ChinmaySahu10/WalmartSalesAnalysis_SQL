CREATE DATABASE IF NOT EXISTS walmartsale;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30)  NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT(2,1) 
);

---------------------------
---------------------------
-- Feature Engineeering --

-- time of day

SELECT time,
	(
    CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END 
    ) AS time_of_day
from sales;

-- Alterting the table to create the column time_of_day

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- Updating the Table with information

UPDATE sales
SET time_of_day = 
(
 CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN time BETWEEN "12:00:01" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END 
);


-- Day of the week

SELECT date, DAYNAME(date)
FROM sales;

-- Alterting the table to create the column day_name

ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = (
				DAYNAME(date)
                );


-- Month Name

SELECT date, MONTHNAME(date)
FROM sales;

-- Alterting the table to create the column month_name

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales
SET month_name = (
				MONTHNAME(date)
                );
-- -------------------------
-- -------------------------

-- Exploratory Data Analysis

-- GENREIC QUESTIONS
-- Q1 How many unique cities does the data have?

SELECT DISTINCT(city)
FROM sales;

-- Q2 Which branch belongs to which city?

SELECT DISTINCT(city), branch
FROM sales;

-- ----------------------------------------
-- Product
-- ----------------------------------------
-- Q1 How many unique product lines does the data have?

SELECT COUNT(DISTINCT(product_line))
FROM SALES;

-- Q2 What is the most common payment method?

SELECT 
	payment_method,
	COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- Q3 What is the most selling product line?

SELECT 
	product_line,
	COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- Q4 What is the total revenue by month?

SELECT month_name, SUM(total) AS revenue
FROM sales
GROUP BY month_name;

-- Q5 What month had the largest COGS?

SELECT month_name, SUM(COGS)
FROM sales
GROUP BY month_name
ORDER BY SUM(COGS) DESC;

-- Q6 What product line had the largest revenue?

SELECT product_line, SUM(total) AS revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC;

-- Q7 What is the city with the largest revenue?

SELECT city, SUM(total) AS revenue
FROM sales
GROUP BY city
ORDER BY revenue DESC;

-- Q8 What product line had the largest VAT?

SELECT product_line, SUM(VAT)
FROM sales
GROUP BY product_line
ORDER BY SUM(VAT) DESC;

-- Q9 Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
    product_line, total, AVG(total),
    CASE 
        WHEN total >= (SELECT AVG(total) FROM sales) THEN 'Good'
        WHEN total < (SELECT AVG(total) FROM sales) THEN 'Bad'
        ELSE 'Nothing'
    END AS good_bad
FROM sales
GROUP BY product_line,total;	

WITH prd_avg AS
(
	SELECT product_line, total,
    AVG(total) OVER (PARTITION BY product_line) AS AT
	FROM sales
)
SELECT product_line, total, AT,
	CASE
		WHEN total >= AT THEN " Good"
        WHEN total < AT THEN "Bad"
	END AS "Status"
FROM prd_avg;

-- Q10 Which branch sold more products than average product sold?

SELECT branch, SUM(quantity)
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM SALES)
ORDER BY SUM(quantity) DESC;

-- Q11 What is the most common product line by gender?

WITH RankedProductLines AS (
    SELECT 
        gender,
        product_line,
        COUNT(product_line) AS product_line_count,
        ROW_NUMBER() OVER (PARTITION BY gender ORDER BY COUNT(product_line) DESC) AS row_num
    FROM 
        sales
    GROUP BY 
        gender, product_line
)
SELECT 
    gender,
    product_line,
    product_line_count
FROM 
    RankedProductLines
WHERE 
    row_num = 1;


-- Q12 What is the average rating of each product line?

SELECT product_line, AVG(rating)
FROM sales
GROUP BY product_line;

-- ----------------------------------------
-- Sales
-- ----------------------------------------
-- Q1 Number of sales made in each time of the day per weekday?

SELECT time_of_day, COUNT(total)
FROM sales
WHERE day_name <> "saturday" AND day_name <> "sunday"
GROUP BY time_of_Day 
ORDER BY COUNT(total) DESC;

-- Q2 Which of the customer types brings the most revenue?

SELECT customer_type, SUM(total) as Revenue
FROM Sales
GROUP BY customer_type
ORDER BY Revenue DESC;

-- Q3 Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT city, AVG(VAT)
FROM sales
GROUP BY city
ORDER BY MAX(VAT) DESC;

-- Q4 Which customer type pays the most in VAT?

SELECT customer_type, COUNT(VAT)
FROM sales
GROUP BY customer_type
ORDER BY COUNT(VAT) DESC;

-- ----------------------------------------
-- Customer
-- ----------------------------------------

-- Q1 How many unique customer types does the data have?

SELECT DISTINCT(CUSTOMER_TYPE)
FROM SALES;

-- Q2 How many unique payment methods does the data have?

SELECT DISTINCT(payment_method)
FROM sales;

-- Q3 What is the most common customer type?

SELECT customer_type, COUNT(customer_type)
FROM sales
GROUP BY customer_type
ORDER BY COUNT(customer_type) DESC;

-- Q4 Which customer type buys the most?

SELECT customer_type, COUNT(total)
FROM sales
GROUP BY customer_type
ORDER BY COUNT(total) DESC;

-- Q5 What is the gender of most of the customers?

SELECT gender, COUNT(customer_type)
FROM sales
GROUP BY gender
ORDER BY COUNT(customer_type) DESC;

-- Q6 What is the gender distribution per branch?

SELECT branch, gender, COUNT(gender)
FROM sales
GROUP BY  branch, gender 
ORDER BY branch ;

-- Q7 Which time of the day do customers give most ratings?

SELECT time_of_day, COUNT(rating)
FROM sales
GROUP BY time_of_day
ORDER BY COUNT(rating) DESC;

-- Q8 Which time of the day do customers give most ratings per branch?

SELECT branch, time_of_day, COUNT(rating) AS "Number of Ratings"
FROM sales
GROUP BY branch, time_of_day
ORDER BY branch, COUNT(rating) DESC;

-- Q9 Which day of the week has the best avg ratings?

SELECT day_name, AVG(rating)
FROM sales
GROUP BY day_name
ORDER BY AVG(rating) DESC;

-- Q10 Which day of the week has the best average ratings per branch? List only the 1st day of the week.

WITH avg_rtg AS 
	(
    SELECT branch, day_name, AVG(rating) AS Average_Rating,
    RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rn_rtg
	FROM sales
	GROUP BY branch, day_name
    )
SELECT branch, day_name, Average_Rating
FROM avg_rtg
WHERE rn_rtg = 1;


-- -------------------------------------------------ENDS HERE ---------------------------------------------------------------------