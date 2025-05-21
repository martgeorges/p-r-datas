#!/bin/bash

while true; do
    clear
    echo "---------------------- $(date) ------------------------"

curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/{RDWRW}" | jq '.' > parking_R.json
curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/{FQMPE}" | jq '.' > parking_M.json
curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/{YAX3J}" | jq '.' > parking_B.json
curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/{P8K2N}" | jq '.' > parking_L.json
curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/{TWVD3}" | jq '.' > parking_T.json
curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/{MZJDR}" | jq '.' > parking_H.json

for file in parking_*.json; do
    #nom des P+R
    name=$(jq -r '.name' "$file")

    #Parking: capacityFull/
    total=$(jq -r '.totalCapacity' "$file")
    occ_ratio=$(jq -r '.currentTotalOccupancy' "$file")
    free=$(jq -r '.currentTotalFreeSpaces' "$file")

    #PMR stats
    pmr_tot=$(jq -r '.totalPMRCapacity' "$file")
    pmr_occ=$(jq -r '.currentPMROcuppancy' "$file")
    #pmr_free=$(jq -r '.currentPMRFreeSpaces' "$file")

    #Elec stats
    elec_tot=$(jq -r '.totalECarCapacity' "$file")
    elec_occ=$(jq -r '.currentECarOccupancy' "$file")
    #elec_free=$(jq -r '.currentECarFreeSpaces' "$file")

    #calc to do occupied and % (basic)
    occupied=$(printf "%.0f" $(echo "$total * $occ_ratio" | bc -l))
    std_pct=$(printf "%.0f" $(echo "$occ_ratio * 100" | bc -l))

    #calc to do occupied and % (PMR)
    occupied_pmr=$(printf "%.0f" $(echo "$pmr_tot * $pmr_occ" | bc -l))
    pct_pmr=$(printf "%.0f" $(echo "$pmr_occ * 100"| bc -l))

    #calc to do occupied and % (Elec)

    printf "%-25s | %-10s | %-10s | %-10s\n " "$name" "$total" "$occupied" "$std_pct"
done

sleep 15

done