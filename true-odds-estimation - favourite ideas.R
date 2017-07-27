# #### 2. Favourite
# 
# ```{r - favourite facet, echo = FALSE, message = FALSE, fig.width = 12, fig.height = 6, fig.show='hold', fig.align='center'}
# 
# # loess fit: 
# # rps_diff ~ original_odds
# # groups: odds_method, favourite
# 
# # create tibble first: create 'favourite' variable then join back to 'plot_data_rps'
# loess_favourite_facet <- plot_data_rps %>% 
#   select(match_id, original_odds, odds_method, odds_type) %>% 
#   spread(odds_type, original_odds) %>% 
#   mutate(favourite = ifelse(H <= A, "home", "away")) %>% 
#   select(-one_of(c("H", "D", "A"))) %>% 
#   right_join(
#     ., 
#     plot_data_rps %>% select(match_id, original_odds, original_rps, odds_method, odds_type, rps_diff), 
#     by = c("match_id", "odds_method")
#   ) %>% 
#   mutate(original_probs = 1/original_odds) %>% 
#   group_by(odds_method, favourite)
# 
# # actual model fit
# loess_favourite_facet <- loess_favourite_facet %>% 
#   do(fit = loess(rps_diff ~ original_probs, .)) %>% 
#   ungroup() %>% 
#   mutate(id = as.character(seq(1, nrow(.))))
# 
# 
# # new data range
# probs_range = seq(0, 1, by=0.00001)
# 
# # loess over data points lattice
# rps_favourite_facet <- pmap(
#   list(loess_favourite_facet$odds_method, loess_favourite_facet$favourite), 
#   .f = function(x, y)
#     as.vector(
#       predict(
#         loess_favourite_facet %>% 
#           filter(odds_method == x, favourite == y) %>% 
#           select(fit) %>% as.data.frame() %>% .[[1]] %>% .[[1]], 
#         newdata = probs_range
#       )
#     )
# ) %>% 
#   map_df(~data_frame(original_probs = probs_range, rps_diff = .x), .id = "id") %>% 
#   right_join(., loess_favourite_facet %>% select(id, odds_method, favourite), by="id") %>% 
#   drop_na()
# 
# 
# # rm probs_range
# rm(probs_range)
# 
# 
# # plot - instead of facet-ing, do as seperate plots as control is better
# plot_favourite_facet_h <- rps_favourite_facet %>% 
#   filter(favourite == "home") %>% 
#   group_by(odds_method, favourite) %>% 
#   ggplot(aes(original_probs, rps_diff, colour = odds_method)) + 
#   geom_smooth() + 
#   geom_hline(yintercept = 0, lty = 2) + 
#   coord_cartesian(xlim = c(0.2, 0.6), ylim = c(-2*10e-5, 0)) +
#   scale_colour_discrete(
#     name = "Odds Method",
#     breaks = c("power_odds", "proportional_odds", "ratio_odds"),
#     labels = c("Power Odds", "Proportional Odds", "Ratio Odds")
#   ) + 
#   theme_classic() +
#   theme(legend.justification = c(0.5, 0.9), legend.position = c(0.5, 0.9)) +
#   labs(x = "Original Probabilities \n Fig 1.6", y = "RPS Difference", title = "Favourite: Home")
# 
# plot_favourite_facet_a <- rps_favourite_facet %>% 
#   filter(favourite == "away") %>% 
#   group_by(odds_method, favourite) %>% 
#   ggplot(aes(original_probs, rps_diff, colour = odds_method)) + 
#   geom_smooth() + 
#   geom_hline(yintercept = 0, lty = 2) + 
#   coord_cartesian(xlim = c(0.2, 0.6), ylim = c(-2*10e-5, 0)) +
#   scale_colour_discrete(
#     name = "Odds Method",
#     breaks = c("power_odds", "proportional_odds", "ratio_odds"),
#     labels = c("Power Odds", "Proportional Odds", "Ratio Odds")
#   ) + 
#   theme_classic() +
#   theme(legend.justification = c(0.5, 0.9), legend.position = c(0.5, 0.9)) +
#   labs(x = "Original Probabilities \n Fig 1.6", y = "RPS Difference", title = "Favourite: Away")
# 
# 
# # # find crossover/intersection points - first find location of min, then output the value and the method
# # rps_comparison_cross_over_points <- rps_comparison_cross_over_points %>% 
# #   mutate(
# #     min_odds = pmin(ratio_odds, power_odds, proportional_odds), 
# #     min_method = rps_comparison_cross_over_points %>% 
# #       select(one_of(c("ratio_odds", "power_odds", "proportional_odds"))) %>% transpose() %>% map_chr(function(x) names(which.min(x)))
# #   ) %>% 
# #   mutate(
# #     crossover = ifelse(lead(min_method) != min_method | lag(min_method) != min_method | row_number() %in% c(1,nrow(.)), 1, 0), 
# #     event_label = ifelse(crossover == 1, paste0("x = ", original_probs), "")
# #   )
# 
# 
# # output plots side by side
# grid.arrange(plot_favourite_facet_h, nullGrob(), plot_favourite_facet_a,  top = textGrob("Combined Odds Method"), widths=c(0.475, 0.05, 0.475))
# 
# rm(plot_favourite_facet_h, plot_favourite_facet_a)
# 
# 
# ```