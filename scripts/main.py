from database_connection import engine
import pandas as pd

# Load dataset
df = pd.read_excel("dataset/Online_Retail.xlsx")


# 1. Initial data inspection

print("FIRST 5 ROWS")
print(df.head())

print("\nDATASET SHAPE")
print(df.shape)

print("\nDATASET INFORMATION")
df.info()

print("\nMISSING VALUES")
print(df.isnull().sum())

print("\nDUPLICATE RECORDS")
print(df.duplicated().sum())


# 2. Remove duplicate records

df = df.drop_duplicates()

print("\nDATASET AFTER REMOVING DUPLICATES")
print(df.shape)


# 3. Clean Description values

# Remove extra spaces and treat blank descriptions as missing
df["Description"] = df["Description"].str.strip()
df["Description"] = df["Description"].replace("", pd.NA)

# Find StockCodes with only one available description
valid_descriptions = df.dropna(subset=["Description"])

description_counts = valid_descriptions.groupby("StockCode")["Description"].nunique()

description_map = (
    valid_descriptions
    .drop_duplicates(subset=["StockCode", "Description"])
    .groupby("StockCode")["Description"]
    .first()
)

recoverable_codes = description_counts[description_counts == 1].index

description_map = description_map.loc[recoverable_codes]

# Fill missing descriptions where possible
df["Description"] = df["Description"].fillna(
    df["StockCode"].map(description_map)
)

# Remove records with unrecoverable descriptions
df = df.dropna(subset=["Description"])


# 4. Handle missing CustomerID

# Retain missing CustomerID values
print("\nMISSING CUSTOMER IDs")
print(df["CustomerID"].isnull().sum())


# 5. Handle Quantity

print("\nZERO QUANTITIES")
print((df["Quantity"] == 0).sum())

print("\nNEGATIVE QUANTITIES")
print((df["Quantity"] < 0).sum())

# Remove zero quantity records
# Retain negative quantities as product returns
df = df[df["Quantity"] != 0]


# 6. Handle UnitPrice

print("\nZERO UNIT PRICES")
print((df["UnitPrice"] == 0).sum())

print("\nNEGATIVE UNIT PRICES")
print((df["UnitPrice"] < 0).sum())

# Remove negative unit prices
# Retain zero unit prices
df = df[df["UnitPrice"] >= 0]


# 7. Clean text columns

df["Description"] = df["Description"].str.strip()
df["Country"] = df["Country"].str.strip()


# 8. Correct data types

df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])

df["CustomerID"] = df["CustomerID"].astype("Int64")


# 9. Final data validation

print("\nFINAL DATASET SHAPE")
print(df.shape)

print("\nFINAL MISSING VALUES")
print(df.isnull().sum())

print("\nFINAL DUPLICATE RECORDS")
print(df.duplicated().sum())

print("\nFINAL DATA TYPES")
print(df.dtypes)

print("\nDATA CLEANING COMPLETED")

# Transfer cleaned data to MySQL

df.to_sql(
    name="online_retail_raw",
    con=engine,
    if_exists="replace",
    index=False,
    chunksize=1000
)

print("Data successfully transferred to MySQL!")
