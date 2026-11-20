USE sales_pipeline;

-- Create transformed table and calculate revenue

CREATE TABLE online_retail_transformed AS
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    Quantity * UnitPrice AS Revenue
FROM online_retail_raw;

-- Check revenue calculation

SELECT
    InvoiceNo,
    Quantity,
    UnitPrice,
    Revenue
FROM online_retail_transformed
LIMIT 10;

-- Extract date details

SELECT
    InvoiceDate,
    YEAR(InvoiceDate) AS Year,
    MONTH(InvoiceDate) AS Month,
    DAY(InvoiceDate) AS Day
FROM online_retail_transformed
LIMIT 10; 

-- Check order status

SELECT
    InvoiceNo,
    CASE
        WHEN InvoiceNo LIKE 'C%' THEN 'Cancelled'
        ELSE 'Completed'
    END AS OrderStatus
FROM online_retail_transformed
LIMIT 10;

-- Count cancelled and completed orders

SELECT
    CASE
        WHEN InvoiceNo LIKE 'C%' THEN 'Cancelled'
        ELSE 'Completed'
    END AS OrderStatus,
    COUNT(*) AS TotalOrders
FROM online_retail_transformed
GROUP BY OrderStatus;

-- Check negative quantity and price

SELECT *
FROM online_retail_transformed
WHERE Quantity < 0 OR UnitPrice <= 0
LIMIT 10;