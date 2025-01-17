
SELECT * FROM fact_events;
SELECT * FROM dim_stores;
SELECT * FROM dim_products;
SELECT * FROM dim_campaigns;

-- Store Performance Analysis:
-- 1. Which are the top 10 stores in terms of Incremental Revenue (IR) generated from the promotions?

WITH cte AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
)
SELECT TOP 10 store_id AS top_10_stores,
CONCAT(FORMAT(((((SUM(quantity_sold_after_promo * promo_price) * 1.0) - (SUM(quantity_sold_before_promo * base_price) * 1.0)) / 1000000)), '0.00'), ' Million') AS Incremental_Revenue
FROM cte
GROUP BY store_id
ORDER BY Incremental_Revenue DESC;

-- 2. Which are the bottom 10 stores when it comes to Incremental Sold Units (ISU) during the promotional period?

SELECT TOP 10 store_id AS bottom_10_stores,
SUM(quantity_sold_after_promo) - SUM(quantity_sold_before_promo)  AS Incremental_Sold_Units
FROM fact_events
GROUP BY store_id
ORDER BY Incremental_Sold_Units; 

-- 3. How does the performance of stores vary by city? Are there any common characteristics among 
--    the top-performing stores that could be leveraged across other stores?

WITH cte AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
)
SELECT s.city, e.store_id, 
SUM(e.quantity_sold_after_promo) - SUM(e.quantity_sold_before_promo)  AS Incremental_Sold_Units,
CONCAT(FORMAT(((((SUM(e.quantity_sold_after_promo * e.promo_price) * 1.0) - (SUM(e.quantity_sold_before_promo * e.base_price) * 1.0)) / 1000000)), '0.00'), ' Million') AS Incremental_Revenue
FROM cte e
JOIN dim_stores s ON e.store_id = s.store_id
GROUP BY s.city, e.store_id
ORDER BY Incremental_Revenue DESC;

-- Promotion Type Analysis:
-- 4. What are the top 2 promotion types that resulted in the highest Incremental Revenue?

WITH cte1 AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
),
cte2 AS (
SELECT TOP 2 promo_type, 
SUM(quantity_sold_after_promo * promo_price) - SUM(quantity_sold_before_promo * base_price) AS Incremental_Revenue
FROM cte1
GROUP BY promo_type
ORDER BY Incremental_Revenue DESC
)
SELECT promo_type, CONCAT(FORMAT(Incremental_Revenue * 1.0 / 1000000, '0.00'), ' Million') AS Incremental_Revenue
FROM cte2;

-- 5. What are the bottom 2 promotion types in terms of their impact on Incremental Sold Units?

SELECT TOP 2 promo_type AS bottom_2_promo_types,
SUM(quantity_sold_after_promo) - SUM(quantity_sold_before_promo)  AS Incremental_Sold_Units
FROM fact_events
GROUP BY promo_type
ORDER BY Incremental_Sold_Units;

-- 6. Is there a significant difference in the performance of discount-based promotions versus BOGOF (Buy One Get One Free) or cashback promotions?

WITH cte1 AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
),
cte2 AS (
SELECT promo_type, 
SUM(quantity_sold_after_promo) - SUM(quantity_sold_before_promo)  AS Incremental_Sold_Units,
SUM(quantity_sold_after_promo * promo_price) - SUM(quantity_sold_before_promo * base_price) AS Incremental_Revenue
FROM cte1
GROUP BY promo_type
)
SELECT promo_type, 
CONCAT(FORMAT(Incremental_Sold_Units * 1.0 / 1000, '0.00'), ' K') AS Incremental_Sold_Units, 
CONCAT(FORMAT(Incremental_Revenue * 1.0 / 1000000, '00.00'), ' Million') AS Incremental_Revenue
FROM cte2
ORDER BY Incremental_Revenue DESC;

-- 7. Which promotions strike the best balance between Incremental Sold Units and maintaining healthy margins?

WITH cte1 AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
),
cte2 AS (
SELECT promo_type,
SUM(quantity_sold_after_promo) - SUM(quantity_sold_before_promo)  AS Incremental_Sold_Units,
100.0 * (SUM(quantity_sold_after_promo * promo_price) - SUM(quantity_sold_before_promo * base_price)) / 
SUM(quantity_sold_after_promo * promo_price) AS Margin
FROM cte1
GROUP BY promo_type
)
SELECT promo_type, Incremental_Sold_Units, CONCAT(FORMAT(Margin, '00.0'), ' %') AS Margin 
FROM cte2
ORDER BY Incremental_Sold_Units DESC;

-- Product and Category Analysis:
-- 8. Which product categories saw the most significant lift in sales from the promotions?

WITH cte1 AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
),
cte2 AS (
SELECT p.category, 
SUM(e.quantity_sold_before_promo * e.base_price) AS sales_before_promo, 
SUM(e.quantity_sold_after_promo * e.promo_price) AS sales_after_promo,
SUM(e.quantity_sold_after_promo * e.promo_price)  - SUM(e.quantity_sold_before_promo * e.base_price) AS Incremental_Revenue
FROM cte1 e
JOIN dim_products p ON e.product_code = p.product_code
GROUP BY p.category
)
SELECT category, 
CONCAT(FORMAT(sales_before_promo * 1.0 / 1000000, '00.00'), ' Million') AS sales_before_promo,
CONCAT(FORMAT(sales_after_promo * 1.0 / 1000000, '00.00'), ' Million') AS sales_after_promo,
CONCAT(FORMAT(Incremental_Revenue * 1.0 / 1000000, '00.00'), ' Million') AS Incremental_Revenue
FROM cte2;

