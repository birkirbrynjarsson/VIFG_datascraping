library (tidyverse) 
library (scales)
library(gridExtra)


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
cor(epldata$Pos, epldata$MeanAge)

epldata %>% filter(Team == "Manchester United") %>% 
  ggplot(aes(Season, Pos)) + 
  geom_point(aes(color=Team))
  # scale_y_continuous(breaks = 10:15)
  # scale_y_continuous(lim=c(0,8))

epldata %>% #filter(Season >= 2006) %>%
  ggplot(aes(group=AgePos, Season, Pos)) +
    geom_line(data = epldata %>% filter(AgePos > 1, AgePos < 20), colour = 'gray') +
    geom_line(data = epldata %>% filter(AgePos <= 1), aes(color=AgePos), size = 2) +
    geom_line(data = epldata %>% filter(AgePos >= 20), aes(color=AgePos), size = 2) +
    geom_point(data = epldata %>% filter(Team == "Liverpool"), color = 'Red') +
    #geom_point(data = epldata %>% filter(AgePos <= 10)) +
    #geom_point(data = epldata %>% filter(AgePos >= 20)) +
    scale_y_reverse() +
    scale_x_continuous(breaks=pretty_breaks())

p1 <- epldata %>% filter(Team == "Arsenal") %>%
  ggplot(aes(x = Season)) +
    geom_line(aes(y = Pos)) +
    scale_y_reverse(breaks=pretty_breaks(), lim=c(20,1))

p2 <- epldata %>% filter(Team == "Arsenal") %>%
  ggplot(aes(x = Season)) +
  geom_line(aes(y = MeanAge)) +
  scale_y_continuous(breaks=pretty_breaks())

grid.arrange(p1, p2)

epldata %>%
  ggplot(aes(Pos, MeanAge)) + 
  #geom_point(aes(color=Pos)) +
  geom_point(aes()) +
  # facet_wrap(~Season) +
  # geom_smooth(method=lm) +
  # scale_y_continuous(breaks = 10:15)
  scale_y_continuous(lim=c(1,8)) +
  scale_x_reverse( lim=c(20,0))

epldata %>%
  ggplot(aes(Pos, MeanAge)) + 
  #geom_point(aes(color=Pos)) +
  geom_point(aes()) +
  # facet_wrap(~Season) +
  # geom_smooth(method=lm) +
  # scale_y_continuous(breaks = 10:15)
  scale_y_continuous(lim=c(1,8)) +
  scale_x_reverse( lim=c(20,0))

epldata %>%         
  ggplot(aes(Pos, MeanAge)) +
  geom_boxplot(aes(group=Pos)) +
  scale_x_reverse( lim=c(21,0)) +
  # geom_smooth(method=lm)
# coord_flip()
