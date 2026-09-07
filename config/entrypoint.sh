#!/bin/sh

# Every default below is applied with setdefault, so values supplied through
# the container environment can override image defaults.
setdefault() {
  eval "[ -n \"\${$1:-}\" ]" && return 0
  eval "export $1=\"\$2\""
}

# Export environment variables with base64-encoded content
setdefault EMAIL_CONTEXT_B64SUPPORTMINUSINFO "$(base64 -w 0 /app/email/templates/support-info.html)"
setdefault EMAIL_CONTEXT_B64TEAMMINUSSIGNATURE "$(base64 -w 0 /app/email/templates/team-signature.html)"
setdefault EMAIL_CONTEXT_B64PROJECTMINUSVIEWMINUSLINK "$(base64 -w 0 /app/email/templates/project-view-link.html)"
setdefault EMAIL_CONTEXT_B64RESEARCHMINUSENVIRONMENTMINUSLINK "$(base64 -w 0 /app/email/templates/research-environment-link.html)"


# Export other environment variables:

setdefault LOG_LEVEL "INFO"
setdefault ENABLE_CODER "true"
setdefault ENABLE_EMAILS "true"
setdefault ENABLE_EXPORTER "true"
setdefault ENABLE_FEASIBILITY "true"
#setdefault FEASIBILITY_MAPPING '[{"label": "Patients", "value": .totals.patients}, {"label": "Samples", "value": .totals.specimen}, {"label": "Molecular Data", "value": .totals.MolecularMarker}]'
setdefault FEASIBILITY_MAPPING '[{"label": "Patients", "value": .totals.patients}, {"label": "Samples", "value": .totals.specimen}]'
setdefault ENABLE_TOKEN_MANAGER "true"
setdefault SECURITY_ENABLED "true"

# Select cache policy: beta during active development; stable after release.
. /app/cache/cache-policy-beta.sh

setdefault FORM_FIELDS_DIRECTORY "/app/form/form-fields"
setdefault FORM_RESOURCES_DIRECTORY "/app/form/templates"
setdefault FORM_TEMPLATE_METADATA_DIRECTORY "/app/form/templates/metadata"
setdefault MAILING_BLACK_LIST_FILE_PATH "/app/email/mailing-black-list.txt"

setdefault EMAIL_TEMPLATES_CONFIG_PATH "/app/email/email-templates.json"
setdefault ACTION_MESSAGES_CONFIG_PATH "/app/action-messages.json"

# export BEAM_API_KEY="App1Secret" #################################### <= Please configure me
# export BEAM_PROJECT_MANAGER_ID="project-manager.proxy.broker.ccp-it.dktk.dkfz.de" #################################### <= Please configure me
# export BEAM_URL="http://beam-proxy:8081" #################################### <= Please configure me

setdefault BK_ADMIN_GROUP_PREFIX "DKTK_CCP_"
setdefault BK_ADMIN_GROUP_SUFFIX "_Verwalter"
setdefault BK_USER_GROUP_PREFIX "DKTK_CCP_"
setdefault BK_USER_GROUP_SUFFIX ""
# Comma-separated groups allowed to create requests without bridgehead membership.
setdefault RESEARCHER_GROUPS "app-ccp-explorer-intern,app-ccp-explorer-public"

setdefault CHECK_EXPIRED_ACTIVE_PROJECTS_CRON_EXPRESSION "30 * * * * *"

setdefault CODER_PATH_DATASHIELD "/app/coder/coder-datashield.json"
setdefault CODER_PATH_RESEARCHUNDERSCOREENVIRONMENT "/app/coder/coder-research-environment.json"
setdefault CODER_BASE_URL "https://dev.samply.de"
setdefault CODER_TEST_FILE_BEAM_ID ""
# export CODER_BEAM_ID_SUFFIX="proxy1.broker.ccp-it.dktk.dkfz.de" #################################### <= Please configure me
setdefault CODER_CREATE_PATH "/organizations/{CODER_ORGANISATION_ID}/members/{CODER_MEMBER_ID}/workspaces"
setdefault CODER_CRON_EXPRESSION "15 * * * * *"
setdefault CODER_DELETE_PATH "/workspaces/{CODER_WORKSPACE_ID}/builds"
# export CODER_MEMBER_ID="XXXX" #################################### <= Please configure me
# export CODER_ORGANISATION_ID="XXXX" #################################### <= Please configure me
# export CODER_SESSION_TOKEN="XXXX" #################################### <= Please configure me
setdefault CODER_TEMPLATE_VERSION_ID "b105a87d-19a4-40d0-bc00-f444976868da"

setdefault DATASHIELD_TEMPLATES "opal-ccp"
setdefault DB_ENCRYPTION_ALGORITHM "AES"
# export DB_ENCRYPTION_PRIVATE_KEY_IN_BASE64="XXXX" #################################### <= Please configure me

setdefault EMAIL_TEMPLATES_DIRECTORY "/app/email/templates"
setdefault EXPLORER_REDIRECT_URI_PARAMETER "redirect_uri"
setdefault EXPLORER_URL "https://demo.lens.samply.de"
setdefault FOCUS_LENS_PROJECT "dktk"

setdefault EXPORTER_CRON_EXPRESSION "*/30 * * * * *"
setdefault EXPORT_TEMPLATES "ccp,ccp-exliquid"
setdefault SAMPLES_TEMPLATES "ccp-sample-list"

setdefault MANAGE_TOKENS_CRON_EXPRESSION "0 * * * * *"

setdefault JWT_GROUPS_CLAIM "groups"
# export OIDC_CLIENT_ID="XXXX" #################################### <= Please configure me
# export OIDC_CLIENT_SECRET="XXXX" #################################### <= Please configure me
# export OIDC_URL="XXX" #################################### <= Please configure me

setdefault PM_ADMIN_GROUPS "admin-ccp-office"
setdefault PROJECT_DOCUMENTS_DIRECTORY "/app/documents"

setdefault PROJECT_MANAGER_EMAIL_FROM "noreply-verbis@dkfz-heidelberg.de"

setdefault RESEARCH_ENVIRONMENT_TEMPLATES "ccp,ccp-exliquid"

setdefault SPRING_MAIL_PRIMARY_HOST "mx-ext.inet.dkfz-heidelberg.de"
# export SPRING_MAIL_PRIMARY_PASSWORD=""
setdefault SPRING_MAIL_PRIMARY_PORT "25"
# export SPRING_MAIL_PRIMARY_USERNAME=""

# export TOKEN_MANAGER_URL="http://token-manager:3030" #################################### <= Please configure me

# Load frontend-related environment variables into the current shell.
. /app/frontend/frontend-environment.sh

# Generate bridgehead exports
/app/generate_bridgeheads.sh > /tmp/bridgeheads.env

# Load them into current shell
. /tmp/bridgeheads.env

# Now, run the Java application with the exported environment variables
exec java $JAVA_OPTS -jar /app/project-manager.jar
