library (tidyverse) 
library (scales)
library(gridExtra)
library(ggthemes)
library(ggrepel)

theme = theme_set(theme_minimal())
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

epldata %>% # filter(Season >= 2006) %>% 
  ggplot(aes(Pos, MeanAge)) + 
    geom_point(aes(color=AgePos)) +
    facet_wrap(~Season) +
    # facet_wrap(~Team) +
    geom_smooth(method=lm) +
    # scale_y_continuous(breaks = 10:15)
    scale_y_continuous(lim=c(0,8)) +
    scale_x_reverse( lim=c(20,0))
corData <- epldata %>% filter(Season >= 2000)
cor(corData$Pos, corData$MeanAge)

epldata %>% filter(Team == "Manchester United") %>% 
  ggplot(aes(Season, Pos)) + 
  geom_point(aes(color=Team))
  # scale_y_continuous(breaks = 10:15)
  # scale_y_continuous(lim=c(0,8))

epldata %>% #filter(Season >= 2006) %>%
  ggplot(aes(group=AgePos, Season, Pos)) +
    theme_economist() +
    ggtitle("Premier League 1998 - 2017\nThe 3 most and least experienced teams", "Measured as the mean value of seasons at the club between active squad member.") + 
    ylab("League position") +
    xlab("Season") +
    #geom_line(data = epldata %>% filter(AgePos > 1, AgePos < 20), colour = 'gray') +
    #geom_line(data = epldata %>% filter(AgePos <= 3), color = 'lightblue') +
    #geom_line(data = epldata %>% filter(AgePos >= 18), color = 'pink') +
    # geom_line(data = epldata %>% filter(AgePos >= 18), aes(), size = 1) +
    #geom_line(data = epldata %>% filter(AgePos >= 2, AgePos <= 3), color = '#2b87e5') +
    #geom_line(data = epldata %>% filter(AgePos >= 18, AgePos <= 19), color = '#e5342b') +
    
    geom_line(data = epldata %>% filter(AgePos >= 2, AgePos <= 3), color = 'lightblue') +
    geom_line(data = epldata %>% filter(AgePos >= 18, AgePos <= 19), color = 'pink') +
  
    geom_line(data = epldata %>% filter(AgePos == 1), color = '#014386', size = 1.2) +
    geom_line(data = epldata %>% filter(AgePos == 20), color = '#861101', size = 1.2) +
    geom_point(data = epldata %>% filter(AgePos == 1, Pos >= 18), color = '#014386', size = 4) +  
    geom_point(data = epldata %>% filter(AgePos >= 1, AgePos <= 3, Pos <= 3), color = '#014386', size = 2.2) +
    geom_point(data = epldata %>% filter(AgePos >= 1, AgePos <= 3, Pos >= 18), color = '#014386', size = 4) +
    geom_point(data = epldata %>% filter(AgePos >= 18, AgePos <= 20, Pos >= 18), color = '#861101', size = 2.2) +
    geom_point(data = epldata %>% filter(Pos <= 3, AgePos >= 18), color = '#861101', size = 4) +
    geom_label_repel(aes(Season, Pos, label = ifelse((Pos == 18 & AgePos <= 3), paste(Team,", Age:",MeanAge),'')), nudge_y = 4, box.padding = 0.5, point.padding = 1,segment.color = 'grey50') +
    geom_label_repel(aes(Season, Pos, label = ifelse((Pos == 19 & AgePos <= 3), paste(Team,", Age:",MeanAge),'')), nudge_y = 3, box.padding = 0.5, point.padding = 1,segment.color = 'grey50') +
    geom_label_repel(aes(Season, Pos, label = ifelse((Pos <= 3 & AgePos >= 18), paste(Team,", Age:",MeanAge),'')), nudge_y = -5,box.padding = 0.5, point.padding = 1,segment.color = 'grey50') +
    scale_y_reverse( lim=c(20,1), breaks=c(20, 19, 18, 15, 10, 5, 4, 3, 2, 1)) +
    scale_x_continuous(breaks=c(1998,2000,2002,2004,2006,2008,2010,2012,2014,2016))

