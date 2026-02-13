<h1 align="center">End-to-End Data Analytics Project: Python + MySQL</h1>

## **<h3>Project Overview</h3>**

This project demonstrates a complete end-to-end analytics workflow, starting from dataset extraction to generating business insights using SQL and Python.

## **<h3>High-Level Workflow</h3>**

**1. Data Extraction:** Downloaded dataset programmatically using Kaggle API

**2. Data Cleaning:** Handled missing values, standardized column names, and fixed datatypes using Pandas

**3. Feature Engineering:** Created business metrics like **discount**, **sale_price**, **sales**, and **profit**

**4. Database Integration:** Loaded the cleaned dataset into **MySQL**

**5. Data Analysis:** Used SQL (CTEs + window functions) to generate insights

---

## **<h3>Project Architecture</h3>**

**Kaggle API → Python (Pandas) → MySQL → SQL Insights → Charts (Python)**

### **Dataset Download**

```bash
kaggle datasets download -d prathampithalia/project -f orders.csv -p . --unzip --force
```

---

## **<h3>Feature Engineering</h3>**

The following metrics were created for analysis:

* **discount**
* **sale_price** (after discount)
* **sales** = sale_price × quantity
* **profit** = (sale_price − cost_price) × quantity

---

## **<h3>SQL Analysis</h3>**

SQL queries were written to analyze:

* Top revenue generating products
* Top products per region
* Month-over-Month (MoM) growth %
* Year-over-Year (YoY) sales comparison
* Category contribution % (revenue mix)
* Best & worst performing sub-categories
* Outlier months with unusually high/low sales

---

## **<h3>Charts Created (Python)</h3>**

Charts were created using Python (Matplotlib) to visualize key insights:

1. Monthly Sales Trend
2. Month-over-Month Growth %
3. Category Contribution to Revenue (%)
4. Top 10 Products by Revenue
5. Region-wise YoY Growth %
6. Profit by Sub-Category (Top 10 vs Bottom 10)

---

## **<h3>Skills Demonstrated</h3>**

* **Python (Pandas):** data cleaning, transformation, feature engineering
* **SQL (MySQL):** CTEs, window functions, aggregations, time-based analysis
* **ETL Workflow:** Extract → Transform → Load pipeline
* **Business Analysis:** turning raw data into meaningful insights

---

## **<h3>How to Run This Project</h3>**

### **1. Install required libraries**

```bash
pip install pandas sqlalchemy pymysql kaggle
```

### **2. Run the notebook**

* `Order_Data_Analysis.ipynb`

### **3. Execute SQL queries**

* Run queries from: `SQL_Queries.sql`
* Use MySQL Workbench or MySQL CLI

---

## **<h3>Files in the Repository</h3>**

* **Order data analysis.py** → Python ETL + MySQL loading
* **Order_Data_Analysis.ipynb** → Notebook version
* **final_queries.sql** → SQL insights queries
* **orders.csv** → Raw dataset
* **README.md** → Documentation

---

## **<h3>Key Insights</h3>**

* Identified top products driving revenue
* Analyzed regional performance and growth trends
* Measured category and sub-category contribution to sales and profit
* Detected seasonal patterns and sales anomalies

