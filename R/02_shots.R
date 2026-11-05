# ------------------------------------------
# Purpose: Plot yearly shot attempts by shot type, plus the overall total.
# Input:   all_shots_seasons_2000_to_2025.tsv (one row per shot)
# Output:  line plot (displayed)
# ------------------------------------------


library(tidyverse)


# Load data ----
raw_data <- read_tsv("data/all_shots_seasons_2000_to_2025.tsv")


# Summarize shot attempts ----
attempts_by_type <- raw_data %>%
  group_by(Season) %>%
  count(SHOT_TYPE)

# Get total attempts
totals_attempts <- raw_data %>%
  group_by(Season) %>%
  count() %>%
  ungroup() %>%
  mutate(SHOT_TYPE = "Total Field Goals")

summary_df <- bind_rows(attempts_by_type, totals_attempts)


# Plot -----
ggplot(summary_df, aes(x = Season, y = n, colour = SHOT_TYPE)) +
  geom_line(linewidth = 1.5) +
  scale_color_brewer(palette = "Set2") +
  labs(title = "Shot attempts per NBA season",
       y = "Attempts",
       color = "Shot type"
       ) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) 
