# Sales Data Pipeline & Business Analysis

## Project Overview

This project focuses on building an end-to-end Sales Data Pipeline using Python, Pandas, MySQL, SQLAlchemy and SQL.

The objective is to clean and transform raw retail transaction data, store the processed data in a MySQL database, and perform SQL-based business analysis to identify meaningful business patterns and insights.

## Project Objectives

- Clean and preprocess raw sales data using Python and Pandas.
- Handle missing values, duplicate records and data type inconsistencies.
- Transform and prepare data for database storage.
- Integrate Python with MySQL using SQLAlchemy.
- Perform business analysis using SQL.
- Analyze sales trends, revenue and customer purchasing behaviour.

## Tools & Technologies

- Python
- Pandas
- MySQL
- MySQL Workbench
- SQLAlchemy
- SQL
- Git & GitHub

## Project Workflow

1. Data Loading and Exploration – Load and inspect the raw retail dataset using Pandas.
2. Data Cleaning – Handle missing values, duplicates and incorrect data types.
3. Data Transformation – Prepare cleaned data for database integration.
4. Database Integration – Connect Python to MySQL using SQLAlchemy.
5. SQL Analysis – Execute business-focused SQL queries.
6. Business Insights – Analyze the results to identify meaningful patterns.

## SQL Business Analysis

A total of 13 SQL queries were developed to answer business-related questions and analyze retail transaction data.

The analysis covers business performance, revenue trends, customer behaviour and product-related metrics.

Detailed explanations of all 13 queries and their business findings will be documented here.

## Key Business Insights

Insights will be added based on the actual SQL query results.

## Project Structure

```text
Sales_Data_Pipeline/
│
├── Sql/
│   ├── 01_data_transformation.sql
│   └── 02_data_analysis.sql
│
├── scripts/
│   ├── main.py
│   └── database_connection.py
│
├── requirements.txt
├── .gitignore
└── README.md
```

## How to Run the Project

1. Clone the repository.
2. Install the required dependencies:

   pip install -r requirements.txt

3. Create a `.env` file with your own MySQL database credentials.
4. Configure your MySQL database.
5. Run the Python scripts.
6. Execute the SQL scripts in MySQL Workbench.

## Dataset

The project uses retail transaction data.

The original raw dataset is not included in this repository.

## Author

Aditya Sakhuja
