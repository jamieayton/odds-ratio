
### 1. Odds Type

### r - odds type facet, echo = FALSE, message = FALSE, fig.width = 12, fig.height = 6, fig.show='hold', fig.align='center'

# loess fit: rps_diff ~ original_odds, grouped by odds_method, odds_type
# fit loess for rps_diff ~ original_odds
loess_odds_methods <- plot_data_rps %>% 
  select(match_id, original_odds, original_rps, odds_method, odds_type, rps_diff) %>% 
  mutate(original_probs = 1/original_odds) %>% 
  group_by(odds_method, odds_type) %>%  
  do(fit = loess(rps_diff ~ original_probs, .)) %>% 
  ungroup() %>% 
  mutate(id = as.character(seq(1, nrow(.))))

# new data range
probs_range = seq(0, 1, by=0.00001)

# loess over data points lattice
rps_odds_type <- map2(
  .x = loess_odds_methods$odds_method, .y = loess_odds_methods$odds_type, 
  .f = function(x, y)
    as.vector(
      predict(
        loess_odds_methods$fit[loess_odds_methods$odds_method == x & loess_odds_methods$odds_type == y][[1]], 
        newdata = probs_range
      )
    )
) %>% 
  map_df(~data_frame(original_probs = probs_range, rps_diff = .x), .id = "id") %>% 
  right_join(., loess_odds_methods %>% select(id, odds_type, odds_method), by="id") %>% 
  drop_na()

# rm probs_range
rm(probs_range)


# original plot
plot_odds_type <- rps_odds_type %>% 
  group_by(odds_method, odds_type) %>% 
  ggplot(aes(original_probs, rps_diff, colour = odds_method)) + 
  geom_smooth() + 
  facet_wrap( ~ odds_type, ncol=3)

plot_odds_type

# geom_hline(yintercept = 0, lty = 2) + 
# coord_cartesian(xlim = c(0, 1), ylim = c(-0.00015, 0)) + 
# scale_colour_discrete(
#   name = "Odds Method",
#   breaks = c("power_odds", "proportional_odds", "ratio_odds"),
#   labels = c("Power Odds", "Proportional Odds", "Ratio Odds")
# ) + 
# theme_classic() + 
# theme(legend.justification = c(1, 0.6), legend.position = c(1, 0.6)) + 
# labs(x = "Original Probabilities \n Fig 1.6", y = "RPS Difference")

# # find crossover/intersection points - first find location of min, then output the value and the method
# rps_comparison_cross_over_points <- rps_comparison_cross_over_points %>% 
#   mutate(
#     min_odds = pmin(ratio_odds, power_odds, proportional_odds), 
#     min_method = rps_comparison_cross_over_points %>% 
#       select(one_of(c("ratio_odds", "power_odds", "proportional_odds"))) %>% transpose() %>% map_chr(function(x) names(which.min(x)))
#   ) %>% 
#   mutate(
#     crossover = ifelse(lead(min_method) != min_method | lag(min_method) != min_method | row_number() %in% c(1,nrow(.)), 1, 0), 
#     event_label = ifelse(crossover == 1, paste0("x = ", original_probs), "")
#   )
# 
# 
# plot_odds_type

rm(plot_odds_type)