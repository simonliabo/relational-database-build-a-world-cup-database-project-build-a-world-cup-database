#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #if not first line do stuff
  if [[ $YEAR != year ]]
  then
    #add unique team to teams table
    #get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    #if it is not yet in table: insert it
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    fi
    #get opponent id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    #if it is not yet in table: insert it
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    fi

    #add unique game to games table 
    #get game id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year = $YEAR AND round = '$ROUND' AND winner_id = $WINNER_ID AND opponent_id = $OPPONENT_ID;")
    if [[ -z $GAME_ID ]]
    then
      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    fi
  fi
done