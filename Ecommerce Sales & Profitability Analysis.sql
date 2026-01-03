use ecommerce_sales_data;
select * from sales;


ALTER TABLE sales 
RENAME COLUMN `sub-category` TO sub_category;
-- 1) Which are the top 5 cities contributing the most to net profit?

SELECT city, ROUND(SUM(profit)) AS Total_Profit
FROM sales
GROUP BY city
ORDER BY Total_Profit DESC
LIMIT 5;


-- 2) What is the average profit margin for each discount level (0%, 5%, 10%, 15%, 20%)?

SELECT discount, ROUND(AVG(CAST(profit AS FLOAT) / CAST(sales AS FLOAT)) * 100, 2) AS Avg_Profit_Margin_Percent
FROM sales
GROUP BY discount
ORDER BY discount ASC;

-- 3) Which product category has the highest total sales but the lowest profit margin?

SELECT category, ROUND(SUM(sales)) AS Total_Sales, ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS Profit_Margin_Percent
FROM sales
GROUP BY category
ORDER BY Total_Sales DESC;

-- 4) What are the top 3 sub-categories by "Quantity Sold" in each region?

WITH RegionalRankings AS (
    SELECT region, 
           sub_category, 
           SUM(quantity) AS Total_Quantity,
           RANK() OVER (PARTITION BY region ORDER BY SUM(quantity) DESC) as Category_Rank
    FROM sales
    GROUP BY region, sub_Category
)
SELECT region, sub_category, Total_Quantity
FROM RegionalRankings
WHERE Category_Rank <= 3;

-- 5) Which payment mode has the highest Average Order Value (AOV)?

SELECT payment_mode, 
       ROUND(AVG(sales), 2) AS Average_Order_Value
FROM sales
GROUP BY payment_mode
ORDER BY Average_Order_Value DESC;


