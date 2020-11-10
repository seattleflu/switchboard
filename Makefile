SHELL := bash -euo pipefail

.PHONY: data/sfs-redcap.sqlite

data/sfs-redcap.sqlite: data/record-barcodes.ndjson derived-tables.sql
	sqlite-utils insert --nl --truncate $@ record_barcodes_new $<
	sqlite3 $@ 'begin transaction; drop table if exists record_barcodes; alter table record_barcodes_new rename to record_barcodes; commit;'
	sqlite3 $@ < derived-tables.sql

data/record-barcodes.ndjson:
	./bin/export-record-barcodes > $@
