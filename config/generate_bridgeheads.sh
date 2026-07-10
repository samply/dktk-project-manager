#!/bin/bash

generate_bridgehead() {
    local id="$1"
    local human="$2"

    local upper_id
    upper_id=$(echo "$id" \
        | tr '[:lower:]' '[:upper:]' \
        | sed 's/-/MINUS/g')

    cat <<EOF
export BRIDGEHEADS_CONFIG_${upper_id}_EXPLORERID="lens-${id}"
export BRIDGEHEADS_CONFIG_${upper_id}_FILEDISPATCHERBEAMID="beam-file.${id}.broker.ccp-it.dktk.dkfz.de"
export BRIDGEHEADS_CONFIG_${upper_id}_FOCUSBEAMID="focus.${id}.broker.ccp-it.dktk.dkfz.de"
export BRIDGEHEADS_CONFIG_${upper_id}_HUMANREADABLE="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_AFFILIATION="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_TOKENMANAGERID="token-manager.${id}.broker.ccp-it.dktk.dkfz.de"

EOF
}

# List of sites: id|human-readable
while IFS='|' read -r id human; do
    generate_bridgehead "$id" "$human"
done <<EOF
berlin|Berlin
bonn|Bonn
dktk-test|DKTK Test
dktk-datashield-test|DKTK DataSHIELD Test
dresden|Dresden
dresden-test|Dresden Test
essen|Essen
frankfurt|Frankfurt
freiburg|Freiburg
hamburg|Hamburg
hannover|Hannover
luebeck|Lübeck
mainz|Mainz
mannheim|Mannheim
marburg|Marburg
master|MASTER
muenchen-lmu|München LMU
muenchen-tum|München TUM
tuebingen|Tübingen
ulm|Ulm
wuerzburg|Würzburg
EOF