epldata %>% #filter(Season >= 2006) %>%
  ggplot(aes(group=Pos, Season, MeanAge)) +
  theme_economist() +
  # geom_line(data = epldata %>% filter(Pos > 1, Pos < 20), colour = 'gray') +
  geom_line(data = epldata %>% filter(Pos <= 1), color = 'yellow', size = 2) +
  #geom_line(data = epldata %>% filter(Pos == 2), color = 'darkgrey', size = 2) +
  #geom_line(data = epldata %>% filter(Pos == 3), color = 'gold', size = 1) +
  #geom_line(data = epldata %>% filter(Pos >= 2, Pos <= 4), color = 'yellow', size = 1) +
  #geom_line(data = epldata %>% filter(Pos == 3), color = 'brown', size = 1) +
  geom_line(data = epldata %>% filter(Pos >= 18), color = 'darkred') +
  #geom_line(data = epldata %>% filter(Team == "Liverpool"), aes(group=Team), color = 'Red') +
  # geom_point(data = epldata %>% filter(AgePos <= 10)) +
  geom_point(color='gray') +
  #scale_x_continuous(breaks=c(1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017))
  scale_x_continuous(breaks=c(1998,2000,2002,2004,2006,2008,2010,2012,2014,2016)) +
  scale_y_continuous(breaks = c(1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0))


p1 <- epldata %>% filter(Team == "Manchester City") %>%
  ggplot(aes(x = Season)) +
    geom_line(aes(y = Pos)) +
    scale_y_reverse(breaks=pretty_breaks(), lim=c(20,1))

p2 <- epldata %>% filter(Team == "Manchester City") %>%
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

epldata %>% #filter(Season >= 1998) %>%
  ggplot(aes(Pos, MeanAge, label=Team)) +
  theme_economist() +
  #ggtitle("Premier League, 1998 - 2017") + 
  ylab("Mean squad togetherness age") +
  xlab("League position") +
  scale_color_solarized() +
  geom_point(color = 'darkgray') +
  #geom_point(data = epldata %>% filter(Team == "Liverpool"), aes(), color = 'red', size=2) +
  #geom_point(data = epldata %>% filter(Team == "Manchester United"), aes(), color = 'darkred', size=2) +
  #geom_point(data = epldata %>% filter(Team == "Arsenal"), aes(), color = 'orange', size=2) +
  #geom_point(data = epldata %>% filter(Team == "Chelsea"), aes(), color = 'blue', size=2) +
  #geom_point(data = epldata %>% filter(Team == "Manchester City"), aes(), color = 'lightblue', size=2) +
  geom_boxplot(aes(group=Pos), alpha=0.7) +
  # geom_tufteboxplot(aes(group=Pos)) +
  scale_x_reverse( lim=c(21,0), breaks=c(20, 15, 10, 5, 4, 3, 2, 1)) +
  scale_y_continuous(breaks = c(1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0)) +
  geom_smooth(color = 'lightblue', alpha = 0.2) +
  # geom_text(aes(label=ifelse(MeanAge > 7,as.character(Team),'')),hjust=0, vjust=0) +
  geom_point(data = epldata %>% filter(Pos == 1, MeanAge > 7), aes(label = Team), size = 3) +
  geom_label_repel(aes(Pos, MeanAge, label = ifelse((MeanAge > 7 & Pos == 1), paste(Team,",",Season),'')), box.padding = 0.35, point.padding = 0.5,segment.color = 'grey50') +
  geom_point(data = epldata %>% filter(Pos == 1, MeanAge < 2), aes(), size = 3) +
  geom_label_repel(aes(Pos, MeanAge, label = ifelse((MeanAge < 2 & Pos == 1), paste(Team,",",Season),'')), box.padding = 0.35, point.padding = 0.5,segment.color = 'grey50') +
  geom_point(data = epldata %>% filter(MeanAge > 5, Pos == 19), aes(), size = 3) +
  geom_label_repel(aes(Pos, MeanAge, label = ifelse((MeanAge > 5 & Pos == 19), paste(Team,",",Season),'')), box.padding = 0.35, point.padding = 0.5,segment.color = 'grey50')
  # coord_flip()

