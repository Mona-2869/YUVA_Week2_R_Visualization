# YUVA Internship - Week 2
# Data Visualization and Insight Communication using R
# Dataset: built-in R datasets::Titanic (2,201 people; aggregated counts)
# Run from the project root: source("scripts/visualization.R")

required <- c("ggplot2", "dplyr", "tidyr", "scales")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing)
invisible(lapply(required, library, character.only = TRUE))

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

data("Titanic", package = "datasets")
titanic <- as.data.frame(Titanic) |>
  dplyr::filter(Freq > 0) |>
  dplyr::mutate(
    Class = factor(Class, levels = c("1st", "2nd", "3rd", "Crew")),
    Sex = factor(Sex, levels = c("Female", "Male")),
    Age = factor(Age, levels = c("Child", "Adult")),
    Survived = factor(Survived, levels = c("No", "Yes"))
  )

# Expand aggregated frequencies for summaries only; plots retain count weights.
overall <- titanic |>
  dplyr::group_by(Survived) |>
  dplyr::summarise(People = sum(Freq), .groups = "drop")
write.csv(overall, "outputs/tables/overall_outcomes.csv", row.names = FALSE)

class_summary <- titanic |>
  dplyr::group_by(Class, Survived) |>
  dplyr::summarise(People = sum(Freq), .groups = "drop") |>
  tidyr::pivot_wider(names_from = Survived, values_from = People, values_fill = 0) |>
  dplyr::mutate(Total = No + Yes, SurvivalRate = Yes / Total)
write.csv(class_summary, "outputs/tables/class_summary.csv", row.names = FALSE)

sex_summary <- titanic |>
  dplyr::group_by(Sex, Survived) |>
  dplyr::summarise(People = sum(Freq), .groups = "drop") |>
  tidyr::pivot_wider(names_from = Survived, values_from = People, values_fill = 0) |>
  dplyr::mutate(Total = No + Yes, SurvivalRate = Yes / Total)

age_summary <- titanic |>
  dplyr::group_by(Age, Survived) |>
  dplyr::summarise(People = sum(Freq), .groups = "drop")

# 1. Stacked bar chart: outcome counts by passenger class/category
p1 <- ggplot(titanic, aes(x = Class, y = Freq, fill = Survived)) +
  geom_col() +
  labs(title = "Passenger outcomes by class",
       subtitle = "Counts are weighted by the source frequency column",
       x = "Passenger category", y = "Number of people", fill = "Survived") +
  scale_y_continuous(labels = scales::comma) +
  theme_minimal(base_size = 12)
ggsave("outputs/figures/01_outcomes_by_class.png", p1, width = 8, height = 5, dpi = 300)

# 2. Line chart: survival rate across the ordered categories
p2 <- ggplot(class_summary, aes(x = Class, y = SurvivalRate, group = 1)) +
  geom_line(linewidth = 1, colour = "#2463A6") +
  geom_point(size = 3, colour = "#D97706") +
  geom_text(aes(label = scales::percent(SurvivalRate, accuracy = 0.1)),
            vjust = -0.9, size = 3.5) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.75)) +
  labs(title = "Survival rate across passenger categories",
       x = "Passenger category", y = "Survival rate") +
  theme_minimal(base_size = 12)
ggsave("outputs/figures/02_survival_rate_line.png", p2, width = 8, height = 5, dpi = 300)

# 3. Bar chart: survival rate by sex
p3 <- ggplot(sex_summary, aes(x = Sex, y = SurvivalRate, fill = Sex)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(aes(label = scales::percent(SurvivalRate, accuracy = 0.1)),
            vjust = -0.5, size = 4) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 1)) +
  labs(title = "Survival rate by sex", x = "Sex", y = "Survival rate") +
  theme_minimal(base_size = 12)
ggsave("outputs/figures/03_survival_by_sex.png", p3, width = 7, height = 5, dpi = 300)

# 4. Grouped bar chart: outcomes by age group
p4 <- ggplot(age_summary, aes(x = Age, y = People, fill = Survived)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Survival outcomes by age group", x = "Age group",
       y = "Number of people", fill = "Survived") +
  theme_minimal(base_size = 12)
ggsave("outputs/figures/04_age_group_outcomes.png", p4, width = 7, height = 5, dpi = 300)

# 5. Scatter plot: category size versus survival rate
p5 <- ggplot(class_summary, aes(x = Total, y = SurvivalRate, label = Class)) +
  geom_point(size = 4, colour = "#2463A6") +
  geom_text(nudge_y = 0.025, check_overlap = TRUE) +
  scale_y_continuous(labels = scales::percent, limits = c(0, 0.75)) +
  scale_x_continuous(labels = scales::comma) +
  labs(title = "Group size versus survival rate",
       x = "Group size (people)", y = "Survival rate") +
  theme_minimal(base_size = 12)
ggsave("outputs/figures/05_group_size_scatter.png", p5, width = 8, height = 5, dpi = 300)

cat("Total people:", sum(titanic$Freq), "\\n")
cat("Overall survival rate:",
    scales::percent(sum(titanic$Freq[titanic$Survived == "Yes"]) / sum(titanic$Freq)),
    "\\n")
cat("Figures saved in outputs/figures and summary tables in outputs/tables.\\n")
