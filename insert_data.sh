#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#TEAMS INSERTIONS
echo $($PSQL "TRUNCATE games, teams")

echo -e "\n ~~ TEAMS INSERTION ~~ \n"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #insert winners
  if [[ $WINNER != winner ]]
  then
    #get team id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");
    #if nf
    if [[ -z $TEAM_ID ]]
      then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $WINNER
    fi
  fi
  #insert opponents
  if [[ $OPPONENT != opponent ]]
  then
    #get team id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");
    #if nf
    if [[ -z $TEAM_ID ]]
      then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $OPPONENT
    fi
  fi
done

#GAMES INSERTIONS
echo -e "\n ~~ GAMES INSERTION ~~ \n"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then 
  #get teams id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'");
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'");
  
  #make insertion
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR, $ROUND, $WINNER, $OPPONENT
    fi
  fi
done