# dktk-project-manager

## Localized display formats

Locale conventions are configured in the optional `locales` section of
`config/display-formats.json`: `en` maps to `en-US` and `de` maps to `de-DE`.
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
`config/display-formats.json`. The backend reads this file from
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
