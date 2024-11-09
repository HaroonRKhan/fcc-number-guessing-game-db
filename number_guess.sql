#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USER_NAME
USER_AVAILABLE=$($PSQL "SELECT user_name FROM users WHERE user_name='$USER_NAME'")
GAME_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(user_id) WHERE user_name='$USER_NAME'")
Best_GAME=$($PSQL "SELECT MIN(number_guesses) FROM users INNER JOIN games USING(user_id) WHERE user_name='$USER_NAME'")

if [[ -z $USER_AVAILABLE ]]
then
  USER_INSERTED=$($PSQL "INSERT INTO users(user_name) VALUES('$USER_NAME')")
  echo "Welcome, $USER_NAME! It looks like this is your first time here."
else
  echo "Welcome back, $USER_NAME! You have played $GAME_PLAYED games, and your best game took $Best_GAME guesses."
fi

SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
# echo $SECRET_NUMBER
echo "Guess the secret number between 1 and 1000:"
NO_OF_GUESSES=1
while read YOUR_GUESS
do
  if [[ ! $YOUR_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
      if [[ $YOUR_GUESS -eq $SECRET_NUMBER ]]
      then
        break;
      else
        if [[ $YOUR_GUESS -gt $SECRET_NUMBER ]]
        then
          echo "It's lower than that, guess again:"
        elif [[ $YOUR_GUESS -lt $SECRET_NUMBER ]]
        then
          echo "It's higher than that, guess again:"
        fi
      fi
  fi
  NO_OF_GUESSES=$(( $NO_OF_GUESSES + 1 ))
done
if [[ $NO_OF_GUESSES == 1 ]]
then
  echo "You guessed it in $NO_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
else
  echo "You guessed it in $NO_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
fi
USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name='$USER_NAME'")
INSERT_GUESSES=$($PSQL "INSERT INTO games(number_guesses, user_id) VALUES($NO_OF_GUESSES, $USER_ID)")
