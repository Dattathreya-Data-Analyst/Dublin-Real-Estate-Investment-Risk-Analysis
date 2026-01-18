USE project;

-- Step 1: Check if the Quarter formats actually match
-- Run these two queries separately to see the format

SELECT DISTINCT Quarter FROM dublin_unemployment_clean LIMIT 5;
-- Compare that output to the one below:
SELECT COUNT(*) FROM dublin_property_prices_2026;
SELECT * FROM dublin_property_prices_2026 LIMIT 5;
DESCRIBE dublin_property_prices_2026;

# Your STR_TO_DATE and table setup

SELECT DISTINCT 
    CASE  
        WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 1 AND 3 THEN CONCAT('Q1 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
        WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 4 AND 6 THEN CONCAT('Q2 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
        WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 7 AND 9 THEN CONCAT('Q3 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
        ELSE CONCAT('Q4 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
    END AS Generated_Quarter
FROM dublin_property_prices_2026 
WHERE Transaction_Date IS NOT NULL
LIMIT 5;

SELECT Transaction_Date, STR_TO_DATE(Transaction_Date, '%d-%m-%Y') as ConvertedDate 
FROM dublin_property_prices_2026 
LIMIT 5;


-- Step 2: Create a Summary of Prices per District per Quarter

SELECT 
    District,
    -- This is the same logic you just fixed to generate the Quarter
    CASE  
        WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 1 AND 3 THEN CONCAT('Q1 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
        WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 4 AND 6 THEN CONCAT('Q2 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
        WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 7 AND 9 THEN CONCAT('Q3 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
        ELSE CONCAT('Q4 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
    END AS Quarter,
    ROUND(AVG(Sale_Price), 2) AS Avg_Quarterly_Price,
    COUNT(*) AS Number_of_Sales
FROM dublin_property_prices_2026 
GROUP BY District, Quarter
ORDER BY Quarter DESC, Avg_Quarterly_Price DESC;


-- 1. Delete the broken view first
DROP VIEW IF EXISTS view_investment_risk_analysis;

-- 2. Create it again with the EXACT column names from your tables
CREATE VIEW view_investment_risk_analysis AS 
WITH QuarterlyProperty AS ( 
    SELECT  
        District, 
        CASE  
            WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 1 AND 3 THEN CONCAT('Q1 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
            WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 4 AND 6 THEN CONCAT('Q2 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
            WHEN MONTH(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')) BETWEEN 7 AND 9 THEN CONCAT('Q3 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
            ELSE CONCAT('Q4 ', RIGHT(YEAR(STR_TO_DATE(Transaction_Date, '%d-%m-%Y')), 2)) 
        END AS Quarter, 
        AVG(Sale_Price) AS Avg_Price
    FROM dublin_property_prices_2026 -- Double check this table name in your sidebar
    GROUP BY District, Quarter 
) 
SELECT  
    p.District, 
    p.Quarter, 
    ROUND(p.Avg_Price, 2) AS Avg_Price, 
    u.`Dublin Unemployment Rate SA (%)` AS Job_Risk_Factor, 
    -- Risk Score Calculation
    ROUND((p.Avg_Price / 100000) + (u.`Dublin Unemployment Rate SA (%)` * 5), 2) AS Investment_Risk_Score 
FROM QuarterlyProperty p 
INNER JOIN dublin_unemployment_clean u ON p.Quarter = u.Quarter 
ORDER BY Investment_Risk_Score ASC;

-- 3. Now try to view it
SELECT * FROM view_investment_risk_analysis;
