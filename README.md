# YUVA Week 2 - Data Visualization and Insight Communication using R

## Objective
Create clear, audience-friendly visualizations with R and explain what each chart reveals.

## Dataset
This project uses R's built-in `datasets::Titanic` contingency table. It represents 2,201 people and contains Class, Sex, Age, Survived, and Freq. `Freq` is the number of people represented by each combination. It is an aggregated table, not 2,201 individual records.

## Project structure
- `scripts/visualization.R` - complete reproducible R analysis and plotting script
- `outputs/figures/` - high-resolution chart examples included in the report
- `outputs/tables/` - generated summary tables (created when the R script runs)
- `report/` - Week 2 Word report

## Run in RStudio
1. Open this folder as the RStudio project/working directory.
2. Open `scripts/visualization.R`.
3. Run `source("scripts/visualization.R")`.
4. The script installs missing packages and saves five 300-DPI PNG charts and CSV summaries.

## Main findings
- Total represented population: 2,201
- Survivors: 711 (32.3%)
- Survival rate: 62.5% in first class, 41.4% in second class, 25.2% in third class, and 24.0% among crew.
- Female survival rate: 73.2%; male survival rate: 21.2%.

## Important interpretation note
These are descriptive associations in an aggregated historical dataset. They do not prove that class or sex alone caused an outcome. The line chart uses the source's ordered passenger categories for visual comparison; Crew is a separate occupational group, not another ticket class.

## Time plan (30-35 hours)
See the report's work log plan. Record actual hours and activities honestly before submission.
