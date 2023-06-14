CREATE TABLE international_debt (
	country_name VARCHAR NOT NULL, 
	country_code VARCHAR NOT NULL, 
	indicator_name VARCHAR NOT NULL, 
	indicator_code VARCHAR NOT NULL, 
	debt DECIMAL NOT NULL
);

--- 1. Review data after import

SELECT * FROM international_debt LIMIT 10;

--- 2. Finding the number of distinct countries

SELECT COUNT(DISTINCT country_name) AS total_distinct_countries
FROM international_debt;

--- 3. Finding the distinct debt indicators

SELECT DISTINCT indicator_code AS distinct_debt_indicators
FROM international_debt
ORDER BY distinct_debt_indicators;

--- 4. Total the amount of debt owed by the countries, presented unit in million and rounded to 2 decimals

SELECT 
	ROUND (SUM(debt)/100000,2) AS total_debt
FROM international_debt;

--- 5. Country with highest debt

SELECT SUM(debt) AS total_debt, country_name
FROM international_debt
GROUP BY country_name 
ORDER BY total_debt DESC;

--- 6. Hightest debt country that excluding 'Least developed countries: UN classification','South Asia', 'IDA only'

SELECT SUM(debt) AS total_debt, country_name
FROM international_debt
WHERE country_name <> 'Least developed countries: UN classification'
AND country_name <> 'South Asia' 
AND country_name <> 'IDA only'
GROUP BY country_name 
ORDER BY total_debt DESC;

--- 7. Analyze country with highest debt- China

SELECT 
	indicator_name, 
	indicator_code, 
	debt, 
	(debt/ sum(debt) OVER ()) AS proportion
FROM international_debt
WHERE country_name = 'China'
ORDER BY proportion DESC

-- 8. Analyze China's debt: calculate the debt amount for the specific indicator 

SELECT 
    indicator_name,
    indicator_code,
    debt,
    (debt / SUM(debt) OVER ()) AS proportion_of_debt
FROM international_debt
WHERE country_name = 'China' AND indicator_code = 'DT.AMT.DLXF.CD';


--- 9. Analyze debt indicator: find the most common debt indicator (display country_name)by calculate the count of each indicator code among countries

SELECT
    indicator_code,
    COUNT(*) AS indicator_count,
    MAX(country_name) AS country_name
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count DESC;

--- 10. Analyze debt indicator: average amount of debt across indicators

SELECT AVG(debt) AS mean_debt,indicator_name, indicator_code AS debt_indicator
FROM international_debt
GROUP BY 2,3
ORDER BY 1 DESC

--- 11. Analyze debt indicator: the highest amount of principal repayments "DT.AMT.DLXF.CD"
	
SELECT 
    DISTINCT country_name,
    MAX(debt) AS highest_principal_repayment
FROM international_debt
WHERE indicator_code = 'DT.AMT.DLXF.CD'
GROUP BY country_name
ORDER BY highest_principal_repayment DESC;

--- 12. Analyze debt indicator: calculate the average debt amount, the proportion of debt, and the count of each indicator code

SELECT 
    indicator_name,
    indicator_code,
    AVG(debt) AS average_debt,
    (SUM(debt) / (SELECT SUM(debt) FROM international_debt)) AS proportion_of_debt,
    COUNT(indicator_code) AS indicator_count
FROM international_debt
GROUP BY indicator_name, indicator_code
ORDER BY indicator_count DESC, average_debt DESC;


--- 13. Analyze debt indicator: Calculate the average debt amount and the proportion of debt for a specific indicator 'DT.AMT.DLXF.CD'

SELECT 
    indicator_name,
    indicator_code,
    AVG(debt) AS average_debt,
    (SUM(debt) / (SELECT SUM(debt) FROM international_debt)) AS proportion_of_debt
FROM international_debt
WHERE indicator_code = 'DT.AMT.DLXF.CD'
GROUP BY indicator_name, indicator_code;

--- 14. Analyze debt indicator: calculate the count of each indicator code among countries

SELECT
    indicator_code,
    COUNT(DISTINCT country_name) AS indicator_count
FROM international_debt
GROUP BY indicator_code
ORDER BY indicator_count DESC, indicator_code DESC;

--- 15. Aggregate Analysis to determine the countries owe the most across cateogries

SELECT
	country_name,
	indicator_code,
	MAX(debt) AS max_debt
FROM international_debt
GROUP BY country_name, indicator_code
ORDER BY max_debt DESC; 

--- 16. Retrieve countries with the highest debt across multiple categories

SELECT 
    country_name, 
    MAX(debt) AS maximum_debt
FROM international_debt
GROUP BY country_name
ORDER BY maximum_debt DESC
LIMIT 10;
