library (tidyverse) 
library (scales)


epldata <- read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/epl_final.csv')
epldata %>% filter(Season==2008) %>% 
  ggplot(aes(Pos, MeanAge)) +
    geom_col(aes(fill=Team))
    # facet_wrap(~Season)

seasons <- rbind(read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2008.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2009.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2010.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2011.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2012.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2013.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2014.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2015.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2016.csv'),
                 read_csv('/Users/birkir/Gitbox/scrape/epl-scrape/epl_data/2017.csv'))

seasons %>% filter(Appearances > 10, Season==2008) %>%           
  ggplot(aes(Team, SeasonAtTeam)) +
    geom_boxplot() +
    facet_wrap(~Season)
    # coord_flip()

epldata %>% filter(Season >= 2006) %>% 
  ggplot(aes(Pos, MeanAge)) +
  # ggplot(aes(Pos, MeanAge)) +
    geom_boxplot(aes(group=Team, ymin = MinAge, lower = Quant25, middle = MeanAge, upper = Quant75, ymax = MaxAge), stat = "identity") +
    facet_wrap(~Season) +
    coord_cartesian(ylim=c(1, 12), xlim=c(1,20)) +
    scale_y_continuous(breaks=pretty_breaks())

epldata %>% filter(Season >= 2006) %>% 
  ggplot(aes(Pos, MeanAge)) + 
    geom_point(aes(color=Team)) +
    facet_wrap(~Season) +
    # facet_wrap(~Team) +
    geom_smooth(method=lm) +
    # scale_y_continuous(breaks = 10:15)
    scale_y_continuous(lim=c(0,8)) +
    scale_x_reverse( lim=c(20,0))
cor(epldata$Pos, epldata$TeamAge)

epldata %>% filter(Season >= 2006) %>%
  ggplot(aes(group=AgePos, Season, Pos)) +
    geom_line(data = epldata %>% filter(AgePos > 3, AgePos < 18), colour = 'gray') +
    geom_line(data = epldata %>% filter(AgePos <= 3), aes(color=AgePos)) +
    geom_line(data = epldata %>% filter(AgePos >= 18), aes(color=AgePos)) +
    geom_point(data = epldata %>% filter(AgePos <= 3)) +
    geom_point(data = epldata %>% filter(AgePos >= 18)) +
    scale_y_reverse() +
    scale_x_continuous(breaks=pretty_breaks())
