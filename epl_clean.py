import pandas as pd

def get_teamAge(filename):
    data = pd.read_csv(filename, index_col=False)
    teams = []
    for team in data.Team.unique():
        index = data.Team == team
        teamAge = "{0:.2f}".format(data[index].sort_values('Appearances', ascending = False)[:15]['SeasonAtTeam'].mean())
        # print(team + ": " + str(teamAge))
        teams.append([team, teamAge])
    df = pd.DataFrame(teams, columns=['Team', 'Age'])
    print(df.sort_values('Age', ascending = False))
    return df


def get_results(filename, year):
    data = pd.read_csv(filename, index_col=False)
    return data[((data.League == 'EPL') & (data.Season == year))]
    

def glossary():
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
    year = 2010
    ageDf = get_teamAge(("epl_data/" + str(year) + ".csv"))
    resultsDf = get_results("epl_data/epl_result.csv", year)
    for index, row in resultsDf.iterrows():
        age = ageDf[(ageDf.Team.str.contains(row['Team']))].iloc[0]['Age']
        resultsDf.at[index, 'TeamAge'] = age
    print((resultsDf[:10])['TeamAge'].median())
    print((resultsDf[10:])['TeamAge'].median())
    print(resultsDf)

    