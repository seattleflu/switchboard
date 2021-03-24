.timeout 10000

begin;

drop table if exists duplicate_redcap_barcode_fields;

create table duplicate_redcap_barcode_fields as
    with duplicates as (
        select
            unique_record_id,
            event_name,
            repeat_instance,
            redcap_field,
            count(*)
        from
            record_barcodes
        group by
            unique_record_id,
            event_name,
            repeat_instance,
            redcap_field
        having count(*) > 1
    )
    select
        record_link as record,
        project_id,
        record_id,
        event_name,
        repeat_instance,
        redcap_field,
        barcode
    from
        record_barcodes
    where
        (unique_record_id) in (select distinct(unique_record_id) from duplicates)
;

commit;
