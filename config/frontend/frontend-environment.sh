#!/bin/sh

export FRONTEND_PROJECT_CONFIG_PATH="/app/frontend/frontend-project-configs.json"
# export FRONTEND_BASEURL="http://project-manager-ui:8099" #################################### <= Please configure me
export FRONTEND_SITES_PROJECTMINUSDASHBOARD="/"
export FRONTEND_SITES_PROJECTMINUSVIEW="/project-view"
export ASSETS_DIRECTORY="/app/frontend/assets"

export FRONTEND_VARIABLES_LOGO_URL="${BACKEND_BASEURL}/assets/logo-dktk-sign.svg"
export FRONTEND_VARIABLES_PROJECT_URL="https://dktk.dkfz.de/"
export FRONTEND_VARIABLES_LOGO_TEXT="dktk"
export FRONTEND_VARIABLES_LOGO_HTML="${BACKEND_BASEURL}/assets/logo.html"
export FRONTEND_VARIABLES_LOGO_CSS="${BACKEND_BASEURL}/assets/logo.css"
export FRONTEND_VARIABLES_FRONTEND_NAME="<b>DKTK BioDataHub</b> Data Request"
export FRONTEND_VARIABLES_PAGE_TITLE="Data Request"
export FRONTEND_VARIABLES_FEASIBILITY_PAGE_SIZE="5"
