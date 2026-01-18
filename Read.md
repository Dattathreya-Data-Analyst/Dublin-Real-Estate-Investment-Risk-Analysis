Dublin Real Estate Investment Risk Analysis (2024 - 2026)

📌 Project Overview
This project provides a data-driven framework for evaluating real estate investment stability in Dublin. By integrating Property Transaction Data with Quarterly Unemployment Statistics, I developed a custom Investment Risk Score to identify districts that offer the best balance between property value and economic resilience.

🛠️ Tech Stack
Database: MySQL (Advanced Joins, CTEs, Views, Date Transformation)
Analysis: Python (Pandas)
Visualization: Matplotlib, Seaborn
Data Sources: Dublin Property Price Register & National Labor Statistics

📊 Methodology & Logic
The core of this project is a custom-engineered Risk Score. The logic assumes that high property prices in areas with rising unemployment represent a "volatility risk" for investors.
1. Data Transformation (SQL)
Raw transaction dates were converted from strings to date objects to allow for quarterly aggregation and joining with economic data
SQL:SQLSTR_TO_DATE(Transaction_Date, '%d-%m-%Y')

2. The Risk Formula
I developed a weighted formula to normalize the relationship between price and labor health:
$$Investment\ Risk\ Score = \left(\frac{Avg\ Sale\ Price}{100,000}\right) + (Unemployment\ Rate \times 5)
.Green Zone (Low Score): Stable pricing supported by high employment.
.Red Zone (High Score): High capital requirement in economically sensitive areas.

🚀 Key Insights
Top Investment District: Dublin 15 (or your top result) showed the most resilience with a risk score of 24.5. This indicates a strong "Entry Price to Employment" ratio.

Economic Impact: The analysis revealed that Dublin 8 (or your bottom result) is highly sensitive to shifts in the Dublin Unemployment Rate. While prices remain high, the volatility suggests this area is better suited for long-term hold strategies rather than short-term speculative "flipping."

Data Integrity: Successfully handled a "MySQL Error 1356" by identifying a schema mismatch between the raw CSV and the View definition, standardizing column aliases to ensure the View was robust.

📂 Project StructurePlaintextdublin-investment-analytics/
├── data/
│   ├── raw/                      # Original CSV files
│   └── processed/                # dublin_investment_analysis_results.csv
├── sql_scripts/
│   ├── 1_data_cleaning.sql       # STR_TO_DATE and table setup
│   └── 2_risk_analysis_view.sql  # Final CREATE VIEW logic
├── visualizations/
│   ├── 1_risk_heatmap.png        # Risk Ranking Bar Chart
│   ├── 2_price_correlation.png   # Scatter Plot
│   └── 3_quarterly_trends.png    # Time Series Line Graph
├── notebooks/
│   └── data_visualization.py     # Python plotting script
└── README.md                     # Project Documentation

📈 Visual Highlights
1. Investment Risk Heatmap
This chart ranks Dublin districts by their calculated risk score, providing an immediate visual guide for capital allocation.(Note: Upload your 1_investment_risk_heatmap.png to the visualizations folder to see it here)

2. Price vs. Job Risk Correlation
A scatter plot demonstrating how local employment health impacts property pricing across different quarters.(Note: Upload your 2_price_unemployment_correlation.png to the visualizations folder)

📝 Conclusion
This project demonstrates the ability to translate raw, disparate datasets into actionable business intelligence. The resulting model provides a scalable way to assess urban real estate markets using macroeconomic indicators.