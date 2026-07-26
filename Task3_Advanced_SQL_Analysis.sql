/* =====================================================================
   MAINCRAFTS TECHNOLOGY — Data Analytics & BI Internship
   Task 3: Advanced SQL Analysis, KPI Modeling & Variance Dashboard
   Part A — Advanced SQL Analysis
   Dialect: Standard SQL / MySQL syntax (adjust date functions for
   SQL Server or PostgreSQL as noted in comments)
   ===================================================================== */

/* ---------------------------------------------------------------------
   0. TABLE STRUCTURE (reference — matches Orders.csv / Customers.csv)
   --------------------------------------------------------------------- */
CREATE TABLE IF NOT EXISTS Customers (
    Customer_ID    VARCHAR(10) PRIMARY KEY,
    Customer_Name  VARCHAR(100),
    Region         VARCHAR(20),
    Segment        VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Orders (
    Order_ID     VARCHAR(10) PRIMARY KEY,
    Order_Date   DATE,
    Customer_ID  VARCHAR(10),
    Category     VARCHAR(30),
    Sales        DECIMAL(10,2),
    Profit       DECIMAL(10,2),
    Discount     DECIMAL(4,2),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

/* ---------------------------------------------------------------------
   STEP 1: Monthly Performance Analysis
   Aggregates Sales and Profit by calendar month across both years.
   --------------------------------------------------------------------- */
SELECT
    YEAR(Order_Date)  AS Year,
    MONTH(Order_Date) AS Month,
    SUM(Sales)  AS Monthly_Sales,
    SUM(Profit) AS Monthly_Profit
FROM Orders
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month;


/* ---------------------------------------------------------------------
   STEP 2: Growth Rate Calculation (Month-over-Month, using a Subquery)
   Joins each month to the PRIOR month (chronologically, across years)
   and calculates % growth in Sales.
   NOTE: the task template joins on Month only (t1.Month = t2.Month + 1),
   which breaks across a Dec->Jan year boundary and would silently drop
   or mis-pair January. The version below keys on Year+Month so every
   month (including January of a new year) is compared correctly.
   --------------------------------------------------------------------- */
SELECT
    t1.Year,
    t1.Month,
    t1.Monthly_Sales,
    t2.Monthly_Sales AS Prev_Month_Sales,
    ROUND((t1.Monthly_Sales - t2.Monthly_Sales) / t2.Monthly_Sales * 100, 1) AS Growth_Percentage
FROM
    (SELECT YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, SUM(Sales) AS Monthly_Sales
     FROM Orders
     GROUP BY YEAR(Order_Date), MONTH(Order_Date)) t1
JOIN
    (SELECT YEAR(Order_Date) AS Year, MONTH(Order_Date) AS Month, SUM(Sales) AS Monthly_Sales
     FROM Orders
     GROUP BY YEAR(Order_Date), MONTH(Order_Date)) t2
ON  (t1.Year = t2.Year AND t1.Month = t2.Month + 1)          -- same-year, prior month
 OR (t1.Year = t2.Year + 1 AND t1.Month = 1 AND t2.Month = 12) -- Jan following Dec
ORDER BY t1.Year, t1.Month;


/* ---------------------------------------------------------------------
   STEP 3: Using CASE for Business Classification
   Classifies each order by Sales value into High/Medium/Low tiers.
   --------------------------------------------------------------------- */
SELECT
    Order_ID,
    Sales,
    CASE
        WHEN Sales > 1000 THEN 'High Value'
        WHEN Sales BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Order_Type
FROM Orders;


/* ---------------------------------------------------------------------
   STEP 4: Identify Underperforming Regions
   Uses JOIN + GROUP BY + HAVING to flag regions with total profit
   below the $10,000 management threshold.
   --------------------------------------------------------------------- */
SELECT
    c.Region,
    SUM(o.Profit) AS Total_Profit
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
HAVING SUM(o.Profit) < 10000;


/* ---------------------------------------------------------------------
   BONUS: Supporting queries used for Part B/C/D comparison tables
   --------------------------------------------------------------------- */

-- Region vs Profit Margin
SELECT
    c.Region,
    SUM(o.Sales)  AS Total_Sales,
    SUM(o.Profit) AS Total_Profit,
    ROUND(SUM(o.Profit) / SUM(o.Sales) * 100, 1) AS Profit_Margin_Pct
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Region
ORDER BY Profit_Margin_Pct DESC;

-- Category vs Year-over-Year Growth %
SELECT
    Category,
    SUM(CASE WHEN YEAR(Order_Date) = 2024 THEN Sales ELSE 0 END) AS Sales_2024,
    SUM(CASE WHEN YEAR(Order_Date) = 2025 THEN Sales ELSE 0 END) AS Sales_2025,
    ROUND(
      (SUM(CASE WHEN YEAR(Order_Date) = 2025 THEN Sales ELSE 0 END)
     - SUM(CASE WHEN YEAR(Order_Date) = 2024 THEN Sales ELSE 0 END))
     / SUM(CASE WHEN YEAR(Order_Date) = 2024 THEN Sales ELSE 0 END) * 100, 1) AS Growth_Pct
FROM Orders
GROUP BY Category
ORDER BY Growth_Pct DESC;

-- Segment vs Revenue Contribution %
SELECT
    c.Segment,
    SUM(o.Sales) AS Segment_Sales,
    ROUND(SUM(o.Sales) / (SELECT SUM(Sales) FROM Orders) * 100, 1) AS Revenue_Contribution_Pct
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Segment
ORDER BY Revenue_Contribution_Pct DESC;

-- Discount impact on Profit (does higher discount reduce profit?)
SELECT
    CASE
        WHEN Discount = 0 THEN '0% (No Discount)'
        WHEN Discount > 0 AND Discount <= 0.10 THEN '1-10%'
        WHEN Discount > 0.10 AND Discount <= 0.20 THEN '11-20%'
        ELSE '21%+'
    END AS Discount_Band,
    COUNT(*) AS Num_Orders,
    SUM(Sales)  AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 1) AS Profit_Margin_Pct
FROM Orders
GROUP BY Discount_Band
ORDER BY Discount_Band;
