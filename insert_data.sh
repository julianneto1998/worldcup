#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")
echo $($PSQL "SELECT setval('games_game_id_seq', 1, false)")
echo $($PSQL "SELECT setval('teams_team_id_seq', 1, false)")

cat games.csv | while IFS="," read YEAR ROUND WIN_NAME OPP_NAME WG OG
do

# INSERT INTO TEAMS TABLE 
  if [[ $YEAR != "year" ]]
  then
  #INSERT team_id, name
    WIN_ID=$($PSQL "SELECT name FROM teams WHERE name='$WIN_NAME'")
    if [[ -z $WIN_ID ]]
    then
      INSERT_WINNER_ID=$($PSQL "INSERT INTO teams(name) VALUES('$WIN_NAME')")
      if [[ $INSERT_WINNER_ID == "INSERT 0 1" ]]
      then
        echo Inserted into teams: $WIN_NAME
      fi
    fi

    OPP_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPP_NAME'")
    if [[ -z $OPP_ID ]]
    then
      INSERT_OPP_ID=$($PSQL "INSERT INTO teams(name) VALUES('$OPP_NAME')")
      if [[ $INSERT_OPP_ID == "INSERT 0 1" ]]
      then
        echo Inserted into teams: $OPP_NAME
      fi
    fi   
  fi

#INSERT INTO GAMES TABLE
  #SELECT win_id
    WIN_ID_CURR=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN_NAME'")
    OPP_ID_CURR=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP_NAME'")

INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WIN_ID_CURR, $OPP_ID_CURR, $WG, $OG)")
if [[ $INSERT_GAME == "INSERT 0 1" ]]
then
  echo Inserted $YEAR, $ROUND, $WIN_ID_CURR, $OPP_ID_CURR, $WG, $OG
fi
done

