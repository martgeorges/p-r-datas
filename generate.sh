#!/bin/bash

mkdir -p data
HTML_FILE="index.html"

while true; do
    clear
    echo "---------------------- $(date) ------------------------"

    # Téléchargement JSON
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/RDWRW" -o data/parking_R.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/FQMPE" -o data/parking_M.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/YAX3J" -o data/parking_B.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/P8K2N" -o data/parking_L.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/TWVD3" -o data/parking_T.json
    curl -s "https://pr-mobile-a.cfl.lu/OpenData/ParkAndRide/MZJDR" -o data/parking_H.json

    printf "+----------------------------+------------+----------+---------------+------------------+------------+----------------+------------------+------------+----------------+\n"
    printf "| %-26s | %-10s | %-9s | %-13s | %-17s | %-11s | %-14s | %-16s | %-11s | %-14s |\n" \
        "P+R" "Max" "Occupées" "Occupation %" \
        "Places Élec" "Occupées" "Occupation %" \
        "Places PMR" "Occupées" "Occupation %"
    printf "+----------------------------+------------+----------+---------------+------------------+------------+----------------+------------------+------------+----------------+\n"

    cat <<EOF > "$HTML_FILE"
<html>
<head>
    <meta http-equiv="refresh" content="16">
    <title>Parking datas</title>
        <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        .container {
            display: flex;
            justify-content: space-between;
            gap: 20px;
        }
        .box {
            flex: 1;
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            text-align: center;
            height: 245px;
        }
        .box h2 {
            margin-top: 0;
            color: #333;
        }
        .box p {
            color: #555;
        }
    </style>
</head>
<body>
    <div align="center">
        <h1>P+R datas - $(date)</h1>
        <table border="1" cellspacing="0" cellpadding="5">
        <tr>
            <th>P + R</th><th>Max Capacity</th><th>Occupied</th><th>% Occupied</th>
            <th>Max Capacity elec</th><th>Elec occ.</th><th>% Elec occ.</th>
            <th>Max Capacity PMR</th><th>PMR occ.</th><th>% PMR occ.</th>
        </tr>
EOF

    for file in data/parking_*.json; do
        name=$(jq -r '.name' "$file")
        total=$(jq -r '.totalCapacity' "$file")
        occ_ratio=$(jq -r '.currentTotalOccupancy' "$file")
        occupied=$(printf "%.0f" "$(echo "$total * $occ_ratio" | bc -l)")
        pct_occupied=$(printf "%.0f" "$(echo "$occ_ratio * 100" | bc -l)")

        pmr_tot=$(jq -r '.totalPMRCapacity' "$file")
        pmr_occ_ratio=$(jq -r '.currentPMROcuppancy' "$file")
        pmr_occ=$(printf "%.0f" "$(echo "$pmr_tot * $pmr_occ_ratio" | bc -l)")
        pct_pmr=$(printf "%.0f" "$(echo "$pmr_occ_ratio * 100" | bc -l)")

        elec_tot=$(jq -r '.totalECarCapacity' "$file")
        elec_occ_ratio=$(jq -r '.currentECarOccupancy' "$file")
        elec_occ=$(printf "%.0f" "$(echo "$elec_tot * $elec_occ_ratio" | bc -l)")
        pct_elec=$(printf "%.0f" "$(echo "$elec_occ_ratio * 100" | bc -l)")

        printf "| %-26s | %-10s | %-8s | %-13s | %-16s | %-10s | %-14s | %-16s | %-10s | %-14s |\n" \
            "$name" "$total" "$occupied" "$pct_occupied%" \
            "$elec_tot" "$elec_occ" "$pct_elec%" \
            "$pmr_tot" "$pmr_occ" "$pct_pmr%"

        printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s%%</td><td>%s</td><td>%s</td><td>%s%%</td><td>%s</td><td>%s</td><td>%s%%</td></tr>\n" \
            "$name" "$total" "$occupied" "$pct_occupied" \
            "$elec_tot" "$elec_occ" "$pct_elec" \
            "$pmr_tot" "$pmr_occ" "$pct_pmr" >> "$HTML_FILE"
    
    done

    printf "+----------------------------+------------+----------+---------------+------------------+------------+----------------+------------------+------------+----------------+\n"



    cat <<EOF >> "$HTML_FILE"
        </table>
    </div>
    <div align="center" style="margin-top: 40px;">
        <h1>P+R datas graphics</h1>
    </div>
    <div class="container">
EOF
    for file in data/parking_B.json; do
        name=$(jq -r '.name' "$file")
done
    cat <<EOF >> "$HTML_FILE"
        <div class="box">
            <h2>$name</h2>
            <p>datas will fit here</p>
        </div>
EOF
    for file in data/parking_H.json; do
        name=$(jq -r '.name' "$file")
done
    cat <<EOF >> "$HTML_FILE"
        <div class="box">
            <h2>$name</h2>
            <p>datas will fit here</p>
        </div>
EOF
    for file in data/parking_L.json; do
        name=$(jq -r '.name' "$file")
done
    cat <<EOF >> "$HTML_FILE"
        <div class="box">
            <h2>$name</h2>
            <p>datas will fit here</p>
        </div>
    </div>
    <div class="container" style="margin-top: 30px;">
EOF
    for file in data/parking_M.json; do
        name=$(jq -r '.name' "$file")
done
    cat <<EOF >> "$HTML_FILE"
        <div class="box">
            <h2>$name</h2>
            <p>datas will fit here</p>
        </div>
EOF
    for file in data/parking_R.json; do
        name=$(jq -r '.name' "$file")
done
    cat <<EOF >> "$HTML_FILE"
        <div class="box">
            <h2>$name</h2>
            <p>datas will fit here</p>
        </div>
EOF
    for file in data/parking_T.json; do
        name=$(jq -r '.name' "$file")
done
    cat <<EOF >> "$HTML_FILE"
        <div class="box">
            <h2>$name</h2>
            <p>datas will fit here</p>
        </div>
</body>
</html>
EOF

    echo "---> [OK] ✅"
    sleep 15
done
