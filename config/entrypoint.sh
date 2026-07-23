#!/bin/sh


# Export environment variables with base64-encoded content
export EMAIL_CONTEXT_B64SUPPORTMINUSINFO="$(base64 -w 0 /app/email/templates/support-info.html)"
export EMAIL_CONTEXT_B64TEAMMINUSSIGNATURE="$(base64 -w 0 /app/email/templates/team-signature.html)"
export EMAIL_CONTEXT_B64PROJECTMINUSVIEWMINUSLINK="$(base64 -w 0 /app/email/templates/project-view-link.html)"
export EMAIL_CONTEXT_B64RESEARCHMINUSENVIRONMENTMINUSLINK="$(base64 -w 0 /app/email/templates/research-environment-link.html)"


# Export other environment variables:

export LOG_LEVEL="INFO"
export ENABLE_CODER="true"
export ENABLE_EMAILS="true"
export ENABLE_EXPORTER="true"
export ENABLE_TOKEN_MANAGER="true"
export SECURITY_ENABLED="true"

export FORM_FIELDS_DIRECTORY="/app/form/form-fields"
export FORM_RESOURCES_DIRECTORY="/app/form/templates"
export FORM_TEMPLATE_METADATA_DIRECTORY="/app/form/templates/metadata"

export EMAIL_TEMPLATES_CONFIG_PATH="/app/email/email-templates.json"
export ACTION_EXPLANATION_CONFIG_PATH="/app/action-explanations.json"

# export BEAM_API_KEY="App1Secret" #################################### <= Please configure me
# export BEAM_PROJECT_MANAGER_ID="project-manager.proxy.broker.ccp-it.dktk.dkfz.de" #################################### <= Please configure me
# export BEAM_URL="http://beam-proxy:8081" #################################### <= Please configure me

export BK_ADMIN_GROUP_PREFIX="DKTK_CCP_"
export BK_ADMIN_GROUP_SUFFIX="_Verwalter"
export BK_USER_GROUP_PREFIX="DKTK_CCP_"
export BK_USER_GROUP_SUFFIX=""

export CHECK_EXPIRED_ACTIVE_PROJECTS_CRON_EXPRESSION="30 * * * * *"

export CODER_PATH_DATASHIELD="/app/coder/coder-datashield.json"
export CODER_PATH_RESEARCHUNDERSCOREENVIRONMENT="/app/coder/coder-research-environment.json"
export CODER_BASE_URL="https://dev.samply.de"
export CODER_TEST_FILE_BEAM_ID=""
# export CODER_BEAM_ID_SUFFIX="proxy1.broker.ccp-it.dktk.dkfz.de" #################################### <= Please configure me
export CODER_CREATE_PATH="/organizations/{CODER_ORGANISATION_ID}/members/{CODER_MEMBER_ID}/workspaces"
export CODER_CRON_EXPRESSION="15 * * * * *"
export CODER_DELETE_PATH="/workspaces/{CODER_WORKSPACE_ID}/builds"
# export CODER_MEMBER_ID="XXXX" #################################### <= Please configure me
# export CODER_ORGANISATION_ID="XXXX" #################################### <= Please configure me
# export CODER_SESSION_TOKEN="XXXX" #################################### <= Please configure me
export CODER_TEMPLATE_VERSION_ID="b105a87d-19a4-40d0-bc00-f444976868da"

export DATASHIELD_TEMPLATES="opal-ccp"
export DB_ENCRYPTION_ALGORITHM="AES"
# export DB_ENCRYPTION_PRIVATE_KEY_IN_BASE64="XXXX" #################################### <= Please configure me

export EMAIL_TEMPLATES_DIRECTORY="/app/email/templates"
export EXPLORER_REDIRECT_URI_PARAMETER="redirect_uri"
export EXPLORER_URL="https://demo.lens.samply.de"

export EXPORTER_CRON_EXPRESSION="*/30 * * * * *"
export EXPORT_TEMPLATES="ccp,ccp-exliquid"
export SAMPLES_TEMPLATES="ccp-sample-list"

export MANAGE_TOKENS_CRON_EXPRESSION="0 * * * * *"

export JWT_GROUPS_CLAIM="groups"
# export OIDC_CLIENT_ID="XXXX" #################################### <= Please configure me
# export OIDC_CLIENT_SECRET="XXXX" #################################### <= Please configure me
# export OIDC_URL="XXX" #################################### <= Please configure me

export PM_ADMIN_GROUPS="admin-ccp-office"
export PROJECT_DOCUMENTS_DIRECTORY="/app/documents"

export PROJECT_MANAGER_EMAIL_FROM="noreply-verbis@dkfz-heidelberg.de"

export RESEARCH_ENVIRONMENT_TEMPLATES="ccp,ccp-exliquid"

export SPRING_MAIL_PRIMARY_HOST="mx-ext.inet.dkfz-heidelberg.de"
# export SPRING_MAIL_PRIMARY_PASSWORD=""
export SPRING_MAIL_PRIMARY_PORT="25"
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
