library(hoopR)
library(tidyverse)


SEASONS <- 2000:2025
RAW_DIR <- "data"
FORCE = FALSE


merged_df <- data.frame(
  "EVENT_TYPE" = character(),
  "n"  = integer(),
  "Season"  = integer()
  )


# Download data, or if it is already downloaded, retrieve files from local
for(selected_season in SEASONS) {
  
  cache <- file.path(RAW_DIR, paste0("shots_", selected_season, ".rds"))
  
  if (file.exists(cache) && FORCE == FALSE) {
    
    message("Retrieving stats from cache for season: ", selected_season)
    
    raw_data <- readRDS(cache)
    
  } else {
    
    message("Downloading stats for season: ", selected_season)
 
    raw_data <- nba_shotchartdetail(
      season = selected_season,
      season_type = "Regular Season",
      team_id = 0,
      player_id = 0,
      context_measure = "FGA"
      )
    
    saveRDS(raw_data, cache)
    Sys.sleep(1)
  }
  
    three_points_df <- raw_data[["Shot_Chart_Detail"]] %>%
    filter(SHOT_TYPE == "3PT Field Goal") %>%
    count(EVENT_TYPE) %>%
    mutate(Season = selected_season)
    
    merged_df <- rbind(merged_df, three_points_df)
}


summary_df <- merged_df %>%
  pivot_wider(names_from = EVENT_TYPE, values_from = n) %>%
  mutate(
    Attempts = `Made Shot` + `Missed Shot`
  )

ggplot(summary_df, aes(x = Season, y = Attempts)) +
  geom_line(linewidth = 2) +
  theme_bw()







