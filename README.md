# Minecrafts-Technology-Internship-task-3
Data analysis and businesses intelligence of s superstore sales Data
Data Analytics & Business Intelligence — Task 3
Advanced SQL Analysis, KPI Modeling & Variance Dashboard
Maincrafts Technology — Data Analytics & BI Internship Program
Overview
This repository contains the completed deliverables for Task 3 of the Maincrafts
Technology BI internship track. Building on the JOIN/KPI fundamentals from Task 2,
this project moves into performance analysis and decision-support analytics:
Advanced SQL (CASE, subqueries, HAVING)
Month-over-month variance and growth-rate analysis
Calculated KPIs (profit margin, growth %, revenue contribution)
An executive-level, formula-driven dashboard
A strategic business recommendation report
Note on data: No production dataset was supplied with the task brief, so a
synthetic but realistic dataset (1,745 orders · 120 customers · 24 months,
Jan 2024–Dec 2025) was generated to complete every part end-to-end. Swap in a
real Orders/Customers export and every formula, query, and chart recalculates
automatically — no logic changes needed.
Repository Structure
Code
Dataset Schema
Orders
Column
Type
Description
Order_ID
text
Unique order identifier
Order_Date
date
Date the order was placed
Customer_ID
text
FK → Customers
Category
text
Technology / Furniture / Office Supplies
Sales
decimal
Order revenue ($)
Profit
decimal
Order profit ($)
Discount
decimal
Discount applied (0–1)
Customers
Column
Type
Description
Customer_ID
text
Primary key
Customer_Name
text
Customer name
Region
text
East / West / North / South
Segment
text
Consumer / Corporate / Home Office
Part A — Advanced SQL (Task3_Advanced_SQL_Analysis.sql)
Step
Query
Concept
1
Monthly Performance Analysis
GROUP BY YEAR, MONTH
2
Growth Rate Calculation
Correlated subquery / self-join (year-boundary safe)
3
Business Classification
CASE WHEN (High / Medium / Low value orders)
4
Underperforming Regions
JOIN + GROUP BY + HAVING
Bonus
Region margin, category growth, segment contribution, discount-band impact
Supporting queries for Parts B–D
Compatible with MySQL / SQL Server syntax; date functions are noted inline for
portability to PostgreSQL/SQLite.
Parts B & C — Excel Performance Analysis + Executive Dashboard (Task3_BI_Workbook.xlsx)
Sheet
Contents
Dashboard
KPI cards (Total Sales, Total Profit, Profit Margin, YoY Growth %, Total Customers), 4 live charts (Monthly Sales Trend, Region vs Sales, Category Profit, Segment Contribution), Top-5-Customers table
Monthly_Variance
Current vs previous month Sales/Profit, variance, growth % — built with SUMIFS, INDEX/MATCH, IF
Performance_Comparison
Region vs Profit Margin, Category vs YoY Growth %, Segment vs Revenue Contribution
Orders / Customers
Raw data plus lookup helper columns (YEAR, MONTH, INDEX/MATCH region & segment lookups, sales rank)
All figures are live formulas, not hardcoded values — the workbook recalculates
fully if the source data changes. Verified error-free (0 formula errors across
~7,450 formulas).
Built as a native Excel dashboard since this environment can't author a
.pbix/.twbx file directly. The KPI cards, DAX-equivalent measures
(Profit Margin = Profit / Sales, Growth % = (Current - Prior) / Prior), and
visual layout map 1:1 onto Power BI or Tableau if you want to rebuild it there.
Part D — Business Analysis Report (Task3_Business_Analysis_Report.docx)
A 2-page executive report answering management's six standing questions:
Is the company growing month-over-month?
Which region is underperforming?
Which category has the highest growth?
Are discounts reducing profit?
Which customer segment contributes the most revenue?
What strategic actions should management take?
Headline findings
Metric
Value
Total Sales (FY24–25)
$676,087
Total Profit
$66,038
Overall Margin
9.8%
YoY Growth
+74.9%
Underperforming Region
South (6.3% margin vs ~10.5% elsewhere)
Highest-Growth Category
Technology (+90.5% YoY)
Top Revenue Segment
Consumer (48.8%)
How to Reproduce / Extend
Replace Orders.csv / Customers.csv with real exports (same column names).
Run the queries in Task3_Advanced_SQL_Analysis.sql against your database.
Open Task3_BI_Workbook.xlsx, update the Orders/Customers sheets, and
recalculate (Excel: Ctrl+Alt+F9) — all downstream sheets and charts refresh.
Update the Business Analysis Report narrative with any new findings.
Key Learning Outcomes
Writing and reasoning about CASE, subqueries, and HAVING
Building variance/growth analysis with SUMIFS, INDEX/MATCH, and IF
Designing an executive-level KPI dashboard
Translating BI output into a strategic business recommendation
Maincrafts Technology · www.maincrafts.com · hr@maincrafts.com
