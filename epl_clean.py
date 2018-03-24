import pandas as pd

def get_csv(filename):
    data = pd.read_csv(filename, index_col=False)
    for team in data.Team.unique():
        index = data.Team == team
        teamAge = data[index].sort_values('Appearances', ascending = False)[:15]['SeasonAtTeam'].mean()
        print(team + ": " + str(teamAge))


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

    arsenal = data['Team'] == 'Arsenal'
    data[arsenal].sort_values('Appearances', ascending=False)[:15]['SeasonAtTeam'].mean()
    data[(data['Team'] == 'Chelsea')].sort_values('Appearances', ascending=False)[:18]
    data.Team.unique() # Returns array of each unique value in 'Team' column

if __name__ == "__main__":
    get_csv("epl_data/2016.csv")