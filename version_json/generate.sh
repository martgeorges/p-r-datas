#!/bin/bash

mkdir -p data public
HTML_FILE="public/index.html"

while true; do
    clear
    echo "---------------------- $(date) ------------------------"

    # Téléchargement JSON (URLs fixes)
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/RDWRW" -o data/parking_R.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/FQMPE" -o data/parking_M.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/YAX3J" -o data/parking_B.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/P8K2N" -o data/parking_L.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/TWVD3" -o data/parking_T.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/MZJDR" -o data/parking_H.json

     printf "%-28s %-12s %-10s %-13s %-18s %-13s %-15s %-18s %-13s %-13s\n" \
        "P+R Ville" "Capacité" "Occupé" "Occupation %" \
        "Places Élec" "Occupées" "Occupation %" \
        "Places PMR" "Occupées" "Occupation %"
    echo "------------------------------------------------------------------------------------------------------------------------------------"

    cat <<EOF > "$HTML_FILE"
    <html>
    <head>
        <meta http-equiv="refresh" content="16">
        <title>État des parkings</title>
    </head>
    <body>
        <div align="center">
            <h2>P+R datas - $(date)</h2>
                <table border="1" cellspacing="0" cellpadding="5">
                <tr>
                    <th>P + R</th><th>Capacity Max</th><th>Occupied</th><th>% Occupied</th>
                    <th>Capacity max elec</th><th>Elec occ.</th><th>% Elec occ.</th>
                    <th>Capacity max PMR</th><th>PMR occ.</th><th>% PMR occ.</th>
                </tr>
EOF

    for file in data/parking_*.json; do

        #nom du parking
        name=$(jq -r '.name' "$file")
        #datas standard pour les parkings
        total=$(jq -r '.totalCapacity' "$file")
        occ_ratio=$(jq -r '.currentTotalOccupancy' "$file")
        occupied=$(printf "%.0f" "$(echo "$total * $occ_ratio" | bc -l)")
        pct_occupied=$(printf "%.0f" "$(echo "$occ_ratio * 100" | bc -l)")

        #datas pour les places pmr 
        pmr_tot=$(jq -r '.totalPMRCapacity' "$file")
        pmr_occ_ratio=$(jq -r '.currentPMROcuppancy' "$file")
        pmr_occ=$(printf "%.0f" "$(echo "$pmr_tot * $pmr_occ_ratio" | bc -l)")
        pct_pmr=$(printf "%.0f" "$(echo "$pmr_occ_ratio * 100" | bc -l)")

        #datas pour les places elecs
        elec_tot=$(jq -r '.totalECarCapacity' "$file")
        elec_occ_ratio=$(jq -r '.currentECarOccupancy' "$file")
        elec_occ=$(printf "%.0f" "$(echo "$elec_tot * $elec_occ_ratio" | bc -l)")
        pct_elec=$(printf "%.0f" "$(echo "$elec_occ_ratio * 100" | bc -l)")

        # retour sur l'output 
        printf "%-28s %-12s %-10s %-13s %-18s %-13s %-15s %-18s %-13s %-13s\n" \
            "$name" "$total" "$occupied" "$pct_occupied%" \
            "$elec_tot" "$elec_occ" "$pct_elec%" \
            "$pmr_tot" "$pmr_occ" "$pct_pmr%"

        printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s%%</td><td>%s</td><td>%s</td><td>%s%%</td><td>%s</td><td>%s</td><td>%s%%</td></tr>\n" \
            "$name" "$total" "$occupied" "$pct_occupied" \
            "$elec_tot" "$elec_occ" "$pct_elec" \
            "$pmr_tot" "$pmr_occ" "$pct_pmr" >> "$HTML_FILE"
    done
    # Fin HTML
    cat <<EOF >> "$HTML_FILE"
        </table>
    </div>
</body>
</html>
EOF

    sleep 15
done