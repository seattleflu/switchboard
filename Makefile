SHELL := bash -euo pipefail

.PHONY: data/scan-redcap.sqlite

data/scan-redcap.sqlite: data/record-barcodes.ndjson derived-tables.sql
	rm -vf $@
	sqlite-utils insert --nl $@ record_barcodes $<
	sqlite3 $@ < derived-tables.sql

data/record-barcodes.ndjson:
	./bin/export-record-barcodes > $@
