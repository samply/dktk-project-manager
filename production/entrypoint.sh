#!/bin/sh

# PROD (default) or TEST: test servers set DEPLOYMENT_ENVIRONMENT=TEST and get the test defaults below.
DEPLOYMENT_ENVIRONMENT="${DEPLOYMENT_ENVIRONMENT:-PROD}"
case "$DEPLOYMENT_ENVIRONMENT" in
  PROD|TEST) ;;
  *) echo "DEPLOYMENT_ENVIRONMENT must be PROD or TEST, not '$DEPLOYMENT_ENVIRONMENT'" >&2; exit 1 ;;
esac
# Exported for generate_bridgeheads.sh (bridgeheads per environment).
export DEPLOYMENT_ENVIRONMENT

# Every default below is applied with setdefault, so values supplied through
# the container environment can override image defaults.
# Usage: setdefault <variable> <production default> [<test default>]
# Without a test default, test servers get the production default.
setdefault() {
  eval "[ -n \"\${$1:-}\" ]" && return 0
  if [ "$DEPLOYMENT_ENVIRONMENT" = "TEST" ] && [ $# -ge 3 ]; then
    setdefault_value="$3"
  else
    setdefault_value="$2"
  fi
  eval "export $1=\"\$setdefault_value\""
}

# Export environment variables with base64-encoded content
setdefault EMAIL_CONTEXT_B64SUPPORTMINUSINFO "$(base64 -w 0 /app/email/templates/support-info.html)"
setdefault EMAIL_CONTEXT_B64TEAMMINUSSIGNATURE "$(base64 -w 0 /app/email/templates/team-signature.html)"
setdefault EMAIL_CONTEXT_B64PROJECTMINUSVIEWMINUSLINK "$(base64 -w 0 /app/email/templates/project-view-link.html)"
setdefault EMAIL_CONTEXT_B64RESEARCHMINUSENVIRONMENTMINUSLINK "$(base64 -w 0 /app/email/templates/research-environment-link.html)"


# Export other environment variables:

setdefault LOG_LEVEL "INFO"
setdefault ENABLE_EMAILS "true"
setdefault ENABLE_EXPORTER "true"
setdefault ENABLE_FEASIBILITY "true"
setdefault ENABLE_LOCAL_APPROVAL "true"
#setdefault FEASIBILITY_MAPPING '[{"label": "Patients", "value": .totals.patients}, {"label": "Samples", "value": .totals.specimen}, {"label": "Molecular Data", "value": .totals.MolecularMarker}]'
setdefault FEASIBILITY_MAPPING '[{"label": "Patients", "value": .totals.patients}, {"label": "Samples", "value": .totals.specimen}]'
setdefault SECURITY_ENABLED "true"

# Select cache policy: beta during active development; stable after release.
. /app/cache/cache-policy-beta.sh

setdefault FORM_FIELDS_DIRECTORY "/app/form/form-fields"
setdefault FORM_RESOURCES_DIRECTORY "/app/form/templates"
setdefault FORM_TEMPLATE_METADATA_DIRECTORY "/app/form/templates/metadata"
setdefault MAILING_BLACK_LIST_FILE_PATH "/app/email/mailing-black-list.txt"

setdefault EMAIL_TEMPLATES_CONFIG_PATH "/app/email/email-templates.json"
setdefault ACTION_MESSAGES_CONFIG_PATH "/app/action-messages.json"
setdefault DISPLAY_FORMATS_CONFIG_PATH "/app/display-formats.json"
setdefault DEFAULT_DATE_FORM_FIELD_DISPLAY_FORMAT "DATE_FORMAT"
setdefault DEFAULT_TIMESTAMP_FORM_FIELD_DISPLAY_FORMAT "DATE_TIME_FORMAT"
setdefault PROJECT_ID_TEMPLATE "REQ-{{YEAR}}-{{SEQUENCE:4}}"
setdefault EXPORTER_QUERY_LABEL_TEMPLATE "[{{PROJECT_CODE}}] {{QUERY_LABEL}}"

# export BEAM_API_KEY="App1Secret" #################################### <= Please configure me
# export BEAM_PROJECT_MANAGER_ID="project-manager.proxy.broker.ccp-it.dktk.dkfz.de" #################################### <= Please configure me
# export BEAM_URL="http://beam-proxy:8081" #################################### <= Please configure me

# Groups are Keycloak (VerbIS realm) paths as Keycloak shows them; the backend ignores the leading slash.
# The same groups serve test and production. Site admins: /projects/dktk/sites/<bridgehead id>/admin.
setdefault BK_ADMIN_GROUP_PREFIX "/projects/dktk/sites/"
setdefault BK_ADMIN_GROUP_SUFFIX "/admin"
setdefault BK_USER_GROUP_PREFIX "/projects/dktk/sites/"
setdefault BK_USER_GROUP_SUFFIX ""
# Comma-separated groups allowed to create requests without bridgehead membership.
# Everyone who can use the Explorer of the server: production dktk-prod-explorer, test dktk-dev-explorer.
setdefault RESEARCHER_GROUPS "/apps/dktk-prod-explorer" "/apps/dktk-dev-explorer"

setdefault CHECK_EXPIRED_ACTIVE_PROJECTS_CRON_EXPRESSION "30 * * * * *"


setdefault DATASHIELD_TEMPLATES "opal-ccp"
setdefault DB_ENCRYPTION_ALGORITHM "AES"
# export DB_ENCRYPTION_PRIVATE_KEY_IN_BASE64="XXXX" #################################### <= Please configure me

setdefault EMAIL_TEMPLATES_DIRECTORY "/app/email/templates"
setdefault EXPLORER_REDIRECT_URI_PARAMETER "redirect_uri"
#setdefault EXPLORER_URL "https://demo.lens.samply.de"
setdefault EXPLORER_URL "https://data.dktk.dkfz.de"
setdefault FOCUS_LENS_PROJECT "dktk"

setdefault EXPORTER_CRON_EXPRESSION "*/30 * * * * *"
setdefault EXPORT_TEMPLATES "ccp,ccp-exliquid"
setdefault SAMPLES_TEMPLATES "ccp-sample-list"


setdefault JWT_GROUPS_CLAIM "groups"
# export OIDC_CLIENT_ID="XXXX" #################################### <= Please configure me
# export OIDC_CLIENT_SECRET="XXXX" #################################### <= Please configure me
# export OIDC_URL="XXX" #################################### <= Please configure me

# Keycloak group path (see the site groups above).
setdefault PM_ADMIN_GROUPS "/projects/dktk/project-manager-admin"
setdefault PROJECT_DOCUMENTS_DIRECTORY "/app/documents"

setdefault PROJECT_MANAGER_EMAIL_FROM "noreply-verbis@dkfz-heidelberg.de"

setdefault RESEARCH_ENVIRONMENT_TEMPLATES "ccp,ccp-exliquid"

setdefault SPRING_MAIL_PRIMARY_HOST "mx-ext.inet.dkfz-heidelberg.de"
# export SPRING_MAIL_PRIMARY_PASSWORD=""
setdefault SPRING_MAIL_PRIMARY_PORT "25"
# export SPRING_MAIL_PRIMARY_USERNAME=""


# Load frontend-related environment variables into the current shell.
. /app/frontend/frontend-environment.sh

# Generate bridgehead exports
/app/generate_bridgeheads.sh > /tmp/bridgeheads.env

# Load them into current shell
. /tmp/bridgeheads.env

# Now, run the Java application with the exported environment variables
exec java $JAVA_OPTS -jar /app/project-manager.jar
