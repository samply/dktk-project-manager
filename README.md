# DKTK Project Manager

The DKTK deployment of the **Samply project manager** (Samply Data Request): researchers of the German Cancer
Consortium (DKTK) request data and samples from the DKTK sites. A request starts in the Explorer with a query and the
chosen sites, gets a form (project, ethics, funding, ...), goes through the central and local approvals, and is then
executed at the sites, which send their results back.

The software is generic; this repository holds what makes it DKTK:

| Folder | Content |
|---|---|
| `production/form/` | The request forms and the template of the request PDF |
| `production/email/` | Email templates and which email goes to whom |
| `production/action-messages.json` | Texts of the actions users take |
| `production/display-formats.json` | How dates and times are shown |
| `production/frontend/` | Frontend settings, request types, logos |
| `production/cache/` | Cache settings of the backend |
| `production/entrypoint.sh`, `production/generate_bridgeheads.sh` | Defaults of every setting; the DKTK sites (bridgeheads) |
| `development/` | Settings for running the backend locally |

Components:

- backend [`samply/project-manager`](https://github.com/samply/project-manager);
- frontend [`samply/project-manager-ui`](https://github.com/samply/project-manager-ui);
- this repository builds the image [`samply/dktk-project-manager`](https://hub.docker.com/r/samply/dktk-project-manager):
  the backend image with `production/` copied to `/app`.

## Branches and images

| Branch | Image | Backend inside | Runs on |
|---|---|---|---|
| `main` | `samply/dktk-project-manager:main` | a released version, written in the `Dockerfile` (stage `backend-release`) | production |
| tag `vX.Y.Z` on `main` | `samply/dktk-project-manager:X.Y.Z` | as `main` at that moment | a release: what production ran (audits, rollback) |
| `develop` | `samply/dktk-project-manager:develop` | `samply/project-manager:develop` (the backend's development state) | test system |

- Changes go into `develop` through pull requests; `main` (production) changes only through a pull request from
  `develop`.
- `main` is built on every merge into `main`. `develop` is built on every merge into `develop` and every night at
  00:17 UTC, so the test system gets the backend's latest development state without a commit here. The servers pull
  their images every night.
- Releases: semantic versions, tag `vX.Y.Z` on `main`, entries in `CHANGELOG.md` (procedure: `runbooks/release.md`,
  "Config repositories", in project-manager-ops).
- Locally: `docker build .` builds on the release, `docker build --build-arg BACKEND=develop .` on the development
  state.

### How a backend release reaches production

1. A new backend version is released (for example `1.1.0`): Docker Hub gets `samply/project-manager:1.1.0`.
2. Within a day, Dependabot (`.github/dependabot.yml`) opens a pull request into `develop` that changes
   `samply/project-manager:1.0.0` to `1.1.0` in the `Dockerfile`.
3. The configuration the new version needs (the `Configuration` section of the backend's CHANGELOG) is added to that
   pull request, which is then merged.
4. A pull request `develop` → `main` is merged; this builds `samply/dktk-project-manager:main` on `1.1.0`.
5. Production pulls it the next night.

The test system had the backend changes before the release: it runs on `samply/project-manager:develop`.

## Minimal docker compose

Backend, frontend and database. Emails, exporter and feasibility run in `test` mode (no SMTP, no Beam; see
[Optional modules](#optional-modules)). A login server (OIDC) with a public client for the frontend and a client for
the backend is needed.

```yaml
services:
  project-manager-ui:
    image: docker.io/samply/project-manager-ui:main
    environment:
      STANDALONE_SINGLE_SPA: "true"
      VUE_APP_OIDC_URL: "https://login.example.org/realms/example"  # issuer of the login server
      VUE_APP_OIDC_CLIENT_ID: "project-manager-ui"                   # public client
      VUE_APP_FRONTEND_URL: "http://localhost:8080"
      VUE_APP_BACKEND_URL: "http://localhost:8097/api"
    ports:
      - "8080:80"

  project-manager-api:
    image: docker.io/samply/dktk-project-manager:main
    environment:
      FRONTEND_BASEURL: "http://localhost:8080"
      BACKEND_BASEURL: "http://localhost:8097/api"
      SERVER_SERVLET_CONTEXT_PATH: "/api"
      PROJECT_MANAGER_DB_URL: "jdbc:postgresql://project-manager-db:5432/project_manager"
      PROJECT_MANAGER_DB_USER: "project_manager"
      PROJECT_MANAGER_DB_PASSWORD: "${PM_DB_PASSWORD}"
      DB_ENCRYPTION_PRIVATE_KEY_IN_BASE64: "${PM_DB_ENCRYPTION_PRIVATE_KEY_IN_BASE64}"  # AES key; never change it later
      OIDC_URL: "https://login.example.org/realms/example"
      OIDC_CLIENT_ID: "project-manager-api"
      OIDC_CLIENT_SECRET: "${OIDC_CLIENT_SECRET}"
      ENABLE_EMAILS: "test"
      ENABLE_EXPORTER: "test"
      ENABLE_FEASIBILITY: "test"
    ports:
      - "8097:8097"
    volumes:
      - ./data/documents:/app/documents
    depends_on:
      project-manager-db:
        condition: service_healthy

  project-manager-db:
    image: docker.io/postgres:18-alpine
    environment:
      POSTGRES_USER: "project_manager"
      POSTGRES_PASSWORD: "${PM_DB_PASSWORD}"
      POSTGRES_DB: "project_manager"
    volumes:
      - ./data/db:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U project_manager -d project_manager"]
      interval: 5s
      retries: 20
```

Every other setting has a default in `production/entrypoint.sh` and can be overridden with an environment variable.
What a deployment must set: `docs/minimal-configuration.md` in project-manager.

## Optional modules

The backend switches parts of its functionality on and off with `ENABLE_*` variables. A disabled module needs none of
its settings. Details: `docs/optional-modules.md` in project-manager.

| Variable | Module | Production | Development |
|---|---|---|---|
| `ENABLE_EXPORTER` | Sends the queries to the sites' exporters (through Beam) and follows the exports | `true` | `test` |
| `ENABLE_FEASIBILITY` | Feasibility counts per site (through Beam) | `true` | `test` |
| `ENABLE_EMAILS` | Sends the emails (SMTP) | `true` | `test` |
| `ENABLE_RESEARCH_ENVIRONMENT` | Research environment workspaces (Coder) | - | - |
| `ENABLE_DATASHIELD` | DataSHIELD tokens (token manager); needs the research environment | - | - |
| `ENABLE_EXTERNAL_EXECUTION` | Site admins execute a request's query at their site directly | - | - |
| `ENABLE_LOCAL_APPROVAL` | Local approval of each site after the central approval (document per site) | `true` | `true` |

Modules are opt-in: a module whose variable is not set (`-`) or empty is disabled. Values: `true`, `false`, or `test`
for exporter, feasibility and emails - a test implementation for development without the external systems:

- `ENABLE_EXPORTER=test`: the queries go through all their states (sent, executed, finished) without Beam; nothing is
  exported.
- `ENABLE_FEASIBILITY=test`: random counts from the template `TEST_FEASIBILITY_RESULT` (e.g. `{{INTEGER}}`).
- `ENABLE_EMAILS=test`: the emails are rendered as in production and written to the backend log instead of sent.
  `EMAILS_TEST_LOG`: `summary` (receiver and kind of email, the default) or `full` (also subject, text and
  attachments). `true` with the mail catcher of teiler-docker (port 1025) shows them in the browser instead.

The backend does not start - and says why - when:

- an enabled module needs a disabled one (e.g. DataSHIELD without the research environment), or a value is not valid;
- `production/frontend/frontend-project-configs.json` offers a request type whose module is disabled (EXPORT, SAMPLES
  and SEQUENCING need the exporter; DATASHIELD and RESEARCH_ENVIRONMENT their modules);
- requests that are not finished need a disabled module: the message lists them with the SQL to archive them (drafts:
  reject). Finished requests stay viewable.

## Project IDs

Project IDs are generated from `PROJECT_ID_TEMPLATE`. This instance uses
`REQ-{{YEAR}}-{{SEQUENCE:4}}`, which creates human-readable IDs such as `REQ-2026-0001`:
a fixed prefix, the year of creation and a running number. The running number
comes from a database sequence, so it never repeats; it is shared across years
(it does not restart at `0001` on 1 January) and keeps growing past four digits.

Supported tokens are `YEAR`, `MONTH`, `DAY`, `HOUR`, `MINUTE`, `SECOND`,
`SEQUENCE:n`, `NUMBER:n` and `STRING:n`. Every template needs at least one
`SEQUENCE`, `NUMBER` or `STRING` token. An empty template falls back to
`{{STRING:20}}`, the previous 20-character random ID format.
Literal text may contain only ASCII letters, digits, `-`, and `_` so generated
IDs remain safe as URL path segments.

The development environment uses the prefix `TEST-` instead (`TEST-2026-0001`),
so development projects can't be mistaken for production ones.

## Create request from the dashboard

Requests are usually created from the Explorer, which sends the query and the
selected sites. The dashboard can also show a **Create request** button, which
creates a draft request with an empty query and no sites and opens it:

| Variable | Content |
|---|---|
| `FRONTEND_VARIABLES_CREATE_REQUEST_ORGANISATION_ROLES` | Comma-separated organization roles allowed to see the dashboard button; unset or empty hides it |
| `FRONTEND_VARIABLES_CREATE_REQUEST_DEFAULT_QUERY_FORMAT` | Format of the new request's query, e.g. `AST_DATA` |

The button is enabled only in development for now. When a request has no
Explorer URL (like the ones created with this button), its creator defines the
query and its format in the request form; requests from the Explorer are still
edited in the Explorer. The message shown after creating the request is
`CREATE_QUERY_AND_DESIGN_PROJECT` in `action-messages.json`.

After the Explorer (or any other client) creates or edits a request, the
project manager returns the URL of the request with a one-time marker
(`action-feedback=<ACTION>`). The request page shows that action's
`success-message` from `action-messages.json` once and removes the marker:
`CREATE_QUERY_AND_DESIGN_PROJECT` after creating, `EDIT_PROJECT` after editing.

## Credentials Sharing Tool

The Results section can offer a **Credentials Sharing Tool**, which prepares
email templates that send a results password separately from the results URL.
It is a proposal and has not been approved, so it is hidden unless enabled:

| Variable | Content |
|---|---|
| `FRONTEND_VARIABLES_CREDENTIALS_SHARING_TOOL_ENABLED` | `true` shows the tool; any other value or no value hides it |

It is enabled only in development for now.

## Summary spacing

The summary of the request form and the request view can show their fields close together or with the same space as
while filling in the draft:

| Variable | Content |
|---|---|
| `FRONTEND_VARIABLES_SUMMARY_SPACING` | `compact`: half the draft's space between fields; `airy` (default, also for any other value): the draft's space |

This instance uses `airy`.

## Feasibility table

The feasibility table in the request view has one row per site and one column per value of the feasibility answer.
Two variables set its width and the alignment of its value columns.

### Width

The table can take only the width its columns need or the whole card. On a wide screen a narrow table keeps each site
close to its numbers; a wider one leaves more room when the answer has many or long columns (e.g. breakdowns):

| Variable | Content |
|---|---|
| `FRONTEND_VARIABLES_FEASIBILITY_TABLE_WIDTH` | `compact`, `medium` or `full`, see below |

| Value | Width | Suited for |
|---|---|---|
| `compact` (default, also for no value or any other value) | As wide as the columns need, at least 32rem (512 px) | Few short columns, e.g. Patients and Samples |
| `medium` | As wide as the columns need, at least 48rem (768 px) | Several columns or longer values |
| `full` | The whole card; the number columns only as wide as their content, at the right | Many columns, e.g. breakdowns |

With `compact` and `medium` the table is left-aligned in the card and never wider than the card for its minimum. In
every case, if the columns need more room than the card has, the table scrolls horizontally inside its frame.

This instance uses `compact`.

### Alignment

| Variable | Content |
|---|---|
| `FRONTEND_VARIABLES_FEASIBILITY_TABLE_ALIGNMENT` | `standard`, `left` or `right`, see below |
| `FRONTEND_VARIABLES_LOCAL_APPROVAL_REQUIRED` | `true`: every site needs its local approval - the request cannot skip it, a missing one is red, the site cannot send the query without it (only in the UI); otherwise a missing local approval is "not provided" |

| Value | Value columns (header included) |
|---|---|
| `standard` (default, also for no value or any other value) | By content: a column whose values are all numbers is right-aligned, so that units, tens and thousands line up; a column with any text is left-aligned |
| `left` | All left-aligned |
| `right` | All right-aligned |

The Site column is always left-aligned. Sites without a value yet (loading, error) do not count for `standard`.

This instance uses `standard`.

## Exporter query label

`EXPORTER_QUERY_LABEL_TEMPLATE` defines the label of the queries sent to the
exporter. It is required: the project manager does not start without it.
This instance uses `[{{PROJECT_CODE}}] {{QUERY_LABEL}}`.

The template is literal text with expressions in double braces. Expressions are
[Spring Expression Language (SpEL)](https://docs.spring.io/spring-framework/reference/core/expressions.html)
and can use these variables:

| Variable | Content | Example |
|---|---|---|
| `PROJECT_CODE` | Project ID | `REQ-2026-0001` |
| `PROJECT_TYPE` | Type of the query | `EXPORT`, `DATASHIELD`, `RESEARCH_ENVIRONMENT`, `SAMPLES` |
| `QUERY_LABEL` | Label of the query | `My query` |

Any Java `String` method can be called on them, such as `substring`,
`toLowerCase`, `toUpperCase` or `replace`. Examples for the project
`REQ-2026-0001` with the query `My query`:

| `EXPORTER_QUERY_LABEL_TEMPLATE` | Label |
|---|---|
| `[{{PROJECT_CODE}}] {{QUERY_LABEL}}` | `[REQ-2026-0001] My query` |
| `[{{PROJECT_CODE.substring(6)}}] {{QUERY_LABEL}}` | `[26-0001] My query` |
| `[{{PROJECT_TYPE}}-{{PROJECT_CODE}}] {{QUERY_LABEL}}` | `[EXPORT-REQ-2026-0001] My query` |
| `{{PROJECT_CODE.toLowerCase()}}: {{QUERY_LABEL}}` | `req-2026-0001: My query` |
| `{{PROJECT_CODE.replace('REQ-', '')}} {{QUERY_LABEL}}` | `2026-0001 My query` |

`substring(6)` keeps the characters from position 6 (counting from 0) to the
end; `substring(0, 8)` would keep the first 8 characters (`REQ-2026`).

If the label is sent again, ` (Attempt: n)` is appended automatically. The
template is checked at startup, so a mistake stops the project manager with a
clear message. If an expression fails for a single project (for example
`substring` on a shorter ID), the error is logged and the label falls back to
`[PROJECT_CODE] QUERY_LABEL`.

## Localized display formats

Locale conventions are configured in the optional `locales` section of
`production/display-formats.json`: `en` maps to `en-US` and `de` maps to `de-DE`.
Thus `1000.1` displays as `1,000.1` or `1.000,1` in
read-only numeric form fields and PDFs. Feasibility counts use the same UI policy.
Locales use BCP 47 tags such as `de-CH`; separators are supplied by the locale.

Resolution tries the requested language, its base language, then the deployment
default. With no number override, the resolved date language supplies the locale.
The current UI requests no language, so `DEFAULT_LANGUAGE` controls its display.
Future language selection must pass the same `language` to display configuration,
metadata, and PDF requests. Browser/server regional preferences are not used.

Formatting preserves numeric precision and removes insignificant trailing zeros.
Canonical values requiring more than 100 fractional or 309 integer digits, and
unrecognized legacy strings, remain unchanged rather than being rounded. Numeric
inputs, API values, storage, and sorting remain unchanged. Feasibility values
remain integer counts; this does not add support for decimal bridgehead statistics.
Older configuration files with `numberFormats` remain supported. Restart the
backend after configuration changes; deploy the backend before the UI to make
explicit locale overrides available.

Human-facing date and date-time patterns are configured in
`production/display-formats.json`. The backend reads this file from
`DISPLAY_FORMATS_CONFIG_PATH` at startup, so changing it requires a backend
restart.

Presentation patterns do not affect API or stored values. `DATE` uses `yyyy-MM-dd`,
`TIMESTAMP` uses a UTC instant ending in `Z`, and `LOCAL_DATE_TIME` uses
`yyyy-MM-ddTHH:mm` without a zone. The current DKTK configuration defines no
persisted dynamic fields of these types.

The database schema and form-value persistence are unchanged from `develop`.
No migration or database recreation is needed when upgrading from `develop`.
Native browser inputs submit fixed ISO values; summaries and PDFs apply the
configured display patterns. Unrecognized existing values remain visible unchanged.

Individual temporal fields can optionally select a display format:

```json
{
  "label": "planned-start-date",
  "data_type": "DATE",
  "display_format": "LONG_DATE_FORMAT"
}
```

Without `display_format`, DATE uses DATE_FORMAT, and TIMESTAMP/LOCAL_DATE_TIME
use DATE_TIME_FORMAT. DATE accepts DATE_FORMAT or LONG_DATE_FORMAT; date-time
types accept any of the four keys, including DATE_TIME_WITH_SECONDS_FORMAT.
The override applies to read-only UI values and PDF form-field values, including
repeated fields. Editable controls, submitted values, and storage are unchanged.
The API exposes this optional metadata as `displayFormat`.
