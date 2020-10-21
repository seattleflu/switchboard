drop table if exists duplicate_record_ids;

create table duplicate_record_ids as
    with duplicates as (
        select
            project_id,
            record_id,
            count(*)
        from
            record_barcodes
        group by
            project_id,
            record_id,
            event_name,
            repeat_instance
        having count(*) > 1
    )
    select
        record_link as record,
        event_name,
        pre_scan_barcode,
        utm_tube_barcode_2,
        reenter_barcode,
        return_utm_barcode,
        collect_barcode_kiosk,
        barcode_swabsend,
        utm_tube_barcode,
        barcode_1,
        barcode_2,
        barcode_3,
        barcode_4,
        barcode_5,
        barcode_6,
        barcode_7,
        barcode_8,
        barcode_9,
        barcode_10,
        barcode_11,
        barcode_12,
        barcode_13,
        barcode_14,
        barcode_15,
        barcode_16,
        barcode_optional_1,
        barcode_optional_2,
        barcode_optional_3,
        barcode_optional_4
    from
        record_barcodes
    where
        (project_id, record_id) in (select project_id, record_id from duplicates)
;
