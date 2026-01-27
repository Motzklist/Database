# Database Project

This repository contains the database schema, initialization scripts, and documentation for the Motzklist project.

## 📋 Overview
This project serves as the data layer for the Motzklist application. It includes the full schema definition, an Entity Relationship Diagram (ERD) for architectural clarity, and a collection of useful SQL queries.

## 📂 Repository Structure
*   **`init.sql`**: The primary script to initialize the database. It contains the `CREATE TABLE` statements and initial data inserts.
*   **`Database ERD.png`**: A visual representation of the database schema showing tables, columns, and relationships.
*   **`DB-queries.md`**: A documentation file containing common SQL queries used for testing and data analysis.
*   **`motzkin-setup.bat`**: A batch script for automated setup (Windows environment).
*   **`LICENSE`**: This project is licensed under the Apache-2.0 License.

## 🛠️ Getting Started

### Prerequisites
To run these scripts, you will need a SQL database engine installed (i.e., PostgreSQL).

### Setup Instructions
1.  **Automated Setup (Windows):**
    Run the `motzkin-setup.bat` file to automate the database creation process.
    
2.  **Manual Setup:**
    Open your preferred SQL management tool (like MySQL Workbench, pgAdmin, or DBeaver) and execute the contents of `init.sql`.

## 📊 Database Schema (ERD)
The structure of the database is designed as follows:

![Database ERD](./Database%20ERD.png)

## 🔍 Usage
For examples of how to interact with the data, please refer to the [DB-queries.md](./DB-queries.md) file. It includes scripts for:
*   Fetching specific user data.
*   Reporting and analytics.
*   Data maintenance tasks.

## ⚖️ License
This project is licensed under the **Apache License 2.0**. See the [LICENSE](./LICENSE) file for details.
