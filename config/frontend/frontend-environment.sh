#!/bin/sh

# Sourced by /app/entrypoint.sh, which defines setdefault.
setdefault FRONTEND_PROJECT_CONFIG_PATH "/app/frontend/frontend-project-configs.json"
# export FRONTEND_BASEURL="http://project-manager-ui:8099" #################################### <= Please configure me
setdefault FRONTEND_SITES_PROJECTMINUSDASHBOARD "/"
setdefault FRONTEND_SITES_PROJECTMINUSVIEW "/project-view"
setdefault ASSETS_DIRECTORY "/app/frontend/assets"

setdefault FRONTEND_VARIABLES_LOGO_URL "${BACKEND_BASEURL}/assets/logo-dktk-sign.svg"
setdefault FRONTEND_VARIABLES_PROJECT_URL "https://dktk.dkfz.de/"
setdefault FRONTEND_VARIABLES_LOGO_TEXT "dktk"
setdefault FRONTEND_VARIABLES_LOGO_HTML "${BACKEND_BASEURL}/assets/logo.html"
setdefault FRONTEND_VARIABLES_LOGO_CSS "${BACKEND_BASEURL}/assets/logo.css"
setdefault FRONTEND_VARIABLES_FRONTEND_NAME "<b>DKTK BioDataHub</b> Data Request"
setdefault FRONTEND_VARIABLES_PAGE_TITLE "Data Request"
setdefault FRONTEND_VARIABLES_FEASIBILITY_PAGE_SIZE "5"
# Lines shown for a normal form-field description before the UI offers "Show more".
setdefault FRONTEND_VARIABLES_FORM_FIELD_DESCRIPTION_COLLAPSED_LINES "2"
setdefault FRONTEND_VARIABLES_DEFAULT_ERROR_MESSAGE_FOR_USER_ACTIONS "The action could not be completed. Please try again. If the problem persists, please contact technical support at biodatahub@dkfz-heidelberg.de."
