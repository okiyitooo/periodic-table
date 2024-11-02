#!/bin/bash

if [ -z "$1" ]; then
    echo "Please provide an element as an argument."
    exit 0
fi
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $1 =~ ^[0-9]+$ ]]; then
    ELEMENT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING (type_id) WHERE atomic_number=$1;")
else
    ELEMENT=$($PSQL "SELECT * FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING (type_id) WHERE symbol='$1' OR name='$1';")
fi
if [[ -z $ELEMENT ]]; then
 echo "I could not find that element in the database."
else
 echo $ELEMENT | while IFS='|' read type_id atomic_number atomic_mass melting_point_celsius boiling_point_celsius symbol name type; do
 echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
 done;
fi
