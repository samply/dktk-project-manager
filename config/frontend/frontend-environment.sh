#!/bin/sh

export FRONTEND_PROJECT_CONFIG_PATH="/app/frontend/frontend-project-configs.json"
# export FRONTEND_BASEURL="http://project-manager-ui:8099" #################################### <= Please configure me
export FRONTEND_SITES_PROJECTMINUSDASHBOARD="/"
export FRONTEND_SITES_PROJECTMINUSVIEW="/project-view"
export ASSETS_DIRECTORY="/app/frontend/assets"

export FRONTEND_VARIABLES_LOGO_URL="${PROJECT_MANAGER_URL}/assets/logo-dktk-sign.svg"
export FRONTEND_VARIABLES_PROJECT_URL="https://dktk.dkfz.de/"
export FRONTEND_VARIABLES_LOGO_TEXT="dktk"
export FRONTEND_VARIABLES_LOGO_HTML="${PROJECT_MANAGER_URL}/assets/logo.html"
export FRONTEND_VARIABLES_LOGO_CSS="${PROJECT_MANAGER_URL}/assets/logo.css"

