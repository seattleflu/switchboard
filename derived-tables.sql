.timeout 10000

begin;

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
        '{"href": "' || record_url || '", "label": "' || record_link_label || '"}' as record,
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
        barcode_17,
        barcode_18,
        barcode_19,
        barcode_20,
        barcode_21,
        barcode_22,
        barcode_23,
        barcode_24,
        barcode_25,
        barcode_26,
        barcode_27,
        barcode_28,
        barcode_29,
        barcode_30,
        barcode_31,
        barcode_32,
        barcode_33,
        barcode_34,
        barcode_optional_1,
        barcode_optional_2,
        barcode_optional_3,
        barcode_optional_4,
        barcode_ex1,
        barcode_ex2,
        core_collection_barcode,
        return_collection_barcode,
        welcome_barcode_1,
        welcome_barcode_2,
        serial_barcode_1,
        serial_barcode_2,
        serial_barcode_3,
        serial_barcode_4,
        return_serial_barcode_1,
        return_serial_barcode_2,
        return_serial_barcode_3,
        return_serial_barcode_4,
        outgoing_barcode,
        core_activation_barcode,
        collection_barcode
    from
        record_barcodes
    where
        (project_id, record_id) in (select project_id, record_id from duplicates)
;

commit;
