import pandas as pd

def get_teamAge(filename):
    data = pd.read_csv(filename, index_col=False)
    teams = []
    for team in data.Team.unique():
        index = data.Team == team
        nrOfPlayers = 14
        for i in range(14, 18):
            if len(data[index]) > i and data[index].sort_values('Appearances', ascending = False).iloc[i]['Appearances'] >= 15:
                nrOfPlayers += 1
            else:
                # print(data[index].sort_values('Appearances', ascending = False)[nrOfPlayers-1:nrOfPlayers])
                break
        # print(nrOfPlayers)
        meanAge = "{0:.2f}".format(data[index].sort_values('Appearances', ascending = False)[:nrOfPlayers]['SeasonAtTeam'].mean())
        medianAge = data[index].sort_values('Appearances', ascending = False)[:nrOfPlayers]['SeasonAtTeam'].median()
        stddev = "{0:.2f}".format(data[index].sort_values('Appearances', ascending = False)[:nrOfPlayers]['SeasonAtTeam'].std(ddof=0))
        maxAge = data[index].sort_values('Appearances', ascending = False)[:nrOfPlayers]['SeasonAtTeam'].max()
        minAge = data[index].sort_values('Appearances', ascending = False)[:nrOfPlayers]['SeasonAtTeam'].min()
        teamSize = data[index].sort_values('Appearances', ascending = False)[:nrOfPlayers]['SeasonAtTeam'].count()
        team25 = data[index].sort_values('Appearances', ascending = False)[:nrOfPlayers]['SeasonAtTeam'].quantile(0.25)
        team75 = data[index].sort_values('Appearances', ascending = False)[:nrOfPlayers]['SeasonAtTeam'].quantile(0.75)
        # print(team + ": " + str(teamAge))
        teams.append([team, meanAge, medianAge, stddev, team25, team75, maxAge, minAge, teamSize])
    df = pd.DataFrame(teams, columns=['Team', 'MeanAge', 'MedianAge', 'StdAge', 'Qaunt25', 'Quant75', 'MaxAge', 'MinAge', 'TeamSize'])
    # print(df.sort_values('MeanAge', ascending = False))
    return df


def get_results(filename):
    data = pd.read_csv(filename, index_col=False)
    return data
    # return data[((data.League == 'EPL') & (data.Season == year))]
    

def glossary():
    # Check out:
    # https://gist.github.com/bsweger/e5817488d161f37dcbd2
    data = pd.DataFrame()
    data.ix[10] # Selecting specific row
    data['Player'] # Selecting Player column only
    data[:20] # Selecting first 20 rows
    data[5:10] # Selecting row 5 to 10
    data[500:] # Selecting rows 500 and up
    data.head() # Select head of data, first 5 rows
    data.tail() # Select tail of data, last 5 rows
    data['Team'].value_counts() # How many times a column value shows up
    arsenal = data['Team'] == 'Arsenal' # Creates a boolean index for selection
    data[arsenal] # Selects/filters with previously made boolean index 
    team_index = data['Team'].str.contains('United') # Boolean index to teams with 'United' in their name
    for index, row in data.iterrows():
        print(row)

    arsenal = data['Team'] == 'Arsenal'
    data[arsenal].sort_values('Appearances', ascending=False)[:15]['SeasonAtTeam'].mean()
    data[(data['Team'] == 'Chelsea')].sort_values('Appearances', ascending=False)[:18]
    data.Team.unique() # Returns array of each unique value in 'Team' column

if __name__ == "__main__":
    years = [1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017]
    resultsDf = get_results("epl_data/epl_result.csv")
    for year in years:
        ageDf = get_teamAge(("epl_data/" + str(year) + ".csv"))
        for index, row in resultsDf[(resultsDf['Season'] == year)].iterrows():
            meanAge = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['MeanAge']
            medianAge = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['MedianAge']
            stdAge = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['StdAge']
            maxAge = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['MaxAge']
            minAge = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['MinAge']
            quant25 = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['Qaunt25']
            quant75 = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['Quant75']
            teamSize = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['TeamSize']
            resultsDf.at[index, 'MeanAge'] = meanAge
            resultsDf.at[index, 'MedianAge'] = medianAge
            resultsDf.at[index, 'StdAge'] = stdAge
            resultsDf.at[index, 'MaxAge'] = maxAge
            resultsDf.at[index, 'MinAge'] = minAge
            resultsDf.at[index, 'Quant25'] = quant25
            resultsDf.at[index, 'Quant75'] = quant75
            resultsDf.at[index, 'TeamSize'] = teamSize
        agePos = 1
        for index, row in resultsDf[(resultsDf['Season'] == year)].sort_values('MeanAge', ascending=False).iterrows():
            resultsDf.at[index, 'AgePos'] = agePos
            agePos += 1
    resultsDf.to_csv("epl_data/epl_final.csv", index=False)        
    