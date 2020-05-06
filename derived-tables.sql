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
            record_id
        having count(*) > 1
    )
    select
        record_link as record,
        record_arm,
        pre_scan_barcode,
        utm_tube_barcode_2,
        reenter_barcode,
        return_utm_barcode
    from
        record_barcodes
    where 
        (project_id, record_id) in (select project_id, record_id from duplicates)
;
