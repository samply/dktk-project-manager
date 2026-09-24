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

generate_bridgehead_contact_language() {
    local id="$1"
    local index="$2"
    local language="$3"
    local name="$4"
    local description="$5"
    local email_address="$6"

    local upper_id
    upper_id=$(echo "$id" \
        | tr '[:lower:]' '[:upper:]' \
        | sed 's/-/MINUS/g')
    local upper_language
    upper_language=$(echo "$language" | tr '[:lower:]' '[:upper:]')

cat <<EOF
export BRIDGEHEADS_CONFIG_${upper_id}_CONTACTS_${index}_NAME_${upper_language}="${name}"
export BRIDGEHEADS_CONFIG_${upper_id}_CONTACTS_${index}_DESCRIPTION_${upper_language}="${description}"
EOF

if [[ -n "$email_address" ]]; then
    cat <<EOF
export BRIDGEHEADS_CONFIG_${upper_id}_CONTACTS_${index}_EMAILADDRESS="${email_address}"

EOF
fi
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

# Contact data: bridgehead-id|contact-index|language|name|description|email-address
# Add one row for each translated contact variant. Put the email address on one
# row per contact (normally the first language row).
while IFS='|' read -r id index language name description email_address; do
    [[ -z "$id" || "$id" == \#* ]] && continue
    generate_bridgehead_contact_language \
        "$id" "$index" "$language" "$name" "$description" "$email_address"
done <<EOF
master|0|en|DKFZ/NCT/DKTK MASTER|DKFZ NCT MASTER team|master-projekte@nct-heidelberg.de
master|0|de|DKFZ/NCT/DKTK MASTER|DKFZ-NCT-MASTER-Team|
EOF
