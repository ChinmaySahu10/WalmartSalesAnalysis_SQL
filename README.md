# Walmart Sales Data Analysis

This project is designed to analyze Walmart Sales data, focusing on identifying top-performing branches and products, tracking sales trends across various products, and understanding customer behavior. The objective is to assess and enhance sales strategies by exploraing the dataset and uncover insights about product, sales & customers. Additionally this dataset has been taken from the Kaggle Walmart Sales Forecasting Competition. [source](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting)

## Purposes Of The Project

The aim is to gain insight into the sales data of Walmart to understand the different factors that affect sales of the different branches.

## About Data

This dataset contains sales transactions from a three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw.
The data contains 17 columns and 1000 rows:

| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| customer_type           | The type of the customer                | VARCHAR(30)    |
| gender                  | Gender of the customer making purchase  | VARCHAR(10)    |
| product_line            | Product line of the product solf        | VARCHAR(100)   |
| unit_price              | The price of each product               | DECIMAL(10, 2) |
| quantity                | The amount of the product sold          | INT            |
| VAT                 	  | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                   | The total cost of the purchase          | DECIMAL(10, 2) |
| date                    | The date on which the purchase was made | DATE           |
| time                    | The time at which the purchase was made | TIMESTAMP      |
| payment_method          | The total amount paid                   | DECIMAL(10, 2) |
| cogs                    | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross_margin_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross_income            | Gross Income                            | DECIMAL(10, 2) |
| rating                  | Rating                                  | FLOAT(2, 1)    |

### Analysis

Conducting a detailed examination of the dataset involves assessing the performance of various product lines. The goal is to identify top-performing product lines and pinpoint areas that require improvement.

Additionally, exploring sales trends provides valuable insights into the effectiveness of implemented sales strategies. Understanding these trends enables businesses to make informed decisions and optimize their approaches for increased sales.

Furthermore, a thorough analysis of customer segments, purchasing patterns, and profitability associated with each segment is essential. This examination offers valuable insights, guiding strategic decisions and enhancing overall business performance.

## Approach 

1. **Database Creation:** This is the first step where database was created, keeping neccessary constriants in my mind.Such as **NULL** values, primary key allocation. These are further explained below:

> A. Build a database
> B. Create table and insert the data with the hlep of import the excel file from kaggle.
> C. Checking for columns with null values in them.

2. **Feature Engineering:** To add more inforamtion to the dataset based on the given information.This helps to understand the data in higher level of granuality.

> A. Add a new column named `time_of_day` to give insight of sales in the Morning, Afternoon and Evening.

> B. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri).

> C. Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). 

3. **Exploratory Data Analysis (EDA):** Exploratory data analysis is done to answer the listed questions and aims of this project.

## Business Questions To Answer

### Generic Question

1. How many unique cities does the data have?
2. Which branch belongs to which city?

### Product

1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
5. What is the city with the largest revenue?
6. What product line had the largest VAT?
7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
8. Which branch sold more products than average product sold?
9. What is the most common product line by gender?
12. What is the average rating of each product line?

### Sales

1. Number of sales made in each time of the day per weekday
2. Which of the customer types brings the most revenue?
3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
4. Which customer type pays the most in VAT?

### Customer

1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give most ratings?
8. Which time of the day do customers give most ratings per branch?
9. Which day fo the week has the best avg ratings?
10. Which day of the week has the best average ratings per branch?

## Code

For the rest of the code, check the [SQL_queries.sql](https://github.com/ChinmaySahu10/WalmartSalesAnalysis_SQL/blob/main/SQL_Query.sql) file

```sql
-- Create database if not exists
CREATE DATABASE IF NOT EXISTS walmartsale;

--- Create Table if not exists
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
```
