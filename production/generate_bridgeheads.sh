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
export BRIDGEHEADS_CONFIG_${upper_id}_FILEDISPATCHERBEAMID="beam-file.${id}.${BROKER_ID}"
export BRIDGEHEADS_CONFIG_${upper_id}_FOCUSBEAMID="focus.${id}.${BROKER_ID}"
export BRIDGEHEADS_CONFIG_${upper_id}_HUMANREADABLE="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_AFFILIATION="${human}"
export BRIDGEHEADS_CONFIG_${upper_id}_TOKENMANAGERID="token-manager.${id}.${BROKER_ID}"
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

# Sites: site|human-readable|production bridgehead|test bridgehead
# - site: the site in Keycloak (/projects/dktk/sites/<site>/...), shared by the site's bridgeheads.
# - human-readable: the display name of the Explorer (without the flag).
# - production / test bridgehead: the SITE_ID of the site's bridgehead on the broker of that environment (empty =
#   none); its Explorer collection id is lens-<bridgehead id>. A server offers the bridgeheads of its
#   DEPLOYMENT_ENVIRONMENT (PROD or TEST).
# A site with two bridgeheads in the same environment has one line per bridgehead.
# Commented rows: bridgeheads not offered at the moment (test instances not used, sites in no Explorer yet).
declare -A site_bridgeheads=()
while IFS='|' read -r site human production test; do
    [[ -z "$site" || "$site" == \#* ]] && continue
    if [[ "$deployment_environment" == "test" ]]; then id="$test"; else id="$production"; fi
    [[ -z "$id" ]] && continue
    # The group defaults to the bridgehead id; set it only when they differ.
    group=""
    [[ "$id" != "$site" ]] && group="$site"
    generate_bridgehead "$id" "$human" "$group"
    site_bridgeheads[$site]+="$id "
done <<EOF
berlin|Berlin (OBDS)||berlin
berlin|Berlin|berlin-test|berlin-test
bonn|Bonn|bonn|
dktk-test|DKTK-Test||dktk-test
dktk-datashield-test|DKTK Datashield Test||dktk-datashield-test
dresden|Dresden|dresden|dresden
#dresden|Dresden-Test||dresden-test
essen|Essen|essen|essen
#essen|Essen-Test||essen-test
frankfurt|Frankfurt|frankfurt|frankfurt
freiburg|Freiburg|freiburg|freiburg
#goettingen|Göttingen|goettingen|goettingen
hamburg|Hamburg|hamburg|hamburg
hannover|Hannover|hannover|hannover
luebeck|UKSH|luebeck|luebeck
#luebeck|UKSH-Test||luebeck-test
mainz|Mainz|mainz|mainz
mannheim|Mannheim|mannheim|mannheim
marburg|Marburg|marburg|
master|MASTER||master
muenchen-lmu|München(LMU)|muenchen-lmu|muenchen-lmu
muenchen-tum|München(TUM)|muenchen-tum|muenchen-tum
#tuebingen|Tübingen|tuebingen|tuebingen
ulm|Ulm|ulm|ulm
wuerzburg|Würzburg|wuerzburg|wuerzburg
EOF

# Contact data: site|contact-index|language|name|description|email-address
# One row for each translated contact variant; the email address on one row per contact (normally the first
# language row). A contact goes to every bridgehead of its site that this server offers.
while IFS='|' read -r site index language name description email_address; do
    [[ -z "$site" || "$site" == \#* ]] && continue
    for id in ${site_bridgeheads[$site]:-}; do
        generate_bridgehead_contact_language \
            "$id" "$index" "$language" "$name" "$description" "$email_address"
    done
done <<EOF
master|0|en|DKFZ/NCT/DKTK MASTER|DKFZ NCT MASTER team|master-projekte@nct-heidelberg.de
master|0|de|DKFZ/NCT/DKTK MASTER|DKFZ-NCT-MASTER-Team|
EOF
