<h1 align="center">End-to-End Retail Sales & Profit Analysis: Python + MySQL</h1>

## **<h3>Project Overview</h3>**

This project demonstrates a complete end-to-end data analytics workflow, from programmatic data extraction to actionable business insights using Python and SQL. The goal is to analyze retail order data to identify revenue drivers, regional performance, and profitability trends.

## **<h3>Project Architecture & Workflow</h3>**

**Extract → Transform → Load (ETL) → Analyze → Visualize**

1.  **Data Extraction**: Downloaded the dataset programmatically using the Kaggle API.
2.  **Data Cleaning & Transformation**: Used Python (Pandas) to handle missing values, standardize column names, and fix data types.
3.  **Feature Engineering**: Derived key business metrics:
    *   `discount` logic
    *   `sale_price` (selling price after discount)
    *   `sales` (revenue = sale_price × quantity)
    *   `profit` ((sale_price - cost_price) × quantity)
4.  **Database Integration**: Loaded the processed data into a MySQL database (`df_orders` table).
5.  **Data Analysis**: Executed complex SQL queries (CTEs, Window Functions, Aggregations) to extract insights.
6.  **Visualization**: Created charts in Python to visualize trends.

---

## **<h3>Detailed Data Analysis & Insights</h3>**

The following key insights were derived from the `Order_Data_Analysis` and `SQL_Queries` analysis:

### **1. Monthly Sales Trend (Volatility & Seasonality)**
*   **Observation**: Sales are highly volatile.
    *   **Peak**: Feb 2023 (~730K)
    *   **Low**: Jun 2023 (~330K)
    *   **Impact**: There is a ~2.2x difference between the best and worst months.
*   **Drivers**: The sharp peak in Feb 2023 likely indicates successful discount campaigns, corporate bulk purchasing, or major product launches. The dip in June suggests a supply shortage or lack of promotions.
*   **Recommendation**: Replicate the "peak month strategy" (pricing + product mix) in weaker months to smooth out volatility.

### **2. Month-over-Month (MoM) Growth**
*   **Observation**: Growth is unstable.
    *   **Highest Growth**: Feb 2023 (+68%)
    *   **Largest Drop**: Mar 2023 (-46%) & Nov 2023 (-46%)
*   **Drivers**: The "spike then correction" pattern (e.g., Oct spike followed by Nov crash) suggests customers purchase early during promotions, cannibalizing future demand.
*   **Recommendation**: Create a stable campaign calendar to reduce volatility. Monitor if high sales months correlate with high discounts (sacrificing margin).

### **3. Category Contribution (Revenue Mix)**
*   **Revenue Split**:
    *   Technology: ~35.5%
    *   Furniture: ~33.5%
    *   Office Supplies: ~31%
*   **Insight**: The portfolio is well-diversified with no single category dominating revenue.
*   **Caution**: High revenue does not equal high profit. Furniture often has high revenue but lower margins due to shipping costs.

### **4. Top Products (Pareto Principle)**
*   **Observation**: Revenue is heavily dependent on a few SKUs.
    *   Top Product: ~245K Sales
    *   2nd Product: ~165K Sales
*   **Insight**: The top product generates ~1.5x more revenue than the second best-seller.
*   **Recommendation**: Ensure inventory availability for these top products to strictly avoid stockouts. Investigate their profit margins to ensure they aren't loss leaders.

### **5. Regional Performance (YoY Growth 2023 vs 2022)**
*   **Best Performers**:
    *   **Central**: +21% growth
    *   **East**: +12% growth
*   **Underperformers**:
    *   **South**: -6% decline
    *   **West**: -12% decline
*   **Recommendation**: Investigate the West and South regions for pricing mismatches, shipping issues, or increased competition. Replicate Central's successful strategy in these regions.

### **6. Profitability by Sub-Category**
*   **High Profit**: Chairs (~155K), Phones (~140K), Binders (~100K).
*   **Low Profit**: Fasteners (~1K), Labels, Envelopes.
*   **Insight**: Profit is concentrated in specific sub-categories.
*   **Recommendation**: Focus marketing budget on high-profit items (Chairs, Phones). Consider bundling low-profit items (Fasteners) or reducing their discounts.

---

## **<h3>Strategic Business Recommendations</h3>**

Based on the data, the following actions are recommended:

1.  **Stabilize Revenue**: Move away from erratic "spike-and-crash" sales cycles by implementing a consistent promotional calendar.
2.  **Profit-First Focus**: Shift focus from pure revenue growth to profit growth. Prioritize high-margin sub-categories like Chairs and Phones over low-margin volume drivers.
3.  **Regional Turnaround**: Launch targeted campaigns in the West and South regions to reverse the negative YoY trend.
4.  **Inventory Management**: Lock down supply chains for the top 10 products that drive the majority of revenue.

---

## **<h3>Technical Implementation</h3>**

### **Files in Repository**
*   `Order_Data_Analysis.ipynb`: The main notebook for data cleaning, feature engineering, and database loading.
*   `SQL_Queries.sql`: Contains all SQL queries used for the analysis (Revenue Drivers, Regional Analysis, Time Series, etc.).
*   `orders.csv`: Raw dataset.
*   `Analysis.md`: Detailed breakdown of the insights.

### **How to Run**

1.  **Install Dependencies**:
    ```bash
    pip install pandas sqlalchemy pymysql kaggle matplotlib
    ```

2.  **Run the Notebook**:
    Execute `Order_Data_Analysis.ipynb` to download data, clean it, and load it into MySQL.

3.  **Execute SQL Queries**:
    Use the queries in `SQL_Queries.sql` to generate the insights tables.
