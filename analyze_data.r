library (tidyverse) 

epldata <- read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/epl_final.csv')
epldata %>% # filter(Season==2017) %>% 
  ggplot(aes(Pos, TeamAge)) + 
    geom_point() +
    facet_wrap(~Season) +
    # facet_wrap(~Team) +
    geom_smooth(method=lm) +
    # scale_y_continuous(breaks = 10:15)
    scale_y_continuous(lim=c(0,8)) +
    scale_x_reverse( lim=c(20,0))
cor(epldata$Pos, epldata$TeamAge)
