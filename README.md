# SupremEats2011 Data Warehouse Project
Introduction: \
This project, crafted by Grupo 1 for the Data Warehouse Architecture course under Professor Gustavo Tadeu Cicotoste, showcases a comprehensive design and implementation of a Data Warehouse solution. The project aims to illustrate the application of modern data warehousing techniques, including ETL processes, Online Analytical Processing (OLAP), and the integration with business intelligence tools.

## Project Structure
```
supremeats-finalproject/
│
├── ML/                      # Python Script for making future sales prediction              
│
├── data/                    # Data files including raw and processed CSVs
│   ├── DW/
│   ├── factTables/
│   └── raw/
│
├── doc/                     # Documentation and assets
│   └── assets/
│   └── dashboard/
│   └── diagram/
│
├── scripts/                 # SQL and Python scripts for data processing
│
├── sql/                     # SQL scripts for DW database schema creation
│
```

## Setup and Installation
#### Requirements
- Python 3.8+
- MySQL 8.0+
- Dash by Plotly
- Plotly

#### Installation Steps
1. Clone the repository:
```
git clone https://github.com/marcelobarbugli/supremeatsDW 
cd supremeats-finalproject
```

2. Install required Python libraries
```
pip install dash plotly pandas
```

3. Database Setup
- Execute the SQL scripts found in the sql/ directory to set up the database schema in MySQL.
- Use the data import scripts to populate the database.

4. Running the Dashboard
- Navigate to the dashboard/ directory.
```
python dashboard.py
```

## Data Architecture
This project utilizes a robust data warehousing model incorporating:
- Operational Data Store (ODS) for staging data.
- Data Marts for department-specific analysis.
- OLAP cubes for multidimensional data analysis.

## Data Flow
- Data is extracted from various sources.
- The raw data undergoes transformation and cleaning.
- Processed data is loaded into the respective data marts and the central data warehouse.

## Features
- Entity-Relationship Diagrams: Visual representations of data relationships.
- SQL Queries: For data manipulation and retrieval.
- Data Dashboards: Interactive dashboards for real-time data analysis.

## Documentation
- Detailed documentation is available in the `doc/` directory, which includes project reports, setup 

### Contributors
- Gisele Siqueira
- Marcelo Dozzi Babugli
- Diego Moura
- Matheus Higa
- Ricardo Geroto
- Roberto Eyama

## Acknowledgments
Special thanks to Professor Gustavo Tadeu Cicotoste and Escola Politecnica da Universidade de São Paulo for their guidance and expertise throughout the development of this project.
