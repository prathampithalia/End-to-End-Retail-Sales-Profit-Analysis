# 1) Download dataset
!kaggle datasets download -d prathampithalia/project -f orders.csv -p . --unzip --force

# 2) Read dataset
import pandas as pd

df = pd.read_csv("orders.csv", na_values=["Not Available", "unknown"])

# 3) Clean column names
df.columns = df.columns.str.strip().str.lower().str.replace(" ", "_")

# 4) Feature engineering
df["discount"] = df["list_price"] * (df["discount_percent"]*0.01)
df["sale_price"] = df["list_price"] - df["discount"]

# Total sales & profit 
df["sales"] = df["sale_price"] * df["quantity"]
df["profit"] = (df["sale_price"] - df["cost_price"]) * df["quantity"]

# 5) Convert order_date
df["order_date"] = pd.to_datetime(df["order_date"], format="%Y-%m-%d")

# 6) Load into MySQL
import sqlalchemy as sal

engine = sal.create_engine("mysql+pymysql://root:<password>@localhost:3306/project")
conn = engine.connect()

df.to_sql("df_orders", con=conn, index=False, if_exists="replace")

print("Loaded into MySQL")