-- 9. Are there specific products that respond exceptionally well or poorly to promotions?

WITH cte1 AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
),
cte2 AS (
SELECT p.product_name, 
SUM(e.quantity_sold_after_promo) - SUM(e.quantity_sold_before_promo)  AS Incremental_Sold_Units,
SUM(e.quantity_sold_after_promo * e.promo_price)  - SUM(e.quantity_sold_before_promo * e.base_price) AS Incremental_Revenue
FROM cte1 e
JOIN dim_products p ON e.product_code = p.product_code
GROUP BY p.product_name
)
SELECT product_name, 
CONCAT(FORMAT(Incremental_Sold_Units * 1.0 / 1000, '0.00'), ' K') AS Incremental_Sold_Units, 
CONCAT(FORMAT(Incremental_Revenue * 1.0 / 1000000, '00.00'), ' Million') AS Incremental_Revenue
FROM cte2
ORDER BY Incremental_Sold_Units DESC;

-- 10. Provide a list of products with a base price greater than 500 and that are featured in promo type of 'BOGOF' (Buy One Get One Free). 
--     This information will help us identify high-value products that are currently being heavily discounted, which can be useful for evaluating our
--     pricing and promotion strategies.

SELECT DISTINCT product_code, base_price
FROM fact_events
WHERE base_price > 500 AND promo_type = 'BOGOF'
ORDER BY base_price DESC;


-- 11. Generate a report that provides an overview of the number of stores in each city. 
--     The results will be sorted in descending order of store counts, allowing us to identify the cities with the highest store presence.
--     The report includes two essential fields: city and store count, which will assist in optimizing our retail operations.

SELECT city, COUNT(store_id) AS store_count
FROM dim_stores
GROUP BY city
ORDER BY store_count DESC;

-- 12. Generate a report that displays each campaign along with the total revenue generated before and after the campaign? 
--     The report includes three key fields: campaign_name, totaI_revenue(before_promotion), totaI_revenue(after_promotion).
--     This report should help in evaluating the financial impact of our promotional campaigns. (Display the values in millions)

WITH cte AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
)
SELECT c.campaign_name, 
CONCAT(FORMAT(1.0 * SUM(cte.quantity_sold_before_promo * cte.base_price) / 1000000, '0.00'), ' Million') AS totaI_revenue_before_promotion, 
CONCAT(FORMAT(1.0 * SUM(cte.quantity_sold_after_promo * cte.promo_price) / 1000000, '0.00'), ' Million') AS totaI_revenue_after_promotion
FROM cte 
JOIN dim_campaigns c ON cte.campaign_id = c.campaign_id
GROUP BY c.campaign_name;

-- 13. Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. 
--     Additionally, provide rankings for the categories based on their ISU%. The report will include three key fields: category, isu%, and rank order.
--     This information will assist in assessing the category-wise success and impact of the Diwali campaign on incremental sales.

-- Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the percentage increase/decrease in quantity sold (after promo) 
--       compared to quantity sold (before promo)

WITH cte AS (
SELECT p.category, 
100.0 * SUM(e.quantity_sold_after_promo - e.quantity_sold_before_promo) / SUM(e.quantity_sold_before_promo) AS ISU_percent,
RANK() OVER(ORDER BY 100.0 * SUM(e.quantity_sold_after_promo - e.quantity_sold_before_promo) / SUM(e.quantity_sold_before_promo) DESC) AS rank
FROM fact_events e
JOIN dim_campaigns c ON e.campaign_id = c.campaign_id
JOIN dim_products p ON e.product_code = p.product_code
WHERE c.campaign_name = 'Diwali'
GROUP BY p.category
)
SELECT category, CONCAT(FORMAT(ISU_percent, '00.00'), ' %') AS ISU_percent, rank
FROM cte;

-- 14. Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns.
--     The report will provide essential information including product name, category, and ir%. 
--     This analysis helps identify the most successful products in terms of incremental revenue across our campaigns, assisting in product optimization.

WITH cte1 AS (
SELECT *, 
CASE 
	WHEN promo_type = '500 Cashback' THEN base_price - 500 
	WHEN promo_type = '25% OFF' THEN base_price - (base_price * 0.25) 
	WHEN promo_type = '33% OFF' THEN base_price - (base_price * 0.33) 
	ELSE base_price * 0.5
END AS promo_price
FROM fact_events
),
cte2 AS (
SELECT p.product_name, p.category,
100.0 * SUM(e.quantity_sold_after_promo * e.promo_price) / SUM(e.quantity_sold_before_promo * e.base_price) AS IR_percent,
RANK() OVER(ORDER BY 100.0 * SUM(e.quantity_sold_after_promo * e.promo_price) / SUM(e.quantity_sold_before_promo * e.base_price) DESC) as rank
FROM cte1 e
JOIN dim_products p ON e.product_code = p.product_code
GROUP BY p.product_name, p.category
)
SELECT product_name, category, CONCAT(FORMAT(IR_percent, '00.00'), ' %') AS IR_percent
FROM cte2
WHERE rank <= 5;


