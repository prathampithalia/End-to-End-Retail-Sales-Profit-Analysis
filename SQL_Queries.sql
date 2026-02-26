

/* 
============================================================
   SECTION 1: Revenue Drivers (Products)
============================================================ 
*/

-- 1) Top 10 highest revenue generating products
SELECT 
    product_id,
    SUM(sales) AS total_sales
FROM df_orders
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 10;


-- 2) Pareto Analysis: Product contribution % + cumulative %
WITH product_sales AS (
    SELECT 
        product_id,
        SUM(sales) AS sales
    FROM df_orders
    GROUP BY product_id
),
ranked AS (
    SELECT 
        product_id,
        sales,
        SUM(sales) OVER () AS total_sales,
        SUM(sales) OVER (ORDER BY sales DESC) AS running_sales
    FROM product_sales
)
SELECT
    product_id,
    sales,
    ROUND((sales / total_sales) * 100, 2) AS product_percent,
    ROUND((running_sales / total_sales) * 100, 2) AS cumulative_percent
FROM ranked
ORDER BY sales DESC;


/* 
============================================================
   SECTION 2: Regional Analysis
============================================================ 
*/

-- 3) Top 5 highest selling products in each region
WITH region_product_sales AS (
    SELECT 
        region,
        product_id,
        SUM(sales) AS total_sales
    FROM df_orders
    GROUP BY region, product_id
)
SELECT *
FROM (
    SELECT
        region,
        product_id,
        total_sales,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_sales DESC) AS rn
    FROM region_product_sales
) x
WHERE rn <= 5
ORDER BY region, rn;


-- 4) Year-over-Year (YoY) Growth % by Region (2023 vs 2022)
WITH yearly_region_sales AS (
    SELECT 
        region,
        YEAR(order_date) AS order_year,
        SUM(sales) AS total_sales
    FROM df_orders
    WHERE YEAR(order_date) IN (2022, 2023)
    GROUP BY region, YEAR(order_date)
),
pivoted AS (
    SELECT
        region,
        SUM(CASE WHEN order_year = 2022 THEN total_sales ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN order_year = 2023 THEN total_sales ELSE 0 END) AS sales_2023
    FROM yearly_region_sales
    GROUP BY region
)
SELECT
    region,
    sales_2022,
    sales_2023,
    (sales_2023 - sales_2022) AS growth,
    ROUND(((sales_2023 - sales_2022) / NULLIF(sales_2022, 0)) * 100, 2) AS growth_percent
FROM pivoted
ORDER BY growth_percent DESC;


/* 
============================================================
   SECTION 3: Time Series (Monthly Trends)
============================================================ 
*/

-- 5) Monthly sales trend (YYYY-MM)
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS ym,
    SUM(sales) AS total_sales
FROM df_orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY ym;


-- 6) Month-over-Month (MoM) Growth % (overall)
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS ym,
        SUM(sales) AS sales
    FROM df_orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
final AS (
    SELECT
        ym,
        sales,
        LAG(sales) OVER (ORDER BY ym) AS prev_sales
    FROM monthly_sales
)
SELECT
    ym AS month,
    ROUND(sales, 2) AS current_sales,
    ROUND(prev_sales, 2) AS previous_sales,
    ROUND(((sales - prev_sales) / NULLIF(prev_sales, 0)) * 100, 2) AS mom_growth_percent
FROM final
ORDER BY ym;


-- 7) Monthly YoY comparison: 2022 vs 2023 (Jan vs Jan, Feb vs Feb...)
WITH monthly_year_sales AS (
    SELECT 
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sales) AS sales
    FROM df_orders
    GROUP BY YEAR(order_date), MONTH(order_date)
)
SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM monthly_year_sales
GROUP BY order_month
ORDER BY order_month;


-- 8) Seasonal analysis: Which month number has highest sales?
SELECT 
    MONTH(order_date) AS month_num,
    SUM(sales) AS total_sales
