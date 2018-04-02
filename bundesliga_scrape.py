import requests
from bs4 import BeautifulSoup as bs

def construct_wiki_url(wiki):
    return "https://en.wikipedia.org" + wiki

def get_teams(url, year):
    page = requests.get(url)
    soup = bs(page.content, "html.parser")

    teamPages = {}

    table = soup.find("span", {"id": "League_table"}).parent.find_next("table")
    for row in table.find_all("tr"):
        col = row.find("td")
        if(not col):
            continue
        # print(col)
        a = col.find("a")
        if(a):
            href = a.get("href")
            team = a.string
            teamPages[team] = href
    
    seasonUrl = str(year - 1) + "-" + str(year)[2:] + "_"
    for key in teamPages:
        index = teamPages[key].rfind("/") + 1
        teamPages[key] = teamPages[key][:index] + seasonUrl + teamPages[key][index:] + "_season"
    
    for key in teamPages:
        print(key + ": " + teamPages[key])
    return teamPages
    


def get_team_season_page(url):
    page = requests.get(url)
    soup = bs(page.content, "html.parser")



def get_players(url, year):
    page = requests.get(url)
    soup = bs(page.content, "html.parser")

    players = {}

    tables = soup.find("span", {"id": "Current_squad"}).parent.find_next("table").find_all("table")
    for table in tables:
        for row in table.find_all("tr"):
            # print(row)
            col = row.find_all("td")
            if(not col):
                continue
            a = col[3].find("a")
            if(a):
                href = a.get("href")
                player = a.string
                players[player] = href
                print(player + ": " + href)



if __name__ == "__main__":
    year = 2017
    teams = get_teams(construct_wiki_url("/wiki/2016%E2%80%9317_Bundesliga"), year)
    get_players(construct_wiki_url("/wiki/2016%E2%80%9317_FC_Augsburg_season"), year)