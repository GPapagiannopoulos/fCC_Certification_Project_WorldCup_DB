#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do 
  if [[ $WINNER != 'winner' ]]
  then
  # get team name 
    WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'; ")
    # if not found 
    if [[ -z $WINNER_NAME ]]
    then
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER'); ")
    fi
    
    OPP_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'; ")
    if [[ -z $OPP_NAME ]]
    then
      INSERT_OPP_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT'); ")
    fi

    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'; ")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'; ")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPP_ID', '$WINNER_GOALS', '$OPPONENT_GOALS'); ")
  fi
done