# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.0.1 - 2026-09-09]
### Added
- CHANGELOG
- Dockerfile
- Public documents
- Templates
- Bridgehead configuration
- Gitlab CI
- Action Explanations Config
- Project manager admin new project message
- New project accepted messages
- New votum message
- '<support-info/>' and '<team-signature/>' email context variables
- Invitation to a project message
- Bridgehead admin technical approval message
- Notification of Bridgehead admin authorization or revocation messages
- Notification regarding Acceptance, rejection or changes request of script messages
- Notification regarding Acceptance, rejection or changes request of final results messages
- Notification regarding Acceptance, rejection or changes request of final analysis results messages
- Authentication Script messages
- Project finished message
- New publication message
- '<project-view-link/>' project view url with format
- Project view link in all templates
- More space between Dear ... and the rest of the message
- Reject project message
- Blocking message in rejection email templates
- Query saved (and executed) in Teiler messages
- Title and description in project configuration
- Error message if a query is sent with an error
- Send error email if error while sending a query to bridgehead
- Mention to Exporter App for Teiler executions of the query
- Result templates
- Create send credentials and find send credentials templates
- Messages of email templates related to the results
- Action Explanations regarding the results
- Email template for NEW_VOTUM_FOR_ALL_BRIDGEHEADS
- Research Environment Link
- DB_ENCRYPTION_ALGORITHM variable
- Coder configuration
- APP_ID and APP_SECRET variables to coder templates
- Authentik configuration
- Sample Form
- Clinical Data Form
- Samples form the template
- Logos in samples form the template
- DataType in a sample template
- Form template metadata for samples
- Project form fields for samples
- Group fields in samples from the template
- Form config
- Development Environment
- Configurable localized display formats without database or form-value persistence changes
- Localized DATE values in generated form PDFs
- Samples as service in configuration
- Project and Forms configuration
- Output format and template id in samples config
- Data and Samples configuration
- Cohort, Samples and Project configuration
- Generate bridgeheads
- Query forms
- Form attachments for new projects in emails
- Final report emails
- Sequencing templates
- Assets
- DKTK logo configuration
- Multiple selected configurations
- Focus configuration for project feasibility queries
- ENABLE_FEASIBILITY feature toggle
- Feasibility mapping
- Form title canonical order
- Mailing blacklist file
- "Set default" function
- Cache config
- German translations for action explanations and user-action feedback messages
- Merge action message proposals into the action message configuration
- Success and error feedback messages for submitting a project
- FRONTEND_VARIABLES_SUMMARY_SPACING (compact or airy summary)
- FRONTEND_VARIABLES_FEASIBILITY_TABLE_WIDTH (compact, medium or full feasibility table)
- FRONTEND_VARIABLES_FEASIBILITY_TABLE_ALIGNMENT (standard, left or right feasibility values)

### Changed
- Replace Minus in bridgeheads
- Variable JWT_GROUPS_CLAIM
- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
- Action Priorities
- Configurations as files
- Move frontend project configuration into `config/frontend` and update related paths
- Rename mail server property
- Messages in italic
- Action explanation for start final stage for project type export
- Accept project bridgehead only if the query-state is finished
- OpenId Client: project-manager-api
- Rename creator to applicant
- Upload script explanation only for DEVELOP and PILOT users
- Exporter cron expression every 30 seconds
- Rename project state CREATED and ACCEPTED as REVIEW and APPROVAL
- Docker VerbIS User for Gitlab CI
- NOT SELECTED configuration
- Rename the Action Explanations configuration to Action Messages
- PDF design
- Favicon as environment variable 
- Localized display-format configuration
- ENABLE_RESEARCH_ENVIRONMENT (was ENABLE_CODER) and ENABLE_DATASHIELD (was ENABLE_TOKEN_MANAGER); ENABLE_APP_REGISTER removed (app register is part of the research environment)
- Research environment and DataSHIELD disabled by default (they belong to the future demo-project-manager)
- Development: ENABLE_EXPORTER, ENABLE_FEASIBILITY and ENABLE_EMAILS = test (test implementations without Beam and SMTP; EMAILS_TEST_LOG=summary); README section "Optional modules"
- Removed the research environment and DataSHIELD configuration (both disabled here): CODER_*, APP_REGISTER_*, TOKEN_MANAGER_URL, MANAGE_TOKENS_CRON_EXPRESSION, production/coder/*.json. A working version for demo-project-manager: master-project-manager, commit 17579fd (branch feat/optional-modules, 2026-10-08, new variable names; with the old names ENABLE_CODER/ENABLE_TOKEN_MANAGER also on main, d738236)
- Removed variables the backend does not read: CODER_MEMBER_ID (only a placeholder inside CODER_CREATE_PATH), CODER_TEMPLATE_VERSION_ID, ENABLE_RSTUDIO_GROUP_MANAGER
- Optional modules are opt-in in the backend (unset = disabled): only the enabled modules are set (ENABLE_EXPORTER, ENABLE_FEASIBILITY, ENABLE_EMAILS); ENABLE_RESEARCH_ENVIRONMENT=false and ENABLE_DATASHIELD=false removed
- Form texts corrected after the review of 2026-10-07 (collaborator title, ethics status and upload texts, data protection confirmation, minimum tissue weight, plasma and breast milk descriptions, sequencing data formats, example of samples per subject, final periods), American spelling (feces, organization); German texts of the changed fields aligned
- American spelling in all texts (anonymized, acknowledgment, organization, centered); German form texts: titles of the ethics and funding forms, untranslated ethics status and conflict-of-interest options, data protection confirmation heading
- German texts for the request metadata (templates/metadata/request.json: request fields shown in the request view and the PDF); German PDF title "DATENANFRAGEFORMULAR", as the UI says "Datenanfrage"

### Fixed
- Avoid splitting fields in samples from the template
- PDF alignment
- PDF: texts with HTML (links, formatting) shown as in the frontend

### Removed
- Application Form
- Only a sample option
