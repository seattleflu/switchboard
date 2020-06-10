SHELL := bash -euo pipefail

.PHONY: data/scan-redcap.sqlite

data/scan-redcap.sqlite: data/record-barcodes.ndjson derived-tables.sql
	sqlite-utils insert --nl $@.new record_barcodes $<
	sqlite3 $@.new < derived-tables.sql
	mv -vf $@.new $@

data/record-barcodes.ndjson:
	./bin/export-record-barcodes > $@
