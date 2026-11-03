#!/bin/bash

# Prints the BRIDGEHEADS_CONFIG_<ID>_* exports of the bridgeheads of this server (DEPLOYMENT_ENVIRONMENT: PROD or
# TEST, default PROD). Inventory and the reasons per bridgehead: project-manager-ops bridgeheads/dktk.md.
deployment_environment=$(echo "${DEPLOYMENT_ENVIRONMENT:-PROD}" | tr '[:upper:]' '[:lower:]')

upper_id() {
    echo "$1" \
        | tr '[:lower:]' '[:upper:]' \
        | sed 's/-/MINUS/g'
}

generate_bridgehead() {
    local id="$1"
    local human="$2"
    local group="$3"

    local upper_id
    upper_id=$(upper_id "$id")

    cat <<EOF
export BRIDGEHEADS_CONFIG_${upper_id}_EXPLORERID="lens-${id}"
export BRIDGEHEADS_CONFIG_${upper_id}_FILEDISPATCHERBEAMID="beam-file.${id}.broker.ccp-it.dktk.dkfz.de"
export BRIDGEHEADS_CONFIG_${upper_id}_FOCUSBEAMID="focus.${id}.broker.ccp-it.dktk.dkfz.de"
export BRIDGEHEADS_CONFIG_${upper_id}_HUMANREADABLE="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_AFFILIATION="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_TOKENMANAGERID="token-manager.${id}.broker.ccp-it.dktk.dkfz.de"
EOF
    if [[ -n "$group" ]]; then
        echo "export BRIDGEHEADS_CONFIG_${upper_id}_GROUP=\"${group}\""
    fi
    echo
}

generate_bridgehead_contact_language() {
    local id="$1"
    local index="$2"
    local language="$3"
    local name="$4"
    local description="$5"
    local email_address="$6"

    local upper_id
    upper_id=$(upper_id "$id")
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

# Bridgeheads: id|human-readable|environments|group
# - human-readable: the display name of the Explorer.
# - environments: prod, test or prod,test (the servers that offer the bridgehead).
# - group: the group of the identity provider (/projects/dktk/bridgeheads/<group>/user, .../admin); empty = the id.
# Commented rows: bridgeheads not offered at the moment (test instances, not in any Explorer yet).
active_bridgeheads=" "
while IFS='|' read -r id human environments group; do
    [[ -z "$id" || "$id" == \#* ]] && continue
    [[ ",${environments}," == *",${deployment_environment},"* ]] || continue
    generate_bridgehead "$id" "$human" "$group"
    active_bridgeheads+="${id} "
done <<EOF
berlin|Berlin (OBDS)|test|
berlin-test|Berlin|prod,test|berlin
bonn|Bonn|prod|
dktk-test|DKTK-Test|test|
dktk-datashield-test|DKTK Datashield Test|test|
dresden|Dresden|prod,test|
#dresden-test|Dresden-Test|test|dresden
essen|Essen|prod,test|
#essen-test|Essen-Test|test|essen
frankfurt|Frankfurt|prod,test|
freiburg|Freiburg|prod,test|
#goettingen|Göttingen|prod,test|
hamburg|Hamburg|prod,test|
hannover|Hannover|prod,test|
luebeck|UKSH|prod,test|
#luebeck-test|UKSH-Test|test|luebeck
mainz|Mainz|prod,test|
mannheim|Mannheim|prod,test|
marburg|Marburg|prod|
master|MASTER|test|
muenchen-lmu|München(LMU)|prod,test|
muenchen-tum|München(TUM)|prod,test|
#tuebingen|Tübingen|prod,test|
ulm|Ulm|prod,test|
wuerzburg|Würzburg|prod,test|
EOF

# Contact data: bridgehead-id|contact-index|language|name|description|email-address
# Add one row for each translated contact variant. Put the email address on one
# row per contact (normally the first language row). Rows of bridgeheads that this
# server does not offer are skipped (any variable of a bridgehead registers it).
while IFS='|' read -r id index language name description email_address; do
    [[ -z "$id" || "$id" == \#* ]] && continue
    [[ "$active_bridgeheads" == *" ${id} "* ]] || continue
    generate_bridgehead_contact_language \
        "$id" "$index" "$language" "$name" "$description" "$email_address"
done <<EOF
master|0|en|DKFZ/NCT/DKTK MASTER|DKFZ NCT MASTER team|master-projekte@nct-heidelberg.de
master|0|de|DKFZ/NCT/DKTK MASTER|DKFZ-NCT-MASTER-Team|
EOF
