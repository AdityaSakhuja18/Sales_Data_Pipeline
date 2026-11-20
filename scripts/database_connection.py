
import os
from pathlib import Path

from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

# Load environment variables
project_root = Path(__file__).resolve().parents[1]
load_dotenv(project_root / ".env")

# Database connection details
connection_url = URL.create(
    drivername="mysql+pymysql",
    username=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=int(os.getenv("DB_PORT", "3306")),
    database=os.getenv("DB_NAME")
)

# Create SQLAlchemy engine
engine = create_engine(connection_url)

# Test connection
def test_connection():
    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT DATABASE()"))

            print("MySQL connection successful!")
            print("Connected Database:", result.scalar())

    except Exception as e:
        print("Connection failed:", e)

    finally:
        engine.dispose()


if __name__ == "__main__":
    test_connection()