FROM df_orders
GROUP BY MONTH(order_date)
ORDER BY total_sales DESC;


/* 
============================================================
   SECTION 4: Category & Sub-Category Insights
============================================================ 
*/

-- 9) Revenue mix: contribution % of each category
WITH category_sales AS (
    SELECT 
        category,
        SUM(sales) AS sales
    FROM df_orders
    GROUP BY category
),
total AS (
    SELECT SUM(sales) AS total_sales FROM category_sales
)
SELECT 
    c.category,
    c.sales,
    ROUND((c.sales / t.total_sales) * 100, 2) AS contribution_percent
FROM category_sales c
CROSS JOIN total t
ORDER BY contribution_percent DESC;


-- 10) For each category: which month had the highest sales?
WITH cat_month_sales AS (
    SELECT 
        category,
        DATE_FORMAT(order_date, '%Y%m') AS order_ym,
        SUM(sales) AS sales
    FROM df_orders
    GROUP BY category, DATE_FORMAT(order_date, '%Y%m')
)
SELECT *
FROM (
    SELECT 
        category,
        order_ym,
        sales,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
    FROM cat_month_sales
) x
WHERE rn = 1
ORDER BY category;


-- 11) Best sub-category in each category (top performer)
WITH subcat_sales AS (
    SELECT 
        category,
        sub_category,
        SUM(sales) AS sales
    FROM df_orders
    GROUP BY category, sub_category
)
SELECT *
FROM (
    SELECT
        category,
        sub_category,
        sales,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
    FROM subcat_sales
) x
WHERE rn = 1
ORDER BY category;


-- 12) Worst sub-category in each category (lowest performer)
WITH subcat_sales AS (
    SELECT 
        category,
        sub_category,
        SUM(sales) AS sales
    FROM df_orders
    GROUP BY category, sub_category
)
SELECT *
FROM (
    SELECT
        category,
        sub_category,
        sales,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales ASC) AS rn
    FROM subcat_sales
) x
WHERE rn = 1
ORDER BY category;


-- 13) Sub-category with highest profit growth (2023 vs 2022)
WITH subcat_year_profit AS (
    SELECT 
        sub_category,
        YEAR(order_date) AS order_year,
        SUM(profit) AS profit
    FROM df_orders
    WHERE YEAR(order_date) IN (2022, 2023)
    GROUP BY sub_category, YEAR(order_date)
),
pivoted AS (
    SELECT 
        sub_category,
        SUM(CASE WHEN order_year = 2022 THEN profit ELSE 0 END) AS profit_2022,
        SUM(CASE WHEN order_year = 2023 THEN profit ELSE 0 END) AS profit_2023
    FROM subcat_year_profit
    GROUP BY sub_category
)
SELECT 
    sub_category,
    profit_2022,
    profit_2023,
    (profit_2023 - profit_2022) AS profit_growth
FROM pivoted
ORDER BY profit_growth DESC
LIMIT 1;


-- 14) Region + Category heatmap table (for dashboards)
SELECT
    region,
    category,
    SUM(sales) AS total_sales
FROM df_orders
GROUP BY region, category
ORDER BY region, total_sales DESC;


/* 
============================================================
   SECTION 5: Anomaly Detection (Outlier Months)
============================================================ 
*/

-- 15) Identify sales outlier months using mean ± 2*stddev
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS ym,
        SUM(sales) AS sales
    FROM df_orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
stats AS (
    SELECT 
        AVG(sales) AS avg_sales,
        STDDEV_SAMP(sales) AS std_sales
    FROM monthly_sales
)
SELECT 
    m.ym,
    m.sales,
    s.avg_sales,
    s.std_sales
FROM monthly_sales m
CROSS JOIN stats s
WHERE m.sales > s.avg_sales + 2*s.std_sales
   OR m.sales < s.avg_sales - 2*s.std_sales
ORDER BY m.ym;
