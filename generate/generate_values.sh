#!/bin/bash

while true; do
    clear
    echo "---------------------- $(date) ------------------------"

curl -s "https://pr-mobile-a.cfl.lu/DatexII" | sed 's/utf-16/utf-8/' | iconv -f utf-8 -t utf-8 | xmllint --format - > parking.xml


printf "%-15s | %-20s | %-20s | %-15s\n" "Parking" "Parking capacity" "Occupied spaces" "Vacant spaces"
echo "-----------------------------------------------------------------------------"
#rodange
name=$(xmlstarlet sel -t -v "(//name)[2]" parking.xml)
total=$(xmlstarlet sel -t -v "(//carParkingCapacity)[1]" parking.xml)
vacant=$(xmlstarlet sel -t -v "(//numberOfVacantSpaces)[1]" parking.xml)
occupied=$(xmlstarlet sel -t -v "(//numberOfOccupiedSpaces)[1]" parking.xml)

printf "%-15s | %-20s | %-20s | %-15s\n" "$name" "$total" "$occupied" "$vacant"

echo "-----------------------------------------------------------------------------"

#Mersch
name=$(xmlstarlet sel -t -v "(//name)[3]" parking.xml)
total=$(xmlstarlet sel -t -v "(//carParkingCapacity)[2]" parking.xml)
vacant=$(xmlstarlet sel -t -v "(//numberOfVacantSpaces)[2]" parking.xml)
occupied=$(xmlstarlet sel -t -v "(//numberOfOccupiedSpaces)[2]" parking.xml)

printf "%-15s | %-20s | %-20s | %-15s\n" "$name" "$total" "$occupied" "$vacant"

echo "-----------------------------------------------------------------------------"
#Belval
name=$(xmlstarlet sel -t -v "(//name)[4]" parking.xml)
total=$(xmlstarlet sel -t -v "(//carParkingCapacity)[3]" parking.xml)
vacant=$(xmlstarlet sel -t -v "(//numberOfVacantSpaces)[3]" parking.xml)
occupied=$(xmlstarlet sel -t -v "(//numberOfOccupiedSpaces)[3]" parking.xml)

printf "%-15s | %-20s | %-20s | %-15s\n" "$name" "$total" "$occupied" "$vacant"

echo "-----------------------------------------------------------------------------"
#Lux gare
name=$(xmlstarlet sel -t -v "(//name)[5]" parking.xml)
total=$(xmlstarlet sel -t -v "(//carParkingCapacity)[4]" parking.xml)
vacant=$(xmlstarlet sel -t -v "(//numberOfVacantSpaces)[4]" parking.xml)
occupied=$(xmlstarlet sel -t -v "(//numberOfOccupiedSpaces)[4]" parking.xml)

printf "%-15s | %-20s | %-20s | %-15s\n" "$name" "$total" "$occupied" "$vacant"

echo "-----------------------------------------------------------------------------"
#Troisvierges
name=$(xmlstarlet sel -t -v "(//name)[6]" parking.xml)
total=$(xmlstarlet sel -t -v "(//carParkingCapacity)[5]" parking.xml)
vacant=$(xmlstarlet sel -t -v "(//numberOfVacantSpaces)[5]" parking.xml)
occupied=$(xmlstarlet sel -t -v "(//numberOfOccupiedSpaces)[5]" parking.xml)

printf "%-15s | %-20s | %-20s | %-15s\n" "$name" "$total" "$occupied" "$vacant"

echo "-----------------------------------------------------------------------------"
#Héienhaff
name=$(xmlstarlet sel -t -v "(//name)[7]" parking.xml)
total=$(xmlstarlet sel -t -v "(//carParkingCapacity)[6]" parking.xml)
vacant=$(xmlstarlet sel -t -v "(//numberOfVacantSpaces)[6]" parking.xml)
occupied=$(xmlstarlet sel -t -v "(//numberOfOccupiedSpaces)[6]" parking.xml)

printf "%-16s | %-20s | %-20s | %-15s\n" "$name" "$total" "$occupied" "$vacant"

echo "-----------------------------------------------------------------------------"

sleep 15
done 