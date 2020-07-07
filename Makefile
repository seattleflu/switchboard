SHELL := bash -euo pipefail

.PHONY: data/scan-redcap.sqlite

data/scan-redcap.sqlite: data/record-barcodes.ndjson derived-tables.sql
	./bin/update-database $< $@

data/record-barcodes.ndjson:
	./bin/export-record-barcodes > $@
