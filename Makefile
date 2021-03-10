SHELL := bash -euo pipefail

.PHONY: data/sfs-redcap.sqlite venv requirements.txt

data/sfs-redcap.sqlite: data/record-barcodes.csv import.sql indexes.sql derived-tables.sql
	sqlite3 $@ 'PRAGMA journal_mode=WAL;'
	chmod -v g+w $@
	sqlite3 $@ < import.sql
	sqlite3 $@ < indexes.sql
	sqlite3 $@ < derived-tables.sql

data/record-barcodes.csv:
	./bin/export-record-barcodes > $@

venv:
	rm -rf .venv
	python3.6 -m venv .venv
	.venv/bin/pip install --upgrade pip setuptools wheel pip-tools
	.venv/bin/pip install -r requirements.txt

requirements.txt:
	.venv/bin/pip-compile --generate-hashes --reuse-hashes
