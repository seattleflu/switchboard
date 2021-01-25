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

    REDCAP_API_TOKEN_redcap.iths.org_20759
    REDCAP_API_TOKEN_redcap.iths.org_21520
    REDCAP_API_TOKEN_redcap.iths.org_21521
    REDCAP_API_TOKEN_redcap.iths.org_22461
    REDCAP_API_TOKEN_redcap.iths.org_22467
    REDCAP_API_TOKEN_redcap.iths.org_22468
    REDCAP_API_TOKEN_redcap.iths.org_22470
    REDCAP_API_TOKEN_redcap.iths.org_22471
    REDCAP_API_TOKEN_redcap.iths.org_22472
    REDCAP_API_TOKEN_redcap.iths.org_22473
    REDCAP_API_TOKEN_redcap.iths.org_22474
    REDCAP_API_TOKEN_redcap.iths.org_22475
    REDCAP_API_TOKEN_redcap.iths.org_22476
    REDCAP_API_TOKEN_redcap.iths.org_22477
    REDCAP_API_TOKEN_redcap.iths.org_23089

These are the same variables used in the [backoffice/id3c-production/env.d/redcap/] envdir.


# Serving the data

You can serve the database with Datasette with:

    pipenv run ./bin/serve

and then browse the tables and views at <http://localhost:8001>.

There's a "canned query" for looking up barcodes at
<http://localhost:8001/sfs-redcap/lookup-barcode>.  The corresponding JSON web
API is <http://localhost:8001/sfs-redcap/lookup-barcode.json?barcode=…>.

The "barcode dialer" is at <http://localhost:8001/dial>.

## Troubleshooting

### On MacOS, if you see this error message:

    ./bin/serve: line 6: realpath: command not found

    You can install realpath as part of coreutils, using Homebrew:

    brew install coreutils

### `database is locked` error
    SQLite handles concurrency differently than a client-server database system does.
    In SQLite, a write operation can lock the entire database and prevent readers
    from accessing it, for example. This is good resource for learning about
    locks in SQLite: https://sqlite.org/lockingv3.html


[backoffice/id3c-production/env.d/redcap-scan/]: https://github.com/seattleflu/backoffice/tree/master/id3c-production/env.d/redcap-scan/
[backoffice/id3c-production/env.d/redcap-sfs]: https://github.com/seattleflu/backoffice/tree/master/id3c-production/env.d/redcap-sfs
