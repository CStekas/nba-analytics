# ------------------------------------------
# Purpose: Plot yearly percentage of successful shots by shot type, plus the overall total.
# Input:   all_shots_seasons_2000_to_2025.tsv (one row per shot)
# Output:  line plot (displayed)
# ------------------------------------------


library(tidyverse)


# Load data --------------------------
raw_data <- read_tsv("data/all_shots_seasons_2000_to_2025.tsv")



#Prepare data -------------------------------
# Summarize shot attempts, and how many were successful or not
attempts_by_type <- raw_data %>%
  group_by(Season, SHOT_TYPE) %>%
  count(EVENT_TYPE)


# Get percentage of successful shots (per type)
percentages_success <- attempts_by_type %>%
  group_by(Season, SHOT_TYPE) %>%
  summarise(
    percentage = n[EVENT_TYPE == "Made Shot"] / sum(n) * 100,
    .groups = "drop"
  )


# Plot -------------------
#Add reference lines
ref_lines <- percentages_success %>%
  group_by(SHOT_TYPE) %>%
  summarise(ref = percentage[Season == min(Season)])   

ggplot(percentages_success, aes(x = Season, y = percentage, colour = SHOT_TYPE)) +
  geom_line(linewidth = 1.2) +
  scale_color_brewer(palette = "Set2") +
  labs(title = "Percentage of successful shot attempts per NBA season",
       y = "% of made shots",
       color = "Shot type"
  ) +
  geom_hline(data = ref_lines, aes(yintercept = ref, colour = SHOT_TYPE), linetype = 2) +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) 
