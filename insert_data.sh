#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

### Truncating tables
echo $($PSQL "TRUNCATE teams, games")

### Inserting Teams (Reading csv -> inserting into PSQL)
tail -n +2 games.csv  | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  ### Inserting Winner
  # get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # insert if winner_id not found
  if [[ -z $WINNER_ID ]]
  then
    WINNER_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $WINNER_INSERT == "INSERT 0 1" ]]
    then
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      echo "Inserting $WINNER into teams table"
    fi
  fi

  ### Inserting Opponent
  # get opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # insert if opponent_id not found
  if [[ -z $OPPONENT_ID ]]
  then
    OPPONENT_INSERT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $OPPONENT_INSERT == "INSERT 0 1" ]]
    then
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      echo "Inserting $OPPONENT into teams table"
    fi
  fi

  ### Inserting Games
  GAME_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $GAME_INSERT == "INSERT 0 1" ]]
  then
    echo "Inserting game [$YEAR - $ROUND] $WINNER x $OPPONENT ($WINNER_GOALS x $OPPONENT_GOALS)"
  fi
done
