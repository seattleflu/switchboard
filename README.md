Exploring the idea of a REDCap record switchboard for the SFS kit unboxing
team.

Aggregates minimal data from REDCap into a SQLite database.  The SQLite
database is served by [Datasette](https://datasette.readthedocs.io) to provide
a lightweight off-the-shelf data browsing and querying interface.  A Datasette
custom page uses the Datasette JSON web API to provide a "barcode dialer" that
jumps you to the associated REDCap record, regardless of which SFS project it
is in.


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

You can build the _data/sfs-redcap.sqlite_ database with:

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
    REDCAP_API_TOKEN_ZH_HANT
    REDCAP_API_TOKEN_UW_REOPENING
    …

These are the same variables used in the [backoffice/id3c-production/env.d/redcap-scan/] and [backoffice/id3c-production/env.d/redcap-sfs] envdirs.


# Serving the data

You can serve the database with Datasette with:

    pipenv run ./bin/serve

and then browse the tables and views at <http://localhost:8001>.

There's a "canned query" for looking up barcodes at
<http://localhost:8001/sfs-redcap/lookup-barcode>.  The corresponding JSON web
API is <http://localhost:8001/sfs-redcap/lookup-barcode.json?barcode=…>.

The "barcode dialer" is at <http://localhost:8001/dial>.

## Troubleshooting

On MacOS, if you see this error message:

    ./bin/serve: line 6: realpath: command not found

You can install realpath as part of coreutils, using Homebrew:

    brew install coreutils


[backoffice/id3c-production/env.d/redcap-scan/]: https://github.com/seattleflu/backoffice/tree/master/id3c-production/env.d/redcap-scan/
[backoffice/id3c-production/env.d/redcap-sfs]: https://github.com/seattleflu/backoffice/tree/master/id3c-production/env.d/redcap-sfs
