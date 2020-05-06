Exploring the idea of a REDCap record switchboard for the SCAN kit unboxing
team.

Currently just data aggregation + deep links into REDCap presented in an
off-the-shelf interface via [Datasette](https://datasette.readthedocs.io).

A custom page providing a streamlined lookup interface is the next step.
Datasette supports adding [custom
pages](https://datasette.readthedocs.io/en/stable/custom_templates.html#custom-pages),
and its JSON web APIs would provide the backend for the frontend code.  The
custom page could start as a very lightweight HTML form + a sprinkling of
vanilla JS (or maybe a tiny React-compat library like
[Preact](https://preactjs.com)).


# Installation

Requires:

* Python 3.6+ and Pipenv
* SQLite CLI (`sqlite3`)

Install the Python deps with:

    pipenv sync

and the SQLite CLI with:

    apt install sqlite3   # on Ubuntu/Debian
    brew install sqlite3  # on macOS with Homebrew


# Building the data

You can build the _data/scan-redcap.sqlite_ database with:

    pipenv run make

Data will be exported from REDCap the first time `make` is run.  Subsequent
times will rebuild the SQLite database but not re-fetch from REDCap unless you
pass the `-B` / `--always-make` option (or delete
_data/record-barcodes.ndjson_).

You'll need to provide several environment variables with REDCap API
credentials:

    REDCAP_API_URL
    REDCAP_API_TOKEN_EN
    REDCAP_API_TOKEN_ES
    REDCAP_API_TOKEN_VI
    REDCAP_API_TOKEN_ZH_HANS
    …

These are the same variables used in the [backoffice/id3c-production/env.d/redcap-scan/](https://github.com/seattleflu/backoffice/tree/master/id3c-production/env.d/redcap-scan/)
envdir.


# Serving the data

You can serve the database with Datasette with:

    pipenv run ./bin/serve

and then browse the tables and views at <http://localhost:8001>.

There's a "canned query" for looking up barcodes at
<http://localhost:8001/scan-redcap/lookup-barcode>.  The corresponding JSON web
API is <http://localhost:8001/scan-redcap/lookup-barcode.json?barcode=…>.
