library(hoopR)
library(tidyverse)


SEASONS <- 2000:2025

merged_df <- data.frame()


# Download data
# It was necessary to add each team separetedly, otherwise it reaches a limit and not all data could be included
for(selected_season in SEASONS) {
  
  message("Downloading stats for season: ", selected_season)
  
  teams <- nba_leaguedashteamstats(season = selected_season)$LeagueDashTeamStats
    
  raw_data <- map_dfr(teams$TEAM_ID, function(tid) {
    Sys.sleep(1)                                    
    nba_shotchartdetail(season = selected_season,
                        season_type = "Regular Season",
                        team_id = tid,
                        player_id = 0,
                        context_measure = "FGA")$Shot_Chart_Detail
    })

  df_year <- raw_data %>%
    mutate(Season = selected_season)
  
  merged_df <- bind_rows(merged_df, df_year)
}


# Save merged output
write_tsv(merged_df, file = "data/all_shots_seasons_2000_to_2025.tsv")






