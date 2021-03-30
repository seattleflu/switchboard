begin;

create index if not exists barcode on record_barcodes(barcode);
create index if not exists unique_record_id on record_barcodes(unique_record_id);

commit;
