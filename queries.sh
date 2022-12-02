#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id=(SELECT winner_id FROM games WHERE year=2018 AND round='Final')")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id IN ((SELECT winner_id FROM games WHERE year=2014 AND round='Eighth-Final') UNION (SELECT opponent_id FROM games WHERE year=2014 AND round='Eighth-Final')) ORDER BY name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT name FROM teams WHERE team_id IN (SELECT DISTINCT winner_id FROM games) ORDER BY name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT CONCAT(t1.year, '|', t2.name) FROM games AS t1 JOIN teams AS t2 ON t1.winner_id=t2.team_id WHERE t1.round='Final' ORDER BY t1.year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
