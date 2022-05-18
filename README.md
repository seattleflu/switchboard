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

* Python 3.6
* SQLite CLI (`sqlite3`)

Install the Python deps with:

    make venv

and the SQLite CLI with:

    apt install sqlite3   # on Ubuntu/Debian
    brew install sqlite3  # on macOS with Homebrew

Activate the virtualenv to run any of the commands below:

    source .venv/bin/activate

(Or alternatively, run the commands below via `./bin/venv-run`.)


# Building the data

You can build the _data/sfs-redcap.sqlite_ database with:

    make

Data will be exported from REDCap the first time `make` is run.  Subsequent
times will rebuild the SQLite database but not re-fetch from REDCap unless you
pass the `-B` / `--always-make` option (or delete
_data/record-barcodes.csv_).

You'll need to provide several environment variables with REDCap API
credentials:

    REDCAP_API_TOKEN_redcap.iths.org_22461
    REDCAP_API_TOKEN_redcap.iths.org_22472
    REDCAP_API_TOKEN_redcap.iths.org_22474
    REDCAP_API_TOKEN_redcap.iths.org_22475
    REDCAP_API_TOKEN_redcap.iths.org_22477
    REDCAP_API_TOKEN_redcap.iths.org_23089
    REDCAP_API_TOKEN_redcap.iths.org_27619
    REDCAP_API_TOKEN_hct.redcap.rit.uw.edu_45

These are the same variables used in the [backoffice/id3c-production/env.d/redcap/] envdir.


# Serving the data

You can serve the database with Datasette with:

    ./bin/serve

and then browse the tables and views at <http://localhost:3002>.

There's a "canned query" for looking up barcodes at
<http://localhost:3002/sfs-redcap/lookup-barcode>.  The corresponding JSON web
API is <http://localhost:3002/sfs-redcap/lookup-barcode.json?barcode=…>.

The "barcode dialer" is at <http://localhost:3002/dial>.


# Development

## Adding or updating a Python dependency

Python dependencies are managed with
[pip-tools](https://github.com/jazzband/pip-tools).

Edit _requirements.in_ to modify our top-level Python dependency declarations.

Then, regenerate the fully-specified _requirements.txt_ using `pip-compile` with:

    make requirements.txt

Finally, re-create your virtualenv from scratch with:

    make venv

Or alternatively, apply the changes to your virtualenv in-place with:

    pip-sync

Once you're satisfied, make sure to commit your changes to both
_requirements.in_ and _requirements.txt_.


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
