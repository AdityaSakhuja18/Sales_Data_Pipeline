USE sales_pipeline;

-- Q1. Which country generates the highest revenue?

SELECT
    country,
    SUM(revenue) AS Total_Revenue
FROM online_retail_transformed
GROUP BY country
ORDER BY Total_Revenue DESC;

-- Q2. Which customers contribute the most to the company's total revenue?

 SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue
FROM online_retail_transformed
GROUP BY CustomerID
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Q3. How does the company's revenue change month over month?

SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
    SUM(Revenue) AS Total_Revenue
FROM online_retail_transformed
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY YearMonth;

-- Q4. Which products generate the highest revenue?

SELECT
    StockCode,
    Description,
    SUM(Quantity) AS Total_Quantity_Sold,
    SUM(Revenue) AS Total_Revenue
FROM online_retail_transformed
GROUP BY StockCode, Description
ORDER BY Total_Revenue DESC
LIMIT 10;

-- Q5. Which year generated the highest revenue?

SELECT
    YEAR(InvoiceDate) AS Year,
    SUM(Revenue) AS Total_Revenue
FROM online_retail_transformed
GROUP BY YEAR(InvoiceDate)
ORDER BY Total_Revenue DESC
LIMIT 1;

-- Q6. What is the average value of each customer order?

SELECT
    CustomerID,
    AVG(Order_Value) AS Avg_Order_Value
FROM (
    SELECT
        CustomerID,
        InvoiceNo,
        SUM(Revenue) AS Order_Value
    FROM online_retail_transformed
    GROUP BY CustomerID, InvoiceNo
) AS Customer_Orders
GROUP BY CustomerID;

-- Q7. Which customers place orders most frequently?

SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders
FROM online_retail_transformed
GROUP BY CustomerID
ORDER BY Total_Orders DESC
LIMIT 10;

-- Q8. What percentage of total orders are cancelled?

SELECT
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,

    COUNT(DISTINCT CASE
        WHEN InvoiceNo LIKE 'C%' THEN InvoiceNo
    END) AS Cancelled_Orders,

    ROUND(
        COUNT(DISTINCT CASE
            WHEN InvoiceNo LIKE 'C%' THEN InvoiceNo
        END) * 100.0 /
        COUNT(DISTINCT InvoiceNo), 2
    ) AS Cancellation_Percentage

FROM online_retail_transformed;

-- Q9. Which countries have the highest number of unique customers?

SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS Unique_Customers,
    SUM(Revenue) AS Total_Revenue
FROM online_retail_transformed
GROUP BY Country
ORDER BY Unique_Customers DESC
LIMIT 10;

-- Q10. Find customers with above-average revenue

WITH Customer_Sales AS (
    SELECT CustomerID, SUM(Revenue) AS Total_Revenue
    FROM online_retail_transformed
    GROUP BY CustomerID
)
SELECT *
FROM Customer_Sales
WHERE Total_Revenue > (
    SELECT AVG(Total_Revenue)
    FROM Customer_Sales
);

-- Q11. Which products have the highest cancelled quantities?

SELECT
    StockCode,
    Description,
    SUM(ABS(Quantity)) AS Cancelled_Quantity
FROM online_retail_transformed
WHERE InvoiceNo LIKE 'C%'
GROUP BY StockCode, Description
ORDER BY Cancelled_Quantity DESC
LIMIT 10;

-- Q12. Which months have the highest number of orders?

SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS YearMonth,
    COUNT(DISTINCT InvoiceNo) AS Total_Orders,
    SUM(Revenue) AS Total_Revenue
FROM online_retail_transformed
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY Total_Orders DESC;

-- Q13. Which customers contribute to the top 20% of total revenue?

WITH Customer_Revenue AS (
    SELECT
        CustomerID,
        SUM(Revenue) AS Total_Revenue
    FROM online_retail_transformed
    GROUP BY CustomerID
),
Revenue_Ranking AS (
    SELECT
        CustomerID,
        Total_Revenue,
        SUM(Total_Revenue) OVER (
            ORDER BY Total_Revenue DESC
        ) AS Cumulative_Revenue,
        SUM(Total_Revenue) OVER () AS Overall_Revenue
    FROM Customer_Revenue
)
SELECT
    CustomerID,
    Total_Revenue,
    ROUND(
        Total_Revenue * 100.0 / Overall_Revenue, 2
    ) AS Revenue_Contribution_Percentage
FROM Revenue_Ranking
WHERE Cumulative_Revenue <= Overall_Revenue * 0.20
ORDER BY Total_Revenue DESC;


