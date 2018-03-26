import requests
from bs4 import BeautifulSoup as bs
from selenium import webdriver
import pandas as pd
import csv
import time
from itertools import chain
import json

root_url = "https://www.premierleague.com"
scraped_season_ids = {}
season_ids = {2017 : 54, 2016 : 42, 2015 : 27, 2014 : 22, 2013 : 21,
              2012 : 20, 2011: 19, 2010 : 18, 2009 : 17, 2008 : 16}
teams = {}
players = {}
browser = webdriver.Chrome()
data = []



def construct_url_by_year(year):
    return root_url + "/players?se=" + str(season_ids[year]) + "&cl=-1"



def construct_url_by_year_team(year, team):
    print("team: " + team + ", year: " + year)
    season_id = season_ids[int(year)]
    team_id = teams[str(year)][team]
    return root_url + "/players?se=" + str(season_id) + "&cl=" + str(team_id)



def scrape():
    for season in season_ids:
        scrape_teams(season)
    # print(teams)
    # for season in teams:
        # print(season)
        # for team in teams[season]:
            # print(team + ": " + teams[season][team])



def scrape_teams(year):
    global teams
    teams = json.load(open('data.json', 'r'))
    if(len(teams) != 0):
        return

    browser.get(construct_url_by_year(year))
    time.sleep(5)
    season_soup = bs(browser.execute_script("return document.body.innerHTML"), "html.parser")

    teams[year] = {}

    for li in season_soup.find('ul', attrs={'aria-labelledby' : "dd-clubs"}).find_all("li"):
        if(li['data-option-id'] == "-1"):
            continue
        teams[year][li['data-option-name']] = li['data-option-id']
    
    with open('data.json', 'w') as outfile:
        json.dump(teams, outfile)



def scrape_players():
    global data
    for season in teams:
        print("\nSraping season: " + season)
        data = []
        for team in teams[season]:
            print("Scraping team: " + team)
            scrape_eplteam_browser(team, season)
            print(team + ": " + teams[season][team])
        dataframe = pd.DataFrame(columns = ["Player", "Team", "Season", "Appearances", "SeasonAtTeam"], data = data)
        filename = (season + ".csv")
        dataframe.to_csv(filename, index=False)
    # season = next(iter(teams))
    # team = next(iter(teams[season]))
    # scrape_eplteam_browser(team, season)
    # scrape_eplteam_browser('Blackpool', '2011')



def scrape_eplteam_browser(team, season):
    browser.get(construct_url_by_year_team(season, team))
    time.sleep(5)
    soup = bs(browser.execute_script("return document.body.innerHTML"), "html.parser")
    players = {}

    for row in soup.find("tbody").find_all("tr"):
        for playerAnchor in row.find_all("a"):
            players[playerAnchor.get_text()] = playerAnchor.get('href')
    
    for i in players:
        pageUrl = ("https:" + players[i])
        scrape_player(pageUrl, team, season)



def scrape_player(url, team, season):
    player_page = requests.get(url)
    player_soup = bs(player_page.content, "html.parser")

    yearsAtTeam = 0
    apps = 0
    detailsWrapper = player_soup.find(class_="playerDetails")
    if detailsWrapper is None:
        return
    playerName = detailsWrapper.find(class_="name").string

    for row in player_soup.find(class_="playerClubHistory").find("tbody").find_all("tr", class_="table"):
        col = row.find_all("td")
        s = col[1].find("p").string.split("/")[1] # Season, eg. 2017/2018
        t = col[2].find(class_="long").string # Team name eg. Arsenal
        a = col[3].string.split("(")[0].strip() # Apperances eg. 24(0) where 0 is substitue apperances
        if(int(s) == int(season)):
            apps = int(a)
        if(int(s) <= int(season) and team in t):
            yearsAtTeam += 1
    print(playerName + ", " + team + ", " + str(season) + ", " + str(apps) + ", " + str(yearsAtTeam))
    data.append([playerName, team, season, apps, yearsAtTeam])



if __name__ == "__main__":
    scrape()
    scrape_players()
    # scrape_player("https://www.premierleague.com/players/4328/Sergio-Ag%C3%BCero/overview")
    # scrape_eplteam_browser("https://www.premierleague.com/players?se=54&cl=1", "Arsenal", "2017")