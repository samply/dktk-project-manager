# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.0.1 - 2026-04-13]
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
- Results templates
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
- Samples as service in configuration
- Project and Forms configuration
- Output format and template id in samples config
- Data and Samples configuration
- Cohort, Samples and Project configuration

### Changed
- Replace Minus in bridgeheads
- Variable JWT_GROUPS_CLAIM
- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
- Action Priorities
- Configurations as files
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

### Fixed
- Avoid splitting fields in samples from the template

### Removed
- Application Form