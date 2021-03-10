begin;

-- When the table doesn't exist, .import assumes the first line of the CSV is a
-- header line (instead of data line) and automatically create the table based
-- on it.
drop table if exists record_barcodes;

.mode csv
.import data/record-barcodes.csv record_barcodes

commit;
