SHELL := bash -euo pipefail

.PHONY: data/sfs-redcap.sqlite

data/sfs-redcap.sqlite: data/record-barcodes.ndjson derived-tables.sql
	sqlite-utils insert --nl --truncate $@ record_barcodes $<
	sqlite3 $@ < derived-tables.sql

data/record-barcodes.ndjson:
	./bin/export-record-barcodes > $@
