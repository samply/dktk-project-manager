# dktk-project-manager

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
| `FRONTEND_VARIABLES_CREATE_REQUEST_ENABLED` | `true` shows the button; any other value or no value hides it |
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
`yyyy-MM-ddTHH:mm` without a zone. The current master configuration defines no
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
